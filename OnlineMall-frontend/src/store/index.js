import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    baseApi: "",  // 使用相对路径，配合vue.config.js中的代理设置和nginx.conf配置
  },
  getters: {
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})
