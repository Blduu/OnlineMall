const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 8932, // 端口
    proxy: {
      '/api': {
        target: 'http://localhost:8080',  // 本地后端地址
        changeOrigin: true,
        pathRewrite: {
          '^/api': ''  // 将/api重写为空
        }
      },
      '/file': {
        target: 'http://localhost:8080',
        changeOrigin: true
      },
      '/avatar': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  },
})
