# 实验介绍

#### 实验内容

在 api 实践那节实验课程中包含一个列表查询接口，但是那个接口会将所有的数据查询出来，一般这种接口会加入分页逻辑，在查询时只查询对应页码的数据，而不是将所有的数据全部都查询出来，本节实验课我们将对分页功能进行介绍及分析，之后进行功能实践，之后还会讲解使用 JqGrid 分页插件进行分页功能的效果展示。

其实分页是一个网站系统中非常重要也十分常用的功能，相信不少同学对这个功能比较熟悉，在 MVC 开发模式下我们通常是把它放入返回对象中并在页面代码中循环遍历并渲染到页面中，也有通过接口返回，并通过前端插件来实现，这两种方式我们都会介绍到，本节实践的内容将其设计为一个通用的分页接口，并将分页数据放到 Result 对象中并通过 json 格式返回。

#### 实验知识点

- 分页功能简介
- 分页功能的作用和好处
- 分页功能实践
- JqGrid 分页插件介绍
- JqGrid 分页插件整合

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

#### 代码获取

**在学习前，一定要获取源码，因为篇幅原因，只会截取部分关键代码。请大家参照完整源码进行学习**

```
wget https://labfile.oss.aliyuncs.com/courses/1367/lou-springboot-14.zip
unzip lou-springboot-14.zip
cd lou-springboot
```

# 什么是分页

在各类电商网站、新闻网站、音乐网站、各类后台管理系统等等网站中都会存在，分页功能也是十分常见的功能，我们来看一下比较常见及常用的分页功能的展现形式：

#### 实验楼分页功能

在实验楼的课程搜索框中输入 "java" 查询相关信息之后跳转到搜索结果页面，页面中大致会有 15 条左右的数据列表，当前展示的是第 1 页的数据，如果想看后面的搜索内容点击页面下方的分页信息即可，比如点击第 2 页或者下一页的按钮就可以看到更多的实验楼课程信息了。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026028157.png/wm)

#### 博客后台分页

博客后台的文章管理页面，也并没有把所有的文章信息都展示出来，而是通过分页功能分别展示出来：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026224543.png/wm)

#### 百度分页

在百度首页搜索框中输入"java"查询相关信息之后跳转到搜索结果页面，页面中大致会有 10 条左右的数据列表，此时展示的是第 1 页的数据，如果想看后面的搜索内容点击页面下方的分页信息即可，比如点击第 6 页或者下一页的按钮就可以看到更多的信息了。

![此处输入图片的描述](http://labfile.oss.aliyuncs.com/courses/1244/baidu-page.gif)

# 分页的作用

不仅仅是常见，分页功能在一个系统中也是不可缺少的，分页功能的作用如下：

- 减少系统资源的消耗，数据查询出来后是放在内存里的，如果在数据量很大的情况下一次性将所有内容都查询出来，会占用过多的内存，通过分页可以减少这种消耗；
- 提高性能，应用与数据库间通过网络传输数据，一次传输 10 条数据结果集与一次传输 20000 条数据结果集肯定是传输 10 条消耗更少的网络资源；
- 提升访问速度，浏览器与应用间的传输也是通过网络，返回 10 条数据明显那比返回 20000 条数据速度更快，因为数据包的大小有差别；
- 符合用户习惯，比如搜索结果或者商品展示，通常用户可能只看最近前 30 条，将所有数据都查询出来比较浪费；
- 基于展现层面的考虑，由于设备屏幕的大小比较固定，一个屏幕能够展示的信息并不是特别多，如果一次展现太多的数据，不管是排版还是页面美观度都有影响，一个屏幕的范围就是那么大，展示信息条数有限。

分页功能的使用可以提升系统性能，也比较符合用户习惯，符合页面设计，这也是为什么大部分系统都会有分页功能。

# 分页设计

#### 分页参数设计

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026524121.png/wm)

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026531814.png/wm)

分页信息区的设计和展示如上图所示，前端分页区比较重要的几个信息是：

- 页码展示
- 当前页码
- 每页条数

当然，有些页面也会加上首页、尾页、跳转页码等功能，这些信息都根据功能需要和页面设计去做增加和删减。

#### 后端功能设计

前端页面的工作是渲染数据和分页信息展示，而后端则需要按照前端传输过来的请求将分页所需的数据正确的查询出来并返回给前端，两端的侧重点并不相同，比如前端需要展示所有页码，而后端则只需要提供总页数即可，并不需要对这个总页码进行其他操作，比如前端需要根据用户操作记录当前页码这个参数以便对页码信息进行调整和限制，而后端则并不是这么注重当前页码，只需要接收前端传输过来的页码进行相应的判断和查询操作即可。

对于后端必不可少的是两个参数：

- 页码(需要第几页的数据)
- 每页条数(每次查询多少条数据,一般默认 10 条或者 20 条)

因为数据库查询语句如下，不同数据库可能关键字有些差别，比如 SQL Server 是通过 `top` 关键字、Oracle 通过 `rownum` 关键字，MySQL 实现分页功能基本都是使用 `limit` 关键字。

```
//下面是mysql的实现语句：

select * from tb_xxxx limit 10,20
```

分页功能的最终实现既是如此，通过页码和条数确定数据库需要查询的是从第几条到第几条的数据，比如查询第 1 页每页 20 条数据就是查询数据库中从 0 到 20 条数据，查询第 4 页每页 10 条数据就是查询数据库中第 30 到 40 条数据，因此对于后端来说页码和条数两个参数就显得特别重要，缺少这两个参数根本无法继续之后的查询逻辑，分页数据也就无从查起。

虽然如此，为了前端分页区展示还要将数据总量或者总页数返回给前端，数据总量是必不可少的，因为总页数可以计算出来，即数据总量除以每页条数，数据总量的获取方式：

```
select count(*) from tb_xxxx
```

之后将数据封装，并返回给前端即可。

# 分页功能实践

接下来我们将结合 tb_admin_user 表进行简单的查询并分页的功能，在前端请求对应的页数时返回那一页的所有数据。 注意：项目统一创建在/home/project/lou-springboot 目录下。

# 新增数据

为了演示分页功能，因此在表中增加一些数据，不然演示效果不太好，执行如下 SQL：

```
USE `lou_springboot`;

DROP TABLE IF EXISTS `tb_admin_user`;
CREATE TABLE `tb_admin_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `password_md5` varchar(50) NOT NULL,
  `user_token` varchar(50) NOT NULL,
  `is_deleted` tinyint(4) DEFAULT '0',
  `create_time` date NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DELETE FROM tb_admin_user;

INSERT  INTO `tb_admin_user`(`id`,`user_name`,`password_md5`,`user_token`,`is_deleted`,`create_time`) VALUES (1,'admin','e10adc3949ba59abbe56e057f20f883e','d87edfdd63674b9591602b26bfb7f93f',0,'2018-07-04 11:21:14'),(2,'test2','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:28'),(3,'test3','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(4,'test4','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(5,'test5','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:33'),(6,'test6','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:34'),(7,'test7','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(8,'test8','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(9,'test9','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:36'),(10,'test10','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:37'),(11,'test11','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(12,'test12','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(13,'test13','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:39'),(14,'test14','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(15,'test15','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(16,'test16','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(17,'test17','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(18,'test18','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:42'),(19,'test19','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:46'),(20,'admin2','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:28'),(21,'admin3','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(22,'admin4','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(23,'admin5','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:33'),(24,'admin6','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:34'),(25,'admin7','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(26,'admin8','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(27,'admin9','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:36'),(28,'admin10','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:37'),(29,'admin11','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(30,'admin12','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(31,'admin13','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:39'),(32,'admin14','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(33,'admin15','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(34,'admin16','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(35,'admin17','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(36,'admin18','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:42'),(37,'admin19','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:46'),(38,'admin011','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(39,'admin02','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:28'),(40,'admin03','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(41,'admin04','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:32'),(42,'admin05','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:33'),(43,'admin06','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:34'),(44,'admin07','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(45,'admin08','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:35'),(46,'admin09','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:36'),(47,'admin010','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:37'),(48,'admin011','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(49,'admin012','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:38'),(50,'admin013','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:39'),(51,'admin014','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(52,'admin015','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:40'),(53,'admin016','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(54,'admin017','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:41'),(55,'admin018','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:42'),(56,'admin019','098f6bcd4621d373cade4e832627b4f6','\'\'',0,'2018-07-09 17:22:46'),(57,'ZHENFENG13','77c9749b451ab8c713c48037ddfbb2c4','592e62069daf32211a71aa892ec1b8f5',0,'2018-07-12 16:08:49'),(58,'213312','eqwfasdfa','\'\'',0,'2018-07-12 16:10:14'),(59,'14415143','51435135','\'\'',0,'2018-07-12 19:43:06'),(60,'shisan','e10adc3949ba59abbe56e057f20f883e','d9ab78a7c39f383e47b7c4ffbb407c87',0,'2018-07-12 19:45:32'),(61,'zhangsan','fcea920f7412b5da7be0cf42b8c93759','',0,'2018-07-12 20:20:22'),(150,'test-user1','3d0faa930d336ba748607ab7076ebce2','\'\'',0,'2018-08-04 17:37:32'),(151,'3123213213','6fdce2f14f4baf2d666fa13dfd8d1945','\'\'',0,'2018-08-15 20:43:42'),(152,'lou2','25f9e794323b453885f5181f1b624d0b','\'\'',0,'2019-01-05 19:55:30'),(153,'lou3','e10adc3949ba59abbe56e057f20f883e','\'\'',0,'2019-01-06 00:28:06'),(154,'lou1','e10adc3949ba59abbe56e057f20f883e','\'\'',0,'2019-01-10 11:05:52');
```

# 后端分页功能代码

- AdminUserDao.xml（注：完整代码位于`resources/mapper/AdminUserDao.xml`）

```
    <!-- 查询用户列表 -->
    <select id="findAdminUsers" parameterType="Map" resultMap="AdminUserResult">
        select id,user_name,create_time from tb_admin_user
        where is_deleted=0
        order by id desc
        <if test="start!=null and limit!=null">
            limit #{start},#{limit}
        </if>
    </select>

    <!-- 查询用户总数 -->
    <select id="getTotalAdminUser" parameterType="Map" resultType="int">
        select count(*) from tb_admin_user
        where is_deleted=0
    </select>
```

- 业务层代码（注：完整代码位于`com.lou.springboot.service.impl.AdminUserServiceImpl`）

```
    public PageResult getAdminUserPage(PageUtil pageUtil) {
        //当前页的用户列表
        List<AdminUser> users = adminUserDao.findAdminUsers(pageUtil);
        //用户总数
        int total = adminUserDao.getTotalAdminUser(pageUtil);
        //分页信息封装
        PageResult pageResult = new PageResult(users, total, pageUtil.getLimit(), pageUtil.getPage());
        return pageResult;
    }
```

- 控制层代码（注：完整代码位于`com.lou.springboot.controller.AdminUserControler`）

```
@RequestMapping(value = "/list", method = RequestMethod.GET)
    public Result list(@RequestParam Map<String, Object> params) {
        //检查参数
        if (StringUtils.isEmpty(params.get("page")) || StringUtils.isEmpty(params.get("limit"))) {
            return ResultGenerator.genErrorResult(Constants.RESULT_CODE_PARAM_ERROR, "参数异常！");
        }
        //查询列表数据
        PageUtil pageUtil = new PageUtil(params);
        return ResultGenerator.genSuccessResult(adminUserService.getAdminUserPage(pageUtil));
    }
```

通过后端代码可以看出，分页功能的交互流程是前端将所需页码和条数参数传输给后端，而后端在接受到分页请求后会对分页参数进行计算，并利用 MySQL 的 `limit` 关键字去查询对应的记录，同学们可以结合代码进行理解和学习，由于篇幅所限，这里仅贴出部分代码，详细版本可以直接下载整个工程代码。

# 分页功能测试

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn`

访问页面：`https://********.simplelab.cn/users/list?page=1&limit=10`

之后通过改变 page 参数和 limit 参数的值进行分页功能的测试，整个过程如下：

![此处输入图片的描述](http://labfile.oss.aliyuncs.com/courses/1244/search-test.gif)

首先我们以每页十条数据查询第一页的数据，之后可以看到分页数据结果返回，接着我们可以通过开发者工具看一下格式化的分页数据结果，currPage 表示当前页，数值为 1，data 中是一个数组对象，后端封装的第一页的 10 条数据都在这里。

之后我们又查询了第二页的数据，最后又设置了每页 30 条数据进行分页功能的测试，功能一切正常。

同学们可以结合该过程进行代码的学习和理解，并自行对比不同参数时返回结果的不同。

# JqGrid 分页插件介绍

JqGrid 是一个用来显示网格数据的 jQuery 插件，通过使用 jqGrid 可以轻松实现前端页面与后台数据的 Ajax 异步通信并实现分页功能，特点如下：

- 兼容目前所有流行的 web 浏览器；
- 完善强大的分页功能；
- 支持多种数据格式解析，XML、JSON、数组等形式；
- 提供丰富的选项配置及方法事件接口；
- 支持表格排序，支持拖动列、隐藏列；
- 支持滚动加载数据；
- 开源免费

[JqGrid in GitHub](https://github.com/tonytomov/jqGrid/tree/master)

[下载地址](https://github.com/tonytomov/jqGrid/releases)

本教程选择的版本为 5.3.0，将代码压缩包解压后可以看到 JqGrid 正式包的目录结构如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026852832.png/wm)

使用 JqGrid 时必要的文件如下：

```
## js文件
jquery.jqGrid.js
grid.locale-cn.js
jquery.jqGrid.js

## 样式文件
ui.jqgrid-bootstrap-ui.css
ui.jqgrid-bootstrap.css
ui.jqgrid.css
```

主要是 js 文件和 css 样式文件，如果想使用 JqGrid 其他特性的话对应的引入其 js 文件即可。

本课程的实战 所有模块的分页插件都是使用 JqGrid 插件实现的，它的分页功能十分强大，而且使用和学习起来都比较简单，JqGrid 还有其他优秀的特性，本系统只使用了其部分特性，感兴趣的朋友可以继续学习其相关知识。

# JqGrid 分页插件整合

注意：项目统一创建在 /home/project/lou-springboot 目录下。

# 资源导入

整合过程其实是我们把 JqGrid 代码压缩包中我们需要的样式文件、js 文件、图片等静态资源放入我们项目的静态资源目录下，比如 static 目录或者其他我们设置的静态资源目录，几个重要的文件我们都在下图中用红线进行标注了，目录如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550125182435.png/wm)

之后就可以在各个需要分页的页面中引用该插件资源并实现分页功能了。

# 整合过程

1. 首先在 html 文件中引入 JqGrid 所需文件：

```
<link href="plugins/jqgrid-5.3.0/ui.jqgrid-bootstrap4.css" rel="stylesheet"/>
<!-- JqGrid依赖jquery，因此需要先引入jquery.min.js文件 -->
<script src="plugins/jquery/jquery.min.js"></script>

<script src="plugins/jqgrid-5.3.0/grid.locale-cn.js"></script>
<script src="plugins/jqgrid-5.3.0/jquery.jqGrid.min.js"></script>
```

1. 在页面中需要展示分页数据的区域添加如下代码，用于 JqGrid 初始化：

```
<!-- JqGrid必要DOM,用于创建表格展示列表数据 -->  
<table id="jqGrid" class="table table-bordered"></table>
<!-- JqGrid必要DOM,分页信息区域 --> 
<div id="jqGridPager"></div>  
```

1. 调用 JqGrid 分页插件的 jqGrid() 方法渲染分页展示区域，代码如下：

```
$("#jqGrid").jqGrid({
        url: 'users/list',// 请求后台json数据的url
        datatype: "json",// 后台返回的数据格式
        colModel: [// 列表信息：表头 宽度 是否显示 渲染参数 等属性
            {label: 'id', name: 'id', index: 'id', width: 50, hidden: true, key: true},
            {label: '登录名', name: 'userName', index: 'userName', sortable: false, width: 80},
            {label: '添加时间', name: 'createTime', index: 'createTime', sortable: false, width: 80}
        ],
        height: 485,// 表格高度  可自行调节
        rowNum: 10,// 默认一页显示多少条数据 可自行调节
        rowList: [10, 30, 50],// 翻页控制条中 每页显示记录数可选集合
        styleUI: 'Bootstrap',// 主题 这里选用的是Bootstrap主题
        loadtext: '信息读取中...',// 数据加载时显示的提示信息
        rownumbers: true,// 是否显示行号，默认值是false，不显示
        rownumWidth: 35,// 行号列的宽度
        autowidth: true,// 宽度自适应
        multiselect: true,// 是否可以多选
        pager: "#jqGridPager",// 分页信息DOM
        jsonReader: {
            root: "data.list", //数据列表模型
            page: "data.currPage", //数据页码
            total: "data.totalPage", //数据总页码
            records: "data.totalCount" //数据总记录数
        },
        // 向后台请求的参数
        prmNames: {
            page: "page",
            rows: "limit",
            order: "order"
        },
        // 数据加载完成并且DOM创建完毕之后的回调函数 
        gridComplete: function () {
            //隐藏grid底部滚动条
            $("#jqGrid").closest(".ui-jqgrid-bdiv").css({"overflow-x": "hidden"});
        }
    });
```

# 分页数据格式详解

在 JqGrid 整合中有如下代码：

```
jsonReader: {
  root: "data.list", //数据列表模型
  page: "data.currPage", //当前页码
  total: "data.totalPage", //数据总页码
  records: "data.totalCount" //数据总记录数
  }
```

这里定义的是 jsonReader 对象如何对后端返回的 json 数据进行解析，比如数据列表为何读取 "data.list"，当前页码为何读取 "data.currPage"，这些都是由后端返回的数据格式所决定的，后端响应结果的数据格式定义在`com.lou.springboot.common.Result` 类中：

```
public class Result<T> implements Serializable {
    //响应码 200为成功
    private int resultCode;
    //响应msg
    private String message;
    //返回数据
    private T data;
}
```

即所有的数据都会被设置到 data 属性中，分页结果集的数据格式定义如下（注：完整代码位于`com.lou.springboot.util.PageResult`）：

```
public class PageResult implements Serializable {
    //总记录数
    private int totalCount;
    //每页记录数
    private int pageSize;
    //总页数
    private int totalPage;
    //当前页数
    private int currPage;
    //列表数据
    private List<?> list;
}
```

由于 JqGrid 分页插件在实现分页功能时必须以下四个参数：当前页的所有数据列表、当前页的页码、总页码、总记录数量，因此我们封装了 PageResult 对象，并将其放入 Result 返回结果的 data 属性中，之后在 JqGrid 读取时直接读取对应的参数即可，这就是前后端进行数据交互时的格式定义，希望大家能够结合代码以及实际的分页效果进行理解和学习。

# 分页功能实践

由于分页接口在前一个实验中已经开发完成，本实验中只需要将前端页面实现即可。

# 前端页面

在 `resources/static` 下新建 user.html，代码如下：

```
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>lou.springboot | 用户管理页</title>
    <link href="plugins/jqgrid-5.3.0/ui.jqgrid-bootstrap4.css" rel="stylesheet"/>
    <link rel="stylesheet" href="plugins/bootstrap/css/bootstrap.css">
    <link rel="stylesheet" href="plugins/sweetalert/sweetalert.css">
    <link href="plugins/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="dist/css/main.css" rel="stylesheet"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="plugins/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="dist/css/adminlte.min.css">
    <link rel="stylesheet" href="plugins/sweetalert/sweetalert.css">
</head>
<body class="hold-transition sidebar-mini" onLoad="checkCookie();">
<div class="wrapper">
    <nav class="main-header navbar navbar-expand bg-white navbar-light border-bottom">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" data-widget="pushmenu" href="#"><i class="fa fa-bars"></i></a>
            </li>
            <li class="nav-item d-none d-sm-inline-block">
                <a href="index.html" class="nav-link">Home</a>
            </li>
        </ul>
        <ul class="navbar-nav ml-auto">
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="https://github.com/ZHENFENG13">
                    <i class="fa fa-home">&nbsp;&nbsp;文档</i>
                </a>
                <div class="dropdown-menu dropdown-donate-lg dropdown-menu-right">
                    <a href="##" class="dropdown-item">实验楼训练营</a>
                </div>
            </li>
            <li class="nav-item dropdown">
                <a class="nav-link" data-toggle="dropdown" href="#">
                    <i class="fa fa-user">&nbsp;&nbsp;作者</i>
                </a>
                <div class="dropdown-menu dropdown-menu-lg dropdown-menu-right">
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item">
                        <i class="fa fa-user-o mr-2"></i> 姓名
                        <span class="float-right text-muted text-sm">十三 / 13</span>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item">
                        <i class="fa fa-user-secret mr-2"></i> 身份
                        <span class="float-right text-muted text-sm">Java开发工程师</span>
                    </a>
                    <div class="dropdown-divider"></div>
                    <a href="#" class="dropdown-item">
                        <i class="fa fa-address-card mr-2"></i> 邮箱
                        <span class="float-right text-muted text-sm">2449207463@qq.com</span>
                    </a>
                </div>
            </li>
        </ul>
    </nav>
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="index.html" class="brand-link">
            <img src="dist/img/logo.jpg" alt="ssm-cluster Logo" class="brand-image img-circle elevation-3"
                 style="opacity: .8">
            <span class="brand-text font-weight-light">lou.springboot</span>
        </a>
        <div class="sidebar">
            <!-- Sidebar user panel (optional) -->
            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="image">
                    <img src="dist/img/logo3.jpg" class="img-circle elevation-2" alt="User Image">
                </div>
                <div class="info">
                    <a href="#" class="d-block">十三</a>
                </div>
            </div>
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu"
                    data-accordion="false">
                    <!-- Add icons to the links using the .nav-icon class
                         with font-awesome or any other icon font library -->
                    <li class="nav-header">Dashboard</li>
                    <li class="nav-item has-treeview">
                        <a href="#" class="nav-link">
                            <i class="nav-icon fa fa-dashboard"></i>
                            <p>
                                Dashboard
                                <i class="right fa fa-angle-left"></i>
                            </p>
                        </a>
                        <ul class="nav nav-treeview">
                            <li class="nav-item">
                                <a href="./index.html" class="nav-link active">
                                    <i class="fa fa-circle-o nav-icon"></i>
                                    <p>lou.springboot主页</p>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="./index2.html" class="nav-link">
                                    <i class="fa fa-circle-o nav-icon"></i>
                                    <p>adminLTE v3</p>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="nav-header">管理模块</li>
                    <li class="nav-item">
                        <a href="user.html" class="nav-link active">
                            <i class="fa fa-user-circle nav-icon"></i>
                            <p>用户管理</p>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0 text-dark">用户管理页</h1>
                    </div><!-- /.col -->
                    <div class="col-sm-6">
                        <ol class="breadcrumb float-sm-right">
                            <li class="breadcrumb-item"><a href="index.html">主页</a></li>
                            <li class="breadcrumb-item active">用户管理页</li>
                        </ol>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                                <!-- 分页展示区，需要增加 jqgrid 相关 DOM -->
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- /.content-wrapper -->
    <footer class="main-footer">
        <strong>Copyright &copy; 2019 <a href="##">13blog.site</a>.</strong>
        All rights reserved.
        <div class="float-right d-none d-sm-inline-block">
            <b>Version</b> 2.0
        </div>
    </footer>
    <aside class="control-sidebar control-sidebar-dark">
    </aside>
</div>
<script src="plugins/jquery/jquery.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- sweet alert -->
<script src="plugins/sweetalert/sweetalert.min.js"></script>
<!-- Bootstrap 4 -->
<script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="plugins/jqgrid-5.3.0/grid.locale-cn.js"></script>
<script src="plugins/jqgrid-5.3.0/jquery.jqGrid.min.js"></script>
<script src="dist/js/public.js"></script>
<script src="dist/js/user.js"></script>
<script src="dist/js/adminlte.js"></script>
</body>
</html>
```

我们使用了 AdminLTE3 的样式和页面布局，之后在页面中引入 JqGrid 的相关静态资源文件，最后在页面中展示分页数据的区域增加如下代码：

```
<!-- 数据展示列表，id 为 jqGrid -->
<table id="jqGrid" class="table table-bordered">
</table>
<!-- 分页按钮展示区 -->
<div id="jqGridPager"></div>
```

# JqGrid 初始化

在`resources/static/dist/js`下新建 user.js，代码如下：

```
$(function () {
    $("#jqGrid").jqGrid({
        url: 'users/list',
        datatype: "json",
        colModel: [
            {label: 'id', name: 'id', index: 'id', width: 50, hidden: true, key: true},
            {label: '登录名', name: 'userName', index: 'userName', sortable: false, width: 80},
            {label: '添加时间', name: 'createTime', index: 'createTime', sortable: false, width: 80}
        ],
        height: 485,
        rowNum: 10,
        rowList: [10, 30, 50],
        styleUI: 'Bootstrap',
        loadtext: '信息读取中...',
        rownumbers: true,
        rownumWidth: 35,
        autowidth: true,
        multiselect: true,
        pager: "#jqGridPager",
        jsonReader: {
            root: "data.list",
            page: "data.currPage",
            total: "data.totalPage",
            records: "data.totalCount"
        },
        prmNames: {
            page: "page",
            rows: "limit",
            order: "order"
        },
        gridComplete: function () {
            //隐藏grid底部滚动条
            $("#jqGrid").closest(".ui-jqgrid-bdiv").css({"overflow-x": "hidden"});
        }
    });
});
```

该代码的含义为：在页面加载时，调用 JqGrid 的初始化方法，将页面中 id 为 jqGrid 的 DOM 渲染为分页表格，并向后端发送请求，之后按照后端返回的 json 数据填充表格以及表格下方的分页按钮，第一页、下一页、最后一页等等逻辑都有 JqGrid 内部实现了，我们只需要将它初始化时所需要的几个数据设置好即可，因此我们需要将返回格式设置为 PageResult 类所封装的数据类型。

由于 user.html 文件中引入了 user.js 文件，所以在页面加载完成后会进行数据列表的渲染及分页插件的渲染，用户可以直接使用翻页功能了，本来这些功能需要我们自行实现，但是使用 JqGrid 后这些都不需要我们再去做逻辑实现，只需要调用其分页方法并将所需的参数设置好即可，十分方便。

# 分页功能测试

启动项目成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn`

访问页面：`https://********.simplelab.cn/user.html`，可以看到分页数据已经正常显示。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid441493labid8432timestamp1550026799711.png/wm)

页面加载后，分页区域也被渲染出了数据，点击下方的翻页按钮，一切功能都正常，同学们可以自行测试。

# 分页功能分析

之后我们对分页功能的实现进行简单的分析，过程如下图所示：

![此处输入图片的描述](http://labfile.oss.aliyuncs.com/courses/1244/user-page-network.gif)

打开浏览器的开发者控制台，并进入 Network 面板，具体来看一下在翻页时执行了哪些请求。

通过该过程我们发现，在每次点击分页按钮时都会向后端的 users/list 请求，参数有：`_search`、 `nd`、 `limit`、`page`、`sidx`，这些参数都是 JqGrid 内部封装的，我们后端在接受请求时只处理了 `limit` 和 `page` 参数，其他参数你也可以自行增加处理逻辑，这里不再继续讲解。

而且翻页逻辑以及参数的封装 JqGrid 内部都已经完善了，比如第一次我们是以每页 10 条数据向后端进行请求，此时共有 7 页，当我们改为每页 50 条数据时，分页插件中只有两页了，这个逻辑也由 JqGrid 插件实现了，因此我们在整合该插件后，只需要处理后端逻辑即可，前端相关的分页逻辑都由它来完成了，大大减少了我们的工作量。

本次实验完成！

# 实验总结

实践代码已经上传，大家按照文中的步骤和我提供的源码进行练习和理解，如果有任何问题希望可以及时反馈，祝大家实验顺利！