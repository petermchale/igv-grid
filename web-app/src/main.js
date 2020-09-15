import Vue from 'vue'
import App from '@/App.vue'
import { router } from '@/routes'
import vuetify from '@/vuetify'
import { store } from '@/store'
import VueClipboard from 'vue-clipboard2'

Vue.use(VueClipboard)

Vue.config.productionTip = false

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app')
