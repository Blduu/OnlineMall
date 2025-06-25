@UI3755WC
<!--
 * 前台首页
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <el-container class="front-container">
    <el-header height="64px" class="front-header box-shadow-light">
      <Navagation 
        :user="user"
        :role="role"
        :login-status="loginStatus"
      />
    </el-header>

    <el-main class="front-main">
      <transition name="page-transition">
        <router-view />
      </transition>
    </el-main>

    <el-footer height="80px" class="front-footer">
      <div class="container">
        <div class="footer-content">
          <div class="footer-logo">
            <img src="@/resource/logo.png" alt="网上购物商城">
            <span>网上购物商城</span>
          </div>
          <div class="footer-links">
            <el-link href="javascript:void(0);">关于我们</el-link>
            <el-link href="javascript:void(0);">联系方式</el-link>
            <el-link href="javascript:void(0);">帮助中心</el-link>
            <el-link href="javascript:void(0);">隐私条款</el-link>
          </div>
          <div class="copyright">
            © {{ new Date().getFullYear() }} 网上购物商城 版权所有
          </div>
        </div>
      </div>
    </el-footer>
  </el-container>
</template>

<script>
import Navagation from "@/components/Navagation";
import request from "@/utils/request";

export default {
  name: "Front",
  data() {
    return {
      user: {},
      role: 'user',
      loginStatus: false,
    };
  },
  methods: {
    getUser() {
      let username = localStorage.getItem("user") 
        ? JSON.parse(localStorage.getItem("user")).username 
        : "";
      if (username) {
        // 从后台获取User数据
        this.request.get("/userinfo/" + username).then(res => {
          // 重新赋值后台的最新User数据
          this.user = res.data;
        });
      }
    },
  },
  components: {
    Navagation,
  },
  created() {
    if (localStorage.getItem("user")) {
      request.post("/role").then(res => {
        if (res.code === '200') {
          this.role = res.data;
          if (localStorage.getItem("user")) {
            this.user = JSON.parse(localStorage.getItem("user"));
            this.loginStatus = true;
          }
        } else {
          this.user = { nickname: '您未登录', avatarUrl: null };
          localStorage.removeItem('user');
          this.loginStatus = false;
        }
      });
    } else {
      this.user = { nickname: '您未登录', avatarUrl: null };
      this.loginStatus = false;
    }
  }
};
</script>

<style scoped>
@import "../../resource/css/search.css";

.front-container {
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

.front-header {
  padding: 0;
  background-color: #ffffff;
}

.front-main {
  flex: 1;
  background-color: #f5f7fa;
  padding: 20px 0;
}

.front-footer {
  background-color: #545c64;
  color: #ebeef5;
  padding: 0;
}

.footer-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
  text-align: center;
}

.footer-logo {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
}

.footer-logo img {
  width: 24px;
  height: 24px;
  margin-right: 8px;
}

.footer-logo span {
  font-size: 16px;
  font-weight: bold;
}

.footer-links {
  margin-bottom: 10px;
}

.footer-links .el-link {
  color: #ebeef5;
  margin: 0 10px;
  font-size: 12px;
}

.footer-links .el-link:hover {
  color: #ffffff;
}

.copyright {
  font-size: 12px;
  color: #c0c4cc;
}

.image {
  width: 100%;
  display: block;
}
</style>
