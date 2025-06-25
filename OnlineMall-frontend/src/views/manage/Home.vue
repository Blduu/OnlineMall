<!--
 * 后台管理欢迎页
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="dashboard-container">
    <div class="welcome-section">
      <div class="welcome-content">
        <h1 class="welcome-title">网上购物商城后台管理系统</h1>
        <p class="welcome-subtitle">欢迎回来，{{ userName }}！</p>
        <div class="welcome-time">{{ currentTime }}</div>
      </div>
    </div>
    
    <div class="dashboard-cards">
      <!-- 统计卡片 -->
      <el-row :gutter="20">
        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="dashboard-card">
            <div class="card-content">
              <div class="card-icon user-icon">
                <i class="el-icon-user"></i>
              </div>
              <div class="card-info">
                <div class="card-title">用户总数</div>
                <div class="card-value">{{ stats.userCount }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="dashboard-card">
            <div class="card-content">
              <div class="card-icon order-icon">
                <i class="el-icon-s-order"></i>
              </div>
              <div class="card-info">
                <div class="card-title">订单总数</div>
                <div class="card-value">{{ stats.orderCount }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="dashboard-card">
            <div class="card-content">
              <div class="card-icon goods-icon">
                <i class="el-icon-goods"></i>
              </div>
              <div class="card-info">
                <div class="card-title">商品总数</div>
                <div class="card-value">{{ stats.goodCount }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
        
        <el-col :xs="24" :sm="12" :md="6">
          <el-card shadow="hover" class="dashboard-card">
            <div class="card-content">
              <div class="card-icon income-icon">
                <i class="el-icon-money"></i>
              </div>
              <div class="card-info">
                <div class="card-title">总收入</div>
                <div class="card-value">¥{{ stats.totalIncome }}</div>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <div class="dashboard-shortcuts">
      <el-row :gutter="20">
        <el-col :xs="24" :md="12">
          <el-card shadow="hover" class="shortcut-card">
            <div slot="header" class="shortcut-header">
              <span>快捷操作</span>
            </div>
            <div class="shortcut-list">
              <el-button type="primary" icon="el-icon-plus" @click="navigateTo('/manage/good')">添加商品</el-button>
              <el-button type="success" icon="el-icon-view" @click="navigateTo('/manage/order')">查看订单</el-button>
              <el-button type="warning" icon="el-icon-picture" @click="navigateTo('/manage/carousel')">轮播图管理</el-button>
              <el-button type="info" icon="el-icon-user" @click="navigateTo('/manage/user')">用户管理</el-button>
            </div>
          </el-card>
        </el-col>
        
        <el-col :xs="24" :md="12">
          <el-card shadow="hover" class="system-card">
            <div slot="header" class="system-header">
              <span>系统信息</span>
            </div>
            <div class="system-info">
              <div class="info-item">
                <span class="info-label">系统版本：</span>
                <span class="info-value">v1.0.0</span>
              </div>
              <div class="info-item">
                <span class="info-label">服务器状态：</span>
                <span class="info-value">
                  <el-tag size="small" type="success">正常运行</el-tag>
                </span>
              </div>
              <div class="info-item">
                <span class="info-label">上次更新：</span>
                <span class="info-value">{{ lastUpdateTime }}</span>
              </div>
              <div class="info-item">
                <span class="info-label">开发者：</span>
                <span class="info-value">BlueSky</span>
              </div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
export default {
  name: "Home",
  data() {
    return {
      userName: '管理员',
      currentTime: '',
      lastUpdateTime: '2025-06-20',
      stats: {
        userCount: '0',
        orderCount: '0',
        goodCount: '0',
        totalIncome: '0.00'
      },
      timer: null
    };
  },
  mounted() {
    // 获取用户信息
    const user = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {};
    if (user.nickname) {
      this.userName = user.nickname;
    }
    
    // 更新时间
    this.updateTime();
    this.timer = setInterval(this.updateTime, 1000);
    
    // 获取统计数据
    this.fetchStats();
  },
  beforeDestroy() {
    // 清除定时器
    if (this.timer) {
      clearInterval(this.timer);
    }
  },
  methods: {
    // 更新当前时间
    updateTime() {
      const now = new Date();
      const options = { 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric', 
        weekday: 'long',
        hour: '2-digit', 
        minute: '2-digit', 
        second: '2-digit' 
      };
      this.currentTime = now.toLocaleDateString('zh-CN', options);
    },
    
    // 获取统计数据
    fetchStats() {
      // 这里应该是从后端API获取数据
      // 由于没有实际的API，这里使用模拟数据
      setTimeout(() => {
        this.stats = {
          userCount: Math.floor(Math.random() * 1000) + 100,
          orderCount: Math.floor(Math.random() * 5000) + 500,
          goodCount: Math.floor(Math.random() * 300) + 50,
          totalIncome: (Math.random() * 100000 + 10000).toFixed(2)
        };
      }, 500);
    },
    
    // 导航到指定路径
    navigateTo(path) {
      this.$router.push(path);
    }
  }
};
</script>

<style scoped>
.dashboard-container {
  padding: 20px;
  height: 100%;
}

.welcome-section {
  text-align: center;
  margin-bottom: 30px;
  padding: 40px 20px;
  background: rgba(255, 255, 255, 0.8);
  border-radius: 8px;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.welcome-title {
  font-size: 28px;
  font-weight: bold;
  color: var(--primary-color);
  margin-bottom: 10px;
}

.welcome-subtitle {
  font-size: 18px;
  color: #606266;
  margin-bottom: 15px;
}

.welcome-time {
  font-size: 14px;
  color: #909399;
}

.dashboard-cards {
  margin-bottom: 30px;
}

.dashboard-card {
  height: 100px;
  margin-bottom: 20px;
  transition: all 0.3s;
}

.dashboard-card:hover {
  transform: translateY(-5px);
}

.card-content {
  display: flex;
  align-items: center;
  height: 100%;
}

.card-icon {
  width: 64px;
  height: 64px;
  border-radius: 8px;
  display: flex;
  justify-content: center;
  align-items: center;
  margin-right: 15px;
}

.card-icon i {
  font-size: 30px;
  color: white;
}

.user-icon {
  background-color: #409EFF;
}

.order-icon {
  background-color: #67C23A;
}

.goods-icon {
  background-color: #E6A23C;
}

.income-icon {
  background-color: #F56C6C;
}

.card-info {
  flex: 1;
}

.card-title {
  font-size: 14px;
  color: #909399;
  margin-bottom: 5px;
}

.card-value {
  font-size: 24px;
  font-weight: bold;
  color: #303133;
}

.shortcut-card, .system-card {
  height: 100%;
  margin-bottom: 20px;
}

.shortcut-header, .system-header {
  font-weight: bold;
  color: #303133;
}

.shortcut-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.system-info {
  padding: 10px 0;
}

.info-item {
  display: flex;
  margin-bottom: 15px;
  font-size: 14px;
}

.info-label {
  width: 100px;
  color: #909399;
}

.info-value {
  flex: 1;
  color: #303133;
}

@media screen and (max-width: 768px) {
  .welcome-section {
    padding: 20px 10px;
  }
  
  .welcome-title {
    font-size: 22px;
  }
  
  .welcome-subtitle {
    font-size: 16px;
  }
  
  .shortcut-list {
    flex-direction: column;
  }
  
  .shortcut-list .el-button {
    margin-bottom: 10px;
  }
}
</style>
