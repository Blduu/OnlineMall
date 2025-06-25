<!--
 *  商品详情页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="container">
    <div class="product-detail-card box-shadow-light radius-large">
      <!-- 商品基本信息区域 -->
      <el-row :gutter="30">
        <el-col :xs="24" :sm="12" :md="10">
          <div class="product-image-container">
            <el-image 
              :src="baseApi + good.imgs" 
              fit="contain"
              class="product-image"
            >
              <div slot="error" class="image-slot">
                <i class="el-icon-picture-outline"></i>
              </div>
            </el-image>
          </div>
        </el-col>

        <el-col :xs="24" :sm="12" :md="14">
          <div class="product-info-container">
            <!-- 商品名称和描述 -->
            <h1 class="product-name">{{ good.name }}</h1>
            <div class="product-description">{{ good.description }}</div>
            
            <!-- 价格信息 -->
            <div class="price-box" v-if="good.discount < 1">
              <div class="price-row">
                <div class="price-label">原价</div>
                <div class="price-value original-price">¥{{ price }}</div>
              </div>
              <div class="price-row">
                <div class="price-label">折扣</div>
                <div class="price-value discount-value">{{ discount }}</div>
              </div>
              <div class="price-row">
                <div class="price-label">现价</div>
                <div class="price-value current-price">¥{{ realPrice }}</div>
              </div>
            </div>
            
            <div class="price-box" v-if="good.discount === 1">
              <div class="price-row">
                <div class="price-label">价格</div>
                <div class="price-value current-price">¥{{ price }}</div>
              </div>
            </div>
            
            <!-- 销量和库存信息 -->
            <div class="sales-info">
              <div class="info-item">
                <i class="el-icon-sell"></i>
                <span>月销量：{{ good.sales }}</span>
              </div>
              <div class="info-item" v-if="showStore">
                <i class="el-icon-box"></i>
                <span>库存：{{ store }}</span>
              </div>
            </div>
            
            <!-- 规格选择 -->
            <div class="standards-section" v-if="standards.length !== 0">
              <div class="section-title">选择规格</div>
              <el-radio-group v-model="checkedStandard" @change="change" class="standard-options">
                <el-radio-button 
                  v-for="(standard, index) in standards" 
                  :key="index"
                  :label="standard.value" 
                  class="standard-option"
                >
                  {{ standard.value }}
                </el-radio-button>
              </el-radio-group>
            </div>
            
            <!-- 数量选择 -->
            <div class="quantity-section">
              <div class="section-title">购买数量</div>
              <el-input-number 
                v-model="count" 
                :min="1" 
                :max="store"
                controls-position="right"
                size="medium"
              ></el-input-number>
            </div>
            
            <!-- 操作按钮 -->
            <div class="action-buttons">
              <el-button 
                type="primary" 
                icon="el-icon-shopping-bag-1" 
                size="medium"
                @click="goToOrder"
                :disabled="!isStandardSelected"
              >
                立即购买
              </el-button>
              <el-button 
                type="warning" 
                icon="el-icon-shopping-cart-2" 
                size="medium"
                @click="addToCart"
                :disabled="!isStandardSelected"
              >
                加入购物车
              </el-button>
            </div>
          </div>
        </el-col>
      </el-row>
    </div>

    <!-- 商品评论区域 -->
    <div class="comments-section box-shadow-light radius-large">
      <div class="section-header">
        <h2>用户评价</h2>
      </div>
      
      <el-divider></el-divider>
      
      <!-- 评论表单 -->
      <div class="comment-form">
        <el-form :model="commentForm" ref="commentForm" :rules="commentRules">
          <el-form-item prop="content">
            <el-input
              type="textarea"
              :rows="3"
              placeholder="分享您对商品的感受..."
              v-model="content"
              maxlength="200"
              show-word-limit
            ></el-input>
          </el-form-item>
          
          <el-form-item label="评分" prop="score">
            <el-rate 
              v-model="score"
              :colors="['#99A9BF', '#F7BA2A', '#FF9900']"
            ></el-rate>
          </el-form-item>
          
          <el-form-item>
            <el-button type="primary" @click="submit">提交评价</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <!-- 评论列表 -->
      <div class="comment-list" v-if="msg.length > 0">
        <el-card
          v-for="(data, index) in msg"
          :key="index"
          class="comment-item"
          shadow="hover"
          @mouseenter="enter(index)"
          @mouseleave="leave(index)"
        >
          <div class="comment-content">{{ data.content }}</div>
          <div class="comment-footer">
            <el-rate 
              v-model="data.score" 
              disabled 
              show-score
              text-color="#ff9900"
              score-template="{value}"
              size="small"
            ></el-rate>
            <div class="comment-time">{{ data.createTime }}</div>
          </div>
        </el-card>
      </div>
      
      <!-- 暂无评论提示 -->
      <el-empty
        v-if="msg.length === 0"
        description="暂无评论"
      ></el-empty>
      
      <!-- 分页器 -->
      <div class="pagination-container">
        <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :current-page="pagination.current"
          :page-sizes="[4, 8, 12, 16]"
          :page-size="pagination.size"
          layout="total, sizes, prev, pager, next, jumper"
          :total="pagination.total"
          background
        ></el-pagination>
      </div>
    </div>
  </div>
</template>

<script>

export default {
  name: "GoodView",
  data() {
    return {
      userId:null,
      baseApi: this.$store.state.baseApi,
      score: 5,
      good: {},
      goodId: Number,
      price: -1,
      isDiscount: false,
      discount: "",
      standards: [],
      checkedStandard: "",
      store: 0,
      showStore: false,
      count: 1,
      title: "",
      content: "",
      pagination: { //分页后的留言列表
        current: 1, //当前页
        total: null, //记录条数
        size: 4 //每页条数
      },
      msg: []
    };
  },
  methods: {
    getPriceRange(standards) {
      let arr = standards.map((item) => {
        return item.price;
      });
      //选择排序
      for (let i = 0; i < arr.length; i++) {
        // 第一次循环，假设第一个值为最小值，后面i++依此类推
        let min = i;
        for (let j = i + 1; j < arr.length; j++) {
          // 将第一个值循环与后面的值比较，如果后面的值比第一个值小，则将索引赋值给min，直到找到最小值
          if (arr[j] < arr[min]) {
            min = j;
          }
        }
        [arr[i], arr[min]] = [arr[min], arr[i]];
      }
      if (arr[0] === arr[arr.length - 1]) {
        return arr[0];
      } else {
        return arr[0] + "元 ~ " + arr[arr.length - 1];
      }
    },
    change(standard) {
      this.showStore = true;
      this.price = standard.price;
      this.store = standard.store;
    },
    goToOrder() {
      if (this.standards.length !== 0) {
        if (this.checkedStandard === "") {
          this.$message.warning("请选择规格");
          return false;
        }
      }
      this.$router.push({
        name: "preOrder",
        query: {
          good: JSON.stringify(this.good),
          realPrice: this.realPrice,
          num: this.count,
          standard: this.checkedStandard,
        },
      });
    },
    addToCart() {
      //未登录，拦截
      if (!localStorage.getItem("user")) {
        this.$router.push("/login");
      }
      if (!this.checkedStandard) {
        this.$message.error("请选择规格");
        return false;
      }
      // 从服务器获取当前用户的id，保证安全
      this.request.get("/userid").then((res) => {
        let userId = res;
        this.userId = res;
        let cart = {
          userId: userId,
          goodId: this.goodId,
          standard: this.checkedStandard,
          count: this.count,
        };
        this.request.post("/api/cart", cart).then((res) => {
          if (res.code === "200") {
            this.$message.success("成功添加购物车");
          }
        });
      });
    },
    getMsg() {
      // 从服务器获取当前用户的id，保证安全
      this.request.get("/userid").then((res) => {
        this.userId = res;
      });

      this.request.get(`/messages/${this.goodId}/${this.pagination.current}/${this.pagination.size}`).then(res => {
        let status = res.code
        if(status == 200) {
          this.msg = res.data.records
          this.pagination = res.data
        }
      })
    },
    //改变当前记录条数
    handleSizeChange(val) {
      this.pagination.size = val
      this.getMsg()
    },
    //改变当前页码，重新发送请求
    handleCurrentChange(val) {
      this.pagination.current = val
      this.getMsg()
    },

    submit() {
      let date = new Date()
      if(false) { //非空判断
        this.$message({
          type: 'error',
          message: '1',
        })
      } else {
        this.request.post("/message", {
            title: this.title,
            goodId: this.goodId,
            content: this.content,
            score:this.score,
            time: date,
            userId: this.userId
          }
        ).then(res => {
          let code = res.data.code
          if(code == 200) {
            this.$message({
              type: "success",
              message: "评论成功"
            })
          }
          this.getMsg()
        })
      }
      this.title = ""
      this.content = ""
      this.getMsg()
    },
    replay(messageId) { //回复留言功能
      this.$prompt('回复留言', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^[\s\S]*.*[^\s][\s\S]*$/,
        inputErrorMessage: '回复不能为空'
      }).then(({ value }) => {
        let date = new Date()
        console.log(messageId)
        this.request.post( '/replay',
          {
            replay: value,
            replayTime: date,
            messageId: messageId
          }
        ).then(res => {
          this.getMsg()
        })
        this.$message({
          type: 'success',
          message: '回复成功'
        });
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '取消输入'
        });
      });
    },
    enter(index) {
      this.flag = true
      this.current = index
    },
    leave(index) {
      this.flag = false;
      this.current = index;
    }
  },

  created() {
    this.goodId = this.$route.params.goodId;
    this.getMsg()
    //初始化商品信息
    // this.good = JSON.parse(this.$route.query.good)
    this.request.get("/api/good/" + this.goodId).then((res) => {
      if (res.code === "200") {
        this.good = res.data;
        let discount = this.good.discount;
        if (discount < 1) {
          this.isDiscount = true;
          this.discount = discount * 10 + "折";
        }
      } else {
        this.$router.go(0);
      }
    });
    //从服务器获取商品规格信息
    this.request.get("/api/good/standard/" + this.goodId).then((res) => {
      if (res.code === "200") {
        let standards = JSON.parse(res.data);
        this.standards = standards;
        //默认选择第一个标准
        this.price = this.getPriceRange(standards);
      } else {
        //没有规格
        this.price = this.good.price;
        this.store = this.good.store;
        this.showStore = true;
      }
    });
  },
  mounted() {
    // 使用已有的初始化逻辑，避免重复代码
  },
  computed: {
    //折后价，小数点后2位
    realPrice: function () {
      if (this.good.discount < 1) {
        //价格为范围，即不是数字，则返回一个范围
        if (isNaN(this.price)) {
          let down =
            this.price.substring(0, this.price.indexOf("元")) *
            this.good.discount;
          let up =
            this.price.substring(this.price.lastIndexOf(" ")) *
            this.good.discount;
          return down.toFixed(2) + "元 ~ " + up.toFixed(2);
        } else {
          return (this.price * this.good.discount).toFixed(2);
        }
      }
      return this.price;
    },
    isStandardSelected() {
      return this.standards.length === 0 || this.checkedStandard !== "";
    },
  },
};
</script>

<style scoped>
.container {
  padding: 20px;
}

.product-detail-card {
  background-color: white;
  padding: 30px;
  margin-bottom: 30px;
}

/* 商品图片区域 */
.product-image-container {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 400px;
  overflow: hidden;
  background: #f7f9fc;
  border-radius: 8px;
}

.product-image {
  max-width: 100%;
  max-height: 100%;
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

/* 商品信息区域 */
.product-info-container {
  padding: 10px 0;
}

.product-name {
  font-size: 24px;
  font-weight: 500;
  color: var(--main-black);
  margin: 0 0 15px 0;
}

.product-description {
  font-size: 14px;
  color: var(--secondary-black);
  margin-bottom: 20px;
  line-height: 1.6;
}

/* 价格区域 */
.price-box {
  background-color: rgba(255, 103, 0, 0.05);
  border-radius: 8px;
  padding: 15px;
  margin-bottom: 20px;
}

.price-row {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.price-row:last-child {
  margin-bottom: 0;
}

.price-label {
  width: 60px;
  color: var(--secondary-black);
  font-size: 14px;
}

.price-value {
  font-size: 16px;
}

.original-price {
  text-decoration: line-through;
  color: var(--secondary-black);
}

.discount-value {
  color: #ff6700;
  font-weight: bold;
}

.current-price {
  color: #ff6700;
  font-size: 24px;
  font-weight: bold;
}

/* 销量和库存信息 */
.sales-info {
  display: flex;
  margin-bottom: 20px;
}

.info-item {
  margin-right: 30px;
  color: var(--secondary-black);
  font-size: 14px;
  display: flex;
  align-items: center;
}

.info-item i {
  margin-right: 5px;
}

/* 规格选择 */
.standards-section,
.quantity-section {
  margin-bottom: 20px;
}

.section-title {
  font-size: 14px;
  color: var(--secondary-black);
  margin-bottom: 10px;
}

.standard-options {
  display: flex;
  flex-wrap: wrap;
}

.standard-option {
  margin-right: 10px;
  margin-bottom: 10px;
}

/* 操作按钮 */
.action-buttons {
  margin-top: 30px;
  display: flex;
  gap: 15px;
}

/* 评论区域 */
.comments-section {
  background-color: white;
  padding: 30px;
}

.section-header {
  margin-bottom: 20px;
}

.section-header h2 {
  margin: 0;
  font-size: 20px;
  font-weight: 500;
  color: var(--main-black);
}

.comment-form {
  margin-bottom: 30px;
}

.comment-list {
  margin-top: 30px;
}

.comment-item {
  margin-bottom: 15px;
}

.comment-content {
  color: var(--main-black);
  margin-bottom: 10px;
  line-height: 1.6;
}

.comment-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: var(--secondary-black);
  font-size: 12px;
}

.pagination-container {
  margin-top: 30px;
  display: flex;
  justify-content: center;
}

@media (max-width: 768px) {
  .product-detail-card,
  .comments-section {
    padding: 15px;
  }
  
  .product-image-container {
    height: 300px;
    margin-bottom: 20px;
  }
  
  .product-name {
    font-size: 20px;
  }
  
  .action-buttons {
    flex-direction: column;
  }
  
  .action-buttons .el-button {
    margin-bottom: 10px;
  }
}
</style>
