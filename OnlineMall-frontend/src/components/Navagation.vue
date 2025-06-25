<!--
 * 前台页面-导航栏
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="navagation box-shadow-light">
    <div class="container">
      <el-row type="flex" align="middle">
        <el-col :span="4">
          <div class="logo">
            <router-link to="/">
              <img src="../resource/logo.png" alt="网上购物商城">
              <span>网上购物商城</span>
            </router-link>
          </div>
        </el-col>

        <el-col :span="16">
          <el-menu 
            :default-active="activeIndex" 
            class="nav-menu" 
            mode="horizontal"
            background-color="#ffffff"
            text-color="#303133"
            active-text-color="#409EFF"
            router
          >
            <el-menu-item index="/" class="menu-item">
              <i class="el-icon-s-home"></i>
              商城首页
            </el-menu-item>
            <el-menu-item index="/goodList" class="menu-item">
              <i class="el-icon-menu"></i>
              商品分类
            </el-menu-item>
            <el-menu-item index="/cart" class="menu-item">
              <i class="el-icon-shopping-cart-2"></i>
              购物车
            </el-menu-item>
            <el-menu-item index="/orderlist" class="menu-item">
              <i class="el-icon-s-order"></i>
              我的订单
            </el-menu-item>
            <el-menu-item index="/manage" class="menu-item" v-if="role === 'admin'">
              <i class="el-icon-s-tools"></i>
              后台管理
            </el-menu-item>
          </el-menu>
        </el-col>

        <el-col :span="4">
          <el-dropdown class="user-dropdown" trigger="click">
            <div class="user-info">
              <el-avatar 
                v-if="user.avatarUrl" 
                size="small" 
                :src="baseApi + user.avatarUrl"
              ></el-avatar>
              <el-avatar 
                v-else 
                size="small" 
                icon="el-icon-user"
              ></el-avatar>
              <span class="username">{{ user.nickname || '未登录' }}</span>
              <i class="el-icon-caret-bottom"></i>
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item v-if="!loginStatus">
                <router-link :to="{ path: '/login', query: { to: '/' } }">
                  <i class="el-icon-key"></i> 登录
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item v-if="!loginStatus">
                <router-link to="/register">
                  <i class="el-icon-plus"></i> 注册
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item v-if="loginStatus">
                <router-link to="/person">
                  <i class="el-icon-user"></i> 个人信息
                </router-link>
              </el-dropdown-item>
              <el-dropdown-item v-if="loginStatus" @click.native="logout">
                <i class="el-icon-switch-button"></i> 退出
              </el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script>
export default {
  name: "Navagation",
  props: {
    user: Object,
    loginStatus: Boolean,
    role: String,
  },
  data() {
    return {
      activeIndex: this.$route.path,
      baseApi: this.$store.state.baseApi,
    };
  },
  methods: {
    logout() {
      localStorage.removeItem("user");
      this.$router.go(0);
      this.$message({
        message: "退出成功",
        type: "success",
        duration: 2000
      });
    },
  },
  watch: {
    $route(to) {
      this.activeIndex = to.path;
    }
  }
};
</script>

<style scoped>
.navagation {
  width: 100%;
  height: 64px;
  background-color: #ffffff;
  position: relative;
  z-index: 100;
}

.logo {
  display: flex;
  align-items: center;
  height: 64px;
}

.logo a {
  display: flex;
  align-items: center;
  text-decoration: none;
  color: var(--primary-color);
}

.logo img {
  width: 40px;
  margin-right: 10px;
}

.logo span {
  font-size: 18px;
  font-weight: bold;
}

.nav-menu {
  border-bottom: none;
}

.menu-item {
  height: 64px;
  line-height: 64px;
  padding: 0 20px;
}

.menu-item i {
  margin-right: 5px;
}

.user-dropdown {
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: flex-end;
}

.user-info {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0 10px;
}

.username {
  margin: 0 8px;
  max-width: 80px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
