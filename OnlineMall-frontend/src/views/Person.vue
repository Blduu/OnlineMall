<!--
 * 个人信息修改页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="container">
    <el-card class="person-card box-shadow-light radius-large">
      <div class="card-header">
        <div class="header-title">
          <i class="el-icon-user"></i> 个人信息
        </div>
        <div class="header-subtitle">您可以在这里修改您的个人资料</div>
      </div>

      <el-divider></el-divider>

      <el-form ref="personForm" :model="form" :rules="rules" label-width="80px" class="person-form">
        <el-form-item label="头像">
          <div class="avatar-container">
            <div class="avatar-wrapper">
              <img 
                v-if="form.avatarUrl" 
                :src="baseApi + form.avatarUrl" 
                class="avatar" 
                @error="handleAvatarError"
              >
              <div v-else class="avatar-placeholder">
                <i class="el-icon-user"></i>
              </div>
              
              <div class="avatar-overlay">
                <el-upload
                  class="avatar-uploader"
                  :action="baseApi + '/avatar'"
                  :headers="token"
                  :show-file-list="false"
                  :on-success="handleAvatarSuccess"
                  :before-upload="beforeAvatarUpload"
                >
                  <el-button 
                    type="primary" 
                    size="mini" 
                    icon="el-icon-camera" 
                    class="upload-button"
                  >
                    更换头像
                  </el-button>
                </el-upload>
              </div>
            </div>
          </div>
        </el-form-item>

        <el-form-item label="昵称" prop="nickname">
          <el-input 
            v-model="form.nickname" 
            prefix-icon="el-icon-user"
            placeholder="请输入昵称"
          ></el-input>
        </el-form-item>

        <el-form-item label="电话" prop="phone">
          <el-input 
            v-model="form.phone" 
            prefix-icon="el-icon-phone"
            placeholder="请输入电话号码"
          ></el-input>
        </el-form-item>

        <el-form-item label="邮箱" prop="email">
          <el-input 
            v-model="form.email" 
            prefix-icon="el-icon-message"
            placeholder="请输入邮箱地址"
          ></el-input>
        </el-form-item>

        <el-form-item label="地址" prop="address">
          <el-input 
            v-model="form.address" 
            prefix-icon="el-icon-location"
            placeholder="请输入收货地址"
          ></el-input>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="save" class="save-button">保存修改</el-button>
          <el-button @click="resetForm">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: "Person",
  data() {
    return {
      form: {},
      originalForm: {}, // 保存原始表单数据，用于重置
      baseApi: this.$store.state.baseApi,
      user: localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")) : {},
      rules: {
        nickname: [
          { required: true, message: '请输入昵称', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        phone: [
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ]
      }
    };
  },
  methods: {
    // 上传前的验证
    beforeAvatarUpload(file) {
      // 增加支持的图片格式
      const isValidFormat = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'].includes(file.type);
      const isLt2M = file.size / 1024 / 1024 < 2;
      
      // 显示上传进度
      this.$message({
        message: '正在上传头像...',
        type: 'info',
        duration: 1000
      });

      if (!isValidFormat) {
        this.$message.error('上传头像图片只能是 JPG、PNG、GIF 或 WebP 格式!');
        return false;
      }
      
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 2MB!');
        return false;
      }
      
      return isValidFormat && isLt2M;
    },
    // 图片上传成功
    handleAvatarSuccess(res) {
      if (res.code === '200') {
        this.form.avatarUrl = res.data;
        console.log("头像上传成功，URL:", this.form.avatarUrl);
        
        // 显示成功消息
        this.$notify({
          title: '上传成功',
          message: '头像已成功更新',
          type: 'success',
          position: 'bottom-right',
          duration: 2000
        });
        
        // 更新本地存储中的用户头像
        if (this.user && this.user.username) {
          const userData = JSON.parse(localStorage.getItem("user") || "{}");
          userData.avatarUrl = res.data;
          localStorage.setItem("user", JSON.stringify(userData));
          
          // 通知父组件刷新用户信息
          this.$emit("refresh");
        }
      } else {
        this.$message.error("头像上传失败: " + res.msg);
        console.error("头像上传失败:", res);
      }
    },
    // 提交事件
    save() {
      this.$refs.personForm.validate(valid => {
        if (valid) {
          // 把表格传给后台，保存到数据库
          this.request.post("/user", this.form).then(res => {
            if (res.code === '200') {
              this.$message({
                message: "个人信息保存成功",
                type: "success",
                duration: 2000
              });
              
              // 把表格的数据更新到user中
              for (let key in this.form) {
                this.user[key] = this.form[key];
              }
              
              // 更新localStorage的user
              localStorage.setItem('user', JSON.stringify(this.user));
              this.$emit("refresh");
              this.$router.go(0);
            } else {
              this.$message.error(res.msg);
            }
          });
        } else {
          return false;
        }
      });
    },
    // 重置表单
    resetForm() {
      Object.assign(this.form, this.originalForm);
      this.$refs.personForm.clearValidate();
    },
    
    // 处理头像加载错误
    handleAvatarError() {
      console.warn("头像图片加载失败");
      this.form.avatarUrl = ''; // 清空头像URL，显示默认图标
      
      // 显示错误提示
      this.$message({
        message: '头像加载失败，将显示默认头像',
        type: 'warning',
        showClose: true
      });
    }
  },
  created() {
    this.request.get("/userinfo/" + this.user.username).then(res => {
      if (res.code === '200') {
        this.form = res.data;
        // 保存原始数据的副本
        this.originalForm = JSON.parse(JSON.stringify(res.data));
        
        // 记录头像URL，用于调试
        console.log("个人信息中的头像URL:", this.form.avatarUrl);
        console.log("完整的头像URL:", this.baseApi + this.form.avatarUrl);
      } else {
        this.$message.error(res.msg);
      }
    }).catch(err => {
      console.error("获取个人信息出错:", err);
    });
  },
  computed: {
    token() {
      return { token: this.user.token };
    }
  }
};
</script>

<style scoped>
.container {
  padding: 20px;
  display: flex;
  justify-content: center;
}

.person-card {
  width: 600px;
  max-width: 100%;
  padding: 30px;
  margin: 20px 0;
}

.card-header {
  text-align: center;
  margin-bottom: 20px;
}

.header-title {
  font-size: 24px;
  font-weight: 500;
  color: var(--primary-color);
  margin-bottom: 10px;
}

.header-subtitle {
  font-size: 14px;
  color: var(--secondary-black);
}

.person-form {
  padding-top: 20px;
}

.avatar-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.avatar-wrapper {
  position: relative;
  width: 120px;
  height: 120px;
  border-radius: 50%;
  margin-bottom: 20px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  transition: all 0.3s ease;
  cursor: pointer;
}

.avatar-wrapper:hover {
  transform: scale(1.05);
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15);
}

.avatar-wrapper:hover .avatar-overlay {
  opacity: 1;
}

.avatar {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 50%;
}

.avatar-placeholder {
  width: 100%;
  height: 100%;
  background-color: #ebeef5;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 50%;
}

.avatar-placeholder i {
  font-size: 40px;
  color: #909399;
}

.avatar-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0, 0, 0, 0.5);
  padding: 8px 0;
  display: flex;
  justify-content: center;
  align-items: center;
  opacity: 0;
  transition: opacity 0.3s;
}

.upload-button {
  border-radius: 20px;
  padding: 6px 12px;
  font-size: 12px;
}

.avatar-uploader .el-upload {
  display: block;
  cursor: pointer;
}

/* 兼容暗色模式 */
@media (prefers-color-scheme: dark) {
  .avatar-placeholder {
    background-color: #333;
  }
  
  .avatar-placeholder i {
    color: #ddd;
  }
}

.avatar-tip {
  font-size: 12px;
  color: var(--secondary-black);
  margin-top: 8px;
}

.save-button {
  width: 120px;
}

@media (max-width: 768px) {
  .person-card {
    width: 100%;
    padding: 20px 15px;
  }
}
</style>
