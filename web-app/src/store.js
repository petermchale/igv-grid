import Vue from 'vue'
import Vuex from 'vuex'

import callSets from '@/assets/thumbnails.json'

Vue.use(Vuex)

export const store = new Vuex.Store({
  strict: true, // https://vuex.vuejs.org/guide/strict.html#development-vs-production
  state: {
    imageSize: 150,
    minImageSize: 100,
    maxImageSize: 600,
    batchSize: 10,
    minBatchSize: 5,
    maxBatchSize: 25,
    selectedCallSetID: null,
    selectedLocusID: null,
    batchIDs: new Array(callSets.length).fill(0)
  },
  mutations: {
    setImageSize (state, imageSize) {
      state.imageSize = imageSize
    },
    setBatchSize (state, batchSize) {
      state.batchSize = batchSize
    },
    setSelectedCallSetIDAndLocusID (state, { callSetID, locusID }) {
      state.selectedCallSetID = callSetID
      state.selectedLocusID = locusID
    },
    setBatchIDs (state, { index, value }) {
      // https://vuejs.org/v2/guide/reactivity.html#For-Arrays
      // https://vuejs.org/v2/guide/list.html#Array-Change-Detection
      // https://vuex.vuejs.org/guide/mutations.html#mutations-follow-vue-s-reactivity-rules
      Vue.set(state.batchIDs, index, value)
    }
  }
})
