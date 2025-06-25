<!--
 * 地址 box
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="address-box" :class="{ 'address-active': isActive }">
    <div class="address-header">
      <span class="user-name">{{ address.linkUser }}</span>
      <span class="user-phone">{{ address.linkPhone }}</span>
    </div>
    
    <div class="address-content">
      <i class="el-icon-location"></i>
      <span class="address-text">{{ address.linkAddress }}</span>
    </div>
    
    <div class="address-actions">
      <el-button 
        type="text" 
        size="mini" 
        icon="el-icon-edit" 
        @click.stop="$emit('edit')"
      >修改</el-button>
      <el-button 
        type="text" 
        size="mini" 
        icon="el-icon-delete" 
        @click.stop="$emit('delete')"
      >删除</el-button>
    </div>
  </div>
</template>

<script>
export default {
  name: "AddressBox",
  props: {
    address: Object,
    isActive: {
      type: Boolean,
      default: false
    }
  }
}
</script>

<style scoped>
.address-box {
  padding: 15px;
  border-radius: 8px;
  border: 1px solid #dcdfe6;
  background-color: #fff;
  transition: all 0.3s;
  height: 100%;
  display: flex;
  flex-direction: column;
}

.address-box:hover {
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
  border-color: #c0c4cc;
}

.address-active {
  border: 2px solid #409EFF;
  box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.address-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-bottom: 10px;
  border-bottom: 1px solid #ebeef5;
  margin-bottom: 10px;
}

.user-name {
  font-weight: bold;
  font-size: 16px;
  color: #303133;
}

.user-phone {
  color: #606266;
}

.address-content {
  flex: 1;
  display: flex;
  align-items: flex-start;
  margin-bottom: 15px;
}

.address-content i {
  color: #909399;
  margin-right: 5px;
  font-size: 16px;
  margin-top: 2px;
}

.address-text {
  color: #606266;
  line-height: 1.5;
  word-break: break-all;
}

.address-actions {
  display: flex;
  justify-content: flex-end;
  border-top: 1px solid #ebeef5;
  padding-top: 10px;
}

.address-actions .el-button {
  padding: 3px 0;
  margin-left: 15px;
}

.address-actions .el-button:first-child {
  margin-left: 0;
}
</style>
