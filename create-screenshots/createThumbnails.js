const puppeteer = require('puppeteer')
const lineReader = require('line-reader')
const Promise = require('bluebird') 
const fs = require('fs')
const path = require('path')
const { cloneDeep } = require('lodash')

const webApp_assets_directory_absolute = process.argv[3]
const thumbnails_directory = process.argv[4]
const webApp_igv_directory_relative = process.argv[5]
const createScreenshots_assets_directory_relative = process.argv[6]
const createScreenshots_assets_directory_absolute = process.argv[7] 
const headless_browser_wait_time = Number(process.argv[8])

async function createScreenshot (coordinates, tracks, imagePath) {
  const browser = await puppeteer.launch({
    headless: true,
    dslowMo: 1000,
    args: ["--hide-scrollbars"]
  })

  const page = await browser.newPage()

  const url = process.argv[2]
  await page.goto(url)

  await page.evaluate(
    async (coordinates, tracks) => await renderIGV(coordinates, tracks),
    coordinates, 
    tracks 
  )

  // Wait for x seconds before taking a screenshot
  // because there is no event that signals that the page is fully rendered
  // c.f., https://github.com/brentp/jigv#automated-screenshots
  // c.f., https://github.com/igvteam/igv.js/issues/1138 
	console.log('headless browser waiting for:', headless_browser_wait_time) 
  await page.waitFor(headless_browser_wait_time) 

	// https://github.com/puppeteer/puppeteer/blob/v5.2.1/docs/api.md#class-elementhandle
  const elementHandle = await page.$('div[class=igv-content-div]')

  // "null" not valid value for "clip" according to docs, 
  // but not setting "clip" triggers an error
  // cf. https://github.com/puppeteer/puppeteer/blob/v5.2.1/docs/api.md#pagescreenshotoptions
  // cf. https://github.com/puppeteer/puppeteer/blob/21552f8fe76108267a6f2574747ff06746623ece/src/common/Page.ts#L1622
  await elementHandle.screenshot({path: imagePath, clip: null, fullPage: true})

  await browser.close()
} 

function getAdditionalTracks () { 
  return cloneDeep(require('../tracks.json'))
}

function getCallSets () { 
  return cloneDeep(require('../callSets.json'))
}

async function createThumbnailsIndexForCallSet (callSet) { 
  const thumbnailsIndex = {
    labelForVisualization: callSet.labelForVisualization,
    loci: []
  }

  const tracks = [{  
    type: 'variant', 
    format: 'vcf', 
    height: 100,
    name: `${callSet.labelForVisualization}`, 
    url: `${webApp_igv_directory_relative}/${callSet.filenameStem}.sorted.vcf.gz`, 
    indexURL: `${webApp_igv_directory_relative}/${callSet.filenameStem}.sorted.vcf.gz.tbi`,
    displayMode: 'collapsed'
  }]  

  for (const track of getAdditionalTracks()) {
    track.url = `${webApp_igv_directory_relative}/${track.url}`
    track.indexURL = `${webApp_igv_directory_relative}/${track.indexURL}`
    tracks.push(track)
  } 
  thumbnailsIndex.tracks = tracks

  let id = 0

  const readFile = Promise.promisify(lineReader.eachLine)

  const bedFilePath = `${createScreenshots_assets_directory_absolute}/${callSet.filenameStem}.sampled.slopped.bed`
  await readFile(bedFilePath, line => {
    const [chromosome, start, end] = line.split('\t')
    const coordinates = `${chromosome}:${start}-${end}`
    const coordinatesReformatted = coordinates.replace(':','-')
    const image = `${callSet.labelForImageFilename}.${coordinatesReformatted}.png`
    thumbnailsIndex.loci.push({
      id: id,
      coordinates: coordinates, 
      image: image
    })
    id++
  })

  return thumbnailsIndex 
}

async function createThumbnailsIndex () {
  const thumbnails = []
  const callSets = getCallSets()
  for (let callsetIndex = 0; callsetIndex < callSets.length; callsetIndex++) {
    const callSet = callSets[callsetIndex]
    thumbnailsForCallSet = await createThumbnailsIndexForCallSet(callSet)
    thumbnailsForCallSet.id = callsetIndex
    thumbnails.push(thumbnailsForCallSet)
  }  
  fs.writeFileSync(`${webApp_assets_directory_absolute}/${thumbnails_directory}.json`, JSON.stringify(thumbnails, null, 2))
  return thumbnails
}

function change_path (oldPath) { 
  const filename = path.parse(oldPath).base
  const newPath = `${createScreenshots_assets_directory_relative}/${filename}`
  return newPath
}

async function createThumbnails () { 
  const thumbnails = await createThumbnailsIndex() 
  // Below, I could have used forEach instead of a for loop
  // But forEach will not "await createScreenshot": 
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach
  // So, if there are many call sets, then forEach may overload memory
  // Also, forEach may require a larger "headless browser wait time" 
  // because the rate of network traffic to and from the server would be larger
  for (let callsetIndex = 0; callsetIndex < thumbnails.length; callsetIndex++) {
    const callset = thumbnails[callsetIndex]
    const oldTracks = callset.tracks
    const newTracks = []
    for (const track of oldTracks) {
      track.url = change_path(track.url)
      track.indexURL = change_path(track.indexURL)
      newTracks.push(track)
    }
    const loci = callset.loci
    for (let locusIndex = 0; locusIndex < loci.length; locusIndex++) {
      const { coordinates, image } = loci[locusIndex]
      const imagePath = `${webApp_assets_directory_absolute}/${thumbnails_directory}/${image}`
      await createScreenshot(coordinates, newTracks, imagePath) 
      console.log(`>>> created thumbnail ${locusIndex+1}/${loci.length} from callset ${callsetIndex+1}/${thumbnails.length}`)
    }
  }
}

createThumbnails()
