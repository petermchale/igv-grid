async function renderIGV(coordinates, tracks) {  
  console.log('igv.js version', igv.version())

  const div = document.getElementById("igv")
  const options = {
    locus: coordinates,
    genome: "hg38",
    tracks: tracks
  }

  const browser = await igv.createBrowser(div, options)  
  console.log('browser info:', browser) 
}

