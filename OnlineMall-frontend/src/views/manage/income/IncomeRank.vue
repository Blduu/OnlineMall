<!--
 * 销售统计图-排行榜
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template >
  <div style="width: 58%;height:100%;margin: 20px auto;background-color: #ffffff ;">
    <template v-for="(good,index) in good">
      <income-item :index="index+1" :good="good" :categories="categories" style="margin-bottom: 2px"></income-item>
    </template>
  </div>
</template>

<script>
import incomeItem from "@/components/IncomeItem";
export default {
  name: "IncomeRank",
  data(){
    return{
      num: 10,
      good: [],
      categories: [],
    }
  },
  components:{
    'income-item': incomeItem,
  },
  created() {
    //先查询分类id和名称
    this.request.get("/api/category").then(res=> {
      if (res.code === '200') {
        this.categories = res.data;
      }
      //获取排行数据
      this.request.get("/api/good/rank/",{params:{num: this.num}}).then(res=>{
        if(res.code==='200'){
          this.good = res.data;
        }
      })
    })

  },
}
</script>
