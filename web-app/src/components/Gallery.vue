<template>
  <div>
    <v-card
      outlined
      v-for="callSet in callSets"
      :key="callSet.id"
      style="margin-bottom: 25px;"
    >
      <v-card-title>{{ callSet.labelForVisualization }}</v-card-title>
      <v-card-subtitle>Batch {{ batchIDs[callSet.id] + 1 }} of {{ numberOfBatches (callSet) }}</v-card-subtitle>
      <v-divider role="presentation"></v-divider>
      <!--
        don't use "v-model" on "v-carousel":
        https://vuex.vuejs.org/guide/forms.html#form-handling
        https://github.com/vuejs/vue/issues/477#issuecomment-58759371
       -->
      <!--
        "value" is a prop of "v-carousel";
        "change" is an event of "v-carousel", with value equal to a number;
        "https://vuetifyjs.com/en/components/carousels/#api
        -->
      <!--
        "updateBatchIDs(callSet.id, $event)";
        https://vuejs.org/v2/guide/events.html#Methods-in-Inline-Handlers
        for "v-carousel", the emitted event is a number, as per the vuetify spec;
        -->
      <v-carousel
        :value="batchIDs[callSet.id]"
        @change="updateBatchIDs(callSet.id, $event)"
        height="auto"
        hide-delimiters
        show-arrows-on-hover
      >
        <!-- "eager" prop forces v-carousel-item content to render when its mounted: -->
        <!-- https://stackoverflow.com/questions/60628478/vuetify-carousel-image-loading -->
        <v-carousel-item
          v-for="(loci, locusID) in batchesOfLoci(callSet)"
          :key="`/${callSet.id}/${locusID}`"
          eager
        >
          <!-- wrapping rows: https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/ -->
          <div
            class="gallery"
            :style="{ 'grid-template-columns': gridTemplateColumns }"
          >
            <v-hover
              v-for="locus in loci"
              :key="`/interactive/${callSet.id}/${locus.id}`"
              v-slot:default="{ hover }"
            >
              <div class="thumbnail-container">
                <img
                  :ref="`thumbnail.${callSet.id}.${locus.id}`"
                  class="thumbnail"
                  :class="`elevation-${hover || (callSetAndLocusSelected(callSet, locus)) ? 16 : 0}`"
                  :style="{
                    'border-color': borderColor(callSet, locus),
                    'z-index': hover ? elevatedThumbnailZIndex : 0,
                    'cursor': hover ? 'pointer' : ''
                    }"
                  @click="goToIGV(callSet.id, locus.id)"
                  :src="thumbnailURL(locus.image)"
                >
                <div
                  class="thumbnail-button-container"
                  :style="{
                    'opacity': hover ? 1 : 0,
                    'z-index': elevatedThumbnailZIndex
                    }"
                >
                  <v-btn
                    x-small fab dark depressed
                    color="rgba(0, 0, 0, .3)"
                    @click="copyGalleryURL(callSet.id, locus.id)"
                  >
                    <v-icon dark>mdi-share-variant</v-icon>
                  </v-btn>
                </div>
              </div>
            </v-hover>
          </div>
        </v-carousel-item>
      </v-carousel>
    </v-card>

    <v-snackbar rounded="pill" v-model="snackbar">
      Shareable URL copied to clipboard!
      <template v-slot:action="{ attrs }">
        <v-btn
          color='error'
          text
          v-bind="attrs"
          @click="snackbar = false"
        >
          Close
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script>
import callSets from '@/assets/thumbnails.json'
import { mapState } from 'vuex'
import tippy from 'tippy.js'
import 'tippy.js/dist/tippy.css'

export default {
  name: 'gallery',
  data () {
    return {
      callSets,
      elevatedThumbnailZIndex: 1,
      snackbar: false,
      tippy: null,
      tippyTimer: null
    }
  },
  methods: {
    thumbnailURL (image) {
      return require(`@/assets/thumbnails/${image}`)
    },
    batchesOfLoci (callSet) {
      const loci = callSet.loci
      const batches = []
      for (let i = 0; i < loci.length; i += this.batchSize) {
        batches.push(loci.slice(i, i + this.batchSize))
      }
      return batches
    },
    numberOfBatches (callSet) {
      return this.batchesOfLoci(callSet).length
    },
    callSetSelected (callSet) {
      return callSet.id === this.selectedCallSetID
    },
    locusSelected (locus) {
      return locus.id === this.selectedLocusID
    },
    callSetAndLocusSelected (callSet, locus) {
      return this.callSetSelected(callSet) && this.locusSelected(locus)
    },
    borderColor (callSet, locus) {
      if (this.callSetAndLocusSelected(callSet, locus)) {
        return 'black'
      } else {
        return 'rgba(0,0,0,.12)'
      }
    },
    updateBatchIDs (index, value) {
      this.$store.commit('setBatchIDs', { index, value })
    },
    updateSelectedCallSetIDAndLocusID (callSetID, locusID) {
      this.$store.commit('setSelectedCallSetIDAndLocusID', { callSetID, locusID })
    },
    copyGalleryURL (callSetID, locusID) {
      this.$copyText(
        `${window.location.origin}/gallery/${this.batchSize}/${this.batchIDs}/${callSetID}/${locusID}`
      ).then(
        e => {
          this.snackbar = true
          this.updateSelectedCallSetIDAndLocusID(callSetID, locusID)
        },
        e => console.log('not copied', e)
      )
    },
    goToIGV (callSetID, locusID) {
      this.updateSelectedCallSetIDAndLocusID(callSetID, locusID)
      this.$router.push(`/interactive/${callSetID}/${locusID}`)
    },
    showTippy () {
      this.tippy = tippy(
        this.$refs[`thumbnail.${this.selectedCallSetID}.${this.selectedLocusID}`][0], {
          content: 'This thumbnail has been shared with you!',
          placement: 'top',
          trigger: 'manual', // only programmatically trigger tippy
          hideOnClick: true
        })
      this.tippy.show()
    }
  },
  computed: {
    gridTemplateColumns () {
      return `repeat(auto-fit, minmax(${this.imageSize}px, 1fr))`
    },
    ...mapState([
      'imageSize',
      'batchSize',
      'selectedCallSetID',
      'selectedLocusID',
      'batchIDs'
    ])
  },
  created () {
    if (this.$route.name === 'gallery') {
      let { batchSize, batchIDs, callSetID, locusID } = this.$route.params

      batchSize = Number(batchSize)
      batchIDs = batchIDs.split(',').map(string => Number(string))
      callSetID = Number(callSetID)
      locusID = Number(locusID)

      this.$store.commit('setBatchSize', batchSize)
      for (let index = 0; index < batchIDs.length; index++) {
        this.updateBatchIDs(index, batchIDs[index])
      }
      this.updateSelectedCallSetIDAndLocusID(callSetID, locusID)
    }
  },
  mounted () {
    if (this.$route.name === 'gallery') {
      this.tippyTimer = setTimeout(this.showTippy, 1000)
    }
  },
  // https://router.vuejs.org/guide/advanced/navigation-guards.html#in-component-guards
  beforeRouteLeave (to, from, next) {
    if (from.name === 'gallery') {
      console.log('tidying up tippy and its timer')
      clearTimeout(this.tippyTimer)
      this.tippy.destroy(true)
    }
    next()
  }
}
</script>

<style>
  .gallery {
    display: grid;
    grid-gap: 10px;
    padding: 10px 10px 10px 10px;
  }

  .thumbnail-container {
    /*
      Setting "position" makes the element with this class
      the "closest positioned ancestor" of direct-descendent elements,
      and therefore their spatial point of reference
     */
    position: relative;
  }

  .thumbnail {
    padding: 2px;
    width: 100%;
    object-fit: contain;
    /* object-position: 50% 50%; doesn't work */
    border-radius: 4px;
    border-style: solid;
    border-width: 0.5px;
    /* set "position" to allow "z-index" to work: https://css-tricks.com/almanac/properties/p/position/#values */
    position: relative;
  }

  .thumbnail-button-container {
    transition: .5s ease;
    /* setting "position" also allows "z-index" to work: https://css-tricks.com/almanac/properties/p/position/#values */
    position: absolute;
    top: 10px;
    left: 10px;
  }

  div.tippy-content {
    font-family: 'Google Sans', sans-serif;
  }
</style>
