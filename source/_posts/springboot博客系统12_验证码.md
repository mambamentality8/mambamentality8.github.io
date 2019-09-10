# 实验介绍

#### 实验内容

我们将在这一节学习在网站中使用验证码的相关知识，以及如何使用 Spring Boot 生成验证码，并进行后续的验证操作，生成验证码的方式以及案例有很多，本教程中所选择的方案是 Google 的 kaptcha 框架。

#### 实验知识点

- 认识验证码
- Spring Boot 整合 kaptcha 步骤
- 生成验证码操作
- 对验证码进行提交验证

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

# 验证码

#### 验证码介绍

谈起验证码这个话题，相信大家都应该很熟悉，在日常上网的时候经常会看到验证码的逻辑设计，比如登陆账号、论坛发帖、购买商品时网站都会要求用户在实际操作之前去输入验证码，验证码的生成规则或者展现形式也各不相同，但是这个设计确实已经存在于各大网站中，以下是百度百科中对它的定义：

> 验证码（CAPTCHA）是“Completely Automated Public Turing test to tell Computers and Humans Apart”（全自动区分计算机和人类的图灵测试）的缩写，是一种区分用户是计算机还是人的公共全自动程序。可以防止：恶意破解密码、刷票、论坛灌水，有效防止某个黑客对某一个特定注册用户用特定程序暴力破解方式进行不断的登陆尝试，实际上用验证码是现在很多网站通行的方式，我们利用比较简易的方式实现了这个功能。这个问题可以由计算机生成并评判，但是必须只有人类才能解答。由于计算机无法解答 CAPTCHA 的问题，所以回答出问题的用户就可以被认为是人类。

# 验证码的作用

由于在后面的实战项目开发中会用到验证码这个功能，因此选择在这篇教程中进行介绍和功能演示。其实验证码设计的主要目的以及它最大的作用也就是**防止不法分子在短时间内用机器批量的重复操作**。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371160445/wm)

我们接下来开发的博客网站会在后台登陆以及用户评论功能模块中使用验证码，这样可以有效防止恶意用户对网站进行破坏，实际上是用验证码是现在很多网站通行的方式，虽然会使得某些操作变得麻烦一点，但是对大部分的功能场景来说这个功能还是很有必要，也很重要，所以不要觉得它麻烦，如果增加这样一个功能可以使得网站更加安全，那就是十分值得的。

# Spring Boot 整合 kaptcha

简单的介绍完验证码之后，接下来，我们还是通过一个案例来讲解如何使用 Spring Boot 来生成验证码，之后我们再对验证码的显示以及后端验证进行案例讲解。

以下为操作步骤：

# 添加依赖

Spring Boot 整合 kaptcha 的第一步就是增加依赖，首先我们需要将其依赖配置增加到 pom.xml 文件中，此时的 pom.xml 文件内容如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/>
    </parent>
    <groupId>com.lou.springboot</groupId>
    <artifactId>spring-boot-captcha</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>spring-boot-captcha</name>
    <description>Demo project for Spring Boot</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <!-- 验证码 -->
        <dependency>
            <groupId>com.github.penggle</groupId>
            <artifactId>kaptcha</artifactId>
            <version>2.3.2</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

如果是在本地开发的话，只需要等待 jar 包及相关依赖下载完成即可。

# 配置

注册 DefaultKaptcha 到 IOC 容器中，新建 config 包，之后新建 KaptchaConfig 类，内容如下：

```
package com.lou.springboot.config;

import com.google.code.kaptcha.impl.DefaultKaptcha;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;
import com.google.code.kaptcha.util.Config;
import java.util.Properties;

@Component
public class KaptchaConfig {
    @Bean
    public DefaultKaptcha getDefaultKaptcha(){
        com.google.code.kaptcha.impl.DefaultKaptcha defaultKaptcha = new com.google.code.kaptcha.impl.DefaultKaptcha();
        Properties properties = new Properties();
        // 图片边框
        properties.put("kaptcha.border", "no");
        // 字体颜色
        properties.put("kaptcha.textproducer.font.color", "black");
        // 图片宽
        properties.put("kaptcha.image.width", "160");
        // 图片高
        properties.put("kaptcha.image.height", "40");
        // 字体大小
        properties.put("kaptcha.textproducer.font.size", "30");
        // 验证码长度
        properties.put("kaptcha.textproducer.char.space", "5");
        // 字体
        properties.setProperty("kaptcha.textproducer.font.names", "宋体,楷体,微软雅黑");
        Config config = new Config(properties);
        defaultKaptcha.setConfig(config);
        return defaultKaptcha;
    }
}
```

这里就是对生成的图片验证码的规则配置，如颜色、宽高、长度、字体等等，可以根据需求自行修改这些规则，之后就可以生成自己想要的验证码了。

# 验证码的生成与显示

#### 后端处理

在 controller 包中新建 KaptchaController，之后注入刚刚配置好的 DefaultKaptcha 类，然后就可以新建一个方法，在方法里可以生成验证码对象，并以图片流的方式写到前端以供显示，代码如下：

```
package com.lou.springboot.controller;
import com.google.code.kaptcha.impl.DefaultKaptcha;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;

/**
 * @author 13
 * @qq交流群 796794009
 * @email 2449207463@qq.com
 * @link http://13blog.site
 */
@Controller
public class KaptchaController {

    @Autowired
    private DefaultKaptcha captchaProducer;

    @GetMapping("/kaptcha")
    public void defaultKaptcha(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        byte[] captchaOutputStream;
        ByteArrayOutputStream imgOutputStream = new ByteArrayOutputStream();
        try {
            //生产验证码字符串并保存到session中
            String verifyCode = captchaProducer.createText();
            httpServletRequest.getSession().setAttribute("verifyCode", verifyCode);
            BufferedImage challenge = captchaProducer.createImage(verifyCode);
            ImageIO.write(challenge, "jpg", imgOutputStream);
        } catch (IllegalArgumentException e) {
            httpServletResponse.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        captchaOutputStream = imgOutputStream.toByteArray();
        httpServletResponse.setHeader("Cache-Control", "no-store");
        httpServletResponse.setHeader("Pragma", "no-cache");
        httpServletResponse.setDateHeader("Expires", 0);
        httpServletResponse.setContentType("image/jpeg");
        ServletOutputStream responseOutputStream = httpServletResponse.getOutputStream();
        responseOutputStream.write(captchaOutputStream);
        responseOutputStream.flush();
        responseOutputStream.close();
    }
}
```

我们在控制器中新增了 defaultKaptcha 方法，该方法所拦截处理的路径为 /kaptcha，在前端访问该路径后就可以接收到一个图片流并显示在浏览器页面上。

#### 前端处理

新建 kaptcha.html，在该页面中显示验证码，代码如下：

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>验证码显示</title>
</head>
<body>
<img src="/kaptcha"
     onclick="this.src='/kaptcha?d='+new Date()*1">
</body>
</html>
```

访问后端验证码路径 /kaptcha，并将其返回显示在 img 标签中，之后定义了 `onclick` 方法，在点击该 img 标签时可以动态的切换显示一个新的验证码，点击时访问的路径为 `/kaptcha?d=1565950414611`，即原来的验证码路径后面带上一个时间戳参数，时间戳是会变化的，所以每次点击都会是一个与之前不同的请求，如果不这样处理的话，由于浏览器的机制可能并不会重新发送请求。

# 功能验证

#### 下载并解压代码

本节课程的代码已经上传，直接下载至实验环境中即可，下载之后执行如下命令进行解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/spring-boot-captcha.zip
unzip spring-boot-captcha.zip
```

接下来就能够看到本次代码的代码结构及相关文件。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371291187/wm)

# 线上环境中启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到 spring-boot-captcha 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动。

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371308976/wm)

之后会在浏览器中弹出 `https://********.simplelab.cn` 页面，我们可以在浏览器中输入如下地址 /kaptcha.html 进行验证，结果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371326607/wm)

页面中可以正确的显示我们已经设置了宽高和字符长度的验证码，并且每次点击后也可以动态的切换，该功能实现完成。

# 验证码的输入验证

验证码的显示完成后，我们接下来要做的就是对用户输入的验证码进行比对和验证，因为一般的做法就是后端生成后会对当前生成的验证码进行保存（可能是 session 中、或者缓存中、或者数据库中），之后显示到前端页面，用户在看到验证码之后在页面对应的输入框中填写验证码，之后才向后端发送请求，而后端再接到请求后会对用户输入的验证码进行验证，如果不对的话则不会进行后续操作，接下来我们来简单的实现一下这个流程。

#### 后端处理

在 KaptchaController 类中新增 `verify` 方法，代码如下：

```
    @GetMapping("/verify")
    @ResponseBody
    public String verify(@RequestParam("code") String code, HttpSession session) {
        if (StringUtils.isEmpty(code)) {
            return "验证码不能为空";
        }
        String kaptchaCode = session.getAttribute("verifyCode") + "";
        if (StringUtils.isEmpty(kaptchaCode) || !code.equals(kaptchaCode)) {
            return "验证码错误";
        }
        return "验证成功";
    }
```

该方法所拦截处理的路径为 /kaptcha，请求参数为 code，即用户输入的验证码，在进行基本的非空验证后，与之前保存在 session 中的 verifyCode 值进行比较，不同则返回验证码错误，相同则返回验证成功。

#### 前端处理

新建 verify.html，该页面中显示验证码，同时有可以供用户输入验证码的输入框以及提交按钮，代码如下：

```
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>验证码测试</title>
</head>
<body>
<img src="/kaptcha"
     onclick="this.src='/kaptcha?d='+new Date()*1">
<input type="text" maxlength="5" id="code" placeholder="请输入验证码">
<button id="verify">验证</button>
</body>
<script src="jquery.js"></script>
<script type="text/javascript">
    $(function () {
        $("#verify").click(function () {
            var code = $("#code").val();
            $.ajax({
                type: 'GET',//方法类型
                url: '/verify?code=' + code,
                success: function (result) {
                    alert(result);
                },
                error: function () {
                    alert("请求失败");
                }
            });
        })
    });
</script>
</html>
```

用户在输入框中输入验证码后可以点击“验证”按钮，点击事件触发后执行 js 方法，该方法会获取到用户输入的验证码的值，并将其作为请求参数，之后进行 Ajax 请求，请求后会在弹框中显示后端返回的处理结果。

# 启动 Spring Boot 项目

编码完成后切换到 spring-boot-captcha 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run`，等待项目启动。

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371348918/wm)

之后会在浏览器中弹出 `https://********.simplelab.cn` 页面，输入地址 `https://********.simplelab.cn/verify.html` 进行验证，结果如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564371373829/wm)

如上图所示，我们可以在输入框中输入验证码并进行相应的验证，验证结果与预期一致，本次实验完成。

# 总结

网站中验证码的功能逻辑也基本如此，主要包括：

- 验证码的生成
- 验证码的显示
- 验证码的比对

本实验中已经将所有功能一一的实现，后续将会结合实际的项目开发对该功能逻辑进行完善，希望大家可以根据文中的步骤以及提供的源码进行实验，有任何问题可以直接与我交流。