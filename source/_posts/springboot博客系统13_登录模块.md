# 实验介绍

#### 实验内容

**从本篇开始将不再进行基础知识的讲解，而是真实的开始去开发一个实践项目了，实践课程的第一篇我们选择讲解两个知识点，一是 AdminLTE3 web app 模板整合，二是登录功能的实现，包括页面和后台 api 的开发。**

在课程介绍时我给出了几张最终项目的预览图，网站的风格比较美观，因为我们最终的实践项目的前端页面就是基于 AdminLTE3 模板进行开发的，本文会简单的介绍这个网页模板并实际的整合进我们的项目中进行登录页面的开发。之后是登录功能的实现，这里说的是互联网范畴的登录，通常供多人使用的网站或程序应用系统为每位用户配置了一套独特的用户名和密码，用户可以使用各自的用户名和密码使用系统，以便系统能识别该用户的身份，从而保持该用户的使用习惯或使用数据，这个功能相信大家都不陌生，我们就把它作为实践课程的第一步吧。

#### 实验知识点

- 登录功能简介
- AdminLTE3 模板整合
- 登录功能实现

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

# 登录功能

#### 用户登录状态

以我们将要开发的后台管理系统来说，这个管理系统是拥有多个页面的，在页面跳转过程中和通过接口进行数据交互时我们需要知道用户的状态，尤其是用户登录的状态，以便我们知道这是否是一个正常的用户，这个用户是否处于合法的登录状态，这样才能在页面跳转和接口请求时知道是否可以让当前用户来操作一些功能或是获取一些数据。

因此需要在每个页面对用户的身份进行验证和确认，但现实情况是，不可能让用户在每个页面上都输入用户名和密码，这是一个多么反人类的设计啊，应该不会有用户想要去使用这种系统，所以在设计时，要求用户进行一次登录操作即可。为了实现这一功能就需要一些辅助技术，用得最多的技术就是浏览器的 Cookie，而在 Java Web 开发中，用的比较多的是 Session，将用户登录的信息存放其中，这样就可以通过读取 Cookie 或者 Session 中的数据获得用户的登录信息，从而达到记录状态，验证用户这一目的。

#### 登录流程设计

通过前文的叙述也可以得出登录的本质，即身份验证和登录状态的保持，在实际编码中是如何实现的呢？

首先，在数据库中查询这条用户记录，伪代码如下：

```
select * from xxx_user where account_number = 'xxxx';
```

如果不存在这条记录则表示身份验证失败，登录流程终止；如果存在这条记录，则表示身份验证成功，接下来则需要进行登录状态的存储和验证了，存储伪代码如下：

```
//通过 Cookie 存储
Cookie cookie = new Cookie("userName",xxxxx);

//通过 Session 存储
session.setAttribute("userName",xxxxx);
```

验证逻辑的伪代码如下：

```
//通过 Cookie 获取需要验证的数据并进行比对校验
Cookie cookies[] = request.getCookies();
if (cookies != null){
    for (int i = 0; i < cookies.length; i++)
           {
               Cookie cookie = cookies[i];
               if (name.equals(cookie.getName()))
               {
                    return cookie;
               }
           }
}

//通过session获取需要验证的数据并进行比对校验
session.getAttribute("userName");
```

本次实践项目的登录状态我们是通过 session 来保存的，用户登录成功后我们将用户信息放到 session 对象中，之后再实现一个拦截器，在访问项目时判断 session 中是否有用户信息，有则放行请求，没有就跳转到登录页面。

# AdminLTE3 模板整合

整合过程其实是我们把 AdminLTE3 代码压缩包中我们需要的样式文件、js 文件、图片等静态资源放入我们 Spring Boot 项目的静态资源目录下，比如 static 目录或者其他我们设置的静态资源目录，几个重要的文件我们都在下图中用红线进行标注了，目录如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378238928/wm)

有些人可能对“整合”不是很理解，甚至以为是一个很复杂的过程，这里我解释一下，我们开发的是一个 web 项目，项目中包括前端工程和后端工程，后端工程我们是比较熟悉的，而前端工程就包括页面文件、样式文件、js 文件等等，由于后端的小伙伴可能不是特别熟悉前端开发，因此我们就选择了 AdminLTE 网站模板这样一个半成品网站来进行改造和开发，大部分页面和样式都已经由模板作者开发好了，我们只需要针对性的修改一些页面供项目使用即可，这个过程中肯定就少不了要把它的样式文件、js 文件等放到我们项目的静态资源目录中，因此，这里所说的“整合”仅仅是把一些必要的文件复制到我们的项目目录中，希望大家不要把这个过程想复杂了。

# 登录功能实践

#### 登录页面实现

由于选用了 AdminLTE3 作为模板，就直接改造其登录页面即可，在 templates/admin 目录中新建 login.html 模板页面，模板引擎我们选择的是 Thymeleaf，代码如下：

```
<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>personal blog | Log in</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="shortcut icon" th:href="@{/admin/dist/img/favicon.png}"/>
    <!-- Font Awesome -->
    <link rel="stylesheet" th:href="@{/admin/dist/css/font-awesome.min.css}">
    <!-- Ionicons -->
    <link rel="stylesheet" th:href="@{/admin/dist/css/ionicons.min.css}">
    <!-- Theme style -->
    <link rel="stylesheet" th:href="@{/admin/dist/css/adminlte.min.css}">
    <style>
        canvas {
            display: block;
            vertical-align: bottom;
        }
        #particles {
            background-color: #F7FAFC;
            position: absolute;
            top: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
        }
    </style>
</head>
<body class="hold-transition login-page">
<div id="particles">
</div>
<div class="login-box">
    <div class="login-logo" style="color: #007bff;">
        <h1>personal blog</h1>
    </div>
    <!-- /.login-logo -->
    <div class="card">
        <div class="card-body login-card-body">
            <p class="login-box-msg">your personal blog , enjoy it</p>
            <form th:action="@{/admin/login}" method="post">
                <div th:if="${not #strings.isEmpty(session.errorMsg)}" class="form-group">
                    <div class="alert alert-danger" th:text="${session.errorMsg}"></div>
                </div>
                <div class="form-group has-feedback">
                    <span class="fa fa-user form-control-feedback"></span>
                    <input type="text" id="userName" name="userName" class="form-control" placeholder="请输入账号"
                           required="true">
                </div>
                <div class="form-group has-feedback">
                    <span class="fa fa-lock form-control-feedback"></span>
                    <input type="password" id="password" name="password" class="form-control" placeholder="请输入密码"
                           required="true">
                </div>
                <div class="row">
                    <div class="col-6">
                        <input type="text" class="form-control" name="verifyCode" placeholder="请输入验证码" required="true">
                    </div>
                    <div class="col-6">
                        <img alt="单击图片刷新！" class="pointer" th:src="@{/common/kaptcha}"
                             onclick="this.src='/common/kaptcha?d='+new Date()*1">
                    </div>
                </div>
                <div class="form-group has-feedback"></div>
                <div class="row">
                    <div class="col-8">
                    </div>
                    <div class="col-4">
                        <button type="submit" class="btn btn-primary btn-block btn-flat">登录
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
<script th:src="@{/admin/plugins/jquery/jquery.min.js}"></script>
<!-- Bootstrap 4 -->
<script th:src="@{/admin/plugins/bootstrap/js/bootstrap.bundle.min.js}"></script>
<script th:src="@{/admin/dist/js/plugins/particles.js}"></script>
<script th:src="@{/admin/dist/js/plugins/login-bg-particles.js}"></script>
</body>
</html>
```

该页面时直接修改的 AdminLTE3 模板的登录页，将文案修改为中文，并微调了一下页面布局，同时增加了验证码的设计，最终的页面效果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378262112/wm)

用户在输入账号、密码和验证码后，点击登录按钮后将会向后端发送登录请求，请求地址为 admin/login，请求类型为 post，在 form 表单中已经定义了登陆的请求路径：

```
<form th:action="@{/admin/login}" method="post">
```

# 表结构设计

**在前面的课程中我们也一直在使用一张 user 表来进行功能演示，不过那只是一张测试表用来讲解功能的，**博客系统正式的用户模块表结构设计如下，包括数据库名称也做了更改，之后的项目开发中我们会一直使用 my_blog_db 数据库：

```
CREATE DATABASE /*!32312 IF NOT EXISTS*/`my_blog_db` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `my_blog_db`;
/*Table structure for table `tb_admin_user` */
DROP TABLE IF EXISTS `tb_admin_user`;
CREATE TABLE `tb_admin_user` (
  `admin_user_id` int(11) NOT NULL AUTO_INCREMENT COMMENT '管理员id',
  `login_user_name` varchar(50) NOT NULL COMMENT '管理员登陆名称',
  `login_password` varchar(50) NOT NULL COMMENT '管理员登陆密码',
  `nick_name` varchar(50) NOT NULL COMMENT '管理员显示昵称',
  `locked` tinyint(4) DEFAULT '0' COMMENT '是否锁定 0未锁定 1已锁定无法登陆',
  PRIMARY KEY (`admin_user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*Data for the table `tb_admin_user` */
insert  into `tb_admin_user`(`admin_user_id`,`login_user_name`,`login_password`,`nick_name`,`locked`) values (1,'admin','e10adc3949ba59abbe56e057f20f883e','十三',0);
```

新增了一张表，并在表中新增了一条用户数据，之后我们在演示登陆功能时会用到。

# 后端功能实现

#### AdminMapper.xml(**注：完整代码位于 src/main/resources/mapper/AdminMapper.xml**)

通过用户名和密码查询用户记录：

```
  <select id="login" resultMap="BaseResultMap">
    select
    <include refid="Base_Column_List" />
    from tb_admin_user
    where login_name = #{userName,jdbcType=VARCHAR} AND login_password=#{password,jdbcType=VARCHAR} AND locked = 0
  </select>
```

#### 业务层代码

代码如下：(**注：完整代码位于 com.site.blog.my.core.service.impl 包下的 AdminUserServiceImpl.java**)

```
    public Admin login(String userName, String password) {
        String passwordMd5 = MD5Util.MD5Encode(password, "UTF-8");
        return adminMapper.login(userName, passwordMd5);
    }
```

#### 控制层代码

首先对参数进行校验，参数中包括登陆信息和验证码，验证码的比对大家应该都了解，拿参数与存储在 session 中的验证码值进行比较，之后调用 adminUserService 业务层代码查询用户对象，之后根据验证结果来跳转页面，如果登陆成功则跳转到管理系统的首页，失败的话则带上错误信息返回到登录页，登录页中会显示出登陆的错误信息。(**注：完整代码位于 com.site.blog.my.core.controller.admin 包下的 AdminController.java**)

```
    @PostMapping(value = "/login")
    public String login(@RequestParam("userName") String userName,
                        @RequestParam("password") String password,
                        @RequestParam("verifyCode") String verifyCode,
                        HttpSession session) {
        if (StringUtils.isEmpty(verifyCode)) {
            session.setAttribute("errorMsg", "验证码不能为空");
            return "admin/login";
        }
        if (StringUtils.isEmpty(userName) || StringUtils.isEmpty(password)) {
            session.setAttribute("errorMsg", "用户名或密码不能为空");
            return "admin/login";
        }
        String kaptchaCode = session.getAttribute("verifyCode") + "";
        if (StringUtils.isEmpty(kaptchaCode) || !verifyCode.equals(kaptchaCode)) {
            session.setAttribute("errorMsg", "验证码错误");
            return "admin/login";
        }
        Admin adminUser = adminService.login(userName, password);
        if (adminUser != null) {
            session.setAttribute("loginUser", adminUser.getAdminNickName());
            session.setAttribute("loginUserId", adminUser.getAdminId());
            //session过期时间设置为7200秒 即两小时
            session.setMaxInactiveInterval(60 * 60 * 2);
            return "redirect:/admin/index";
        } else {
            session.setAttribute("errorMsg", "登陆失败");
            return "admin/login";
        }
    }
```

# 登陆功能演示

#### 启动 MySQL 并新增 tb_admin_user 表

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

之后执行如下命令登陆 MySQL 数据库：

```
sudo mysql -u root 
```

因为实验楼线上实验环境中 MySQL 数据库默认并没有设置密码，因此以上命令即可完成登陆，最后在命令行中执行前文给出的建表语句 SQL 即可。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378294793/wm)

# 线上环境中启动 Spring Boot 项目

我们提供的整个项目的完整代码，请大家参照源码对比学习了解各个功能模块的代码内容。

```
wget https://labfile.oss.aliyuncs.com/courses/1367/My-Blog.zip
unzip My-Blog.zip
```

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到已解压的 My-Blog 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 mvn spring-boot:run ，之后就可以等待项目启动。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378353054/wm)

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果，之后会在浏览器中弹出 `https://********.simplelab.cn` 访问页面：`https://********.simplelab.com/admin/login` 即可进入到登录页面，之后就可以对相关功能进行测试了，演示过程如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564378379155/wm)

输入账号密码以及正确的验证码，之后点击登陆按钮就可以完成登陆流程，本次实验完成！

# 实验总结

除了按照以上步骤进行实验外，有几点也需要格外注意：

1. 下载代码并解压，检查代码是否正确
2. 启动 MySQL 数据库并检查是否包含 tb_admin_user 表
3. 端口号和数据库连接信息是否正确

希望大家在本地和实验楼线上环境都能够顺利进行测试和实践，后续试验中我们会对整个登陆流程和用户身份验证来完善。