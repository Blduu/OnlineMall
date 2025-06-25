<!--
 * 后台管理 - 基础布局
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="admin-container">
    <el-container class="admin-layout">
      <!-- 侧边栏菜单 -->
      <el-aside :width="sideWidth + 'px'" class="admin-aside">
        <Aside :is-collapse="isCollapse"></Aside>
      </el-aside>

      <el-container class="admin-main-container">
        <!-- 顶部导航栏 -->
        <el-header class="admin-header">
          <Header
            :collapse-icon="collapseIcon"
            :collapse-title="collapseTitle"
            @collapse="handleCollapse"
            :user="user"
          ></Header>
        </el-header>

        <!-- 主内容区域 -->
        <el-main :class="{'admin-main': true, 'admin-main-home': $route.path === '/manage/home'}">
          <transition name="fade" mode="out-in">
            <router-view @refresh="getUser"/>
          </transition>
        </el-main>

        <!-- 页脚 -->
        <el-footer height="40px" class="admin-footer">
          <div class="footer-content">
            <span>© {{ currentYear }} 网上购物商城后台管理系统</span>
            <span>技术支持: BlueSky</span>
          </div>
        </el-footer>
      </el-container>
    </el-container>
  </div>
</template>

<style>
.admin-container {
  height: 100%;
  width: 100%;
}

.admin-layout {
  height: 100%;
}

.admin-aside {
  transition: width 0.3s;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
  z-index: 10;
  overflow: hidden;
  background-color: #101010;
}

.admin-header {
  background-color: #ffffff;
  padding: 0;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
  z-index: 9;
  height: 60px !important;
  line-height: 60px;
  border-bottom: 1px solid #e6e6e6;
}

.admin-main-container {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.admin-main {
  background-color: #f5f7fa;
  padding: 20px;
  flex: 1;
  overflow-y: auto;
}

.admin-main-home {
  background: url("@/resource/img/back.png") center center no-repeat;
  background-size: cover;
  display: flex;
  align-items: center;
  justify-content: center;
}

.admin-footer {
  background-color: #fff;
  border-top: 1px solid #e6e6e6;
  color: #606266;
  font-size: 12px;
  display: flex;
  align-items: center;
  padding: 0 20px;
}

.footer-content {
  width: 100%;
  display: flex;
  justify-content: space-between;
}

/* 过渡动画 */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}

/* 响应式设计 */
@media screen and (max-width: 768px) {
  .admin-aside {
    position: fixed;
    height: 100%;
    z-index: 1001;
  }
  
  .admin-main {
    padding: 15px;
  }
  
  .admin-footer {
    padding: 0 15px;
  }
}
</style>

<script>
import Aside from "@/components/Aside";
import Header from "@/components/Header";

export default {
  data() {
    return {
      user: {},
      isCollapse: false,
      sideWidth: 250,
      collapseIcon: "el-icon-s-fold",
      collapseTitle: "收缩",
      currentYear: new Date().getFullYear()
    };
  },
  components: {
    Aside,
    Header,
  },
  methods: {
    // 折叠侧边栏
    handleCollapse() {
      this.isCollapse = !this.isCollapse;
      if (this.isCollapse) {
        this.sideWidth = 64;
        this.collapseIcon = "el-icon-s-unfold";
        this.collapseTitle = "展开";
      } else {
        this.sideWidth = 250;
        this.collapseIcon = "el-icon-s-fold";
        this.collapseTitle = "收缩";
      }
    },
    // 获取用户信息
    getUser() {
      let username = localStorage.getItem("user")
        ? JSON.parse(localStorage.getItem("user")).username
        : "";
      if (username) {
        this.request.get("/userinfo/" + username).then((res) => {
          if (res.code === "200") {
            this.user = res.data;
            // 避免 avatarUrl 为 null 的情况
            if (!this.user.avatarUrl) {
              this.user.avatarUrl = '';
            }
            console.log("用户信息获取成功:", this.user);
          } else {
            console.error("获取用户信息失败:", res.msg);
          }
        }).catch(err => {
          console.error("获取用户信息请求出错:", err);
        });
      } else {
        console.warn("未找到用户信息，请先登录");
      }
    },
    // 检查屏幕尺寸并自动折叠侧边栏
    checkScreenSize() {
      if (window.innerWidth < 768 && !this.isCollapse) {
        this.handleCollapse();
      }
    }
  },
  created() {
    this.getUser();
    // 初始检查屏幕尺寸
    this.checkScreenSize();
    // 添加窗口大小变化监听
    window.addEventListener('resize', this.checkScreenSize);
  },
  beforeDestroy() {
    // 移除窗口大小变化监听
    window.removeEventListener('resize', this.checkScreenSize);
  }
};
</script>
