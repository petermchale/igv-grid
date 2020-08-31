import Vue from 'vue'
import VueRouter from 'vue-router'

import NotFoundComponent from '@/components/NotFoundComponent'
import Gallery from '@/components/Gallery'
import IGVOnGallery from '@/components/IGVOnGallery'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    component: Gallery
  },
  {
    path: '/:callSetID/:locusID',
    component: IGVOnGallery
  },
  {
    // https://router.vuejs.org/guide/essentials/history-mode.html#caveat
    path: '*',
    component: NotFoundComponent
  }
]

export const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})
