# OnlineMall-backend 网上购物商城后端

## 项目介绍

OnlineMall-backend 是一个基于 Spring Boot 的网上购物商城后端系统，提供了完整的电商平台功能支持，包括用户管理、商品管理、订单管理、购物车、支付等功能模块。系统采用前后端分离架构，本项目为后端部分，为前端提供REST风格的API接口。

## 技术栈

- **基础框架**：Spring Boot 2.5.6
- **ORM框架**：Mybatis-Plus 3.5.1
- **数据库**：MySQL 8.x
- **缓存**：Redis
- **权限认证**：JWT (JSON Web Token)
- **接口文档**：Swagger 2.9.2
- **其他工具库**：
  - Hutool 5.7.21 - Java工具类库
  - Fastjson 1.2.73 - JSON处理库
  - Lombok - 简化Java代码
  - Druid 1.2.2 - 数据库连接池

## 系统架构

### 整体架构

系统采用了分层架构设计，从上至下依次为：

- **表示层**：Controller层，负责接收和响应HTTP请求
- **业务层**：Service层，处理业务逻辑
- **持久层**：Mapper层，与数据库交互
- **数据层**：Entity实体类，对应数据库表结构
- **通用组件**：工具类和通用配置

### 架构图

```
┌───────────────────┐
│    前端应用       │
└─────────┬─────────┘
          │
          │ HTTP请求
          ▼
┌───────────────────┐      ┌───────────────┐
│   API网关/接口层   │─────>│   认证授权    │
└─────────┬─────────┘      └───────────────┘
          │
          │
          ▼
┌───────────────────┐      ┌───────────────┐
│    业务逻辑层     │<────>│   缓存服务    │
└─────────┬─────────┘      └───────────────┘
          │
          │
          ▼
┌───────────────────┐
│    数据访问层     │
└─────────┬─────────┘
          │
          │
          ▼
┌───────────────────┐
│    数据库服务     │
└───────────────────┘
```

### 前后端交互流程

```
┌─────────┐      ┌─────────┐      ┌─────────┐      ┌─────────┐      ┌─────────┐
│  浏览器  │      │ Vue前端 │      │ 后端API │      │  Redis  │      │ MySQL  │
└────┬────┘      └────┬────┘      └────┬────┘      └────┬────┘      └────┬────┘
     │                │                │                │                │
     │  请求页面      │                │                │                │
     │───────────────>│                │                │                │
     │                │                │                │                │
     │  返回页面      │                │                │                │
     │<───────────────│                │                │                │
     │                │                │                │                │
     │  用户操作      │                │                │                │
     │───────────────>│                │                │                │
     │                │  API请求(携带token) │                │                │
     │                │───────────────>│                │                │
     │                │                │  验证token    │                │
     │                │                │───────────────>│                │
     │                │                │                │                │
     │                │                │  返回用户信息  │                │
     │                │                │<───────────────│                │
     │                │                │                │                │
     │                │                │  数据库操作    │                │
     │                │                │───────────────────────────────>│
     │                │                │                │                │
     │                │                │  返回数据      │                │
     │                │                │<───────────────────────────────│
     │                │                │                │                │
     │                │                │  缓存数据(可选)│                │
     │                │                │───────────────>│                │
     │                │  返回API响应   │                │                │
     │                │<───────────────│                │                │
     │                │                │                │                │
     │  更新页面      │                │                │                │
     │<───────────────│                │                │                │
     │                │                │                │                │
```

### 部署架构

系统支持两种部署方式：传统部署和Docker容器化部署。

#### Docker部署架构

```
┌─────────────────────────────────────────────────────┐
│                   Docker Compose                    │
│                                                     │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────┐  │
│  │ Nginx容器     │  │ Backend容器   │  │ MySQL   │  │
│  │ (前端静态文件)│  │ (Spring Boot) │  │ 容器    │  │
│  └───────┬───────┘  └───────┬───────┘  └────┬────┘  │
│          │                  │                │      │
│          └──────────────────┼────────────────┘      │
│                             │                       │
│                    ┌────────┴────────┐              │
│                    │  Redis容器      │              │
│                    └─────────────────┘              │
└─────────────────────────────────────────────────────┘

           │                  │                │
           ▼                  ▼                ▼
      80/443端口         8080端口       数据持久化卷
        (外部访问)       (API访问)      (数据存储)
```

## 功能模块

### 1. 用户模块
- 用户注册、登录、退出
- 个人信息管理
- 地址管理
- 权限控制

### 2. 商品模块
- 商品分类管理
- 商品信息管理（名称、价格、库存、图片等）
- 商品规格管理
- 商品搜索

### 3. 购物车模块
- 购物车商品管理
- 购物车结算

### 4. 订单模块
- 订单创建、查询、管理
- 订单状态流转

### 5. 支付模块
- 支付接口集成
- 订单支付状态管理

### 6. 文件模块
- 商品图片上传与管理
- 用户头像管理

### 7. 推荐系统
- 商品推荐算法
- 个性化推荐

### 8. 消息与评论模块
- 用户留言
- 评论与回复

## 项目结构

```
OnlineMall-backend/
├─ src/main/java/com/bluesky/em/
│  ├─ BackendApplication.java            # 应用程序入口
│  ├─ common/                            # 通用类
│  ├─ config/                            # 配置类
│  │  ├─ CorsConfig.java                 # 跨域配置
│  │  ├─ GlobalExceptionHandler.java     # 全局异常处理
│  │  ├─ InterceptorConfig.java          # 拦截器配置
│  │  ├─ MybatisPlusConfig.java          # MybatisPlus配置
│  │  ├─ RedisConfig.java                # Redis配置
│  │  └─ SwaggerConfig.java              # Swagger文档配置
│  ├─ constants/                         # 常量定义
│  ├─ controller/                        # 控制器层
│  ├─ entity/                            # 实体类
│  │  ├─ form/                           # 表单对象
│  │  └─ vo/                             # 视图对象
│  ├─ exception/                         # 异常处理
│  ├─ interceptor/                       # 拦截器
│  │  └─ JwtInterceptor.java             # JWT拦截器
│  ├─ mapper/                            # MyBatis映射接口
│  ├─ service/                           # 服务接口
│  │  └─ impl/                           # 服务实现
│  └─ utils/                             # 工具类
│     ├─ recommend/                      # 推荐算法工具
│     └─ TokenUtils.java                 # Token处理工具
├─ src/main/resources/
│  ├─ application.yml                    # 应用配置文件
│  ├─ banner.txt                         # 启动Banner
│  └─ mapper/                            # MyBatis XML映射文件
├─ avatar/                               # 用户头像存储目录
├─ file/                                 # 文件上传存储目录
├─ sql/                                  # 数据库脚本
│  └─ DB_OnlineMall.sql                  # 数据库初始化脚本
├─ pom.xml                               # Maven项目配置
└─ Dockerfile                            # Docker构建文件
```

## 数据库设计

系统包含以下主要数据表：

- `sys_user`: 用户信息表
- `address`: 用户地址表
- `avatar`: 用户头像表
- `category`: 商品分类表
- `good`: 商品信息表
- `good_standard`: 商品规格表
- `cart`: 购物车表
- `t_order`: 订单表
- `order_goods`: 订单商品关联表
- `message`: 留言表
- `replay`: 回复表
- `icon`: 图标表
- `carousel`: 轮播图表
- `sys_file`: 系统文件表

### 表关系图

```
┌─────────────┐       ┌─────────────┐      ┌─────────────┐
│   sys_user  │       │   address   │      │   avatar    │
└─────┬───────┘       └──────┬──────┘      └─────────────┘
      │                      │                    │
      │ 1                    │ n                  │ 1
      ▼                      ▼                    ▼
┌─────────────┐       ┌─────────────┐      ┌─────────────┐
│    cart     │       │  t_order    │      │  category   │
└──────┬──────┘       └──────┬──────┘      └──────┬──────┘
       │                     │                    │
       │ n                   │ 1:n                │ 1
       ▼                     ▼                    ▼
┌─────────────┐       ┌─────────────┐      ┌─────────────┐
│    good     │◄──────┤ order_goods │      │  standard   │
└──────┬──────┘       └─────────────┘      └─────────────┘
       │
       │ 1:n
       ▼
┌─────────────┐       ┌─────────────┐      ┌─────────────┐
│good_standard │       │   message   │      │   replay    │
└─────────────┘       └──────┬──────┘      └──────┬──────┘
                             │                    │
                             │ 1                  │ n
                             └────────────────────┘
```

## 配置文件说明

### application.yml 主要配置

```yaml
# 服务端口
server:
  port: 8080  # 可根据需要修改

# Spring配置
spring:
  # 设置激活的环境
  profiles:
    active: ${SPRING_PROFILES_ACTIVE:local}  # 默认使用local环境，可通过环境变量覆盖
  
  # 数据库通用配置
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    # 连接池配置
    hikari:
      connection-timeout: 60000  # 连接超时时间
      maximum-pool-size: 10      # 最大连接数
      minimum-idle: 5            # 最小空闲连接数
  
  # 文件上传配置
  servlet:
    multipart:
      max-file-size: 30MB  # 最大文件上传大小

  # Redis配置
  redis:
    database: 0  # 使用的数据库索引
    lettuce:
      pool:
        min-idle: 0        # 最小空闲连接
        max-active: 8      # 最大活动连接
        max-idle: 8        # 最大空闲连接
        max-wait: -1ms     # 最大等待时间

# 是否开启推荐算法
useRecommend: true  # 设置为false可关闭推荐功能
```

### 环境特定配置

```yaml
# 本地开发环境配置
spring:
  config:
    activate:
      on-profile: local
  # 本地数据库配置
  datasource:
    url: jdbc:mysql://localhost:3306/DB_OnlineMall?serverTimezone=GMT%2b8&useSSL=false&allowPublicKeyRetrieval=true
    username: root
    password: root
  # 本地Redis配置  
  redis:
    host: localhost
    port: 6379
    password: root

# Docker环境配置
spring:
  config:
    activate:
      on-profile: docker
  # Docker数据库配置
  datasource:
    url: jdbc:mysql://mysql:3306/DB_OnlineMall?serverTimezone=GMT%2b8&useSSL=false&allowPublicKeyRetrieval=true
    username: onlinemall
    password: onlinemall
  # Docker Redis配置  
  redis:
    host: redis
    port: 6379
    password: root
```

## 安装部署

### 环境要求

- JDK 1.8+
- Maven 3.5+
- MySQL 8.x
- Redis

### 本地开发环境配置

1. 克隆项目到本地
   ```bash
   git clone [项目仓库URL]
   cd OnlineMall-backend
   ```

2. 创建并初始化数据库
   ```bash
   # 登录MySQL
   mysql -u root -p
   
   # 创建数据库
   CREATE DATABASE DB_OnlineMall;
   
   # 退出MySQL
   exit
   
   # 导入数据库脚本
   mysql -u root -p DB_OnlineMall < sql/DB_OnlineMall.sql
   ```

3. 修改数据库连接配置（如果需要）
   编辑 `src/main/resources/application.yml`，修改数据库连接信息和Redis连接信息

4. 编译打包
   ```bash
   mvn clean package -DskipTests
   ```

5. 运行项目
   ```bash
   java -jar target/OnlineMall-backend-0.0.1-SNAPSHOT.jar
   ```

### Docker部署

1. 构建Docker镜像
   ```bash
   docker build -t onlinemall-backend .
   ```

2. 使用docker-compose部署
   ```bash
   # 在项目根目录下（与docker-compose.yml同级）
   docker-compose up -d
   ```

## API文档

项目集成了Swagger文档，启动项目后可通过以下地址访问API文档：
```
http://localhost:8080/swagger-ui.html
```

通过Swagger UI可以查看所有API接口的详细说明，包括:
- 接口URL
- 请求方法
- 请求参数
- 响应结果
- 接口测试功能

### 文档结构

Swagger文档按照控制器进行分组，主要包括以下模块：
- 用户管理接口
- 商品管理接口
- 购物车接口
- 订单接口
- 文件上传接口
- 地址管理接口
- 轮播图管理接口
- 分类管理接口
- 收入统计接口

## 认证授权

系统使用JWT进行身份验证和授权。除了公开接口外，其他接口都需要在请求头中携带token进行访问。

### 认证流程

1. 用户登录成功后，服务端生成JWT token并返回给客户端
2. 客户端在后续请求中，在请求头中添加`token`字段，值为服务端返回的token
3. 服务端通过JwtInterceptor拦截请求，验证token的有效性
4. 验证成功后，从Redis中获取用户信息，并存入ThreadLocal中供后续业务使用
5. 请求结束后，清除ThreadLocal中的用户信息

### 权限控制

系统通过用户角色进行权限控制：
- 普通用户(user)：只能访问与自己相关的资源
- 管理员(admin)：可以访问所有资源，包括管理功能

### 相关代码

JWT认证相关的关键类：
- `TokenUtils.java`：负责生成token和验证登录状态
- `JwtInterceptor.java`：JWT拦截器，验证token并从Redis获取用户信息
- `UserHolder.java`：线程本地变量，存储当前请求的用户信息

## API接口示例

所有API都遵循REST风格，统一使用JSON格式进行数据交换。系统使用统一的响应格式：

```json
{
  "code": 200,      // 状态码：200成功，401认证失败，403权限不足，500服务器错误，其他业务错误码
  "msg": "success", // 响应消息
  "data": {}        // 返回的数据，可能是对象、数组或null
}
```

### 1. 用户认证接口

#### 用户登录
- **URL**: `/login`
- **Method**: `POST`
- **请求参数**:
  ```json
  {
    "username": "admin",
    "password": "123456"
  }
  ```
- **成功响应**:
  ```json
  {
    "code": 200,
    "msg": "登录成功",
    "data": {
      "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "user": {
        "id": 1,
        "username": "admin",
        "role": "admin",
        "avatar": "/avatar/xxx.png"
      }
    }
  }
  ```

#### 用户注册
- **URL**: `/register`
- **Method**: `POST`
- **请求参数**:
  ```json
  {
    "username": "user1",
    "password": "123456",
    "phone": "13800138000"
  }
  ```

### 2. 商品相关接口

#### 获取商品列表
- **URL**: `/api/good/list`
- **Method**: `GET`
- **请求参数**:
  - `pageNum`: 页码，默认1
  - `pageSize`: 每页数量，默认10
  - `categoryId`: 分类ID（可选）
  - `keyword`: 搜索关键字（可选）
- **成功响应**:
  ```json
  {
    "code": 200,
    "msg": "success",
    "data": {
      "records": [
        {
          "id": 1,
          "name": "智能手机",
          "description": "最新款智能手机",
          "imgs": "/file/xxx.png",
          "discount": 0.9,
          "sales": 100,
          "categoryId": 28
        }
      ],
      "total": 50,
      "pages": 5,
      "current": 1,
      "size": 10
    }
  }
  ```

#### 获取商品详情
- **URL**: `/api/good/detail/{id}`
- **Method**: `GET`
- **成功响应**:
  ```json
  {
    "code": 200,
    "msg": "success",
    "data": {
      "id": 1,
      "name": "智能手机",
      "description": "最新款智能手机",
      "imgs": "/file/xxx.png",
      "discount": 0.9,
      "sales": 100,
      "categoryId": 28,
      "standards": [
        {
          "value": "基础版",
          "price": 3999.00,
          "store": 100
        },
        {
          "value": "高级版",
          "price": 5999.00,
          "store": 50
        }
      ]
    }
  }
  ```

### 3. 购物车接口

#### 添加购物车
- **URL**: `/api/cart/add`
- **Method**: `POST`
- **Headers**: `token: xxx`
- **请求参数**:
  ```json
  {
    "goodId": 1,
    "count": 2,
    "standard": "基础版"
  }
  ```

#### 获取购物车列表
- **URL**: `/api/cart/list`
- **Method**: `GET`
- **Headers**: `token: xxx`
- **成功响应**:
  ```json
  {
    "code": 200,
    "msg": "success",
    "data": [
      {
        "id": 1,
        "goodId": 1,
        "goodName": "智能手机",
        "goodImg": "/file/xxx.png",
        "count": 2,
        "standard": "基础版",
        "price": 3999.00,
        "createTime": "2023-11-12 18:05:42"
      }
    ]
  }
  ```

### 4. 订单接口

#### 创建订单
- **URL**: `/api/order/create`
- **Method**: `POST`
- **Headers**: `token: xxx`
- **请求参数**:
  ```json
  {
    "addressId": 1,
    "cartIds": [1, 2]
  }
  ```
- **成功响应**:
  ```json
  {
    "code": 200,
    "msg": "创建成功",
    "data": {
      "orderId": 10001,
      "orderNo": "2023111200001",
      "totalAmount": 7998.00
    }
  }
  ```

## 推荐系统详解

系统实现了基于协同过滤(Collaborative Filtering)的商品推荐算法。主要原理是通过分析用户的历史行为，找出相似用户的喜好，为目标用户推荐他可能感兴趣但尚未接触过的商品。

### 算法流程

1. 收集用户行为数据（浏览、购买、收藏等）
2. 计算用户与商品之间的关联度矩阵
3. 基于用户相似度进行推荐（找出与当前用户相似的用户，推荐他们喜欢但当前用户尚未接触的商品）
4. 基于商品相似度进行推荐（找出与用户已经喜欢的商品相似的其他商品）

### 相关配置

系统的推荐功能可以通过`application.yml`中的`useRecommend`参数进行开关控制：

```yaml
# 是否开启推荐算法
useRecommend: true  # 设置为false可关闭推荐功能
```

### 相关代码

推荐算法的核心实现在`com.bluesky.em.utils.recommend`包下，主要包括：

- `CoreMath.java`: 核心数学计算工具，提供相似度计算等功能
- `dto/ProductDTO.java`: 商品数据传输对象
- `dto/RelateDTO.java`: 关联度数据传输对象

## 开发规范

### 代码风格

1. **命名规范**
   - 类名：使用大驼峰命名法（PascalCase）
   - 方法名与变量名：使用小驼峰命名法（camelCase）
   - 常量：全部大写，单词间用下划线分隔（SNAKE_CASE）
   - 包名：全部小写

2. **注释规范**
   - 类注释：包含类的功能描述、作者、日期等
   - 方法注释：包含方法功能、参数、返回值、异常等说明
   - 关键代码注释：对复杂逻辑进行必要的注释说明

3. **异常处理**
   - 使用自定义异常类`BizException`处理业务异常
   - 使用全局异常处理器统一处理异常，返回标准格式的错误信息

### API设计规范

1. 使用RESTful风格设计API
   - GET：获取资源
   - POST：创建资源
   - PUT：更新资源
   - DELETE：删除资源

2. URL命名规范
   - 使用名词而非动词
   - 复数形式表示集合资源
   - 避免使用特殊字符

3. 响应状态码
   - 200：成功
   - 400：请求参数错误
   - 401：未授权
   - 403：权限不足
   - 404：资源不存在
   - 500：服务器内部错误

## 常见问题(FAQ)

### Q1: 如何修改上传文件的存储路径？
A1: 在应用启动前，确保`avatar`和`file`目录已创建。若要修改路径，需要修改`FileConstants.java`中的相关常量。

### Q2: 如何扩展商品的规格类型？
A2: 在`good_standard`表中添加新的规格类型，同时修改前端表单组件以支持新的规格类型。

### Q3: Redis连接失败如何解决？
A3: 检查Redis服务是否正常运行，并确认`application.yml`中的Redis配置信息是否正确。确保网络连通性和防火墙设置允许应用访问Redis服务器。

### Q4: JWT token过期时间如何修改？
A4: 在`RedisConstants.java`中修改`USER_TOKEN_TTL`常量的值，该值定义了token的有效时间（默认单位为分钟）。

### Q5: 如何关闭Swagger文档？
A5: 在生产环境中，可以通过在`SwaggerConfig.java`中使用条件注解来控制Swagger的启用状态，或者直接移除相关依赖。

## 性能优化建议

1. **数据库优化**
   - 为频繁查询的字段添加适当的索引
   - 使用连接池管理数据库连接
   - 对大表进行分表分库处理

2. **缓存策略**
   - 商品详情、分类等不常变动的数据使用Redis缓存
   - 合理设置缓存过期时间
   - 实现缓存预热和缓存更新策略

3. **JVM调优**
   - 根据服务器资源适当调整JVM内存参数
   - 使用G1垃圾回收器减少停顿时间

4. **代码层面优化**
   - 避免频繁创建大对象，减少GC压力
   - 使用批量操作代替循环单条操作
   - 异步处理长耗时操作

## 项目特色与总结

### 技术特色

1. **前后端分离架构**
   - 后端提供RESTful API，前端使用Vue.js构建
   - 清晰的职责分离，便于团队协作

2. **JWT认证与权限控制**
   - 无状态的JWT认证机制
   - 基于Redis的token存储，提高安全性
   - 细粒度的权限控制机制

3. **智能推荐系统**
   - 基于协同过滤算法实现个性化商品推荐
   - 可根据用户行为自动调整推荐结果

4. **高效的数据库设计**
   - 合理的表结构设计，避免冗余数据
   - 良好的索引设计，提高查询效率

5. **全面的异常处理**
   - 自定义业务异常处理机制
   - 全局统一的异常处理策略

### 业务亮点

1. **完整的电商流程**
   - 从商品浏览、购物车、下单到支付的完整流程
   - 多规格商品支持，满足不同商品特性需求

2. **灵活的分类管理**
   - 支持多级分类管理
   - 分类与图标结合，增强用户体验

3. **多样的订单管理功能**
   - 订单状态流转管理
   - 订单统计与分析功能

4. **丰富的用户互动**
   - 留言与评论功能
   - 回复机制，促进用户间交流

5. **便捷的文件管理**
   - 商品图片和用户头像统一管理
   - 支持多种图片格式

### 项目展望

1. **功能扩展**
   - 集成更多支付方式
   - 添加商品评分系统
   - 实现站内消息通知功能

2. **性能优化**
   - 进一步优化数据库查询性能
   - 引入分布式缓存机制
   - 优化图片存储和访问方式

3. **安全性增强**
   - 增加接口访问频率限制
   - 强化数据加密机制
   - 完善日志记录和审计功能

## 联系方式

- 作者：BlueSky
- 日期：2025年6月15日 