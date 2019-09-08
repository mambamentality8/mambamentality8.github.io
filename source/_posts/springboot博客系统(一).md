# 实验介绍

#### 实验内容

我们将在这一节学习如何快速构建一个 Spring Boot 项目，之后会对 Spring Boot 项目的目录结构进行简单的介绍，最后是启动 Spring Boot 项目的方法介绍。

#### 实验知识点

- 如何快速构建一个 Spring Boot 项目
- Spring Boot 项目目录结构介绍
- Spring Boot 项目启动

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+



# Spring Boot 项目构建

#### 使用 Spring Initializr 构建

> 这种方式需要访问外部网络，实验楼在线环境中无法演示，大家可以自行在本地环境进行尝试。

Spring 官方提供了 Spring Initializr 来进行 Spring Boot 的快速构建，这是一个在线生成 Spring Boot 基础项目的工具，我们可以将其理解为 Spring Boot 的“创建向导”，接下来我们使用这个在线向导来快速的创建一个 Spring Boot 骨架工程。

- 首先，打开在浏览器中输入 Spring Initializr 的网站地址：[https://start.spring.io](https://start.spring.io/)
- 之后可以看到页面上需要我们填写和选择项目的基础信息，依次填写即可
- 最后点击“Generate Project”按钮即可获取到一个 Spring Boot 基础项目的代码压缩包

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10294timestamp1552979043544.png/wm)

如图所示，Spring Boot 版本我们选择的是最新稳定版本 2.1.0 ，当然也可以选择其他稳定版本，视项目要求而定，“ dependencies ” 表示添加到项目所依赖的 Spring Boot 组件，根据项目`要求来选择，需要哪些场景就直接选择相应模块即可，与 SpringBoot Initializr 构建方式类似，也可以多选，本次演示选择了 Web 模块。

#### mvn 命令行创建 Spring Boot 项目

打开命令行并将目录切换到对应的文件夹中，之后运行以下命令：

```
mvn archetype:generate -DinteractiveMode=false -DgroupId=com.lou.springboot -DartifactId=springboot-demo -Dversion=0.0.1-SNAPSHOT
```

在构建成功后可以生成骨架项目，但是由于生成的项目仅仅是骨架项目，因此 pom.xml 文件中需要自己添加依赖，主方法启动类也需要自行添加，并不是很方便，因此不是特别推荐。

#### 直接打开

最后一种方式是直接导入 Spring Boot 项目，如果已经存在 Spring Boot 项目则直接打开，与引入普通的 Maven 工程类似，解压并通过 IDE 打开项目即可(比如 Eclipse、IDEA 或者实验楼的 WebIDE )，导入成功就可以进行 Spring Boot 项目开发了。

> 关于实验楼的 WebIDE，大家可以通过链接了解详情：https://www.shiyanlou.com/library/shiyanlou-docs/feature/webide 。后续实验内容，都是基于实验楼的 WebIDE 进行的。



# 目录结构详解

打开项目之后可以看到 Spring Boot 项目的目录结构如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10294timestamp1552979067764.png/wm)

如上图所示，Spring Boot 的目录结构主要由以下部分组成：

```
lou-springboot
    ├── src/main/java
    ├── src/main/resources
    ├── src/test/java
    └── pom.xml
```

其中 `src/main/java` 表示 Java 程序开发目录，这个目录大家应该都比较熟悉，唯一的区别是 Spring Boot 项目中还有一个主程序类。

`src/main/resources` 表示资源文件目录，与普通的 Spring 项目相比有些区别，如上图所示该目录下有 `static` 和 `templates` 两个目录，是 Spring Boot 项目默认的静态资源文件目录和模板文件目录，在 Spring Boot 项目中是没有 `webapp` 目录的，默认是使用 `static` 和 `templates` 两个文件夹。

`src/test/java` 表示测试类文件夹，与普通的 Spring 项目差别不大。

pom.xml 用于配置项目依赖。

以上即为 Spring Boot 项目的目录结构，与普通的 Spring 项目存在一些差异，不过在平常开发过程中，这个差异的影响并不大，说到差别较大的地方可能是部署和启动方式的差异，接下来十三讲详细介绍 Spring Boot 项目的启动方式。



# Spring Boot 项目启动

- 首先，点击下方工具栏中的 Terminal 打开命令行窗口
- 之后使用 Maven 命令将项目打包，执行命令为:`mvn clean package -Dmaven.test.skip=true`，等待打包结果即可
- 打包成功后进入 target 目录，`cd target`
- 最后就是启动已经生成的 Jar 包，执行命令为`java -jar springboot-demo-0.0.1-SNAPSHOT.jar`

这种方式也是 Spring Boot 上线时常用的启动流程，希望不熟悉的朋友都按照以上过程练习几次。



# 实验楼 WebIDE 中操作 Spring Boot 项目

下面，我们将演示在实验楼 WebIDE 中操作 Spring Boot 项目。我们已经将本次实验的源码上传，大家可以直接下载使用。



# 下载并解压代码

下载代码压缩包

```
wget  https://labfile.oss.aliyuncs.com/courses/1367/lou-springboot.zip
```

解压压缩包

```
unzip lou-springboot.zip
```

过程如下所示：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10294timestamp1552979112190.png/wm)

可以看到我们的代码已经在 WebIDE 中打开，而且可以进行线上编辑。



# 线上环境中启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要通过`cd lou-springboot`切换到 lou-springboot 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动了，过程如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10294timestamp1552979146023.png/wm)



# 实验总结

项目成功启动后，点击实验楼侧栏中的 Web 服务，可以看到一个 white label error 页面，这个页面是 Spring Boot 的默认错误页面，由页面内容可以看出报错为 404 ，访问其他地址也都会是这个页面，此时的 web 服务中并没有任何可访问资源，因为我们并没有在项目中增加任何一行代码，没有接口，也没有页面。

![whitelabel](https://doc.shiyanlou.com/courses/uid770606-20190827-1566885437049/wm)

虽然是错误页面，不过能够看到这个页面已经证明咱们的 Spring Boot 项目搭建和启动过程都已经正确执行了，关于使用 Spring Boot 进行 web 相关功能的开发，我们将在下一篇文章中进行讲解，希望大家可以按照我的教程在本地和线上环境都动手进行操作，以掌握 Spring Boot 的基本构建和启动操作。

