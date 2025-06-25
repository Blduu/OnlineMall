<!--
 * 左侧滑动-菜单栏
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="sidebar-container">
    <el-menu
      :default-openeds="['2', 'good']"
      :collapse-transition="false"
      :collapse="isCollapse"
      background-color="rgb(28,28,28)"
      text-color="#fff"
      active-text-color="#409EFF"
      router
      unique-opened
    >
      <!-- 系统标题和Logo -->
      <div class="sidebar-logo">
        <router-link to="/manage/home" class="logo-link">
          <img src="../resource/logo.png" class="sidebar-logo-img">
          <span class="sidebar-title" v-show="!isCollapse">商城管理系统</span>
        </router-link>
      </div>

      <!-- 主页菜单项 -->
      <el-menu-item index="/manage/home" class="menu-item">
        <i class="el-icon-house"></i>
        <span slot="title">控制台</span>
      </el-menu-item>

      <!-- 前台跳转 -->
      <el-menu-item index="/" class="menu-item">
        <i class="el-icon-shopping-cart-2"></i>
        <span slot="title">前台商城</span>
      </el-menu-item>

      <!-- 系统管理菜单 -->
      <el-submenu index="2" class="submenu-item">
        <template slot="title">
          <i class="el-icon-setting"></i>
          <span slot="title">系统管理</span>
        </template>

        <!-- 账户管理子菜单 -->
        <el-submenu v-show="userGroup" index="user" class="submenu-item">
          <template slot="title">
            <i class="el-icon-user"></i>
            <span>账户管理</span>
          </template>
          <el-menu-item index="/manage/user" v-if="menuFlags.userMenu" class="menu-item">
            <i class="el-icon-user-solid"></i>用户管理
          </el-menu-item>
        </el-submenu>

        <!-- 文件管理子菜单 -->
        <el-submenu v-if="fileGroup" index="file" class="submenu-item">
          <template slot="title">
            <i class="el-icon-folder"></i>
            <span>文件管理</span>
          </template>
          <el-menu-item index="/manage/file" v-if="menuFlags.fileMenu" class="menu-item">
            <i class="el-icon-document"></i>文件管理
          </el-menu-item>
          <el-menu-item index="/manage/avatar" v-if="menuFlags.avatarMenu" class="menu-item">
            <i class="el-icon-picture-outline"></i>头像管理
          </el-menu-item>
        </el-submenu>

        <!-- 商城管理子菜单 -->
        <el-submenu v-if="GoodGroup" index="good" class="submenu-item">
          <template slot="title">
            <i class="el-icon-goods"></i>
            <span>商城管理</span>
          </template>
          <el-menu-item index="/manage/category" v-if="menuFlags.categoryMenu" class="menu-item">
            <i class="el-icon-collection"></i>商品分类
          </el-menu-item>
          <el-menu-item index="/manage/carousel" v-if="menuFlags.carouselMenu" class="menu-item">
            <i class="el-icon-picture-outline-round"></i>轮播图
          </el-menu-item>
          <el-menu-item index="/manage/good" v-if="menuFlags.goodMenu" class="menu-item">
            <i class="el-icon-shopping-bag-1"></i>商品管理
          </el-menu-item>
          <el-menu-item index="/manage/order" v-if="menuFlags.orderMenu" class="menu-item">
            <i class="el-icon-s-order"></i>订单管理
          </el-menu-item>
        </el-submenu>

        <!-- 销售统计子菜单 -->
        <el-submenu v-if="incomeGroup" index="income" class="submenu-item">
          <template slot="title">
            <i class="el-icon-data-analysis"></i>
            <span>销售统计</span>
          </template>
          <el-menu-item index="/manage/incomeChart" v-if="menuFlags.incomeChartMenu" class="menu-item">
            <i class="el-icon-pie-chart"></i>图表分析
          </el-menu-item>
          <el-menu-item index="/manage/incomeRank" v-if="menuFlags.incomeRankMenu" class="menu-item">
            <i class="el-icon-trophy"></i>收入排行
          </el-menu-item>
        </el-submenu>
      </el-submenu>
    </el-menu>
  </div>
</template>

<script>
import request from "@/utils/request";

export default {
  name: "Aside",
  props: {
    isCollapse: Boolean,
  },

  /*初始化数据*/
  data() {
    return {
      role: 'user',
      /*菜单打开状态*/
      menuFlags: {
        userMenu: false,
        fileMenu: false,
        avatarMenu: false,
        goodMenu: false,
        carouselMenu: false,
        orderMenu: false,
        categoryMenu: false,
        incomeChartMenu: false,
        incomeRankMenu: false,
      }
    }
  },

  computed: {
    userGroup: function () {
      return this.menuFlags.userMenu
    },
    fileGroup: function () {
      return this.menuFlags.fileMenu || this.menuFlags.avatarMenu
    },
    GoodGroup: function () {
      return this.menuFlags.goodMenu || this.menuFlags.orderMenu || this.menuFlags.categoryMenu || this.menuFlags.carouselMenu
    },
    incomeGroup: function () {
      return this.menuFlags.incomeChartMenu || this.menuFlags.incomeRankMenu
    }
  },
  created() {
    /*获取用户角色*/
    request.post("/role").then(res => {
      if (res.code === '200') {
        this.role = res.data;
        /*只有管理员有权限*/
        if (this.role === 'admin') {
          this.menuFlags.userMenu = true
          this.menuFlags.fileMenu = true
          this.menuFlags.avatarMenu = true
          this.menuFlags.categoryMenu = true
          this.menuFlags.goodMenu = true
          this.menuFlags.carouselMenu = true
          this.menuFlags.orderMenu = true
          this.menuFlags.incomeChartMenu = true
          this.menuFlags.incomeRankMenu = true
        } else if (this.role === 'user') {

        }
      }
    })
  }
}
</script>

<style scoped>
.sidebar-container {
  height: 100%;
  overflow-x: hidden;
}

.sidebar-container::-webkit-scrollbar {
  width: 0;
  display: none;
}

.sidebar-logo {
  height: 60px;
  padding: 0 15px;
  overflow: hidden;
  display: flex;
  align-items: center;
  transition: all 0.3s;
}

.logo-link {
  height: 100%;
  width: 100%;
  display: flex;
  align-items: center;
  text-decoration: none;
}

.sidebar-logo-img {
  width: 32px;
  height: 32px;
  transition: all 0.3s;
}

.sidebar-title {
  margin-left: 12px;
  color: #fff;
  font-size: 16px;
  font-weight: 600;
  white-space: nowrap;
  transition: all 0.3s;
}

.menu-item {
  transition: all 0.3s;
  border-left: 3px solid transparent;
}

.menu-item:hover, .submenu-item:hover {
  background-color: rgba(255, 255, 255, 0.05) !important;
}

.menu-item.is-active {
  background-color: rgba(64, 158, 255, 0.1) !important;
  border-left: 3px solid #409EFF;
}

/* 菜单图标样式 */
.el-menu-item i, .el-submenu__title i {
  color: #bfcbd9;
  margin-right: 10px;
}

.el-menu-item.is-active i {
  color: #409EFF;
}

/* 折叠时的样式调整 */
.el-menu--collapse .sidebar-logo {
  padding: 0 10px;
  justify-content: center;
}
</style>
