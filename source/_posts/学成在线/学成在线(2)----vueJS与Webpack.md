# vue.js

### vue.js介绍

#### vue.js是什么？

 Vue (读音 /vjuː/，类似于 view) 是一套用于构建用户界面的渐进式框架。与其它大型框架不同的是，Vue 被设计 
为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一 方面，当与现代化的工具链以及各种支持类库结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。
渐进式框架：Progressive，说明vue.js的轻量，是指一个前端项目可以使用vue.js一两个特性也可以整个项目都用 vue.js。
自底向上逐层应用：作为渐进式框架要实现的目标就是方便项目增量开发。

参考：https://cn.vuejs.org/v2/guide/ 

#### Vue.js与ECMAScript
Vue 不支持 IE8 及以下版本，因为 Vue 使用了 IE8 无法模拟的 ECMAScript 5 特性。 

什么是ECMAScript?
**ECMAScript**是一种由[Ecma国际](https://baike.baidu.com/item/Ecma国际)（前身为[欧洲计算机制造商协会](https://baike.baidu.com/item/欧洲计算机制造商协会/2052072)，European Computer Manufacturers Association）通过ECMA-262标准化的脚本[程序设计语言](https://baike.baidu.com/item/程序设计语言)。这种语言在[万维网](https://baike.baidu.com/item/万维网)上应用广泛，它往往被称为[JavaScript](https://baike.baidu.com/item/JavaScript)或[JScript](https://baike.baidu.com/item/JScript)，所以它可以理解为是JavaScript的一个标准,但实际上后两者是ECMA-262标准的实现和扩展。

ECMAScript（简称ES）是一种规范，我们平常所说的Js/Javascript是ECMAScript的实现，早期主要应用的ES3，当 前主流浏览器都支持ES5、ES6，ES8已于2017年发布。
ES6：http://www.ecma-international.org/ecma-262/6.0/ 
ES7：http://www.ecma-international.org/ecma-262/7.0/

#### Vue.js的使用 

1）在html页面使用script引入vue.js的库即可使用。 
2）使用Npm管理依赖，使用webpack打包工具对vue.js应用打包。 大型应用推荐此方案。
3）Vue-CLI脚手架,使用vue.js官方提供的CLI脚本架很方便去创建vue.js工程雏形。

#### vue.js有哪些功能？

1）声明式渲染
Vue.js 的核心是一个允许采用简洁的模板语法来声明式地将数据渲染进 DOM 的系统。 
比如：使用vue.js的插值表达式放在Dom的任意地方， 差值表达式的值将被渲染在Dom中。
2）条件与循环
dom中可以使用vue.js提供的v-if、v-for等标签，方便对数据进行判断、循环。
3）双向数据绑定
Vue 提供v-model 指令，它可以轻松实现Dom元素和数据对象之间双向绑定，即修改Dom元素中的值自动修改绑 定的数据对象，修改数据对象的值自动修改Dom元素中的值。
4）处理用户输入
为了让用户和你的应用进行交互，我们可以用 v-on  指令添加一个事件监听器，通过它调用在 Vue 实例中定义的 方法
5）组件化应用构建 
vue.js可以定义一个一个的组件，在vue页面中引用组件，这个功能非常适合构建大型应用。

### vue.js基础

#### MVVM模式

vue.js是一个MVVM的框架，理解MVVM有利于学习vue.js。

- MVVM拆分解释为：

  - Model:负责数据存储
  - View:负责页面展示
  - View Model:负责业务逻辑处理（比如Ajax请求等），对数据进行加工后交给视图展示

- MVVM要解决的问题是将业务逻辑代码与视图代码进行完全分离，使各自的职责更加清晰，后期代码维护更加简单

- 用图解的形式分析Ajax请求回来数据后直接操作Dom来达到视图的更新的缺点，以及使用MVVM模式是如何 来解决这个缺点的

- Vue中的 MVVM

  ![1569070208671](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/01.png)

从上图看出，VM(ViewModel)可以把view视图和Model模型解耦合，VM的要做的工作就是vue.js所承担的。 

#### 入门程序

本次测试我们在门户目录中创建一个html页面进行测试，正式的页面管理前端程序会单独创建工程。 
在门户目录中创建vuetest目录，并且在目录下创建vue_01.html文件

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>vue.js入门程序</title>
    <script src="js/vue/vue.min.js"></script>
</head>
<body>
<div id="app">
    {{name}}
</div>
<script type="text/javascript">
    var vm = new Vue({
        el: '#app',
        data: {
            name: "hello world",
        }
    })
</script>
</body>
</html>
```

代码编写步骤：
1、定义html，引入vue.js
2、定义app div，此区域作为vue的接管区域 3、定义vue实例，接管app区域。 
4、定义model（数据对象） 
5、VM完成在app中展示数据

#### v‐model和v-text

实现效果：

![1569070305446](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/02.png)

代码如下：

```
<!DOCTYPE html>
<html lang="en" xmlns:v-on="http://www.w3.org/1999/xhtml" xmlns:v-bind="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>vue.js入门程序</title>
</head>
<body>
<div id="app">
        <!--MVVM的view视图-->
    <!--{{name}}解决闪烁问题使用v-text-->
    <span v-text="name"></span>
    <!--
            v-model代替了value属性
        1.从model到dom,这里num1和num2的值来自于model
        2.从dom到model,我在文本框中输入值,传递给我的model,model在传递给我的差值表达式
    -->
    <input type="text" v-model="num1">+
    <input type="text" v-model="num2">=
    <span v-text="Number.parseInt(num1)+Number.parseInt(num2)"></span>
    <!--{{Number.parseInt(num1)+Number.parseInt(num2)}}-->
    <button>计算</button>
</div>
</body>
<script src="https://cdn.staticfile.org/vue/2.4.2/vue.min.js"></script>
<script>
    /*MVVM的VM(View Model)部分*/
    // 实例化Vue对象
    //vm :叫做MVVM中的 View Model
    var VM = new Vue({
        el: "#app",//表示当前vue对象接管app的div区域
        data: {
            name: '黑马程序员',// 相当于是MVVM中的Model这个角色
            num1: 0,
            num2: 0
        }
    });
</script>
</html>
```

```
<!DOCTYPE html>
<html lang="en" xmlns:v-on="http://www.w3.org/1999/xhtml" xmlns:v-bind="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>vue.js入门程序</title>
</head>
<body>
<div id="app">
        <!--MVVM的view视图-->
    <!--{{name}}解决闪烁问题使用v-text-->
    <a v-bind:href="url">
    <span v-text="name"></span>
    </a>
    <!--
            v-model代替了value属性
        1.从model到dom,这里num1和num2的值来自于model
        2.从dom到model,我在文本框中输入值,传递给我的model,model在传递给我的差值表达式
    -->
    <input type="text" v-model="num1">+
    <input type="text" v-model="num2">=
    <span v-text="result"></span>
    <!--<span v-text="Number.parseInt(num1)+Number.parseInt(num2)"></span>-->
    <!--{{Number.parseInt(num1)+Number.parseInt(num2)}}-->
    <button v-on:click="change">计算</button>
</div>
</body>
<script src="https://cdn.staticfile.org/vue/2.4.2/vue.min.js"></script>
<script>
    /*MVVM的VM(View Model)部分*/
    // 实例化Vue对象
    //vm :叫做MVVM中的 View Model
    var VM = new Vue({
        el: "#app",//表示当前vue对象接管app的div区域
        data: {
            name: '黑马程序员',// 相当于是MVVM中的Model这个角色
            num1: 0,
            num2: 0,
            result:0,
            url:"http://www.itcast.com"
        },
        methods :{
            change:function () {
               this.result = Number.parseInt(this.num1)+Number.parseInt(this.num2)
                //alert("计算结果: "+1)
            }
        }
    });
</script>
</html>
```



本例子学习了：

- v-model：(v-model和v-bind很像   v-model是双向数据绑定)

  - 在表单控件或者组件上创建双向绑定 
  - v-model仅能在如下元素中使用：
    - input
    - select
    - textarea 
    - components（Vue中的组件）

- v-text

  - 解决插值表达式闪烁问题，使用v-text 
  - v-text可以将一个变量的值渲染到指定的元素中,它可以解决插值表达式闪烁的问题

- v-on绑定一个按钮的单击事件

- v-bind：(v-model和v-bind很像   v-bind是单向数据绑定)

  - 作用:

    - v‐bind可以将数据对象绑定在dom的任意属性中。(单向) 
    - v‐bind可以给dom对象绑定一个或多个特性，例如动态绑定style和class

  - 举例：

    - ```
      <img v‐bind:src="imageSrc">
      ```

    - ```
      <div v‐bind:style="{ fontSize: size + 'px' }"></div>
      ```

  - 缩写形式

    - ```
      <img :src="imageSrc">
      ```

    - ```
      <div :style="{ fontSize: size + 'px' }"></div>
      ```

#### v-if和v-for

```
<!DOCTYPE html>
<html lang="en" xmlns:v-on="http://www.w3.org/1999/xhtml" xmlns:v-bind="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>vue.js入门程序</title>
</head>
<body>
<div id="app">
    <ul>
        <!--:key 主键-->
        <li v-for="(item,index) in list" :key="index" v-if="index % 2==0">{{index}}--{{item}}</li>
        <li v-for="(value,key) in user">{{key}}--{{value}}</li>
        <li v-for="(item,index) in userlist" :key="item.user.uname">
            <div v-if="item.user.username=='itheima'" style="background:greenyellow">
                {{index}}--{{item.user.username}}--{{item.user.age}}
            </div>
            <div v-else="">
                {{index}}--{{item.user.username}}--{{item.user.age}}
            </div>
        </li>
    </ul>
</div>
</body>
<script src="https://cdn.staticfile.org/vue/2.4.2/vue.min.js"></script>
<script>
    /*MVVM的VM(View Model)部分*/
    // 实例化Vue对象
    //vm :叫做MVVM中的 View Model
    var VM = new Vue({
        el: "#app",//表示当前vue对象接管app的div区域
        data: {
            list: [1, 2, 3, 4, 5],
            user: {uname: 'itcast', age: 10},
            userlist: [
                {user: {username: 'itcast', age: 10}},
                {user: {username: 'itheima', age: 11}}
            ]
        }
    });
</script>
</html>
```

# webpack

Webpack 是一个前端资源的打包工具，它可以将js、image、css等资源当成一个模块进行打包。

![1569072458919](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/03.png)

从图中我们可以看出，Webpack 可以将js、css、png等多种静态资源 进行打包

webpack的好处: 

1、模块化开发

程序员在开发时可以分模块创建不同的js、 css等小文件方便开发，最后使用webpack将这些小文件打包成一个文 件，减少了http的请求次数。
webpack可以实现按需打包，为了避免出现打包文件过大可以打包成多个文件。

2、 编译typescript、ES6等高级js语法 

随着前端技术的强大，开发中可以使用javascript的很多高级版本，比如：typescript、ES6等，方便开发， webpack可以将打包文件转换成浏览器可识别的js语法。

3、CSS预编译

webpack允许在开发中使用Sass 和 Less等原生CSS的扩展技术，通过sass-loader、less-loader将Sass 和 Less的 语法编译成浏览器可识别的css语法。

webpack的缺点:

1、配置有些繁琐
2、文档不丰富

### 安装webpack

webpack基于node.js运行，首先需要安装node.js。

#### 什么是node.js

Node.js 是一个基于 Chrome V8 引擎的 [JavaScript](https://baike.baidu.com/item/JavaScript/321142) 运行环境。 Node.js 使用了一个事件驱动、非阻塞式 I/O 的模型。 [1] 

Node 是一个让 JavaScript 运行在[服务端](https://baike.baidu.com/item/服务端/6492316)的开发平台，它让 JavaScript 成为与[PHP](https://baike.baidu.com/item/PHP/9337)、[Python](https://baike.baidu.com/item/Python/407313)、[Perl](https://baike.baidu.com/item/Perl/851577)、[Ruby](https://baike.baidu.com/item/Ruby/11419) 等服务端语言平起平坐的[脚本语言](https://baike.baidu.com/item/脚本语言/1379708)。 [2]  发布于2009年5月，由Ryan Dahl开发，实质是对Chrome V8引擎进行了封装。

Node对一些特殊用例进行优化，提供替代的[API](https://baike.baidu.com/item/API/10154)，使得V8在非浏览器环境下运行得更好。V8引擎执行Javascript的速度非常快，性能非常好。Node是一个基于Chrome JavaScript运行时建立的平台， 用于方便地搭建响应速度快、易于扩展的网络应用。Node 使用[事件驱动](https://baike.baidu.com/item/事件驱动/9597519)， 非阻塞[I/O](https://baike.baidu.com/item/I%2FO/84718) 模型而得以轻量和高效，非常适合在分布式设备上运行数据密集型的实时应用。

#### 安装node.js

为什么会有node.js？

传统意义上的 JavaScript 运行在浏览器上，Chrome 使用的 JavaScript 引擎是 V8，Node.js 是一个运行在服务端 的框架，它的底层就使用了 V8 引擎，这样就可以使用javascript去编写一些服务端的程序，这样也就实现了用 javaScript去开发 Apache + PHP 以及 Java Servlet所开发的服务端功能，这样做的好处就是前端和后端都采用 javascript，即开发一份js程序即可以运行在前端也可以运行的服务端，这样比一个应用使用多种语言在开发效率上 要高，不过node.js属于新兴产品，一些公司也在尝试使用node.js完成一些业务领域，node.js基于V8引擎，基于 事件驱动机制，在特定领域性能出色，比如用node.js实现消息推送、状态监控等的业务功能非常合适。



下边我们去安装Node.js： 
1、下载对应你系统的Node.js版本: 
https://nodejs.org/en/download/

![1569072833062](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/04.png)

推荐下载LTS版本



2、选安装目录进行安装
安装完成检查PATH环境变量是否设置了node.js的路径。



3、测试 
在命令提示符下输入命令

```
node ‐v
```



 #### 安装NPM

1、自动安装NPM
npm全称Node Package Manager，他是node包管理和分发的工具，使用NPM可以对应用的依赖进行管理，NPM 的功能和服务端项目构建工具maven差不多，我们通过npm 可以很方便地下载js库，打包js文件。
node.js已经集成了npm工具，在命令提示符输入 npm -v 可查看当前npm版本

![1569072991329](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/05.png)

2、查看包路径
包路径就是npm从远程下载的js包所存放的路径。
使用 npm conﬁg ls 查询NPM管理包路径（NPM下载的依赖包所存放的路径）

```
npm config ls
```

![1569073005295](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/06.png)

3、创建目录

NPM默认的管理包路径在C:/用户/[用户名]/AppData/Roming/npm/node_meodules，为了方便对依赖包管理，我 们将管理包的路径设置在单独的地方，本教程将安装目录设置在node.js的目录下，创建npm_modules和 npm_cache.

![1569217870510](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/07.png)

本教程安装node.js在X:\development\js\node下所以执行命令如下：

```
npm config set preﬁx "X:\development\js\node\npm_modules"
```

```
npm config set cache "X:\development\js\node\npm_cache"
```

此时再使用 npm conﬁg ls 查询NPM管理包路径发现路径已更改

![1569218562056](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/08.png)

#### 安装cnpm 

##### 1.连网

npm默认会去国外的镜像去下载js包，在开发中通常我们使用国内镜像，这里我们使用淘宝镜像 下边我们来安装cnpm： 
有时我们使用npm下载资源会很慢，所以我们可以安装一个cnmp(淘宝镜像)来加快下载速度。 输入命令，进行全局安装淘宝镜像。

```
npm install -g cnpm --registry=https://registry.npm.taobao.org
```

安装后，我们可以使用以下命令来查看cnpm的版本 

```
cnpm -v
```

![1569073159807](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/09.png)

如果nrm没有安装则需要进行全局安装：

```
npm install -g nrm
```

nrm ls 查看镜像指向

```
nrm ls
```

![1569220581272](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/10.png)

使nrm use XXX切换 镜像 

```
nrm use taobao
```

![1569073192324](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/11.png)



##### 2.不连网

资料文件下有已经下载好的webpack 相关包，下边是安装方法。

1）配置环境变量
NODE_HOME = D:\Program Files\nodejs (node.js安装目录) 
在PATH变量中添加：%NODE_HOME%;%NODE_HOME%\npm_modules;

2）找到npm包路径
根据上边的安装说明npm包路径被设置到了node.js安装目录下的npm_modules目录。
可以使用npm conﬁg ls查看。
拷贝课程资料中的 npm_modules.zip到node.js安装目录，并解压npm_modules.zip覆盖本目录下的 npm_modules文件夹。

3）完成上边步骤测试
cnpm -v

#### 安装webpack

##### 1.连网

webpack安装分为本地安装和全局安装： 
本地安装：仅将webpack安装在当前项目的node_modules目录中，仅对当前项目有效。 
全局安装：将webpack安装在本机，对所有项目有效，全局安装会锁定一个webpack版本，该版本可能不适用某个 项目。全局安装需要添加 -g 参数。

进入webpacktest测试目录目录，运行： 

1）本地安装：

只在我的项目中使用webpack，需要进行本地安装，因为项目和项目所用的webpack的版本不一样。本地安装就会 将webpack的js包下载到项目下的npm_modeuls目录下。
在门户目录下创建webpack测试目录webpacktest01：

```
npm install --save-dev webpack
```

```
cnpm install --save-dev webpack
```

4.0以后的版本需要安装

```
npm install --save-dev webpack-cli
```

2）全局安装加-g： 

全局安装就将webpack的js包下载到npm的包路径下。

```
npm install webpack -g
```

 或 

```
cnpm install webpack -g
```

3）安装webpack指定的版本：
本教程使用webpack3.6.0，安装webpack3.6.0：
进入webpacktest测试目录，运行：

```
cnpm install --save-dev webpack@3.6.0
```

全局安装：

```
npm install webpack@3.6.0 -g
```

或 

```
cnpm install webpack@3.6.0 -g
```

##### 2.非连网

参考上边 “非连网环境安装cnpm”描述，将课程资料中的 npm_modules.zip到node.js安装目录，并解压 npm_modules.zip覆盖本目录下的npm_modules文件夹。
说明：已执行 “非连网环境安装cnpm”下的操作不用重复执行。 
测试：
在cmd状态输入webpack，出现如下提示说明 webpack安装成功

![1569079225427](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/11.png)

#### webpack入门程序

通过本入门程序体会webpack打包的过程及模块化开发的思想。

##### 1.需求分析

通过入门程序实现对js文件的打包，体会webpack是如何对应用进行模块化管理。 
对上边1+1=2的例子使用webpack进行模块化管理

![1569080294183](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/13.png)

##### 2.定义模块

创建webpacktest01目录，将vue.min.js及vue_02.html拷贝到目录下。 

1、定义model01.js
在webpacktest01目录下创建model01.js 
将本程序使用的加法运算的js方法抽取到一个js文件，此文件就是一个模块

```
var add = function (x, y) {
    return x + y;
}
var add2 = function (x, y) {
    return x + y + 2;
}
module.exports.add = add;
// module.exports ={add,add2};//如果有多个方法这样导出
// module.exports.add2 = add2//如果有多个方法也可以这样导出
```

2、定义main.js 
在webpacktest01目录下创建main.js，main.js是本程序的js主文件，包括如下内容： 

​	1、在此文件中会引用model01.js模块
​	2、引用vue.min.js（它也一个模块） 
​	3、将html页面中构建vue实例的代码放在main.js中。
main.js的代码如下:

```
//导入model01.js
var {add} = require("./model01")
var Vue = require("./vue.min")
var VM = new Vue({
    el: '#app',//vm接管了app区域的管理
    data: {//model数据
        name: '黑马程序员',
        num1: 0,
        num2: 0,
        result: 0,
        url: 'http://www.itcast.cn',
        size: 11
    },
    methods: {
        change: function () {
            this.result = add(Number.parseInt(this.num1), Number.parseInt(this.num2))
            // this.result = Number.parseInt(this.num1)+Number.parseInt(this.num2)
            //alert("计算结果："+this.result)
        }
    }
});
```

##### 3.打包测试

上边将mode01.js模块及main.js主文件编写完成，下边使用webpack对这些js文件进行打包 
1、进入程序目录，执行

```
webpack main.js build.js
```

 这段指令表示将main.js打包输出为 build.js文件 
执行完成，观察程序目录是否出现build.js。
2、在html中引用build.js

```
<!DOCTYPE html>
<html lang="en" xmlns:v-bind="http://www.w3.org/1999/xhtml" xmlns:v-on="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>vue.js常用指令的测试</title>
</head>
<body>
<!--实现在body区域显示一个传智播客名称-->
<div id="app">
    <!--相当于MVVM的view视图-->
    <!--{{name}}-->
    <a v-bind:href="url">
        <span v-text="name"></span>
    </a>
    <input type="text" v-model="num1"/> +
    <input type="text" v-model="num2"/>=
    <!-- <span v-text="Number.parseInt(num1)+Number.parseInt(num2)"></span>-->
    <span v-text="result"></span>
    <!--{{Number.parseInt(num1)+Number.parseInt(num2)}}-->
    <button v-on:click="change">计算</button>
</div>
</body>
<!--<script src="vue.min.js"></script>-->
<script src="build.js"></script>
<script>
    //编写MVVM中的model部分及VM（ViewModel）部分

</script>
</html>
```

### webpack-dev-server

webpack-dev-server开发服务器，它的功能可以实现热加载 并且自动刷新浏览器。 
创建一个新的程序目录，这里我们创建webpacktest02目录，将webpack入门程序的代码拷贝进来，并在目录下创 建src目录、dist目录。
将main.js和model01.js拷贝到src目录。

#### 安装配置

##### 1.安装webpack-dev-server

进入到webpacktest02的目录下

使用 webpack-dev-server需要安装webpack、 webpack-dev-server和 html-webpack-plugin三个包。

```
cnpm install webpack@3.6.0 webpack-dev-server@2.9.1 html-webpack-plugin@2.30.1 --save-dev
```

安装完成，会发现程序目录出现一个package.json文件，此文件中记录了程序的依赖。 相当于java的pom.xml

安装完成，会发现程序目录出现一个node_modules目录,存放了本程序所依赖的包

没有联网的提供的node_modules.zip到webpacktest02目录下，解压到node_modules目录下

##### 2.配置webpack-dev-server

在package.json中配置script

```
"scripts": {
    "dev": "webpack-dev-server --inline --hot --open --port 5008"
  },
```

- inline：自动刷新

- hot：热加载

- port：指定端口

- open：自动在默认浏览器打开

- host：可以指定服务器的 ip，不指定则为127.0.0.1，如果对外发布则填写公网ip地址

此时package.json的文件内容如下：

```
{
  "scripts": {
    "dev": "webpack-dev-server --inline --hot --open --port 5008"
  },
  "devDependencies": {
    "html-webpack-plugin": "^2.30.1",
    "webpack": "^3.6.0",
    "webpack-dev-server": "^2.9.1"
  }
}
```

devDependencies：开发人员在开发过程中所需要的依赖。 

scripts：可执行的命令

#### 配置webpack.conﬁg.js

在webpacktest02目录下创建 webpack.conﬁg.js， webpack.conﬁg.js是webpack的配置文件。在此文件中可以配 置应用的入口文件、输出配置、插件等，其中要实现热加载自动刷新功能需要配置html-webpack-plugin插件。 html-webpack-plugin的作用是根据html模板在内存生成html文件，它的工作原理是根据模板文件在内存中生成一 个index.html文件。

##### 1.配置模板文件 

将原来的vue_02.html作为模板文件，为了和内存中的index.html文件名区别，注意将vue_02.html中的script标签 去掉，内容如下：

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>vue.js常用指令的测试</title>
</head>
<body>
<!--实现在body区域显示一个传智播客名称-->
<div id="app">
    <!--相当于MVVM的view视图-->
    <!--{{name}}-->
    <a v-bind:href="url">
        <span v-text="name"></span>
    </a>
    <input type="text" v-model="num1"/> +
    <input type="text" v-model="num2"/>=
    <!-- <span v-text="Number.parseInt(num1)+Number.parseInt(num2)"></span>-->
    <span v-text="result"></span>
    <!--{{Number.parseInt(num1)+Number.parseInt(num2)}}-->
    <button v-on:click="change">计算</button>
</div>
</body>
<script>
    //编写MVVM中的model部分及VM（ViewModel）部分

</script>
</html>
```

##### 2.配置 html-webpack-plugin 

在webpack.conﬁg.js中配置html-webpack-plugin插件

```
//引用html-webpack-plugin插件，作用是根据html模板在内存生成html文件，它的工作原理是根据模板文件在内存中生成一个index.html文件。
var htmlwp = require('html-webpack-plugin');
module.exports = {
    entry: './src/main.js',  //指定打包的入口文件
    output: {
        path: __dirname + '/dist',  // 注意：__dirname表示webpack.config.js所在目录的绝对路径
        filename: 'build.js'		   //输出文件
    },
    devtool: 'eval-source-map',
    plugins: [
        new htmlwp({
            title: '首页',  //生成的页面标题<head><title>首页</title></head>
            filename: 'index.html', //webpack-dev-server在内存中生成的文件名称，自动将build注入到这个页面底部，才能实现自动刷新功能
            template: 'vue_02.html' //根据vue_02.html这个模板来生成(这个文件请程序员自己生成)
        })
    ]
}
```

#### 启动

两种方式:

1、进入 webpacktest02目录，执行npm run dev 
2、使用webstorm，右键package.json文件，选择“Show npm Scripts” 
打开窗口：

![1569225381399](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/14.png)

双击 dev。
注意：dev就是在package.json中配置的webpack-dev-server --inline --hot --open --port 5008命令。 发现启动成功自动打开浏览器。 
修改src中的任意文件内容，自动加载并刷新浏览器。

#### debug调试

使用了webpack之后就不能采用传统js的调试方法在chrome中打断点。

webpack将多个源文件打包成一个文件，并且文件的内容产生了很大的变化，webpack提供devtool进行调试， devtool是基于sourcemap的方式，在调试时会生成一个map文件，其内容记录生成文件和源文件的内容映射，即 生成文件中的哪个位置对应源文件中的哪个位置，有了sourcemap就可以在调试时看到源代码。

配置如下： 
1、在webpack.conﬁg.js中配置：

```
devtool: 'eval-source-map'
```

webpack.conﬁg.js部分内容如下：

```
var htmlwp = require('html‐webpack‐plugin');
module.exports={
    entry:'./src/main.js',  //指定打包的入口文件
    output:{
        path : __dirname+'/dist',  // 注意：__dirname表示webpack.config.js所在目录的绝对路径         filename:'build.js'          //输出文件
    },
    devtool: 'eval‐source‐map', //添加的断点配置
    ......
```

2、在js中跟踪代码的位置上添加debugger 一个例子：
在add方法中添加debugger

```
// 定义add函数 
var add = function (x, y) {
    debugger
    return x+y;
}
```

启动应用，刷新页面跟踪代码：
点击“计算” 即进入debugger代码位置，此时可以使用chrome进行调试了。

![1569225504567](https://blog-mamba.oss-cn-beijing.aliyuncs.com/java/items/xczx/xczx02/15.png)