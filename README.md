# OnlineMall - 全功能电商系统

OnlineMall是一套完整的电子商务平台解决方案，采用前后端分离架构，支持商品展示、购物车、订单管理、支付模拟、用户管理、推荐系统等全套电商功能。本项目提供完整的Docker部署方案，适用于本地开发和生产环境部署。

## 项目技术栈

### 后端技术
- **核心框架**: Spring Boot 2.5.6
- **ORM框架**: MyBatis Plus 3.5.1 
- **数据库**: MySQL 8.4.5
- **缓存**: Redis 8.0.1
- **认证授权**: JWT (java-jwt 3.10.3)
- **API文档**: Swagger 2.9.2
- **工具库**: Hutool 5.7.21、Lombok、FastJSON
- **推荐系统**: 协同过滤算法

### 前端技术
- **核心框架**: Vue.js 2.6.14
- **UI组件库**: Element UI 2.15.6
- **路由管理**: Vue Router 3.5.1
- **状态管理**: Vuex 3.6.2
- **HTTP客户端**: Axios
- **图表库**: ECharts 5.4.2

### 容器化和部署
- **容器化**: Docker, Docker Compose
- **Web服务器**: Nginx
- **自动化部署**: PowerShell, Bash脚本

## 项目结构

```
OnlineMall/
├── OnlineMall-backend/         # 后端项目
│   ├── Dockerfile              # 后端Docker镜像构建文件
│   ├── src/                    # 后端源代码
│   │   ├── main/java           # Java源码
│   │   └── main/resources      # 资源文件和配置
│   ├── avatar/                 # 用户头像存储目录
│   ├── file/                   # 系统文件存储目录
│   └── sql/                    # 数据库初始化脚本
├── OnlineMall-frontend/        # 前端项目
│   ├── Dockerfile              # 前端Docker镜像构建文件
│   ├── nginx.conf              # Nginx配置文件
│   └── src/                    # 前端源代码
├── docker-compose.yml          # Docker Compose配置文件
├── deploy.ps1                  # PowerShell部署脚本
├── deploy.bat                  # 批处理部署脚本
├── server-init.sh              # 服务器初始化脚本
└── 部署文档.md                  # 详细部署文档
```

## 核心功能

### 用户端功能
- 用户注册、登录和个人中心
- 商品分类浏览和搜索
- 商品详情查看
- 购物车管理
- 下单和支付流程
- 订单管理和历史记录
- 个性化商品推荐
- 用户地址管理
- 消息系统

### 管理端功能
- 商品管理（新增、编辑、删除、上下架）
- 商品分类管理
- 轮播图管理
- 订单管理和统计
- 用户管理
- 销售统计和数据分析图表
- 文件和头像管理

## 环境配置

项目支持两种环境配置，通过Spring profiles自动切换：

1. **本地开发环境** (`local` profile)
   - 默认连接本地MySQL和Redis
   - 适合开发和调试

2. **Docker部署环境** (`docker` profile)
   - 连接Docker容器中的MySQL和Redis
   - 适合生产环境部署

## 快速开始

### 1. 本地开发环境搭建

#### 前提条件
- JDK 1.8+
- Maven 3.5+
- MySQL 8.0+
- Redis 6.0+
- Node.js 12.0+
- npm 6.0+

#### 后端启动步骤

1. 准备本地数据库：
   - MySQL (localhost:3306)，用户名/密码: root/root
   - 创建数据库：`DB_OnlineMall`
   - 导入初始数据：`OnlineMall-backend/sql/DB_OnlineMall.sql`

2. 准备Redis服务：
   - Redis (localhost:6379)，密码: root

3. 启动后端项目：
   ```bash
   cd OnlineMall-backend
   mvn spring-boot:run
   ```
   或直接在IDE中运行`BackendApplication`类

#### 前端启动步骤

1. 安装依赖：
   ```bash
   cd OnlineMall-frontend
   npm install
   ```

2. 启动开发服务器：
   ```bash
   npm run serve
   ```
   
3. 访问前端：
   - 浏览器打开 `http://localhost:8080`

### 2. Docker 部署

#### 本地Docker部署

使用Docker Compose在本地快速部署整个系统：

```bash
# 构建镜像并启动容器
docker-compose up -d
```

访问：
- 前端: `http://localhost`
- 后端API: `http://localhost:8080`

#### 服务器部署

##### 服务器环境准备

在Alibaba Cloud Linux服务器上执行初始化脚本：

```bash
chmod +x server-init.sh
./server-init.sh
```

该脚本自动安装Docker、Docker Compose，配置镜像加速，开放必要端口等。

##### 使用PowerShell部署（Windows推荐）：

```powershell
.\deploy.ps1 -Version 1.0.0 -ServerIp <服务器IP> -ServerPassword <服务器密码>
```

参数说明：
- `Version`: 镜像版本号，方便版本管理
- `ServerIp`: 服务器IP地址
- `ServerPassword`: 服务器root用户密码

##### 使用批处理脚本部署：

```batch
deploy.bat -version 1.0.0 -serverip <服务器IP> -serverpassword <服务器密码>
```

> **注意**：部署脚本需要安装OpenSSH工具或Git for Windows（内置SSH）

### 3. 验证部署

- 前端访问: `http://<服务器IP>`
- 后端API: `http://<服务器IP>:8080/swagger-ui.html`
- 默认管理员账号: admin/123456

## 系统架构

### 开发环境架构
```
[浏览器] → [前端开发服务器:8080] → [本地后端服务:8080] → [本地MySQL/Redis]
```

### Docker部署架构
```
[用户] → [Nginx容器:80] → [Spring Boot容器:8080] → [MySQL容器:3306/Redis容器:6379]
       ↘ [管理员] → [Swagger API文档:8080/swagger-ui.html]
```

## 部署方案特点

- **多环境支持**：同一代码库支持本地开发和Docker生产环境
- **自动环境切换**：基于Spring Profiles实现环境配置自动切换
- **多组件容器化**：MySQL、Redis、前端、后端全部容器化部署
- **数据持久化**：使用Docker数据卷保存MySQL和Redis数据
- **自动化构建**：一键完成前后端项目构建、打包和部署
- **版本管理**：支持镜像版本号管理，便于回滚
- **环境隔离**：各组件独立容器运行，互不干扰
- **配置灵活**：通过环境变量注入，支持不同环境配置
- **统一代理**：使用Nginx反向代理，简化前后端交互
- **文件存储**：支持商品图片、用户头像等静态资源存储

## 数据目录持久化

Docker部署中，以下数据通过卷挂载实现持久化：

- MySQL数据：`mysql-data:/var/lib/mysql`
- Redis数据：`redis-data:/data`
- 用户头像：`./OnlineMall-backend/avatar:/app/avatar`
- 系统文件：`./OnlineMall-backend/file:/app/file`

## 常见问题排查

1. **数据库连接失败**
   - 检查MySQL服务状态：`docker logs onlinemall-mysql`
   - 确认连接配置与环境匹配

2. **Redis连接失败**
   - 检查Redis服务状态：`docker logs onlinemall-redis`
   - 确认密码配置正确

3. **图片上传失败**
   - 确认`avatar`和`file`目录权限正确
   - 检查目录挂载是否正确

4. **前端访问后端API失败**
   - 检查Nginx配置中的反向代理设置
   - 确认后端服务运行正常

5. **容器无法启动**
   - 检查端口占用：`netstat -tulpn | grep <端口号>`
   - 查看容器日志：`docker logs <容器名>`

更多问题排查，请参考 [部署文档](./部署文档.md)。

## 开发者指南

项目使用标准的Spring Boot和Vue.js开发流程：

1. 后端API开发流程：
   - 定义Entity实体类
   - 创建Mapper接口和XML
   - 实现Service业务逻辑
   - 编写Controller接口

2. 前端页面开发流程：
   - 创建Vue组件
   - 配置路由
   - 调用API实现功能
   - 样式调整

## 许可证

本项目采用MIT许可证，详情请参见LICENSE文件。

## 联系方式

如有问题或建议，请提交Issue或联系项目维护者。 