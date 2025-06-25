<!--
 * 前台首页 相关内容
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="top-view-container">
    <!-- 搜索组件 -->
    <search @search="handleSearch" class="search-component"></search>

    <!-- 主内容区域 -->
    <div class="main-content">
      <!-- 顶部区域：分类导航和轮播图 -->
      <div class="top-section">
        <!-- 商品分类导航 -->
        <div class="category-menu">
          <div class="category-header">
            <i class="el-icon-menu"></i>
            <span>商品分类</span>
          </div>
          
          <ul class="category-list">
            <li v-for="(item, index) in icons" :key="index" class="category-item">
              <div class="category-icon">
                <i class="iconfont" v-html="item.value"></i>
              </div>
              
              <div class="category-links">
                <div v-for="(category, index2) in item.categories" :key="index2" class="category-item-link">
                  <router-link
                    :to="{
                      path: '/goodlist',
                      query: { categoryId: category.id },
                    }"
                    class="category-link"
                  >
                    {{ category.name }}
                  </router-link>
                  <span v-if="index2 != item.categories.length - 1" class="category-separator">/</span>
                </div>
              </div>
            </li>
          </ul>
        </div>

        <!-- 轮播图区域 -->
        <div class="carousel-container">
          <el-carousel height="370px" indicator-position="outside" :interval="4000">
            <el-carousel-item v-for="carousel in carousels" :key="carousel.id">
              <router-link :to="'/goodview/' + carousel.goodId" class="carousel-link">
                <el-image 
                  :src="baseApi + carousel.img"
                  fit="cover"
                  class="carousel-image"
                ></el-image>
              </router-link>
            </el-carousel-item>
          </el-carousel>
        </div>
      </div>

      <!-- 推荐商品区域 -->
      <div class="recommended-section">
        <div class="section-header">
          <h2 class="section-title">
            <i class="el-icon-star-on"></i>
            推荐商品
          </h2>
          <el-link type="primary" :underline="false" href="/goodlist">查看更多 <i class="el-icon-arrow-right"></i></el-link>
        </div>
        
        <el-row :gutter="20" class="product-grid">
          <el-col 
            :xs="24" 
            :sm="12" 
            :md="8" 
            :lg="6" 
            v-for="good in good" 
            :key="good.id" 
            class="product-col"
          >
            <router-link :to="'goodview/' + good.id" class="product-link">
              <el-card shadow="hover" class="product-card">
                <div class="product-image-container">
                  <el-image 
                    :src="baseApi + good.imgs" 
                    fit="cover"
                    class="product-image"
                  ></el-image>
                </div>
                
                <div class="product-info">
                  <div class="product-name">{{ good.name }}</div>
                  <div class="product-price">
                    <span class="price-tag">¥{{ good.price }}</span>
                    <span class="original-price" v-if="good.discount && good.discount < 1">
                      ¥{{ (good.price / good.discount).toFixed(2) }}
                    </span>
                  </div>
                </div>
              </el-card>
            </router-link>
          </el-col>
        </el-row>
      </div>
    </div>
  </div>
</template>

<script>
import search from "../../components/Search";
export default {
  name: "TopView",
  //页面初始化数据
  data() {
    return {
      userId:null,
      //轮播图
      carousels: [],
      //推荐商品
      good: [],
      baseApi: this.$store.state.baseApi,

      //分类icon，每个icon包含id、value、categories对象数组.category：id，name
      icons: [],
      //搜索内容
      searchText: "",
    };
  },
  components: {
    search,
  },
  //页面创建
  created() {
    if (localStorage.getItem("user")) {
      let user = JSON.parse(localStorage.getItem("user"));
      this.userId = user.id
    }else{
      this.userId = 0;
    }

    this.request.get(`/api/good/all?userId=${this.userId}`).then((res) => {
      if (res.code === "200") {
        this.good = res.data;
      } else {
        this.$message.error(res.msg);
      }
    });
    this.request.get("/api/icon").then((res) => {
      if (res.code === "200") {
        this.icons = res.data;
        if(this.icons.length > 6) {
          // 截取前六个分类
          this.icons = this.icons.slice(0, 6);
        }
      }
    });
    this.request.get("/api/carousel").then((res) => {
      if (res.code === "200") {
        this.carousels = res.data;
      }
    });
  },
  //方法
  methods: {
    //搜索按钮触发
    handleSearch(text) {
      this.searchText = text;
      this.$router.push({
        path: "/goodList",
        query: { searchText: this.searchText },
      });
    },

  },
};

</script>

<style scoped>
.top-view-container {
  width: 100%;
}

.search-component {
  margin-bottom: 20px;
}

.main-content {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 20px;
}

/* 顶部区域样式 */
.top-section {
  display: flex;
  margin-bottom: 30px;
}

/* 分类导航样式 */
.category-menu {
  width: 250px;
  margin-right: 20px;
  background-color: #f5f7fa;
  border-radius: 4px;
  overflow: hidden;
}

.category-header {
  background-color: #409EFF;
  color: white;
  padding: 12px 15px;
  font-size: 16px;
  font-weight: bold;
}

.category-header i {
  margin-right: 5px;
}

.category-list {
  padding: 0;
  margin: 0;
  list-style: none;
}

.category-item {
  padding: 12px 15px;
  border-bottom: 1px solid #ebeef5;
  display: flex;
  align-items: center;
  transition: background-color 0.3s;
}

.category-item:hover {
  background-color: #ecf5ff;
}

.category-item:last-child {
  border-bottom: none;
}

.category-icon {
  margin-right: 10px;
  color: #606266;
}

.category-links {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.category-item-link {
  display: inline-block;
}

.category-link {
  color: #606266;
  text-decoration: none;
  font-size: 14px;
  transition: color 0.3s;
}

.category-link:hover {
  color: #409EFF;
}

.category-separator {
  margin: 0 5px;
  color: #c0c4cc;
}

/* 轮播图样式 */
.carousel-container {
  flex: 1;
  overflow: hidden;
  border-radius: 8px;
}

.carousel-link {
  display: block;
  width: 100%;
  height: 100%;
}

.carousel-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

/* 推荐商品区域样式 */
.recommended-section {
  margin-top: 30px;
}

.section-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

.section-title {
  font-size: 20px;
  color: #303133;
  margin: 0;
  display: flex;
  align-items: center;
}

.section-title i {
  color: #f56c6c;
  margin-right: 5px;
}

.product-grid {
  margin-bottom: 20px;
}

.product-col {
  margin-bottom: 20px;
}

.product-link {
  text-decoration: none;
  color: inherit;
  display: block;
}

.product-card {
  height: 100%;
  transition: transform 0.3s;
}

.product-card:hover {
  transform: translateY(-5px);
}

.product-image-container {
  height: 200px;
  overflow: hidden;
}

.product-image {
  width: 100%;
  height: 100%;
  transition: transform 0.3s;
}

.product-card:hover .product-image {
  transform: scale(1.05);
}

.product-info {
  padding: 10px 0;
}

.product-name {
  font-size: 14px;
  color: #303133;
  margin-bottom: 8px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.product-price {
  display: flex;
  align-items: center;
}

.price-tag {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
  margin-right: 8px;
}

.original-price {
  font-size: 12px;
  color: #909399;
  text-decoration: line-through;
}

/* 响应式样式 */
@media screen and (max-width: 992px) {
  .top-section {
    flex-direction: column;
  }
  
  .category-menu {
    width: 100%;
    margin-right: 0;
    margin-bottom: 20px;
  }
  
  .carousel-container {
    width: 100%;
  }
}

@media screen and (max-width: 768px) {
  .main-content {
    padding: 15px;
  }
  
  .category-item {
    padding: 10px;
  }
  
  .product-image-container {
    height: 150px;
  }
}
</style>
