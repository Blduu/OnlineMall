<!--
 * app主页
 *
 * @Author: BlueSky
 * @Date: 2025-06-20
-->
<template>
  <div id="app">
    <transition name="page-transition">
      <router-view/>
    </transition>
  </div>
</template>

<style>
@import "./resource/css/icon.css";
@import "./resource/global.css";
</style>
