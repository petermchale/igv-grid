<template>
  <v-app id="app">
    <v-app-bar app elevate-on-scroll style="background-color: #eee">
      <v-toolbar-title>IGV Grid</v-toolbar-title>
      <v-spacer/>
      <v-slider
        prepend-icon="mdi-image-multiple"
        v-model="batchSize"
        :min="minBatchSize"
        :max="maxBatchSize"
        hide-details=auto
      />
      <span class="numerical-field">{{ this.batchSize }}</span>
      <v-spacer/>
      <v-slider
        prepend-icon="mdi-image-size-select-large"
        v-model="imageSize"
        :min="minImageSize"
        :max="maxImageSize"
        hide-details
      />
    </v-app-bar>

    <!-- Sizes content based upon application components -->
    <v-main style="background-color: #eee">
      <!-- Provides the proper gutter to the application  -->
      <v-container fluid>
        <router-view :key="$route.path"/>
      </v-container>
    </v-main>

  </v-app>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    // https://vuex.vuejs.org/guide/forms.html#two-way-computed-property
    imageSize: {
      get () {
        return this.$store.state.imageSize
      },
      set (value) {
        this.$store.commit('setImageSize', value)
      }
    },
    batchSize: {
      get () {
        return this.$store.state.batchSize
      },
      set (value) {
        this.$store.commit('setBatchSize', value)
      }
    },
    ...mapState([
      'minImageSize',
      'maxImageSize',
      'minBatchSize',
      'maxBatchSize'
    ])
  }
}
</script>

<style scoped>
  .numerical-field {
    margin-left: 9px;
    width: 40px;
    color: rgba(0,0,0,.6);
  }
</style>
