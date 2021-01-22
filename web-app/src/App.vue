<template>
  <v-app id="app">
    <v-app-bar app elevate-on-scroll style="background-color: #eee">
      <v-toolbar-title>IGV Grid</v-toolbar-title>

      <v-spacer/>

      <v-btn
        text
        class="text-none"
        href="https://github.com/petermchale/igv-grid"
        target="_blank"
        >
          GitHub
      </v-btn>

      <v-menu
        transition="scale-transition"
        origin="top right"
        :close-on-content-click="false"
      >
        <template v-slot:activator="{ on, attrs }">
          <v-btn
            icon
            v-bind="attrs"
            v-on="on"
          >
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </template>
        <v-list>
          <v-list-item>
            <v-list-item-action class="slider-container">
              <v-slider
                prepend-icon="mdi-image-multiple"
                v-model="batchSize"
                :min="minBatchSize"
                :max="maxBatchSize"
                hide-details=auto
              />
            </v-list-item-action>
            <v-list-item-content>
              <span class="numerical-field">{{ this.batchSize }}</span>
            </v-list-item-content>
          </v-list-item>
          <v-list-item>
            <v-list-item-action style="width: 300px; margin-right: 10px;">
              <v-slider
                prepend-icon="mdi-image-size-select-large"
                v-model="imageSize"
                :min="minImageSize"
                :max="maxImageSize"
                hide-details
              />
            </v-list-item-action>
          </v-list-item>
        </v-list>
      </v-menu>

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
  data () {
    return {
    }
  },
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
    width: 25px;
    color: rgba(0,0,0,.6);
  }
  .slider-container {
    width: 300px;
    margin-right: 10px !important;
  }
</style>
