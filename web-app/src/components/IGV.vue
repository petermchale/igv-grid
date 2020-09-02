<template>
  <div class="lightbox" @click.self="closeLightbox">
    <div ref="igv" class="overflow-box">
    </div>
  </div>
</template>

<script>
import igv from 'igv'
import callSets from '@/assets/thumbnails.json'
import { fastaURL, indexURL } from '@/assets/reference.json'
import { cloneDeep } from 'lodash'

export default {
  data () {
    return {
      callSets,
      browser: null
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
      return this.callSet.tracks
    }
  },
  methods: {
    closeLightbox () {
      return this.$router.push('/')
    }
  },
  mounted () {
    // console.log('igv.js version', igv.version())

    const options = {
      showIdeogram: true,
      reference: { fastaURL, indexURL },
      locus: this.locus.coordinates,
      // https://github.com/igvteam/igv.js/issues/1167:
      tracks: cloneDeep(this.tracks).filter(track => track.interactive)
    }

    igv.createBrowser(this.$refs.igv, options).then(browser => {
      this.browser = browser
      // console.log('browser info:', browser)
    })
  },
  beforeDestroy () {
    // prevent memory leaks:
    igv.removeBrowser(this.browser)
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

  .overflow-box {
    overflow: auto;
    height: 100%;
    background-color: white;
  }
</style>
