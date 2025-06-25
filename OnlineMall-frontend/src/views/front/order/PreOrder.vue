<!--
 * 付费订单页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="pre-order-container">
    <el-card class="order-card" shadow="hover">
      <!-- 收货地址区域 -->
      <div class="address-section">
        <div class="section-header">
          <span class="section-title">收货地址</span>
          <el-button type="primary" size="small" icon="el-icon-plus" @click="addAddress">添加新地址</el-button>
        </div>
        
        <div class="address-list">
          <template v-if="addressData.length > 0">
            <el-row :gutter="20">
              <el-col :xs="24" :sm="12" :md="8" v-for="(item, index) in addressData" :key="index">
                <address-box
                  :address="item"
                  :class="['address-item', index === checkedIndex ? 'address-active' : '']"
                  @edit="editAddress(item)"
                  @delete="deleteAddress(item)"
                  @click.native="select(index)"
                ></address-box>
              </el-col>
            </el-row>
          </template>
          <el-empty v-else description="暂无收货地址" :image-size="100">
            <el-button type="primary" @click="addAddress">添加地址</el-button>
          </el-empty>
        </div>
      </div>

      <!-- 地址编辑弹窗 -->
      <el-dialog 
        title="地址信息" 
        :visible.sync="dialogFormVisible"
        width="500px"
        :close-on-click-modal="false"
      >
        <el-form :model="address" ref="addressForm" :rules="addressRules" label-width="100px">
          <el-form-item label="联系人" prop="linkUser">
            <el-input v-model="address.linkUser" placeholder="请输入联系人姓名"></el-input>
          </el-form-item>
          <el-form-item label="联系电话" prop="linkPhone">
            <el-input v-model="address.linkPhone" placeholder="请输入联系电话"></el-input>
          </el-form-item>
          <el-form-item label="详细地址" prop="linkAddress">
            <el-input 
              type="textarea"
              :rows="3"
              v-model="address.linkAddress" 
              placeholder="请输入详细地址"
            ></el-input>
          </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
          <el-button @click="dialogFormVisible = false">取 消</el-button>
          <el-button type="primary" @click="saveAddress">确 定</el-button>
        </div>
      </el-dialog>

      <!-- 商品确认区域 -->
      <div class="goods-section">
        <div class="section-header">
          <span class="section-title">商品信息</span>
        </div>
        
        <el-table
          :data="goods"
          stripe
          border
          style="width: 100%"
          :header-cell-style="{background:'#f5f7fa', color:'#606266'}"
        >
          <el-table-column label="商品图片" width="120" align="center">
            <template slot-scope="scope">
              <el-image
                :src="baseApi + scope.row.imgs"
                style="width: 80px; height: 80px"
                fit="contain"
                :preview-src-list="[baseApi + scope.row.imgs]"
              ></el-image>
            </template>
          </el-table-column>
          <el-table-column prop="name" label="商品名称" min-width="180"></el-table-column>
          <el-table-column prop="standard" label="规格" width="120"></el-table-column>
          <el-table-column label="单价" width="120">
            <template slot-scope="scope">
              <span class="price-text">¥{{ scope.row.realPrice.toFixed(2) }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="num" label="数量" width="100" align="center"></el-table-column>
          <el-table-column label="小计" width="120" align="right">
            <template slot-scope="scope">
              <span class="price-text">¥{{ (scope.row.realPrice * scope.row.num).toFixed(2) }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>

      <!-- 订单汇总区域 -->
      <div class="order-summary">
        <div class="summary-item">
          <span>商品总价：</span>
          <span class="price-text">¥{{ sumPrice }}</span>
        </div>
        <div class="summary-item">
          <span>优惠金额：</span>
          <span class="discount-text">-¥{{ sumDiscount }}</span>
        </div>
        <div class="summary-item total">
          <span>应付金额：</span>
          <span class="total-price">¥{{ sumPrice }}</span>
        </div>
        <div class="submit-area">
          <el-button 
            type="danger" 
            size="medium" 
            :disabled="addressData.length === 0"
            @click="submitOrder"
          >提交订单</el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script>
import API from "@/utils/request";
import addressBox from "@/components/AddressBox";
export default {
  name: "cart",
  data() {
    return {
      baseApi: this.$store.state.baseApi,
      userId: 0,
      addressData: [],
      address: {},
      checkedIndex: 0,
      dialogFormVisible: false,
      good: {},
      realPrice: -1,
      goods: [],
      cartId: "",
      addressRules: {
        linkUser: [
          { required: true, message: '请输入联系人姓名', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        linkPhone: [
          { required: true, message: '请输入联系电话', trigger: 'blur' },
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        linkAddress: [
          { required: true, message: '请输入详细地址', trigger: 'blur' },
          { min: 5, max: 100, message: '地址长度在 5 到 100 个字符', trigger: 'blur' }
        ]
      }
    };
  },
  components: {
    "address-box": addressBox,
  },
  created() {
    this.loadAddress();

    this.good = JSON.parse(this.$route.query.good);
    this.good.realPrice = this.$route.query.realPrice;
    this.good.num = this.$route.query.num;
    this.good.standard = this.$route.query.standard;
    this.cartId = this.$route.query.cartId;
    this.goods.push(this.good);
  },
  computed: {
    //汇总价格
    sumPrice: function () {
      let sum = 0;
      this.goods.forEach(function (good) {
        sum += good.realPrice * good.num;
      });
      return sum.toFixed(2);
    },
    //汇总折扣
    sumDiscount: function () {
      let sum = 0;
      this.goods.forEach(function (good) {
        sum += (good.realPrice / good.discount - good.realPrice) * good.num;
      });
      return sum.toFixed(2);
    },
  },
  //方法
  methods: {
    select(index) {
      this.checkedIndex = index;
    },
    // 添加地址弹窗
    addAddress() {
      this.address = {};
      this.dialogFormVisible = true;
      // 重置表单校验
      if (this.$refs.addressForm) {
        this.$refs.addressForm.resetFields();
      }
    },
    
    // 编辑地址弹窗
    editAddress(item) {
      this.address = JSON.parse(JSON.stringify(item));
      this.dialogFormVisible = true;
    },
    
    // 删除地址
    deleteAddress(item) {
      this.$confirm("您确认删除该地址吗?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "warning",
      }).then(() => {
        API.delete("api/address/" + item.id).then((res) => {
          if (res.code === "200") {
            this.$message.success("删除地址成功");
            this.loadAddress();
          }
        });
      }).catch(() => {
        // 取消删除操作
      });
    },
    
    // 保存地址
    saveAddress() {
      if (this.$refs.addressForm) {
        this.$refs.addressForm.validate(valid => {
          if (valid) {
            this.address.userId = this.userId;
            API.post("/api/address", this.address).then((res) => {
              if (res.code === "200") {
                this.$message.success("保存成功");
                this.loadAddress();
                this.dialogFormVisible = false;
              } else {
                this.$message.error(res.msg);
              }
            });
          }
        });
      } else {
        this.address.userId = this.userId;
        API.post("/api/address", this.address).then((res) => {
          if (res.code === "200") {
            this.$message.success("保存成功");
            this.loadAddress();
            this.dialogFormVisible = false;
          } else {
            this.$message.error(res.msg);
          }
        });
      }
    },
    //加载地址
    loadAddress() {
      API.get("/userid").then((res) => {
        this.userId = res;
        API.get("/api/address/" + res).then((res) => {
          if (res.code === "200") {
            this.addressData = res.data;
          }
        });
      });
    },
    // 提交订单
    submitOrder() {
      let address = this.addressData[this.checkedIndex];
      if (!address) {
        this.$message({
          type: "warning",
          message: "请选择收货地址！",
        });
        return;
      }
      
      this.$confirm("确认提交订单吗?", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        type: "info"
      }).then(() => {
        // 调用提交订单接口
        API.post("/api/order", {
          totalPrice: this.sumPrice,
          linkUser: address.linkUser,
          linkPhone: address.linkPhone,
          linkAddress: address.linkAddress,
          state: "待付款",
          goods: JSON.stringify(this.goods),
          cartId: this.cartId,
        }).then((res) => {
          if (res.code === "200") {
            let orderNo = res.data;
            // 跳转到支付页面
            this.$router.replace({
              path: "pay",
              query: { money: this.sumPrice, orderNo: orderNo },
            });
          } else {
            this.$message({
              type: "error",
              message: res.msg,
            });
          }
        });
      }).catch(() => {
        // 取消提交订单
      });
    },
  },
};
</script>

<style scoped>
.pre-order-container {
  padding: 20px;
}

.order-card {
  margin-bottom: 20px;
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
  font-size: 18px;
  font-weight: bold;
  color: #303133;
  position: relative;
  padding-left: 12px;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 4px;
  height: 18px;
  background-color: #409EFF;
  border-radius: 2px;
}

.address-section {
  margin-bottom: 30px;
}

.address-list {
  margin-bottom: 20px;
}

.address-item {
  margin-bottom: 15px;
  transition: all 0.3s;
  cursor: pointer;
}

.address-active {
  border: 2px solid #409EFF !important;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.goods-section {
  margin-bottom: 30px;
}

.order-summary {
  margin-top: 20px;
  border-top: 1px solid #ebeef5;
  padding-top: 20px;
}

.summary-item {
  display: flex;
  justify-content: flex-end;
  margin-bottom: 10px;
}

.summary-item span:first-child {
  margin-right: 20px;
  color: #606266;
}

.price-text {
  color: #f56c6c;
  font-weight: bold;
}

.discount-text {
  color: #67c23a;
  font-weight: bold;
}

.total {
  font-size: 18px;
  margin-top: 15px;
  padding-top: 15px;
  border-top: 1px dashed #ebeef5;
}

.total-price {
  color: #f56c6c;
  font-size: 24px;
  font-weight: bold;
}

.submit-area {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

.submit-area .el-button {
  padding: 12px 30px;
  font-size: 16px;
}

@media screen and (max-width: 768px) {
  .pre-order-container {
    padding: 10px;
  }
  
  .section-title {
    font-size: 16px;
  }
  
  .summary-item {
    flex-direction: column;
    align-items: flex-end;
  }
  
  .summary-item span:first-child {
    margin-right: 0;
    margin-bottom: 5px;
  }
  
  .total-price {
    font-size: 20px;
  }
  
  .submit-area .el-button {
    width: 100%;
  }
}
</style>

<style scoped>
.active {
  border: black 5px solid;
}
</style>
