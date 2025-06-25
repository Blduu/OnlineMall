<!--
 * 用户登录页
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="login-container" :style="backgroundDiv">
    <div class="login-card box-shadow-base radius-large">
      <div class="login-header">
        <div class="logo">
          <img src="../resource/logo.png" alt="网上购物商城">
          <span>欢迎登录</span>
        </div>
        <div class="header-subtitle">网上购物商城 - 您的一站式购物平台</div>
      </div>
      
      <el-divider></el-divider>
      
      <div class="login-form">
        <el-form ref="loginForm" :model="user" :rules="rules" label-width="80px">
          <el-form-item label="用户名" prop="username">
            <el-input 
              v-model.trim="user.username" 
              prefix-icon="el-icon-user"
              placeholder="请输入用户名">
            </el-input>
          </el-form-item>

          <el-form-item label="密码" prop="password">
            <el-input 
              v-model.trim="user.password" 
              prefix-icon="el-icon-lock"
              show-password 
              placeholder="请输入密码">
            </el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="onSubmit" class="login-button">登录</el-button>
            <el-button @click="$router.push('/register')">注册账号</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <div class="login-footer">
        <el-link type="info" href="javascript:void(0);">忘记密码</el-link>
        <el-link type="info" href="javascript:void(0);">帮助</el-link>
        <el-link type="info" href="javascript:void(0);">隐私政策</el-link>
      </div>
    </div>
  </div>
</template>

<script>
import md5 from 'js-md5';

export default {
  name: "Login",
  data() {
    return {
      to: '/', // 登录成功跳转的页面
      user: {
        username: '',
        password: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ]
      },
      backgroundDiv: {
        backgroundImage: "url(" + require("@/resource/img/login_back.png") + ")",
        backgroundRepeat: "no-repeat",
        backgroundSize: "cover",
      },
    };
  },
  created() {
    this.to = this.$route.query.to ? this.$route.query.to : "/";
  },
  methods: {
    onSubmit() {
      this.$refs.loginForm.validate((valid) => {
        if (valid) {
          const loginData = {
            username: this.user.username,
            password: md5(this.user.password)
          };
          
          this.request.post("/login", loginData).then(res => {
            if (res.code === '200') {
              this.$message({
                message: "登录成功",
                type: "success",
                duration: 2000
              });
              this.$router.push(this.to);
              localStorage.setItem("user", JSON.stringify(res.data));
            } else {
              this.$message.error(res.msg);
            }
          });
        } else {
          return false;
        }
      });
    }
  }
};
</script>

<style scoped>
.login-container {
  height: 100%;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-position: center;
}

.login-card {
  width: 450px;
  padding: 30px;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 8px;
}

.login-header {
  text-align: center;
  margin-bottom: 20px;
}

.logo {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 10px;
}

.logo img {
  width: 40px;
  margin-right: 10px;
}

.logo span {
  font-size: 24px;
  font-weight: bold;
  color: var(--primary-color);
}

.header-subtitle {
  font-size: 14px;
  color: var(--secondary-black);
}

.login-form {
  padding: 20px 0;
}

.login-button {
  width: 100%;
  margin-bottom: 15px;
}

.login-footer {
  display: flex;
  justify-content: space-around;
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid var(--border-color-lighter);
}
</style>
