import axios from 'axios'
import ElementUI from "element-ui";
import router from '../router'

const request = axios.create({
    baseURL: '/api',  // 修改为相对路径，通过Nginx代理转发到后端
    timeout: 5000
})

// request 拦截器
// 可以自请求发送前对请求做一些处理
// 比如统一加token，对请求参数统一加密
request.interceptors.request.use(config => {
    config.headers['Content-Type'] = 'application/json;charset=utf-8';
    let user = JSON.parse(localStorage.getItem("user"))
    if(user){
         config.headers['token'] = user.token;  // 设置token
    }
    return config
}, error => {
    return Promise.reject(error)
});

// response 拦截器
// 可以在接口响应后统一处理结果
request.interceptors.response.use(
    response => {
        let res = response.data;
        // 如果是返回的文件
        if (response.config.responseType === 'blob') {
            return res
        }
        // 兼容服务端返回的字符串数据
        if (typeof res === 'string') {
            res = res ? JSON.parse(res) : res
        }
        // 发生错误，如token失效，则返回登录
        if(res.code==='402'){
            ElementUI.MessageBox({
                title: '错误',
                message: res.msg
            }).then(() =>{
                router.push('/login')
            } )
        }
        return res;
    },
    error => {
        return Promise.reject(error)
    }
)


export default request

