async function renderIGV(coordinates, tracks) {  
  console.log('igv.js version', igv.version())
 
  const div = document.getElementById("igv")

  const response = await axios.get('/assets/reference.json')
  const { fastaURL, indexURL } = response.data
  
  const options = {
    locus: coordinates,
    reference: { fastaURL, indexURL },
    tracks: tracks.filter(track => track.thumbnail)
  }

  const browser = await igv.createBrowser(div, options)  
  console.log('browser info:', browser) 
}

function removeScrollBars () {
  for (const scrollBar of document.getElementsByClassName('igv-scrollbar-outer-div')) {
    scrollBar.style.display = "none"
  }  
}

function removeTrackLabels () {
  for (const scrollBar of document.getElementsByClassName('igv-track-label')) {
    scrollBar.style.display = "none"
  }  
}
