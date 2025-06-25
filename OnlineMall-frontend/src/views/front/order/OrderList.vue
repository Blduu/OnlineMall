<!--
 * 订单列表
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="order-list-container">
    <div class="order-list-header">
      <h2 class="page-title">
        <i class="el-icon-tickets"></i>
        我的订单
      </h2>
      <el-radio-group v-model="activeStatus" size="medium" @change="filterOrders">
        <el-radio-button label="all">全部订单</el-radio-button>
        <el-radio-button label="待付款">待付款</el-radio-button>
        <el-radio-button label="已支付">已支付</el-radio-button>
        <el-radio-button label="已发货">已发货</el-radio-button>
        <el-radio-button label="已收货">已收货</el-radio-button>
      </el-radio-group>
    </div>

    <div class="order-list-content">
      <template v-if="filteredOrders.length > 0">
        <transition-group name="order-list" tag="div">
          <order-item 
            v-for="order in filteredOrders" 
            :order="order" 
            :key="order.id" 
            class="order-item"
            @order-updated="refreshOrders"
          ></order-item>
        </transition-group>
        
        <div class="order-list-footer">
          <el-pagination
            background
            layout="prev, pager, next"
            :page-size="pageSize"
            :total="totalOrders"
            :current-page.sync="currentPage"
            @current-change="handlePageChange"
          ></el-pagination>
        </div>
      </template>
      
      <el-empty 
        v-else 
        :image-size="200"
        description="暂无订单记录" 
        class="empty-state"
      >
        <el-button type="primary" @click="goShopping">去购物</el-button>
      </el-empty>
    </div>
  </div>
</template>

<script>
import OrderItem from "@/components/OrderItem";
import API from "@/utils/request";

export default {
  name: "OrderList",
  components: {
    'order-item': OrderItem,
  },
  data() {
    return {
      allOrders: [],
      filteredOrders: [],
      activeStatus: 'all',
      currentPage: 1,
      pageSize: 5,
      totalOrders: 0
    }
  },
  created() {
    this.loadOrders();
  },
  methods: {
    // 加载订单数据
    loadOrders() {
      API.get("/userid").then(res => {
        API.get("/api/order/userid/" + res).then(res => {
          if (res.code === '200') {
            this.allOrders = res.data;
            // 格式化日期
            for (let i = 0; i < this.allOrders.length; ++i) {
              this.allOrders[i].create_time = this.formatDate(this.allOrders[i].create_time);
            }
            // 按创建时间降序排序
            this.allOrders.sort((a, b) => new Date(b.create_time) - new Date(a.create_time));
            this.filterOrders();
          }
        });
      });
    },
    
    // 格式化日期
    formatDate(dateString) {
      if (!dateString) return '';
      return dateString.replace(/T/g, ' ').replace(/\.[\d]{3}Z/, '');
    },
    
    // 根据状态筛选订单
    filterOrders() {
      if (this.activeStatus === 'all') {
        this.filteredOrders = this.allOrders;
      } else {
        this.filteredOrders = this.allOrders.filter(order => order.state === this.activeStatus);
      }
      this.totalOrders = this.filteredOrders.length;
      this.currentPage = 1;
      this.updatePagedOrders();
    },
    
    // 更新分页数据
    updatePagedOrders() {
      const startIndex = (this.currentPage - 1) * this.pageSize;
      const endIndex = startIndex + this.pageSize;
      this.filteredOrders = this.filteredOrders.slice(startIndex, endIndex);
    },
    
    // 处理页码变化
    handlePageChange(page) {
      this.currentPage = page;
      this.updatePagedOrders();
    },
    
    // 刷新订单列表
    refreshOrders() {
      this.loadOrders();
    },
    
    // 前往购物
    goShopping() {
      this.$router.push('/');
    }
  }
}
</script>

<style scoped>
.order-list-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

.order-list-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  flex-wrap: wrap;
  gap: 15px;
}

.page-title {
  font-size: 22px;
  color: #303133;
  margin: 0;
  display: flex;
  align-items: center;
}

.page-title i {
  margin-right: 8px;
  color: #409EFF;
}

.order-list-content {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  padding: 20px;
  min-height: 400px;
}

.order-item {
  margin-bottom: 15px;
  transition: all 0.3s;
}

.order-list-enter-active, .order-list-leave-active {
  transition: all 0.5s;
}

.order-list-enter, .order-list-leave-to {
  opacity: 0;
  transform: translateY(30px);
}

.order-list-footer {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

.empty-state {
  padding: 40px 0;
}

@media screen and (max-width: 768px) {
  .order-list-container {
    padding: 10px;
  }
  
  .order-list-header {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .order-list-content {
    padding: 15px;
  }
}
</style>
