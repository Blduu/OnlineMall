<!--
 * 头部配置
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="admin-header-container">
    <!-- 左侧区域：菜单控制和导航 -->
    <div class="header-left">
      <!-- 收缩按钮 -->
      <div class="header-actions">
        <el-tooltip :content="collapseTitle" placement="bottom" effect="light">
          <i 
            :class="['header-icon', collapseIcon]" 
            @click="$emit('collapse')"
          ></i>
        </el-tooltip>
        
        <el-tooltip content="返回" placement="bottom" effect="light">
          <i 
            class="header-icon el-icon-back" 
            @click="back"
          ></i>
        </el-tooltip>
      </div>

      <!-- 面包屑导航 -->
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/manage/home' }">
          <i class="el-icon-s-home"></i> 首页
        </el-breadcrumb-item>
        <el-breadcrumb-item>{{ routePath }}</el-breadcrumb-item>
      </el-breadcrumb>
    </div>

    <!-- 右侧区域：用户信息和操作 -->
    <div class="header-right">
      <!-- 用户信息下拉菜单 -->
      <el-dropdown trigger="click">
        <div class="user-profile">
          <el-avatar 
            :size="32" 
            :src="user.avatarUrl ? baseApi + user.avatarUrl : ''" 
            :icon="user.avatarUrl ? '' : 'el-icon-user-solid'"
            class="user-avatar"
          ></el-avatar>
          <span class="user-name">{{ user.nickname || '用户' }}</span>
          <i class="el-icon-caret-bottom"></i>
        </div>
        
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item>
            <div @click="$router.push('/manage/person')" class="dropdown-item">
              <i class="el-icon-user"></i> 个人信息
            </div>
          </el-dropdown-item>
          <el-dropdown-item divided>
            <div @click="logout" class="dropdown-item">
              <i class="el-icon-switch-button"></i> 退出登录
            </div>
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>
  </div>
</template>

<script>
export default {
  name: "Header",
  props: {
    collapseIcon: String,
    collapseTitle: String,
    user: Object
  },
  methods: {
    // 登出
    logout() {
      localStorage.removeItem("user");
      this.$router.push('/login');
      this.$message({
        message: "退出成功",
        type: "success",
        duration: 2000
      });
    },
    // 返回上一页
    back() {
      this.$router.go(-1);
    }
  },
  data() {
    return {
      routePath: '',
      baseApi: this.$store.state.baseApi,
    }
  },
  watch: {
    // 监听路由变化，更新面包屑
    '$route': function() {
      this.routePath = this.$route.meta.path;
    }
  },
  created() {
    this.routePath = this.$route.meta.path;
  }
}
</script>

<style scoped>
.admin-header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  height: 100%;
  padding: 0 15px;
}

.header-left {
  display: flex;
  align-items: center;
}

.header-actions {
  display: flex;
  margin-right: 20px;
}

.header-icon {
  font-size: 18px;
  padding: 8px;
  margin-right: 8px;
  color: #606266;
  cursor: pointer;
  border-radius: 4px;
  transition: all 0.3s;
}

.header-icon:hover {
  background-color: #f2f2f2;
  color: var(--primary-color);
}

.el-breadcrumb {
  font-size: 14px;
  line-height: 1;
}

.header-right {
  display: flex;
  align-items: center;
}

.user-profile {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 5px 10px;
  border-radius: 4px;
  transition: all 0.3s;
}

.user-profile:hover {
  background-color: #f2f2f2;
}

.user-avatar {
  margin-right: 8px;
}

.user-name {
  font-size: 14px;
  color: #606266;
  margin-right: 5px;
}

.dropdown-item {
  display: flex;
  align-items: center;
}

.dropdown-item i {
  margin-right: 8px;
}

@media screen and (max-width: 768px) {
  .user-name {
    display: none;
  }
  
  .header-actions {
    margin-right: 10px;
  }
}
</style>
