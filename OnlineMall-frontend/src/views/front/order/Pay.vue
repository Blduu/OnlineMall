<!--
 * 支付页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="pay-container">
    <el-card class="pay-card" shadow="hover">
      <div class="pay-header">
        <i class="el-icon-shopping-cart-full pay-icon"></i>
        <h2 class="pay-title">订单支付</h2>
      </div>
      
      <div class="order-info">
        <el-descriptions :column="1" border>
          <el-descriptions-item label="订单号">
            <span class="order-no">{{ orderNo }}</span>
          </el-descriptions-item>
          <el-descriptions-item label="支付金额">
            <span class="pay-amount">¥{{ money }}</span>
          </el-descriptions-item>
        </el-descriptions>
      </div>
      
      <div class="payment-methods">
        <div class="methods-title">
          <span>请选择支付方式</span>
        </div>
        
        <div class="methods-options">
          <div 
            class="payment-option" 
            :class="{ 'selected': selectedMethod === 'wechat' }"
            @click="selectPayment('wechat')"
          >
            <img src="../../../resource/img/微信支付.png" class="payment-icon">
            <span>微信支付</span>
          </div>
          
          <div 
            class="payment-option" 
            :class="{ 'selected': selectedMethod === 'alipay' }"
            @click="selectPayment('alipay')"
          >
            <img src="../../../resource/img/支付宝.png" class="payment-icon">
            <span>支付宝</span>
          </div>
        </div>
      </div>
      
      <div class="pay-actions">
        <el-button type="primary" size="large" @click="pay" :disabled="!selectedMethod">
          立即支付
        </el-button>
        <el-button @click="goBack">返回订单</el-button>
      </div>
      
      <div class="pay-tips">
        <i class="el-icon-warning-outline"></i>
        <span>请在30分钟内完成支付，超时订单将自动取消</span>
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "Pay",
  data() {
    return {
      userId: 0,
      money: 0,
      orderNo: '',
      selectedMethod: ''
    }
  },
  created() {
    this.money = parseFloat(this.$route.query.money).toFixed(2);
    this.orderNo = this.$route.query.orderNo;
  },
  methods: {
    selectPayment(method) {
      this.selectedMethod = method;
    },
    pay() {
      if (!this.selectedMethod) {
        this.$message.warning('请选择支付方式');
        return;
      }
      
      this.$confirm(`确认使用${this.selectedMethod === 'wechat' ? '微信' : '支付宝'}支付 ¥${this.money} 元?`, '确认支付', {
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        type: 'info'
      }).then(() => {
        this.request.get("/api/order/paid/" + this.orderNo).then(res => {
          if (res.code === '200') {
            this.$notify({
              title: '支付成功',
              message: `您已成功支付 ¥${this.money} 元`,
              type: 'success',
              duration: 3000
            });
            setTimeout(() => {
              this.$router.replace("/orderlist");
            }, 1500);
          } else {
            this.$message.error(res.msg);
          }
        });
      }).catch(() => {
        // 取消支付
      });
    },
    goBack() {
      this.$router.push('/orderlist');
    }
  }
}
</script>

<style scoped>
.pay-container {
  padding: 30px;
  display: flex;
  justify-content: center;
}

.pay-card {
  width: 100%;
  max-width: 600px;
}

.pay-header {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 30px;
}

.pay-icon {
  font-size: 28px;
  color: #409EFF;
  margin-right: 10px;
}

.pay-title {
  font-size: 24px;
  color: #303133;
  margin: 0;
}

.order-info {
  margin-bottom: 30px;
}

.order-no {
  font-family: monospace;
  color: #606266;
  font-weight: bold;
}

.pay-amount {
  color: #f56c6c;
  font-size: 20px;
  font-weight: bold;
}

.payment-methods {
  margin-bottom: 30px;
}

.methods-title {
  font-size: 16px;
  color: #303133;
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
}

.methods-options {
  display: flex;
  justify-content: center;
  flex-wrap: wrap;
  gap: 20px;
}

.payment-option {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 15px 30px;
  border: 1px solid #dcdfe6;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
}

.payment-option:hover {
  border-color: #c0c4cc;
}

.payment-option.selected {
  border-color: #409EFF;
  background-color: #ecf5ff;
}

.payment-icon {
  width: 50px;
  height: 50px;
  margin-bottom: 10px;
}

.pay-actions {
  display: flex;
  justify-content: center;
  margin-bottom: 20px;
  gap: 15px;
}

.pay-tips {
  text-align: center;
  color: #909399;
  font-size: 14px;
}

.pay-tips i {
  margin-right: 5px;
  color: #e6a23c;
}

@media screen and (max-width: 768px) {
  .pay-container {
    padding: 15px;
  }
  
  .payment-option {
    padding: 10px 20px;
  }
  
  .payment-icon {
    width: 40px;
    height: 40px;
  }
  
  .pay-actions {
    flex-direction: column;
  }
}
</style>
