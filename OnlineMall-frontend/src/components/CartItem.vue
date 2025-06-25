<!--
 * 购物车内容项
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <el-card class="cart-item box-shadow-light" :body-style="{ padding: '0px' }">
    <div class="cart-header">
      <span>
        <i class="el-icon-time"></i>
        {{ cart.createTime }}
      </span>
    </div>
    
    <div class="cart-body">
      <div class="cart-product">
        <router-link :to="'/goodview/'+cart.goodId" class="product-image">
          <el-image 
            :src="baseApi + cart.img" 
            fit="cover" 
            :preview-src-list="[baseApi + cart.img]">
            <div slot="error" class="image-slot">
              <i class="el-icon-picture-outline"></i>
            </div>
          </el-image>
        </router-link>

        <div class="product-info">
          <router-link :to="'/goodview/'+cart.goodId" class="product-name">
            {{ cart.goodName }}
          </router-link>
          <div class="product-spec">规格：{{ cart.standard }}</div>
        </div>
      </div>

      <div class="cart-details">
        <div class="price-section">
          <div class="price-label">单价</div>
          <div class="price-value">¥ {{ realPrice.toFixed(2) }}</div>
        </div>

        <div class="quantity-section">
          <div class="quantity-label">数量</div>
          <div class="quantity-control">
            <template v-if="!countChangeFlag">
              <el-button 
                type="text" 
                size="mini" 
                @click="countChangeFlag=true" 
                class="quantity-display"
              >
                {{ cart.count }} <i class="el-icon-edit"></i>
              </el-button>
            </template>
            
            <el-input-number 
              v-else
              v-model="cart.count" 
              :min="1" 
              :max="cart.store" 
              size="mini"
              @change="updateQuantity"
            ></el-input-number>
          </div>
        </div>

        <div class="total-section">
          <div class="total-label">总价</div>
          <div class="total-value">¥ {{ totalPrice }}</div>
        </div>

        <div class="action-section">
          <el-button 
            type="primary" 
            size="mini" 
            @click="pay" 
            icon="el-icon-shopping-cart-2"
          >
            结算
          </el-button>
          
          <el-popconfirm
            confirm-button-text="确定"
            cancel-button-text="取消"  
            title="确定将该商品从购物车移除吗？"
            @confirm="del"
            icon="el-icon-warning"
            icon-color="red"
          >
            <el-button 
              slot="reference" 
              type="danger" 
              size="mini" 
              icon="el-icon-delete"
            >
              删除
            </el-button>
          </el-popconfirm>
        </div>
      </div>
    </div>
  </el-card>
</template>

<script>
export default {
  name: "CartItem",
  props: {
    cart: Object
  },
  data() {
    return {
      countChangeFlag: false,
      baseApi: this.$store.state.baseApi
    }
  },
  computed: {
    totalPrice: function() {
      return (this.realPrice * this.cart.count).toFixed(2)
    },
    realPrice: function() {
      return (this.cart.price * this.cart.discount)
    }
  },
  methods: {
    // 从购物车移除
    del() {
      this.request.delete("/api/cart/" + this.cart.id).then(res => {
        if(res.code === '200') {
          this.$message({
            message: "商品已从购物车移除",
            type: "success"
          });
          this.$emit('delete', this.cart.id);
        }
      })
    },
    // 更新商品数量
    updateQuantity() {
      // 这里可以添加更新购物车数量的API调用
      this.countChangeFlag = false;
      this.$message({
        message: "商品数量已更新",
        type: "success"
      });
    },
    // 跳转到支付页面
    pay() {
      let good = {
        id: this.cart.goodId,
        name: this.cart.goodName,
        imgs: this.cart.img,
        discount: this.cart.discount
      };
      this.$router.push({
        name: 'preOrder',
        query: {
          good: JSON.stringify(good),
          realPrice: this.realPrice,
          num: this.cart.count,
          standard: this.cart.standard,
          cartId: this.cart.id
        }
      });
    }
  }
}
</script>

<style scoped>
.cart-item {
  margin-bottom: 20px;
  border-radius: 8px;
  overflow: hidden;
}

.cart-header {
  background-color: var(--primary-color);
  color: white;
  padding: 10px 20px;
  font-size: 14px;
}

.cart-body {
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.cart-product {
  display: flex;
  margin-bottom: 15px;
}

.product-image {
  width: 100px;
  height: 100px;
  margin-right: 20px;
  border-radius: 4px;
  overflow: hidden;
}

.product-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.product-name {
  font-size: 16px;
  margin-bottom: 10px;
  color: var(--main-black);
}

.product-spec {
  color: var(--secondary-black);
  font-size: 14px;
}

.cart-details {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-top: 15px;
  border-top: 1px dashed var(--border-color-light);
}

.price-section,
.quantity-section,
.total-section,
.action-section {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.price-label,
.quantity-label,
.total-label {
  color: var(--secondary-black);
  font-size: 12px;
  margin-bottom: 5px;
}

.price-value,
.total-value {
  font-weight: bold;
  color: var(--main-black);
}

.total-value {
  color: #ff6700;
}

.quantity-display {
  font-weight: bold;
}

.action-section {
  display: flex;
  flex-direction: row;
  gap: 10px;
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

@media (max-width: 768px) {
  .cart-details {
    flex-wrap: wrap;
  }
  
  .price-section, .quantity-section, .total-section, .action-section {
    margin: 10px;
  }
}
</style>
