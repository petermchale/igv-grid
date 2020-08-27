async function renderIGV(coordinates, tracks) {  
  console.log('igv.js version', igv.version())
 
  const div = document.getElementById("igv")

  const response = await axios.get('/assets/reference.json')
  const { fastaURL, indexURL } = response.data

  const options = {
    showIdeogram: false,
    showRuler: false,
    locus: coordinates,
    reference: { fastaURL, indexURL },
    tracks: tracks
  }

  const browser = await igv.createBrowser(div, options)  
  console.log('browser info:', browser) 
}

