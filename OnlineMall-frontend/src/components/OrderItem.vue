<!--
 * 我的订单列表
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="order-item">
    <div class="order-header">
      <div class="order-info">
        <span class="order-date">{{ order.create_time }}</span>
        <span class="order-number">订单编号：{{ order.order_no }}</span>
      </div>
      <div class="order-status" :class="statusClass">
        {{ order.state }}
      </div>
    </div>
    
    <div class="order-body">
      <div class="product-image">
        <router-link :to="'/goodview/' + order.good_id">
          <el-image 
            :src="baseApi + order.imgs" 
            fit="cover"
            :preview-src-list="[baseApi + order.imgs]"
          ></el-image>
        </router-link>
      </div>
      
      <div class="order-details">
        <div class="product-info">
          <router-link :to="'/goodview/' + order.good_id" class="product-name">
            {{ order.good_name }}
          </router-link>
          <div class="product-meta">
            <span class="product-spec">规格：{{ order.standard }}</span>
            <span class="product-quantity">数量：{{ order.count }}</span>
          </div>
        </div>
        
        <div class="order-price">
          <div class="price-amount">¥{{ order.total_price }}</div>
        </div>
        
        <div class="shipping-info">
          <el-popover
            placement="bottom-start"
            width="300"
            trigger="hover"
          >
            <div class="address-detail">
              <p><i class="el-icon-user"></i> 收货人：{{ order.link_user }}</p>
              <p><i class="el-icon-phone"></i> 联系电话：{{ order.link_phone }}</p>
              <p><i class="el-icon-location"></i> 收货地址：{{ order.link_address }}</p>
            </div>
            <div slot="reference" class="recipient">
              <i class="el-icon-user"></i>
              <span>{{ order.link_user }}</span>
            </div>
          </el-popover>
        </div>
        
        <div class="order-actions">
          <!-- 已发货状态 -->
          <template v-if="order.state === '已发货'">
            <el-button type="success" size="small" @click="receive">确认收货</el-button>
          </template>
          
          <!-- 已收货状态 -->
          <template v-else-if="order.state === '已收货'">
            <el-tag type="success" effect="dark">
              <i class="el-icon-check"></i> 交易完成
            </el-tag>
          </template>
          
          <!-- 已支付状态 -->
          <template v-else-if="order.state === '已支付'">
            <el-tag type="info">等待发货</el-tag>
          </template>
          
          <!-- 待付款状态 -->
          <template v-else>
            <el-button type="primary" size="small" @click="pay">去支付</el-button>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "OrderItem",
  props: {
    order: Object,
  },
  data() {
    return {
      baseApi: this.$store.state.baseApi,
    }
  },
  computed: {
    // 根据订单状态返回对应的样式类
    statusClass() {
      const statusMap = {
        '待付款': 'status-pending',
        '已支付': 'status-paid',
        '已发货': 'status-shipped',
        '已收货': 'status-completed'
      };
      return statusMap[this.order.state] || '';
    }
  },
  methods: {
    // 跳转到支付页面
    pay() {
      this.$router.push({
        path: 'pay',
        query: {
          money: this.order.total_price,
          orderNo: this.order.order_no
        }
      });
    },
    
    // 确认收货
    receive() {
      this.$confirm('是否确认收货?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        this.request.get("/api/order/received/" + this.order.order_no).then(res => {
          if (res.code === '200') {
            this.$message.success("收货成功");
            this.order.state = '已收货';
            this.$emit('order-updated');
          }
        });
      }).catch(() => {
        // 取消操作
      });
    }
  }
}
</script>

<style scoped>
.order-item {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  margin-bottom: 20px;
  overflow: hidden;
  transition: all 0.3s;
}

.order-item:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
}

.order-header {
  background-color: #f5f7fa;
  padding: 12px 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  border-bottom: 1px solid #ebeef5;
}

.order-info {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 15px;
}

.order-date {
  color: #606266;
  font-size: 14px;
}

.order-number {
  color: #303133;
  font-weight: 500;
}

.order-status {
  font-weight: bold;
  padding: 4px 10px;
  border-radius: 4px;
  font-size: 14px;
}

.status-pending {
  color: #e6a23c;
}

.status-paid {
  color: #409EFF;
}

.status-shipped {
  color: #67c23a;
}

.status-completed {
  color: #67c23a;
}

.order-body {
  padding: 20px;
  display: flex;
  align-items: center;
}

.product-image {
  width: 100px;
  height: 100px;
  margin-right: 20px;
  flex-shrink: 0;
}

.product-image .el-image {
  width: 100%;
  height: 100%;
  border-radius: 4px;
  border: 1px solid #ebeef5;
}

.order-details {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
}

.product-info {
  flex: 1;
  margin-right: 20px;
}

.product-name {
  font-size: 16px;
  color: #303133;
  text-decoration: none;
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
}

.product-name:hover {
  color: #409EFF;
}

.product-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 15px;
  color: #909399;
  font-size: 14px;
}

.order-price {
  margin-right: 20px;
  text-align: right;
}

.price-amount {
  font-size: 18px;
  color: #f56c6c;
  font-weight: bold;
}

.shipping-info {
  margin-right: 20px;
}

.recipient {
  color: #409EFF;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
}

.address-detail {
  line-height: 1.8;
  color: #606266;
}

.address-detail p {
  margin: 5px 0;
}

.address-detail i {
  margin-right: 5px;
  color: #909399;
}

.order-actions {
  min-width: 100px;
  text-align: right;
}

@media screen and (max-width: 768px) {
  .order-body {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .product-image {
    margin-bottom: 15px;
    margin-right: 0;
  }
  
  .order-details {
    width: 100%;
  }
  
  .product-info, .order-price, .shipping-info {
    margin-bottom: 15px;
    margin-right: 0;
    width: 100%;
  }
  
  .order-actions {
    width: 100%;
    text-align: left;
  }
}
</style>
