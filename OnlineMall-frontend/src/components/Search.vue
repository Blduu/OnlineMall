<!--
 * 前台首页搜索栏
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div class="search-container">
    <el-input
      v-model="searchText"
      placeholder="请输入想要购买的商品"
      class="search-input"
      prefix-icon="el-icon-search"
      @keyup.enter.native="$emit('search', searchText)"
      clearable
    >
      <el-button 
        slot="append" 
        icon="el-icon-search" 
        @click="$emit('search', searchText)"
      >
        搜索
      </el-button>
    </el-input>
  </div>
</template>

<script>
export default {
  name: "Search",
  data(){
    return{
      searchText:'',
    }
  }
}
</script>

<style scoped>
.search-container {
  padding: 20px 0;
  text-align: center;
}

.search-input {
  width: 650px;
  max-width: 100%;
}

.el-input__inner {
  height: 50px;
  font-size: 16px;
}

.el-input-group__append {
  background-color: var(--primary-color);
  color: #fff;
  border-color: var(--primary-color);
}

.el-input-group__append:hover {
  opacity: 0.9;
}
</style>
