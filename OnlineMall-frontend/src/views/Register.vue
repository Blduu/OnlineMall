<!--
 * 用户注册页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="register-container" :style="backgroundDiv">
    <div class="register-card box-shadow-base radius-large">
      <div class="register-header">
        <div class="logo">
          <img src="@/resource/logo.png" alt="网上购物商城">
          <span>用户注册</span>
        </div>
        <div class="header-subtitle">欢迎加入网上购物商城</div>
      </div>
      
      <el-divider></el-divider>
      
      <div class="register-form">
        <el-form ref="registerForm" :model="user" :rules="rules" label-width="80px">
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

          <el-form-item label="确认密码" prop="confirmPassword">
            <el-input 
              v-model.trim="user.confirmPassword" 
              prefix-icon="el-icon-key"
              show-password
              placeholder="请再次输入密码">
            </el-input>
          </el-form-item>

          <el-form-item>
            <el-button type="primary" @click="onSubmit" class="register-button">注册</el-button>
            <el-button @click="$router.push('/login')">返回登录</el-button>
          </el-form-item>
        </el-form>
      </div>
      
      <div class="register-footer">
        <p>注册即表示您同意我们的 <el-link type="primary" href="javascript:void(0);">服务条款</el-link> 和 <el-link type="primary" href="javascript:void(0);">隐私政策</el-link></p>
      </div>
    </div>
  </div>
</template>

<script>
import md5 from "js-md5";

export default {
  name: "Register",
  data() {
    // 确认密码的验证规则
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'));
      } else if (value !== this.user.password) {
        callback(new Error('两次输入密码不一致'));
      } else {
        callback();
      }
    };

    return {
      user: {
        username: '',
        password: '',
        confirmPassword: ''
      },
      rules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '长度在 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, max: 20, message: '长度在 6 到 20 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, message: '请再次输入密码', trigger: 'blur' },
          { validator: validateConfirmPassword, trigger: 'blur' }
        ]
      },
      backgroundDiv: {
        backgroundImage: "url(" + require("@/resource/img/login_back.png") + ")",
        backgroundRepeat: "no-repeat",
        backgroundSize: "cover"
      }
    };
  },
  methods: {
    onSubmit() {
      this.$refs.registerForm.validate((valid) => {
        if (valid) {
          const registerData = {
            username: this.user.username,
            password: md5(this.user.password)
          };

          this.request.post("/register", registerData).then(res => {
            if (res.code === '200') {
              this.$message({
                message: "注册成功",
                type: "success",
                duration: 2000
              });
              this.$router.push("/login");
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
.register-container {
  height: 100%;
  width: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  background-position: center;
}

.register-card {
  width: 450px;
  padding: 30px;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 8px;
}

.register-header {
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

.register-form {
  padding: 20px 0;
}

.register-button {
  width: 100%;
  margin-bottom: 15px;
}

.register-footer {
  text-align: center;
  color: var(--secondary-black);
  font-size: 12px;
  margin-top: 20px;
}
</style>
