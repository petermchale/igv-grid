<template>
  <div class="lightbox" @click.self="closeLightbox" >
    <div ref="igv" class="igv"></div>
  </div>
</template>

<script>
import igv from 'igv'
import callSets from '@/assets/thumbnails.json'
import { cloneDeep } from 'lodash'

export default {
  data () {
    return {
      callSets,
      // https://cli.vuejs.org/guide/html-and-static-assets.html#the-public-folder
      publicPath: process.env.BASE_URL
    }
  },
  computed: {
    callSet () {
      return this.callSets.find(callSet =>
        callSet.id === Number(this.$route.params.callSetID)
      )
    },
    locus () {
      return this.callSet.loci.find(locus =>
        locus.id === Number(this.$route.params.locusID)
      )
    },
    tracks () {
      // https://stackoverflow.com/a/23436563/6674256
      const newTracks = []
      for (const track of cloneDeep(this.callSet.tracks)) {
        track.url = this.changePath(track.url)
        track.indexURL = this.changePath(track.indexURL)
        newTracks.push(track)
      }
      return newTracks
    }
  },
  methods: {
    closeLightbox () {
      return this.$router.push('/')
    },
    changePath (filename) {
      // return `${this.publicPath}${filename}`
      return `/${filename}`
    }
  },
  mounted () {
    console.log('igv.js version', igv.version())

    const options = {
      genome: 'hg38',
      locus: 'chr10:10265461', // 'chr1:820,455-820,494', // this.locus.coordinates,
      tracks: this.tracks
    }

    console.log('options:', JSON.parse(JSON.stringify(options)))

    igv.createBrowser(this.$refs.igv, options).then(browser => {
      console.log('browser info:', browser)
    })
  }
}
</script>

<style>
  .lightbox {
    /* https://stackoverflow.com/questions/49049829/event-bubbling-with-z-indices */
    z-index: 6;
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 50px;
    background-color: rgba(0, 0, 0, 0.8);
  }

  .igv {
    background-color: white;
  }
</style>
