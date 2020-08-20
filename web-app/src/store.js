import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export const store = new Vuex.Store({
  strict: true, // https://vuex.vuejs.org/guide/strict.html#development-vs-production
  state: {
    imageSize: 150,
    minImageSize: 100,
    maxImageSize: 600,
    batchSize: 10,
    minBatchSize: 5,
    maxBatchSize: 25
  },
  mutations: {
    setImageSize (state, imageSize) {
      state.imageSize = imageSize
    },
    setBatchSize (state, batchSize) {
      state.batchSize = batchSize
    }
  }
})
