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
      <v-carousel
        v-model="batchIDs[callSet.id]"
        height="auto"
        hide-delimiters
        show-arrows-on-hover
      >
        <!-- "eager" prop forces v-carousel-item content to render when its mounted: -->
        <!-- https://stackoverflow.com/questions/60628478/vuetify-carousel-image-loading -->
        <v-carousel-item
          v-for="(loci, locusID) in batchesOfLoci(callSet)"
          :key="locusID"
          eager
        >
          <!-- wrapping rows: https://css-tricks.com/auto-sizing-columns-css-grid-auto-fill-vs-auto-fit/ -->
          <div
            class="gallery"
            :style="{ 'grid-template-columns': gridTemplateColumns }"
          >
            <router-link
              v-for="locus in loci"
              :key="locus.id"
              :to="`/${callSet.id}/${locus.id}`"
            >
              <v-hover v-slot:default="{ hover }">
                <img
                  class="gallery-panel"
                  :class="`elevation-${hover ? 16 : 0}`"
                  :style="{ 'z-index': hover ? 1: 0 }"
                  :src="thumbnailURL(locus.image)"
                >
              </v-hover>
            </router-link>
          </div>
        </v-carousel-item>
      </v-carousel>
    </v-card>
  </div>
</template>

<script>
import callSets from '@/assets/thumbnails.json'
import { mapState } from 'vuex'

export default {
  name: 'gallery',
  data () {
    return {
      batchIDs: new Array(callSets.length).fill(0),
      callSets
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
    }
  },
  computed: {
    gridTemplateColumns () {
      return `repeat(auto-fit, minmax(${this.imageSize}px, 1fr))`
    },
    ...mapState([
      'imageSize',
      'batchSize'
    ])
  }
}
</script>

<style>
  .gallery {
    display: grid;
    grid-gap: 10px;
    padding: 10px 10px 10px 10px;
  }

  .gallery-panel {
    width: 100%;
    object-fit: contain;
    /* object-position: 50% 50%; doesn't work */
    border-radius: 4px;
    border: thin solid rgba(0,0,0,.12);
    /* set "position" to allow "z-index" to work: https://css-tricks.com/almanac/properties/p/position/#values */
    position: relative;
  }
</style>
