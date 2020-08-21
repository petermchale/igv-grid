const puppeteer = require('puppeteer')
const lineReader = require('line-reader')
const Promise = require('bluebird') 
const fs = require('fs')
const path = require('path')
const { cloneDeep } = require('lodash')
// const cloneDeep = require('lodash/clonedeep')

const webApp_assets_directory_absolute = process.argv[3]
const thumbnails_directory = process.argv[4]
const webApp_igv_directory_relative = process.argv[5]
const createScreenshots_assets_directory_relative = process.argv[6]
const createScreenshots_assets_directory_absolute = process.argv[7] 

async function createScreenshot (coordinates, tracks, imagePath) {
  const browser = await puppeteer.launch({
    headless: true,
    dslowMo: 1000,
    // defaultViewport: null, // disable viewport to match window
    // args: ['--window-size=600,600']
  })

  const page = await browser.newPage()

  const url = process.argv[2]
  await page.goto(url)

  await page.evaluate(
    async (coordinates, tracks) => await renderIGV(coordinates, tracks),
    coordinates, 
    tracks 
  )

  await page.waitFor(1000)  // wait for x seconds
  // c.f., https://github.com/brentp/jigv#automated-screenshots
  // c.f., https://github.com/igvteam/igv.js/issues/1138 

  // await page.screenshot({path: imagePath, fullPage: true})

  // TODO: class "igv-track-container-div" should not include picture of chromosome, but does
	// https://github.com/puppeteer/puppeteer/blob/v5.2.1/docs/api.md#class-elementhandle
  const elementHandle = await page.$('div[class=igv-track-container-div]')
  // console.log(elementHandle)
  // TODO: "null" not valid value for "clip" according to docs, but not setting "clip" triggers an error
  await elementHandle.screenshot({path: imagePath, clip: null, fullPage: true})

  await browser.close()
} 

function additional_tracks () { 
  return cloneDeep(require('../tracks.json'))
}

function callSets () { 
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
    name: `${callSet.labelForVisualization}`, 
    url: `${webApp_igv_directory_relative}/${callSet.filenameStem}.sorted.vcf.gz`, 
    indexURL: `${webApp_igv_directory_relative}/${callSet.filenameStem}.sorted.vcf.gz.tbi`
  }]  

  for (const track of additional_tracks()) {
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
  let id = 0
  for (const callSet of callSets()) {
    thumbnailsForCallSet = await createThumbnailsIndexForCallSet(callSet)
    thumbnailsForCallSet.id = id
    thumbnails.push(thumbnailsForCallSet)
    id++
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
  thumbnails = await createThumbnailsIndex() 
  thumbnails.forEach((callset, callsetIndex) => {
    const oldTracks = callset.tracks
    const newTracks = []
    for (const track of oldTracks) {
      track.url = change_path(track.url)
      track.indexURL = change_path(track.indexURL)
      newTracks.push(track)
    }
    // forEach does not wait for promises https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/forEach
    callset.loci.forEach(async ({ coordinates, image }, locusIndex) => {
      const imagePath = `${webApp_assets_directory_absolute}/${thumbnails_directory}/${image}`
      await createScreenshot(coordinates, newTracks, imagePath) 
      console.log(`>>> created thumbnail ${locusIndex+1}/${callset.loci.length} from callset ${callsetIndex+1}/${thumbnails.length}`)
    })
  })
}

createThumbnails()
