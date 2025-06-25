# 网上购物系统前端

## 项目介绍

本项目是一个基于 Vue.js 开发的网上购物系统前端，提供完整的电商购物体验，包括商品浏览、购物车、订单管理、用户管理等功能。系统分为前台商城和后台管理两大模块，满足普通用户购物和管理员运营需求。

## 技术栈

- **前端框架**: Vue.js 2.6.14
- **路由管理**: Vue Router 3.5.1
- **状态管理**: Vuex 3.6.2
- **UI组件库**: Element UI 2.15.6
- **HTTP客户端**: Axios 0.26.1
- **数据可视化**: ECharts 5.4.2
- **加密工具**: js-md5 0.7.3
- **构建工具**: Vue CLI 5.0.3
- **容器化**: Docker
- **Web服务器**: Nginx

## 项目结构

```
OnlineMall-frontend/
├── public/                  # 静态资源目录
├── src/                     # 源代码目录
│   ├── components/          # 公共组件
│   │   ├── AddressBox.vue   # 地址选择组件
│   │   ├── Aside.vue        # 侧边栏组件
│   │   ├── CartItem.vue     # 购物车商品项组件
│   │   ├── Header.vue       # 页头组件
│   │   ├── IncomeItem.vue   # 收入项组件
│   │   ├── MessageItem.vue  # 消息项组件
│   │   ├── Navagation.vue   # 导航组件
│   │   ├── OrderItem.vue    # 订单项组件
│   │   └── Search.vue       # 搜索组件
│   ├── router/              # 路由配置
│   ├── store/               # Vuex状态管理
│   ├── utils/               # 工具类
│   │   ├── icons.js         # 图标工具
│   │   └── request.js       # Axios请求封装
│   ├── views/               # 页面视图
│   │   ├── front/           # 前台商城视图
│   │   │   ├── good/        # 商品相关页面
│   │   │   ├── order/       # 订单相关页面
│   │   │   └── TopView.vue  # 首页视图
│   │   ├── manage/          # 后台管理视图
│   │   │   ├── file/        # 文件管理
│   │   │   ├── good/        # 商品管理
│   │   │   ├── income/      # 收入统计
│   │   │   └── Home.vue     # 后台首页
│   │   ├── Login.vue        # 登录页
│   │   ├── Person.vue       # 个人信息页
│   │   └── Register.vue     # 注册页
│   ├── resource/            # 资源文件
│   │   ├── css/             # 样式文件
│   │   ├── img/             # 图片资源
│   │   └── global.css       # 全局样式
│   ├── App.vue              # 根组件
│   └── main.js              # 入口文件
├── Dockerfile               # Docker构建文件
├── nginx.conf               # Nginx配置文件
├── babel.config.js          # Babel配置
├── vue.config.js            # Vue CLI配置
└── package.json             # 项目依赖
```

## 核心组件说明

### Navagation.vue

网站导航组件，提供了商城首页、商品分类、购物车、订单等入口，同时包含用户登录状态显示和操作菜单。

### Front.vue

前台商城的主布局组件，包含页头导航、主内容区和页脚设计，提供了良好的用户体验。

### GoodList.vue

商品列表页面，实现了按分类浏览商品、搜索商品功能，支持分页显示，商品卡片展示等功能。

### Home.vue

后台管理系统的首页，展示了系统概览、数据统计和快捷操作，为管理员提供直观的数据展示和便捷的功能入口。

## 功能模块

### 前台商城

1. **首页**
   - 轮播图展示热门商品
   - 商品分类导航
   - 商品推荐展示
   - 搜索功能

2. **商品**
   - 商品分类浏览
   - 商品搜索与筛选
   - 商品详情查看
   - 商品规格选择
   - 商品评价查看

3. **购物车**
   - 添加商品到购物车
   - 修改商品数量
   - 删除购物车商品
   - 购物车结算
   - 选择/全选商品

4. **订单**
   - 订单预览确认
   - 收货地址管理
   - 支付方式选择
   - 订单支付流程
   - 订单列表查看
   - 订单状态跟踪
   - 订单详情查看

5. **用户中心**
   - 个人信息管理
   - 头像上传修改
   - 收货地址管理
   - 订单管理
   - 密码修改

### 后台管理

1. **用户管理**
   - 用户列表展示
   - 用户信息编辑
   - 用户状态管理
   - 用户权限设置

2. **商品管理**
   - 商品分类管理
   - 商品信息维护
   - 商品规格管理
   - 商品上下架控制
   - 轮播图管理

3. **订单管理**
   - 订单列表查看
   - 订单详情查看
   - 订单状态更新
   - 订单发货操作

4. **数据统计**
   - 销量统计图表
   - 收入统计图表
   - 商品销售排行
   - 收入走势分析

5. **文件管理**
   - 商品图片上传管理
   - 用户头像管理
   - 轮播图资源管理

## 数据流转

1. **前端数据流**
   - 使用Vuex进行全局状态管理
   - 组件间通过Props和Events进行数据传递
   - 复杂表单数据通过Vuex存储和提交

2. **前后端交互**
   - 使用Axios封装HTTP请求
   - 统一的请求拦截器添加Token认证
   - 统一的响应拦截器处理错误和Token失效
   - RESTful API设计规范

3. **数据本地存储**
   - 用户登录信息存储在localStorage
   - 购物车数据在未登录时存储在localStorage
   - 登录后与服务器数据同步

## 安装与运行

### 环境要求

- Node.js 14.0+
- npm 6.0+

### 开发环境搭建

1. **克隆项目**

```bash
git clone <项目仓库地址>
cd OnlineMall-frontend
```

2. **安装依赖**

```bash
npm install
```

3. **配置环境变量**

在项目根目录创建`.env`文件（如需要），配置相关环境变量。

4. **启动开发服务器**

```bash
npm run dev
```

开发服务器默认运行在 http://localhost:8932

### 生产环境构建

```bash
# 构建生产环境版本
npm run build
```

构建完成后，生成的静态文件将位于`dist`目录下。

### Docker部署

1. **构建Docker镜像**

```bash
docker build -t onlinemall-frontend .
```

2. **运行容器**

```bash
# 单独运行前端容器
docker run -d -p 80:80 --name onlinemall-frontend onlinemall-frontend

# 或使用docker-compose运行整个应用栈
docker-compose up -d
```

## 接口代理配置

项目通过 Nginx 反向代理将前端请求转发至后端服务:

### 开发环境

在`vue.config.js`中配置了代理设置:

```javascript
devServer: {
  port: 8932,
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true,
      pathRewrite: {
        '^/api': ''
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
}
```

### 生产环境

在`nginx.conf`中配置了反向代理:

```
location /api/ {
    proxy_pass http://backend:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}

location /file/ {
    proxy_pass http://backend:8080/file/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}

location /avatar/ {
    proxy_pass http://backend:8080/avatar/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

## 权限控制

系统实现了基于角色的访问控制:

- **游客**: 可以浏览商品、注册、登录
- **普通用户**: 可以购买商品、管理购物车、查看订单、管理个人信息
- **管理员**: 可以访问后台管理系统，进行商品、用户、订单等全方位管理

权限控制在路由守卫中实现，通过`meta.requireAuth`和`meta.requireLogin`属性控制页面访问权限。

## 项目亮点

1. **响应式设计**：适配不同屏幕尺寸的设备
2. **模块化组件**：高度复用的组件设计
3. **权限控制系统**：基于角色的精细化权限控制
4. **数据可视化**：使用ECharts实现直观的数据图表展示
5. **完整Docker部署支持**：提供容器化部署方案
6. **统一的异常处理**：全局的错误处理和消息提示机制

## 项目展示

> 此部分应放置系统的截图展示，包括前台商城首页、商品详情页、购物车、后台管理等关键页面的截图。

## 浏览器兼容性

- Chrome (最新版)
- Firefox (最新版)
- Safari (最新版)
- Edge (最新版)
- 不支持IE浏览器

## 贡献指南

1. Fork本仓库
2. 创建特性分支：`git checkout -b feature/your-feature`
3. 提交更改：`git commit -m 'Add some feature'`
4. 推送分支：`git push origin feature/your-feature`
5. 提交Pull Request

## 开发者

BlueSky@2025

## 版本历史

- v1.0.0 (2025-06-20): 初始版本发布 