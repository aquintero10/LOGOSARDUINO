import Vue from 'vue'
import App from './App.vue'
//import vueTable from 'vue-good-table'

Vue.config.productionTip = false
//Vue.use(vueTable);

new Vue({
  render: h => h(App),
}).$mount('#app')
