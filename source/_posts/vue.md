---
title: springboot
top: 9996
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
description: springboot
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

### 什么是vue

### 为什么要用vue

###  如何使用vue

#### 1.用vue做出自己的第一个网页

- **引包**

  - **确认已经下载了node,然后执行命令 npm install vue (如需下载自己要的版本在vue后面加上@版本号)**

  - **页面引入刚下载的包**
  
    ```javascript
    <script type="text/javascript" src="vue.js"></script>
    ```
  
    
  
- **留坑**

  - **即留一个vue模板插入的地方或者是vue代码对其生效的地方**

    ```html
    <div id="app"></div>
    ```

    

- **实例化**

  -  **new Vue({el:目的地,template:模板内容,data:对象});**
    - **目的地 el 对应上面留坑的坑位，可通过id名，类名，标签名来查找 。方式和jq一样**
    - **内容 template**  <font color="red">**template里面只能有一个根标签**</font>
    - **数据 data 值为函数形式也可是对象，但是都是用函数，因为用的函数最后也是return一个对象**

```javascript
 new Vue({
            el:'#app',
            template:`
                <div>我这里是模板内容{ {msg} }</div>`,
            data:function() {
                return {
                    msg:'Hello Vue!'
                }
            }
        })
```

- **插值表达式{ { } }**
- **插值表达式内填入data里面的变量即可在页面取到变量值{ { data里的变量 } }**



#### 2.常用指令

- ##### 什么是指令

  - ##### **在vue中提供一些对于页面+数据的更为方便的操作，这些操作就叫做指令。**

    - **譬如在HTML页面中这样使用<div v-xxx=''></div>**

  - **在vue中v-xxx就是vue的指令**

  - **指令就是以数据去驱动DOM行为的,简化DOM操作**

- ##### **常用的指令有哪些，及怎么使用这些指令**

  - ##### **v-text 不可解析html标签   元素的innerText**

  - **v-html 可解析html标签  元素的innerHtml**

  - **v-if 做元素的插入（append）和移除（remove）操作**

  - **v-else-if**

  - **v-else**

  - **v-show display:none 和display：block的切换**

  - **v-for**

    - **数组 item，index**
    - **对象 value，key ，index**

    

#### 3.vue单双向数据流及事件绑定

- ##### **vue单向数据流绑定属性值 v-bind: (属性) 简写 :(属性)**

  - ##### **例子：**

    - ```html
      <input v-bind:value="name" v-bind:class="name">
      <!--v-bind:class="name"可以简写为:class="name"-->
      <input v-bind:value="name" :class="name">
      ```

    - **单向数据绑定 内存改变影响页面改变,而页面的改变不会影响内存的改变**

    - **v-bind就是对属性的简单赋值,当内存中值改变，还是会触发重新渲染**

- **vue双向数据流 v-model 只作用于有value属性的元素**

  - ##### **例子:**

    - ```html
      <input v-model="name" v-bind:class="name">
      ```

    - **双向数据绑定 页面对于input的value改变，能影响内存中name变量**

    - **内存js改变name的值，会影响页面重新渲染最新值**

#### 4.过滤器

- **过滤器就是可以对我们的数据进行添油加醋然后再显示**

- **过滤器分为全局过滤器和组件内的过滤器**

  - **全局过滤器Vue.filter('过滤器名',过滤方式fn );**
  - **组件内的过滤器 filters:{ '过滤器名',过滤方式fn }**
  - **{ { msg | 过滤器名} }**

- **最终都是在过滤方式fn里面return产出最终你需要的数据**

- ##### vue中的this是vue封装好给我们使用的，跟平常方法里面的this是不同的



#### 5.数据监听watch计算属性computed

- **watch监听单个，computed监听多个**

  - **业务场景：**
    - **类似淘宝，当我输入某个人名字时，我想触发某个效果**
    - **利用vue做一个简单的计算器**

- **当watch监听的是复杂数据类型的时候需要做深度监听**

  ```javascript
  watch:{
      msg:{
          handler(val){
              if(val.text=='love'){
                  alert(val.text)
              }
          },
              deep:true//开启深度监听
      }
  }**computed 监视对象,写在了函数内部, 凡是函数内部有this.相关属性,改变都会触发当前函数**
  ```

- **computed 监视对象,写在了函数内部, 凡是函数内部有this.相关属性,改变都会触发当前函数**

