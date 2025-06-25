<!--
 * 用户管理页面
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
<div class="user-manage-container">
  <!-- 搜索和过滤区域 -->
  <el-card class="search-card">
    <div class="search-area">
      <el-select 
        v-model="searchMode" 
        placeholder="请选择搜索类型" 
        size="medium"
        class="search-select"
      >
        <el-option value="id" label="用户ID"></el-option>
        <el-option value="username" label="账号"></el-option>
        <el-option value="nickname" label="昵称"></el-option>
      </el-select>
      
      <el-input 
        v-if="searchMode==='id'" 
        v-model="searchParams.id" 
        placeholder="请输入用户ID" 
        prefix-icon="el-icon-search" 
        clearable
        class="search-input"
      ></el-input>
      
      <el-input 
        v-if="searchMode==='username'" 
        v-model="searchParams.username" 
        placeholder="请输入账号" 
        prefix-icon="el-icon-search" 
        clearable
        class="search-input"
      ></el-input>
      
      <el-input 
        v-if="searchMode==='nickname'" 
        v-model="searchParams.nickname" 
        placeholder="请输入昵称" 
        prefix-icon="el-icon-search" 
        clearable
        class="search-input"
      ></el-input>
      
      <div class="search-buttons">
        <el-button type="primary" icon="el-icon-search" @click="search">搜索</el-button>
        <el-button type="info" icon="el-icon-refresh" @click="reload">重置</el-button>
      </div>
    </div>
    
    <!-- 操作按钮区域 -->
    <div class="action-buttons">
      <el-button type="success" icon="el-icon-plus" @click="handleAdd">新增用户</el-button>
      <el-button type="danger" icon="el-icon-delete" @click="delBatch" :disabled="multipleSelection.length === 0">
        批量删除 <span v-if="multipleSelection.length">({{ multipleSelection.length }})</span>
      </el-button>
    </div>
  </el-card>

  <!-- 用户表格 -->
  <el-card class="table-card">
    <el-table
      :data="tableData"
      stripe
      border
      size="medium"
      v-loading="loading"
      element-loading-text="加载中..."
      @selection-change="handleSelectionChange"
      class="user-table"
    >
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="id" label="ID" width="80" align="center"></el-table-column>
      <el-table-column prop="username" label="账号" width="120"></el-table-column>
      
      <el-table-column label="身份" width="100" align="center">
        <template slot-scope="scope">
          <el-tag :type="scope.row.role === 'admin' ? 'danger' : 'success'" size="medium">
            {{ scope.row.role === 'admin' ? '管理员' : '用户' }}
          </el-tag>
        </template>
      </el-table-column>
      
      <el-table-column prop="nickname" label="昵称" width="120"></el-table-column>
      <el-table-column prop="phone" label="电话" width="150"></el-table-column>
      <el-table-column prop="email" label="邮箱" width="180"></el-table-column>
      <el-table-column prop="address" label="地址" min-width="180"></el-table-column>
      
      <el-table-column label="操作" width="180" align="center">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="primary"
            icon="el-icon-edit"
            @click="handleEdit(scope.row)"
          >编辑</el-button>
          <el-button
            size="mini"
            type="danger"
            icon="el-icon-delete"
            @click="handleDelete(scope.row.id)"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    
    <!-- 分页控件 -->
    <div class="pagination-container">
      <el-pagination
        @size-change="handleSizeChange"
        @current-change="handleCurrentPage"
        :current-page="currentPage"
        :page-sizes="[5, 10, 20, 50]"
        :page-size="pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="total"
        background
      >
      </el-pagination>
    </div>
  </el-card>

  <!-- 用户表单弹窗 -->
  <el-dialog 
    :title="dialogTitle" 
    :visible.sync="dialogFormVisible" 
    width="500px"
    :close-on-click-modal="false"
  >
    <el-form 
      :model="user" 
      ref="userForm" 
      label-width="80px" 
      :rules="formRules"
    >
      <el-form-item label="昵称" prop="nickname">
        <el-input v-model="user.nickname" placeholder="请输入昵称"></el-input>
      </el-form-item>
      
      <el-form-item label="身份" prop="role">
        <el-select v-model="user.role" placeholder="请选择身份" style="width: 100%">
          <el-option
            v-for="item in roleOptions"
            :key="item.value"
            :label="item.label"
            :value="item.value">
          </el-option>
        </el-select>
      </el-form-item>

      <el-form-item label="电话" prop="phone">
        <el-input v-model="user.phone" placeholder="请输入电话号码"></el-input>
      </el-form-item>
      
      <el-form-item label="邮箱" prop="email">
        <el-input v-model="user.email" placeholder="请输入邮箱"></el-input>
      </el-form-item>
      
      <el-form-item label="地址" prop="address">
        <el-input v-model="user.address" placeholder="请输入地址"></el-input>
      </el-form-item>
    </el-form>

    <div slot="footer" class="dialog-footer">
      <el-button @click="dialogFormVisible = false">取 消</el-button>
      <el-button type="primary" @click="save">确 定</el-button>
    </div>
  </el-dialog>
</div>
</template>

<script>
export default {
  name: "User",
  /*页面创建完成动作*/
  created() {
    this.load();
  },
  /*初始化数据*/
  data() {
    return {
      tableData: [],
      roleOptions: [
        { value: 'admin', label: '管理员' },
        { value: 'user', label: '用户' }
      ],
      total: 0,
      pageSize: 10,
      currentPage: 1,
      searchMode: 'id',
      searchParams: {
        id: '',
        username: '',
        nickname: ''
      },
      dialogFormVisible: false,
      dialogTitle: '',
      user: {},
      multipleSelection: [],
      loading: false,
      formRules: {
        nickname: [
          { required: true, message: '请输入昵称', trigger: 'blur' },
          { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
        ],
        role: [
          { required: true, message: '请选择用户身份', trigger: 'change' }
        ],
        phone: [
          { pattern: /^1[3-9]\d{9}$/, message: '请输入正确的手机号码', trigger: 'blur' }
        ],
        email: [
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ]
      }
    }
  },
  /*方法*/
  methods:{
    handleSizeChange(pageSize){
      this.pageSize = pageSize;
      this.load();
    },
    /*分页跳转*/
    handleCurrentPage(currentPage){
      this.currentPage = currentPage;
      this.load();
    },
    /*筛选*/
    handleSelectionChange(val){
      this.multipleSelection = val
    },
    // 数据加载
    load() {
      this.loading = true;
      this.request.get("/user/page", {
        params: {
          pageNum: this.currentPage,
          pageSize: this.pageSize,
          id: this.searchParams.id,
          username: this.searchParams.username,
          nickname: this.searchParams.nickname
        }
      }).then(res => {
        this.loading = false;
        if (res.code === '200') {
          this.tableData = res.data.records;
          this.total = res.data.total;
        } else {
          this.$message.error(res.msg || '获取用户数据失败');
        }
      }).catch(() => {
        this.loading = false;
        this.$message.error('网络错误，请稍后重试');
      });
    },
    
    // 搜索和重置
    search() {
      this.currentPage = 1;
      this.load();
    },
    reload() {
      this.searchParams.id = '';
      this.searchParams.username = '';
      this.searchParams.nickname = '';
      this.currentPage = 1;
      this.load();
    },
    
    // 新增用户
    handleAdd() {
      this.dialogTitle = '新增用户';
      this.user = {
        role: 'user'
      };
      this.dialogFormVisible = true;
      // 重置表单校验
      if (this.$refs.userForm) {
        this.$refs.userForm.resetFields();
      }
    },
    
    // 编辑用户
    handleEdit(row) {
      this.dialogTitle = '编辑用户';
      this.user = JSON.parse(JSON.stringify(row));
      this.dialogFormVisible = true;
    },
    
    // 保存用户
    save() {
      if (this.$refs.userForm) {
        this.$refs.userForm.validate(valid => {
          if (valid) {
            this.request.post("/user", this.user).then(res => {
              if (res.code === '200') {
                this.$message({
                  type: 'success',
                  message: '保存成功'
                });
                this.dialogFormVisible = false;
                this.load();
              } else {
                this.$message.error(res.msg || '保存失败');
              }
            });
          }
        });
      } else {
        this.request.post("/user", this.user).then(res => {
          if (res.code === '200') {
            this.$message({
              type: 'success',
              message: '保存成功'
            });
            this.dialogFormVisible = false;
            this.load();
          } else {
            this.$message.error(res.msg || '保存失败');
          }
        });
      }
    },
    
    // 删除用户
    handleDelete(id) {
      this.$confirm('确认删除该用户吗?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.request.delete("/user/" + id).then(res => {
          if (res.code === '200') {
            this.$message({
              type: "success",
              message: "删除成功"
            });
            this.load();
          } else {
            this.$message.error(res.msg || '删除失败');
          }
        });
      }).catch(() => {
        // 取消删除操作
      });
    },
    
    // 批量删除
    delBatch() {
      if (this.multipleSelection.length === 0) {
        this.$message.warning('请至少选择一条记录');
        return;
      }
      
      this.$confirm(`确认删除选中的 ${this.multipleSelection.length} 条记录吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        let ids = this.multipleSelection.map(v => v.id);
        this.request.post("/user/del/batch", ids).then(res => {
          if (res.code === '200') {
            this.$message({
              type: "success",
              message: "删除成功",
              duration: 3000
            });
            this.load();
          }else {
            this.$message.error(res.msg);
          }
        })
      })
    }
  }
}
</script>

<style scoped>
.user-manage-container {
  padding: 10px;
}

.search-card {
  margin-bottom: 20px;
}

.search-area {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  margin-bottom: 15px;
}

.search-select {
  width: 150px;
  margin-right: 10px;
  margin-bottom: 10px;
}

.search-input {
  width: 250px;
  margin-right: 10px;
  margin-bottom: 10px;
}

.search-buttons {
  display: flex;
  gap: 10px;
  margin-bottom: 10px;
}

.action-buttons {
  display: flex;
  gap: 10px;
  margin-top: 10px;
}

.table-card {
  margin-bottom: 20px;
}

.user-table {
  margin-bottom: 20px;
}

.pagination-container {
  display: flex;
  justify-content: flex-end;
  margin-top: 20px;
}

@media screen and (max-width: 768px) {
  .search-area {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .search-select,
  .search-input {
    width: 100%;
    margin-right: 0;
  }
  
  .search-buttons,
  .action-buttons {
    width: 100%;
    justify-content: space-between;
  }
}
</style>
