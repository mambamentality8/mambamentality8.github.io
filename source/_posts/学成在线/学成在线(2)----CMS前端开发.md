# CMS前端工程创建

### 导入系统管理前端工程

CMS系统使用Vue-cli脚手架创建， Vue-cli是Vue官方提供的快速构建单页应用的脚手架，github地址： 
https://github.com/vuejs/vue-cli（有兴趣的同学可以参考官方指导使用vue-cli创建前端工程），本项目对Vue-cli 创建的工程进行二次封装，下边介绍CMS工程的情况。

### 工程结构

如果我要基于Vue-Cli创建的工程进行开发还需要在它基础上作一些封装，导入课程资料中提供Vue-Cli封装工程。 将课程资料中的xc-ui-pc-sysmanage.7z拷贝到UI工程目录中，并解压，用WebStorm打开xc-ui-pc-sysmanage目录。



- build:						构建工程用到的目录
- config:                      一些配置类的js文件
- dist:                           webpack打包输出的静态文件
- node_modules         npm下载的依赖包
- src                               主程序包
- static                           存放一些静态资源
- test                              用于测试

![1569060308438](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/01.png)

#### 1.package.json(类似maven的pom.xml)

package.json记录了工程所有依赖，及脚本命令：

![1569060383074](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/02.png)

开发使用：

```
npm run dev
```

打包使用：

```
npm run build
```

#### 2.webpack.base.conf.js

webpack.base.conf.js就是webpack的webpack.conﬁg.js配置文件，在此文件中配置了入口文件及各种Loader。

webpack是通过vue-load解析.vue文件，通过css-load打包css文件等。

#### 3.main.js

main.js是工程的入口文件，在此文件中加载了很多第三方组件，如：Element-UI、Base64、VueRouter等。 
index.html是模板文件。

#### 4.src目录

src目录下存放页面及js代码。

![1569060456923](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/03.png)

assets：存放一些静态文件，如图片
base：存放基础组件
base/api：基础api接口 
base/component：基础组件，被各各模块都使用的组件 
base/router：总的路由配置，加载各模块的路由配置文件
common：工具类
component：组件目录，本项目不用
mock：存放前端单元测试方法
module：存放各业务模块的页面和api方法
下级目录以模块名命名，下边以cms举例： 
cms/api：cms模块的api接口 
cms/components：cms模块的组件
cms/page： cms模块的页面
cms/router：cms模块的路由配置
statics：存放第三方组件的静态资源
vuex：存放vuex文件，本项目不使用
static：与src的平级目录，此目录存放静态资源 
它与assets的区别在于，static目录中的文件不被webpack打包处理，会原样拷贝到dist目录下。

#### 启动测试

坑:

```
Error: Node Sass does not yet support your current environment: Windows 64-bit with Unsupported runtime (64)
```

解决:

修改package.json,然后run npm install

```
"node-sass": "^4.12.0"
```



### 单页面应用介绍

单页[Web](https://baike.baidu.com/item/Web/150564)应用（single page web application，SPA），就是只有一张Web页面的应用。单页应用程序 (SPA) 是加载单个HTML 页面并在用户与应用程序交互时动态更新该页面的Web应用程序。 [1]  浏览器一开始会加载必需的HTML、CSS和JavaScript，所有的操作都在这张页面上完成，都由JavaScript来控制。因此，对单页应用来说模块化的开发和设计显得相当重要。

#### 单页面应用的优缺点：

优点：
1、用户操作体验好，用户不用刷新页面，整个交互过程都是通过Ajax来操作。 
2、适合前后端分离开发，服务端提供http接口，前端请求http接口获取数据，使用JS进行客户端渲染。
缺点：
1、首页加载慢
单页面应用会将js、 css打包成一个文件，在加载页面显示的时候加载打包文件，如果打包文件较大或者网速慢则 用户体验不好。
2、SEO不友好
SEO（Search Engine Optimization）为搜索引擎优化。它是一种利用搜索引擎的搜索规则来提高网站在搜索引擎 排名的方法。目前各家搜索引擎对JS支持不好，所以使用单页面应用将大大减少搜索引擎对网站的收录。
总结：
本项目的门户、课程介绍不采用单页面应用架构去开发，对于需要用户登录的管理系统采用单页面开发。

# CMS前端页面查询开发

### 页面结构

在model目录创建cms模块的目录结构

![1569062323632](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/04.png)

在page目录新建page_list.vue，扩展名为.vue。 .vue文件的结构如下：

```
<template>
  <!--编写页面静态部分，即view部分-->
  测试页面显示...
</template>
<script>
  /*编写页面静态部分，即model及vm部分。*/ </script>
<style>
  /*编写页面样式，不是必须*/
</style>
```

在页面的template中填写 “测试页面显示...”。 

报错:

```
- text "测试页面显示..." outside root element will be ignored.
```

注意：template内容必须有一个根元素，否则vue会报错，这里我们在template标签内定义一个div。

```
<template>
  <!--编写页面静态部分，即view部分-->
  <div>
    测试页面显示...
  </div>
</template>

<script>
  /*编写页面静态部分，即model及vm部分。*/
</script>

<style>
  /*编写页面样式，不是必须*/
</style>
```

这样左侧就能出现我们的菜单栏了
![1569307855159](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/05.png)

### 页面路由

在cms目录下创建page_list.vue页面。 
现在先配置路由，实现url访问到页面再进行内容完善与调试。 

#### 1.在cms的router下配置路由

```
import Home from '@/module/home/page/home.vue';  //@符号就是代表src目录
import page_list from '@/module/cms/page/page_list.vue';
export default [{
    path: '/',
    component: Home,
    name: 'CMS',//菜单名称
    hidden: false,
    children:[
      {path:'/cms/page/list',name:'页面列表',component: page_list,hidden:false}
    ]
  }
]
```

#### 2.在base目录下的router导入cms模块的路由

```
// 导入路由规则
import HomeRouter from '@/module/home/router'
import CmsRouter from '@/module/cms/router'
// 合并路由规则
concat(HomeRouter)//加入home模块的路由
concat(CmsRouter)//加入cms模块的路由
```

#### 3.测试 

启动工程，刷新页面，页面可以外正常浏览，并且看到“测试页面显示...”字样

### Element-UI介绍

本项目使用Element-UI来构建界面，Element是一套为开发者、设计师和产品经理准备的基于 Vue 2.0 的桌面端组 件库。
Element-UI官方站点：http://element.eleme.io/#/zh-CN/component/installation

### Table组件测试

本功能实现的页面列表，用户可以进行分页查询、输入查询条件查询，通过查看Element-UI库，我们需要Table 表 格、Form表单 及Pagination 分页组件。 
进入Element-UI官方，找到Table组件，拷贝源代码到page_list.vue页面中，如下：

```
<template>
  <div>
  <el-button type="primary" size="small">查询</el-button>
    <el-table
      :data="tableData"
      stripe
      style="width: 100%">
      <el-table-column
        prop="date"
        label="日期"
        width="180">
      </el-table-column>
      <el-table-column
        prop="name"
        label="姓名"
        width="180">
      </el-table-column>
      <el-table-column
        prop="address"
        label="地址">
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        tableData: [{
          date: '2016-05-02',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1518 弄'
        }, {
          date: '2016-05-04',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1517 弄'
        }, {
          date: '2016-05-01',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1519 弄'
        }, {
          date: '2016-05-03',
          name: '王小虎',
          address: '上海市普陀区金沙江路 1516 弄'
        }]
      }
    }
  }
</script>
<style>
  /*编写页面样式，不是必须*/
</style>
```

测试：

![1569311597796](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/06.png)

通过查看代码发现： 
el-table组件绑定了tableData模型数据。
tableData模型数据在script标签中定义。

### 页面内容完善

根据需求完善页面内容，完善列表字段，添加分页组件。

修改page_list.vue文件

```
<template>
  <div>
    <!--按钮组件-->
    <el-button type="primary" @click="query" size="small">查询</el-button>

    <!--表格组件-->
    <el-table
      :data="list"
      stripe
      style="width: 100%">
      <el-table-column type="index" width="60">
      </el-table-column>
      <el-table-column prop="pageName" label="页面名称" width="120">
      </el-table-column>
      <el-table-column prop="pageAliase" label="别名" width="120">
      </el-table-column>
      <el-table-column prop="pageType" label="页面类型" width="150">
      </el-table-column>
      <el-table-column prop="pageWebPath" label="访问路径" width="250">
      </el-table-column>
      <el-table-column prop="pagePhysicalPath" label="物理路径" width="250">
      </el-table-column>
      <el-table-column prop="pageCreateTime" label="创建时间" width="180">
      </el-table-column>
    </el-table>

    <!--分页组件-->
    <el-pagination
      layout="prev, pager, next"
      :total="total"
      :page-size="params.size"
      :current-page="params.page"
      @current-change="changePage"
      style="float:right;">
    </el-pagination>
  </div>
</template>

<script>
  export default {
    data() {
      return {
        list: [
          {
            "siteId": "5a751fab6abb5044e0d19ea1",
            "pageId": "5a754adf6abb500ad05688d9",
            "pageName": "index.html",
            "pageAliase": "首页",
            "pageWebPath": "/index.html",
            "pageParameter": null,
            "pagePhysicalPath": "F:\\develop\\xc_portal_static\\",
            "pageType": "0",
            "pageTemplate": null,
            "pageHtml": null,
            "pageStatus": null,
            "pageCreateTime": "2018-02-03T05:37:53.256+0000",
            "templateId": "5a962b52b00ffc514038faf7",
            "pageParams": null,
            "htmlFileId": "5a7c1c54d019f14d90a1fb23",
            "dataUrl": null
          },
          {
            "siteId": "5a751fab6abb5044e0d19ea1",
            "pageId": "5a795ac7dd573c04508f3a56",
            "pageName": "index_banner.html",
            "pageAliase": "轮播图",
            "pageWebPath": "/include/index_banner.html",
            "pageParameter": null,
            "pagePhysicalPath": "F:\\develop\\xc_portal_static\\include\\",
            "pageType": "0",
            "pageTemplate": null,
            "pageHtml": null,
            "pageStatus": null,
            "pageCreateTime": "2018-02-06T07:34:21.255+0000",
            "templateId": "5a962bf8b00ffc514038fafa",
            "pageParams": null,
            "htmlFileId": "5a795bbcdd573c04508f3a59",
            "dataUrl": null
          }],
        //数据总条数
        total: 50,
        params: {
          //当前页
          page: 2,
          //每页显示条数
          size: 10
        }
      }
    },
    methods: {
      query: function () {
        alert('查询')
        //调用服务端的接口
      },
      changePage: function () {//形参就是当前页码
        //调用query方法
        this.query()
      }
    },
  }
</script>
<style>
  /*编写页面样式，不是必须*/
</style>
```

测试:

![1569341095616](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/07.png)

### Api调用

#### 1.Api方法定义

在cms模块的api目录定义cms.js，
在cms.js中定义如下js方法，此方法实现http请求服务端页面查询接口。

```
//public是对axios的工具类封装，定义了http请求方法
import http from './../../../base/api/public'

//页面查询
export const page_list = (page,size,params) =>{
  //请求服务端的页面查询接口
  return http.requestQuickGet(apiUrl+'/cms/page/list/'+page+'/'+size);
}
```

axios实现了http方法的封装，vue.js官方不再继续维护vue-resource,推荐使用 axios。

#### 2.Api调用

前端页面导入cms.js，调用js方法请求服务端页面查询接口。
1）在script标签最上面导入cms.js

```
import * as cmsApi from '../api/cms'
```

在query方法中调用 page_list方法

```
//查询
query:function () {
  cmsApi.page_list(this.params.page,this.params.size).then((res)=>{
    console.log(res)
    this.total = res.queryResult.total
    this.list = res.queryResult.list
  })
}
```

### 跨域问题解决

测试上边的代理 ，结果报错如下 ：
No 'Access-Control-Allow-Origin' header is present on the requested resource. Origin 
'http://localhost:11000' is therefore not allowed access.



原因：浏览器的同源策略不允许跨域访问，所谓同源策略是指协议、域名、端口相同。 



解决：采用proxyTable解决。
proxyTable是什么？
vue-cli提供的解决vue开发环境下跨域问题的方法，proxyTable的底层使用了http-proxy-middleware（https://github.com/chimurai/http-proxy-middleware），它是http代理中间件，它依赖node.js， 基本原理是用服务端代理解决浏览器跨域：

![1569411024707](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02_02/08.png)

cms跨域解决原理： 
1、访问页面http://localhost:11000/ 

2、页面请求http://localhost:11000/cms
由于url由http://localhost:31001/cms...改为“http://localhost:11000/cms."，所以不存在跨域 

3、通过proxyTable由node服务器代理请求 http://localhost:31001/cms. 
	  服务端请求服务端就不存在跨域问题



具体的配置如下：
1）修改api方法中url的定义

请求前加/api前缀

```
//public是对axios的工具类封装，定义了http请求方法
import http from './../../../base/api/public'
//@相当于src目录
let sysConfig = require('@/../config/sysConfig')

let apiUrl = sysConfig.xcApiUrlPre;
//页面查询
export const page_list = (page, size, params) => {
  //请求服务端的页面查询接口
  return http.requestQuickGet(apiUrl + '/cms/page/list/' + page + '/' + size);
}
```

2）在conﬁg/index.js下配置proxyTable。 
以/api/cms开头的请求，代理请求http://localhost:31001

```
var sysConfig = {
  xcApiUrlPre: '/api',
  xcApiUrl: 'http://api.xuecheng.com/',
  imgUrl: 'http://img.xuecheng.com/',
  videoUrl: 'http://video.xuecheng.com/',
  openAuthenticate: true,
  openAuthorize: true
}

module.exports = sysConfig
```

### 分页查询测试

#### 1.定义分页视图 

使用v-on监听更改分页事件

```
<el-pagination
      layout="prev, pager, next"
      :total="total"
      :page-size="params.size"
      :current-page="params.page"
      @current-change="changePage"
      style="float:right;">
    </el-pagination>
```

#### 2.定义数据模型对象

```
data() {
      return {
        list: [],
        //数据总条数
        total: 0,
        params: {
          //当前页
          page: 1,
          //每页显示条数
          size: 10
        }
      }
    }
```

#### 3.定义分页方法，接收页码参数

```
 changePage: function (currentPage) { //形参就是当前页码
        //调用query方法
        //alert(currentPage)
        this.params.page = currentPage
        this.query()
      }
```

测试分页效果

### 进入页面立即查询

目前实现的功能是进入页面点击查询按钮向服务端表求查询，实际的需求是进入页面立即查询。
如何实现？

这要用到vue的钩子函数，每个 Vue 实例在被创建时都要经过一系列的初始化过程——例如，需要设置数据监听、 编译模板、将实例挂载到 DOM 并在数据变化时更新 DOM 等。同时在这个过程中也会运行一些叫做生命周期钩子的函数，这给了用户在不同阶段添加自己的代码的机会。

通常使用最多的是created和mounted两个钩子： 
created：vue实例已创建但是DOM元素还没有渲染生成。 
mounted：DOM元素渲染生成完成后调用。

本例子在两个方法的任意一个都满足需求： 
在script标签中methods方法外
添加如下代码：

```
mounted(){
      this.query()
    }
```

