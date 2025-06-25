<!--
 * 商品列表
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="container">
    <search @search="handleSearch"></search>

    <div class="product-container box-shadow-light radius-large">
      <!-- 商品分类 -->
      <div class="category-section">
        <div class="section-header">
          <h2>商品分类</h2>
        </div>
        
        <el-row :gutter="20" class="category-list">
          <el-col v-for="(item, index) in icons" :key="index" :span="6" class="category-group">
            <div class="category-icon">
              <i class="iconfont" v-html="item.value"></i>
            </div>
            <div class="category-items">
              <span v-for="(category, index2) in item.categories" :key="index2">
                <el-link
                  :underline="false"
                  @click="load(category.id)"
                  :class="{ 'is-active': categoryId == category.id }"
                >
                  {{ category.name }}
                </el-link>
                <span v-if="index2 != item.categories.length - 1" class="separator">/</span>
              </span>
            </div>
          </el-col>
        </el-row>
      </div>

      <el-divider></el-divider>

      <!-- 商品列表 -->
      <div class="product-list-section">
        <el-row :gutter="24">
          <el-col
            :xs="12"
            :sm="8" 
            :md="8" 
            :lg="6"
            v-for="good in good"
            :key="good.id"
            class="product-item"
          >
            <router-link :to="'goodview/' + good.id">
              <el-card 
                class="product-card box-shadow-light" 
                :body-style="{ padding: '0px' }"
                shadow="hover"
              >
                <div class="product-image">
                  <el-image 
                    :src="baseApi + good.imgs"
                    fit="cover"
                    lazy
                  >
                    <div slot="error" class="image-slot">
                      <i class="el-icon-picture-outline"></i>
                    </div>
                  </el-image>
                </div>
                
                <div class="product-info">
                  <div class="product-name">{{ good.name }}</div>
                  <div class="product-price">
                    <span class="price-symbol">¥</span>
                    <span class="price-value">{{ good.price }}</span>
                  </div>
                </div>
              </el-card>
            </router-link>
          </el-col>
        </el-row>
        
        <!-- 无商品时显示 -->
        <el-empty 
          v-if="good.length === 0" 
          description="暂无相关商品" 
          :image-size="200"
        ></el-empty>
      </div>

      <!-- 分页控件 -->
      <div class="pagination-section">
        <el-pagination
          background
          :hide-on-single-page="false"
          :current-page="currentPage"
          :page-size="pageSize"
          layout="total, prev, pager, next, jumper"
          :total="total"
          @current-change="handleCurrentPage"
        >
        </el-pagination>
      </div>
    </div>
  </div>
</template>

<script>
import search from "@/components/Search";

export default {
  name: "GoodList",
  data() {
    return {
      // 分类icon，每个icon包含id、value、categories对象数组.category：id，name
      icons: [],
      total: 0,
      pageSize: 12,
      currentPage: 1,
      // 选择的分类
      categoryId: Number,
      // 搜索的内容
      searchText: "",
      good: [],
      baseApi: this.$store.state.baseApi,
    };
  },
  components: {
    search,
  },
  created() {
    // 二者一般不同时存在
    this.searchText = this.$route.query.searchText;
    this.categoryId = this.$route.query.categoryId;

    this.loadCategories();
    this.load();
  },
  methods: {
    loadCategories() {
      this.request.get("/api/icon").then((res) => {
        if (res.code === "200") {
          this.icons = res.data;
        }
      });
    },
    handleCurrentPage(currentPage) {
      this.currentPage = currentPage;
      this.load();
    },
    handleSearch(text) {
      this.searchText = text;
      this.load();
    },
    load(categoryId) {
      if (categoryId != undefined) {
        this.categoryId = categoryId;

        this.$router.push({
          path: "/goodlist",
          query: { categoryId: this.categoryId },
        });
      }
      this.request
        .get("/api/good/page", {
          params: {
            pageNum: this.currentPage,
            pageSize: this.pageSize,
            searchText: this.searchText,
            categoryId: this.categoryId,
          },
        })
        .then((res) => {
          if (res.code === "200") {
            this.total = res.data.total;
            this.good = res.data.records;
          }
        });
    },
  },
};
</script>

<style scoped>
.product-container {
  background-color: white;
  padding: 30px;
  margin-bottom: 30px;
}

.section-header {
  margin-bottom: 20px;
}

.section-header h2 {
  margin: 0;
  color: var(--primary-color);
  font-size: 24px;
  font-weight: 500;
}

/* 分类区域样式 */
.category-section {
  margin-bottom: 20px;
}

.category-list {
  margin-top: 15px;
}

.category-group {
  margin-bottom: 15px;
}

.category-icon {
  margin-bottom: 8px;
}

.category-icon .iconfont {
  font-size: 22px;
  color: var(--primary-color);
}

.category-items {
  font-size: 14px;
  line-height: 1.8;
}

.category-items .el-link {
  margin: 0 3px;
  font-size: 14px;
}

.category-items .el-link.is-active {
  color: var(--primary-color);
  font-weight: bold;
}

.separator {
  color: var(--secondary-black);
  margin: 0 3px;
}

/* 商品列表样式 */
.product-list-section {
  margin-top: 20px;
  min-height: 400px;
}

.product-item {
  margin-bottom: 20px;
}

.product-card {
  transition: all 0.3s;
  height: 100%;
}

.product-card:hover {
  transform: translateY(-5px);
}

.product-image {
  height: 200px;
  overflow: hidden;
}

.el-image {
  width: 100%;
  height: 100%;
}

.image-slot {
  display: flex;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 100%;
  background: var(--background-color-base);
  color: var(--placeholder);
  font-size: 30px;
}

.product-info {
  padding: 15px;
}

.product-name {
  font-size: 16px;
  color: var(--main-black);
  margin-bottom: 10px;
  height: 44px;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.product-price {
  color: #ff6700;
  font-size: 18px;
  display: flex;
  align-items: baseline;
}

.price-symbol {
  font-size: 14px;
  margin-right: 2px;
}

.price-value {
  font-weight: bold;
}

/* 分页区域样式 */
.pagination-section {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

@media (max-width: 768px) {
  .product-container {
    padding: 15px;
  }
  
  .category-section {
    margin-bottom: 10px;
  }
  
  .category-group {
    margin-bottom: 10px;
  }
  
  .section-header h2 {
    font-size: 20px;
  }
}
</style>
