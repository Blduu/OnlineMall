<!--
 * 我的购物车页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="container cart-container">
    <!-- 购物车为空时 -->
    <div v-if="carts.length === 0" class="empty-cart">
      <el-empty :image-size="200" description="购物车是空的">
        <router-link to="/">
          <el-button type="primary">去购物</el-button>
        </router-link>
      </el-empty>
    </div>
    
    <!-- 购物车有商品时 -->
    <div v-else>
      <div class="cart-header">
        <h2>我的购物车</h2>
        <div class="cart-total">
          共 <span class="count">{{ carts.length }}</span> 件商品
        </div>
      </div>
      
      <!-- 购物车商品列表 -->
      <cart-item 
        v-for="cart in carts" 
        :key="cart.id" 
        :cart="cart" 
        @delete="delItem"
      ></cart-item>
    </div>
  </div>
</template>

<script>
import CartItem from "@/components/CartItem";

export default {
  name: "Cart",
  data() {
    return {
      userId: null,
      carts: [],
    }
  },
  components: {
    CartItem
  },
  created() {
    this.loadCartData();
  },
  methods: {
    loadCartData() {
      this.request.get("/userid").then(res => {
        this.userId = res;
        this.request.get("/api/cart/userid/" + this.userId).then(res => {
          if (res.code === '200') {
            this.carts = res.data;
            // 格式化日期时间
            this.carts.forEach(item => {
              item.createTime = item.createTime
                .toLocaleString()
                .replace(/T/g, ' ')
                .replace(/\.[\d]{3}Z/, '');
            });
          } else {
            this.$message.error("获取购物车数据失败");
          }
        });
      });
    },
    delItem(id) {
      this.carts = this.carts.filter(item => item.id != id);
    }
  }
}
</script>

<style scoped>
.cart-container {
  min-height: 60vh;
  padding: 20px;
}

.cart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding-bottom: 15px;
  border-bottom: 1px solid var(--border-color-lighter);
}

.cart-header h2 {
  margin: 0;
  font-weight: 500;
  color: var(--main-black);
}

.cart-total {
  color: var(--secondary-black);
}

.cart-total .count {
  color: var(--primary-color);
  font-weight: bold;
  margin: 0 5px;
}

.empty-cart {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 100px 0;
}
</style>
