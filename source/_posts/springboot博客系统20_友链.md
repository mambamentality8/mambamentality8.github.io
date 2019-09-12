# 实验介绍

#### 实验内容

后台管理系统的大部分功能及页面都已经开发完成，接下来是博客相关页面的制作和功能开发，本实验是博客首页的制作和功能实现。

本次训练营的实践项目是我在 GitHub 上开源的一个仓库，地址是 https://github.com/ZHENFENG13/My-Blog，从写下该项目的第一行代码到项目开发完成并开源到 GitHub 断断续续花费了半年多的时间，后续也不断的优化和重构，最终结果也呈现在大家的眼前。

目前在项目中内置了三套博客主题模板可供大家选择使用，主题风格各有千秋，由于课程原因本次训练营中的开发实录只选择了其中一套主题进行讲解，因为另外两套的实现仅仅是页面布局和 CSS 文件有区别，功能和逻辑都是一样的。

#### 实验知识点

- 博客首页简介
- 页面布局讲解
- 博客首页制作
- 公共代码抽取

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，文章中只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/html.zip
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog-25.zip
unzip My-Blog-25.zip
cd My-Blog
```

# 博客首页

前面一些实验讲解的都是博客后台管理系统相关内容，这个后台管理系统通常只是网站拥有者去查看和使用，而博客页面则与此有较大的不同，博客相关页面涉及到的用户操作大多是查看，就是把后台管理系统中添加和编辑的数据通过博客页面呈现给用户，这些页面更多的偏重于展示功能，包括文章内容、网站信息、文章归类等等信息的查看，相较于后台管理系统来说，博客相关页面的开发和制作在编码逻辑、功能实现上会更简单一些，因为涉及到的操作只是数据查询和数据聚合，这不代表开发难度就降低了，这些页面往往更加注重页面观感和元素设计，如果用户觉得第一眼之后就没有了看下去的欲望也是不行的，但是博客系统也并不需要做的过于绚丽多姿，简洁美观即可。

在博客页面中，首页是最先被用户浏览到，这个页面也是非常重要的入口，如果用户在该页面就萌生退意那就证明页面的设计还需要在仔细斟酌，因此博客的首屏页面也是重中之重，为了满足大家不同的审美和选择，我在博客项目所有的功能都开发完成后，又增加了一些博客模板，后续如果有需要的话也会继续增加，目前是有三个博客模板供大家选择，由于本实验是讲解博客首页，就先来看看不同模板中博客首页的效果吧！

- 模板一

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380461423/wm)

- 模板二

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380473555/wm)

- 模板三

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380484685/wm)

# 页面设计

通过前文中三个首页的页面展现效果，我们大致可以得出一个博客首页布局的通用模板：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380496936/wm)

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380506122/wm)

由上图可以看出，博客首屏页面的整个设计版面被切分成七个部分：

1. 顶部导航栏：可以放置 Logo 图片、博客系统名称、其它页面的名称及跳转链接等信息；
2. 搜索框：实现文章搜索功能；
3. 文章列表：用于展示文章列表，显示文章的概览信息；
4. 博客统计：根据发布时间、点击次数等维度筛选出的博客列表；
5. 标签统计：筛选出使用频次高的标签或者分类数据；
6. 分页导航：放置分页按钮，用于分页跳转功能；
7. 页脚区域：放置博客的基本信息。

当然，以上版面设计的分析只是对于我的博客模板来说是这样的，社区中还有许多其他的博客系统项目，由于前端的设计和实现非常灵活且多变，这些博客系统可能又是另外一些页面样式和页面布局，但是页面上所展现的数据和基础的页面布局可能不会大改，基础布局包括以下四个部分：

- 顶部导航栏区域：这个区域处于页面顶部或者左侧区域且占用页面的面积较小，用于放置 Logo 图、系统名称、其它页面的名称及跳转链接等导航信息用于实现页面跳转的管理。
- 侧边工具栏区域：这个区域中包括搜索框、博客统计、标签统计等信息，会展示一些数据但并不是最主要的部分，甚至有很多博客系统中并不会有侧边工具栏区域，该区域会被文章列表区所占用。
- 文章列表区域：这个区域会占用整个版面的大部分面积，包括前文中提到的文章列表和分页导航，因此是整个系统最重要的部分。
- 底部页脚区域：这个区域占用的面积较小，通常会在整个版面的底部一小部分区域，用来展示辅助信息，如版权信息、系统信息、项目版本号等等，不过这个区域并不是必须的。

以上是对博客系统首屏布局的大致切分和讲解，接下来是具体的系统编码实现。

# 首页制作

#### 静态页面

首页的静态资源文件已经上传，文件名是 html.zip，可以直接下载并查看，文件目录结构如下：

```
html
  ├── css
  ├── img
  ├── js
  └── index.html
```

分别是样式文件、基础的展示图片、脚本文件及首页的代码，html 代码如下：

```
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <title>主页</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="css/style.css">
    <!--[if lt IE 9]>
    <script src="js/respond.js"></script>
    <![endif]-->
</head>
<body>
<header>
    <div class="widewrapper masthead">
        <div class="container">
            <a href="index.html" id="logo">
                <img src="img/logo.png" class="logo-img" alt="personal-blog">
            </a>
            <div id="mobile-nav-toggle" class="pull-right">
                <a href="#" data-toggle="collapse" data-target=".clean-nav .navbar-collapse">
                    <i class="fa fa-bars"></i>
                </a>
            </div>
            <nav class="pull-right clean-nav">
                <div class="collapse navbar-collapse">
                    <ul class="nav nav-pills navbar-nav">
                        <li>
                            <a href="index.html">主页</a>
                        </li>
                        <li>
                            <a href="##">关于</a>
                        </li>
                        <li>
                            <a href="##">联系我</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    <div class="widewrapper subheader">
        <div class="container">
            <div class="clean-breadcrumb">
                <a href="#">首页</a>
            </div>
            <div class="clean-searchbox">
                <form action="#" method="get" accept-charset="utf-8">
                    <input class="searchfield" id="searchbox" type="text" placeholder="搜索">
                    <button class="searchbutton" type="submit">
                        <i class="fa fa-search"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>
<div class="widewrapper main">
    <div class="container">
        <div class="row">
            <div class="col-md-8 blog-main">
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class=" blog-summary">
                        <header>
                            <img src="img/photo1.png" alt="">
                            <h3><a href="##">第14课：SweetAlert 插件整合及搜索功能实现</a></h3>
                        </header>

                    </article>
                </div>
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img src="img/photo2.png" alt="">
                            <h3><a href="##">第13课：富文本信息管理模块</a></h3>
                        </header>

                    </article>
                </div>

                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img src="img/photo1.png" alt="">
                            <h3><a href="##">第12课：文件导入导出功能</a></h3>
                        </header>

                    </article>
                </div>
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img src="img/photo1.png" alt="">
                            <h3><a href="##">第11课：多图上传与大文件分片上传、断点续传</a></h3>
                        </header>

                    </article>
                </div>
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img src="img/photo1.png" alt="">
                            <h3><a href="##">第10课：图片管理模块</a></h3>
                        </header>

                    </article>
                </div>
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class=" blog-summary">
                        <header>
                            <img src="img/photo2.png" alt="">
                            <h3><a href="##">第09课：弹框组件整合——完善添加和修改功能</a></h3>
                        </header>
                    </article>
                </div>
                <ul class="blog-pagination">
                    <li><a href="#">&laquo;</a></li>
                    <li class="active"><a href="#"> 1 </a></li>
                    <li class="disabled"><a href="#"> 2 </a></li>
                    <li><a href="#"> 3 </a></li>
                    <li><a href="#"> 4 </a></li>
                    <li><a href="#"> 5 </a></li>
                    <li><a href="#">&raquo;</a></li>
                </ul>
            </div>
            <aside class="col-md-4 blog-aside">
                <div class="aside-widget">
                    <header>
                        <h3>点击最多</h3>
                    </header>
                    <div class="body">
                        <ul class="clean-list">
                            <li><a href="">关于personal-blog</a></li>
                            <li><a href="">关于personal-blog</a></li>
                            <li><a href="">关于personal-blog</a></li>
                            <li><a href="">关于personal-blog</a></li>
                            <li><a href="">关于personal-blog</a></li>
                        </ul>
                    </div>
                </div>
                <div class="aside-widget">
                    <header>
                        <h3>最新发布</h3>
                    </header>
                    <div class="body">
                        <ul class="clean-list">
                            <li><a href="">SpringBoot</a></li>
                            <li><a href="">SpringBoot</a></li>
                            <li><a href="">SpringBoot</a></li>
                            <li><a href="">SpringBoot</a></li>
                            <li><a href="">SpringBoot</a></li>
                            <li><a href="">SpringBoot</a></li>
                        </ul>
                    </div>
                </div>
                <div class="aside-widget">
                    <header>
                        <h3>标签栏</h3>
                    </header>
                    <div class="body clearfix">
                        <ul class="tags">
                            <li><a href="#">HTML5</a></li>
                            <li><a href="#">CSS3</a></li>
                            <li><a href="#">COMPONENTS</a></li>
                            <li><a href="#">TEMPLATE</a></li>
                            <li><a href="#">PLUGIN</a></li>
                            <li><a href="#">BOOTSTRAP</a></li>
                            <li><a href="#">TUTORIAL</a></li>
                            <li><a href="#">UI/UX</a></li>
                        </ul>
                    </div>
                </div>
            </aside>
        </div>
    </div>
</div>
<footer>
    <div class="widewrapper footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 footer-widget">
                    <h3><i class="fa fa-user"></i>About</h3>
                    <p>your singal blog.</p>
                    <p>have fun.</p>
                </div>
                <div class="col-md-4 footer-widget">
                    <h3><i class="fa fa-tag"></i>备案</h3>
                    <p>浙ICP备 xxxxxx-x号</p>
                </div>
                <div class="col-md-4 footer-widget">
                    <h3><i class="fa fa-copyright"></i>Copy Right</h3>
                    <p>My Blog</p>
                </div>
            </div>
        </div>
    </div>
</footer>
<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/modernizr.js"></script>
</body>
</html>
```

这个 html 代码是可以直接在本地打开的，同学们可以自行查看其页面效果，并结合前文中分析的页面设计和排版理解，之后我们主要是将页面整合到我们的系统中并进行实际的功能编码。

#### 首页整合

接下来我们做的都是博客页面相关页面和功能，为了与后端管理系统相区别，我们都会新建包和目录。在 resources/templates 目录下新建 blog 目录用于存放博客页面的模板页面,之后并放入 index.html 页面，在 resources/static 目录下新建 blog 目录用于存放博客页面的相关静态资源，之后将前文中提到的静态资源文件都移动到该目录下。

然后打开 index.html 文件并在该模板文件的 <html> 标签中导入 Thymeleaf 的名称空间：

```
<html lang="en" xmlns:th="http://www.thymeleaf.org">
```

导入该名称空间主要是为了 Thymeleaf 的语法提示和 Thymeleaf 标签的使用，接着我们在模板中使用 th 标签来修改静态资源的引用路径，最终的模板文件如下：

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="utf-8">
    <title>主页</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width">
    <!-- Bootstrap styles -->
    <link rel="stylesheet" th:href="@{/blog/css/bootstrap.min.css}">
    <!-- Font-Awesome -->
    <link rel="stylesheet" th:href="@{/blog/css/font-awesome/css/font-awesome.min.css}">
    <!-- Styles -->
    <link rel="stylesheet" th:href="@{/blog/css/style.css}" id="theme-styles">
    <!--[if lt IE 9]>
    <script th:src="@{/blog/js/respond.js}"></script>
    <![endif]-->
</head>
<body>
<header>
    <div class="widewrapper masthead">
        <div class="container">
            <a href="index.html" id="logo">
                <img th:src="@{/blog/img/logo.png}" class="logo-img" alt="My Blog">
            </a>
            <div id="mobile-nav-toggle" class="pull-right">
                <a href="#" data-toggle="collapse" data-target=".clean-nav .navbar-collapse">
                    <i class="fa fa-bars"></i>
                </a>
            </div>
            <nav class="pull-right clean-nav">
                <div class="collapse navbar-collapse">
                    <ul class="nav nav-pills navbar-nav">
                        <li>
                            <a href="index.html">主页</a>
                        </li>
                        <li>
                            <a href="##">关于</a>
                        </li>
                        <li>
                            <a href="##">联系我</a>
                        </li>
                    </ul>
                </div>
            </nav>
        </div>
    </div>
    <div class="widewrapper subheader">
        <div class="container">
            <div class="clean-breadcrumb">
                <a href="#">首页</a>
            </div>
            <div class="clean-searchbox">
                <form action="#" method="get" accept-charset="utf-8">
                    <input class="searchfield" id="searchbox" type="text" placeholder="搜索">
                    <button class="searchbutton" type="submit">
                        <i class="fa fa-search"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>
<div class="widewrapper main">
    <div class="container">
        <div class="row">
            <div class="col-md-8 blog-main">
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class=" blog-summary">
                        <header>
                            <img th:src="@{/blog/img/photo1.png}" alt="">
                            <h3><a href="##">第14课：SweetAlert 插件整合及搜索功能实现</a></h3>
                        </header>

                    </article>
                </div>
                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img th:src="@{/blog/img/photo2.png}" alt="">
                            <h3><a href="##">第13课：富文本信息管理模块</a></h3>
                        </header>

                    </article>
                </div>

                <div class="col-md-6 col-sm-6 blog-main-card ">
                    <article class="blog-summary">
                        <header>
                            <img th:src="@{/blog/img/photo1.png}" alt="">
                            <h3><a href="##">第12课：文件导入导出功能</a></h3>
                        </header>

                    </article>
                </div>
                ...省略部分代码
            </div>

        </div>
    </div>
</div>
                ...省略部分代码
<script th:src="@{/blog/js/jquery.min.js}"></script>
<script th:src="@{/blog/js/bootstrap.min.js}"></script>
<script th:src="@{/blog/js/modernizr.js}"></script>
</body>
</html>
```

前端文件制作完毕，接下来我们新建 Controller 来处理首页请求路径并跳转到对应的页面。

#### Controller 处理跳转

首先在 controller 包下新建 blog 包，并新建 MyBlogController.java，之后新增如下代码：

```
package com.site.blog.my.core.controller.blog;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MyBlogController {

    /**
     * 首页
     *
     * @return
     */
    @GetMapping({"/", "/index", "index.html"})
    public String index() {
        return "blog/index";
    }
}
```

该方法用于处理 "/", "/index", "index.html" 等请求，这种路径的请求一般为首页请求，如果你觉得还需要加其他路径的话也可以在 Mapping 配置中加上，方法的最后返回 "blog/index" ，即访问该方法会跳转到 blog 目录下的 index.html 模板文件中。

至此，跳转逻辑处理完毕，演示效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564380541196/wm)

# 页面抽取

前文中我们也提到了页面设计以及几个基本的页面区域，页面顶部和页面底部两个区域在我们本次的实践系统中都是相似的，因此对这两部分进行公共代码抽取减少重复编码，在 resources/templates 目录下新建 header.html 和 footer.html 两个模板文件，代码如下：

- header.html

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head th:fragment="head-fragment">
    <meta charset="utf-8">
    <title th:text="${pageName}">主页</title>
    <meta name="viewport" content="width=device-width">
    <!-- Bootstrap styles -->
    <link rel="stylesheet" th:href="@{/blog/css/bootstrap.min.css}">
    <!-- Font-Awesome -->
    <link rel="stylesheet" th:href="@{/blog/css/font-awesome/css/font-awesome.min.css}">
    <!-- Styles -->
    <link rel="stylesheet" th:href="@{/blog/css/style.css}" id="theme-styles">
    <!--[if lt IE 9]>
    <script th:src="@{/blog/default/js/respond.js}"></script>
    <![endif]-->
</head>
<header th:fragment="header-fragment">
    <div class="widewrapper masthead">
        <div class="container">
            <a th:href="@{/index}" id="logo">
                <img th:src="@{/blog/img/logo.png}" class="logo-img" alt="my personal blog">
            </a>
            <div id="mobile-nav-toggle" class="pull-right">
                <a href="#" data-toggle="collapse" data-target=".clean-nav .navbar-collapse">
                    <i class="fa fa-bars"></i>
                </a>
            </div>
            <nav class="pull-right clean-nav">
                <div class="collapse navbar-collapse">
                    <ul class="nav nav-pills navbar-nav">
                        <li>
                            <a th:href="@{/index}">主页</a>
                        </li>
                        <li>
                            <a th:href="@{/link}">友链</a>
                        </li>
                        <li>
                            <a th:href="@{/about}">关于</a>
                        </li>
                    </ul>
                </div>
            </nav>

        </div>
    </div>

    <div class="widewrapper subheader">
        <div class="container">
            <div class="clean-breadcrumb">
                <th:block th:text="${pageName}"></th:block>
            </div>
            <div class="clean-searchbox">
                <form method="get" accept-charset="utf-8">
                    <input class="searchfield" id="searchbox" type="text" placeholder="  搜索">
                    <button class="searchbutton" id="searchbutton">
                        <i class="fa fa-search"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>
</header>
<!-- /.header -->
</html>
```

- footer.html

```
<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<footer th:fragment="footer-fragment">
    <div class="widewrapper footer">
        <div class="container">
            <div class="row">
                <div class="col-md-3 footer-widget">
                    <h3><i class="fa fa-user"></i>About</h3>
                    <p>your singal blog.</p>
                </div>
                <div class="col-md-3 footer-widget">
                    <h3><i class="fa fa-info-circle"></i>ICP</h3>
                    <p>浙ICP备 xxxxxx-x号</p>
                </div>
                <div class="col-md-3 footer-widget">
                    <h3><i class="fa fa-copyright"></i>Copy Right</h3>
                    <p>2018 十三</p>
                </div>
                <div class="col-md-3 footer-widget">
                    <h3><i class="fa fa-arrow-circle-o-up"></i>Powered By</h3>
                    zhenfeng13
                </div>

            </div>
        </div>
    </div>
</footer>
</html>
```

之后我们修改 index.html，页面的头部区域和底部区域通过 `th:replace` 标签 引入进来，修改代码如下：

```
<!-- 引入导航栏和搜索栏 -->
<head th:replace="blog/header::head-fragment"></head>
<body>
<header th:replace="blog/header::header-fragment"></header>

<!-- 引入页脚footer-fragment -->
<footer th:replace="blog/footer::footer-fragment"></footer>
```

修改完成后重启项目查看页面效果，一切正常则证明编码正常。

# 总结

由于篇幅的原因，文中给出的部分代码做了删减，完整的代码同学们可以根据我提供的地址进行下载。

本节实验对首屏页面进行了简单的介绍和讲解，之后讲解了首屏页面的制作过程以及页面公共代码抽取，目前只是前端页面的制作，并没有数据的读取和渲染，下一节实验将会讲解数据的查询以及如何填充到页面中，本节实验到此结束，同学们可以按照文中的思路和过程自行测试。

