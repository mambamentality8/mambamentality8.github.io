# 实验介绍

#### 实验内容

由于实验楼环境上开发的原因，咱们的项目一直使用的是 maven 插件运行，不过开发完成后，正式的项目上线或者版本更新一般是直接使用 jar 包或者 war 包来部署，本篇文章主要介绍这两种部署方式。

#### 实验知识点

- Spring Boot 项目 jar 包部署
- Spring Boot 项目 war 包生成

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+

# Spring Boot 项目 jar 包部署

这里就以前一个实验的代码为例，大家直接下载前面的源码即可。

# 生成 jar 包

Spring Boot 项目默认是使用的 jar 包部署，在使用 Maven 构建工具进行项目打包时一般也是构建成 jar 包，构建步骤如下：

- 进入项目主目录

  比如咱们的项目名称是 My-Blog，运行如下项目即可切换目录：

  ```
  cd My-Blog
  ```

- 构建项目

  进入项目目录后，运行 mvn 构建命令即可将咱们的项目构建为 jar 包，命令如下：

  ```
  mvn clean package  -Dmaven.test.skip=true
  ```

  过程如下：

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381841160/wm)

  构建完成后可以看到在 target 目录下出现了咱们的项目 jar 包。

# 部署 jar 包

jar 包生成后就能够运行项目了，执行命令为 java -jar 项目名称.jar，过程如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381851473/wm)

首先是进入到 jar 包文件的目录，接着运行 java -jar My-Blog.jar 即可启动咱们的项目，与 mvn 插件方式运行项目的结果是一样的，在项目正常启动后就可以打开 web 项目进行访问了。

# 后台运行

如果是直接运行 java -jar my-blog-4.0.0-SNAPSHOT.jar 启动命令，那么在结束当前终端的时候（比如 ctrl+c 或者关闭终端），这个时候当前项目的运行进程也会被关闭，所以项目相当于结束掉了，我们也无法访问 web 资源了，这种情况我们肯定不希望出现，所以一般会将其设置为后台运行，只需要在刚刚的命令后添加一个 & 符号即可，命令如下：

```
java -jar my-blog-4.0.0-SNAPSHOT.jar &
```

此时项目就会后台运行了，结束当前终端的时候也不会影响项目的运行。

# 关闭后台运行的项目

有启动就要有关闭，如果想要重启项目或者部署一个新版本的项目就需要关闭当前后台运行的项目，关闭过程如下:

- 找到当前项目的进程号，执行命令如下：

  ```
  ps -ef |grep my-blog-4.0.0-SNAPSHOT.jar
  ```

  之后会出现它的进程号。

- 关闭进程

  找到进程号后运行 kill 命令即可关闭当前项目，执行命令如下：

  ```
  kill -9 818
  ```

  命令最后的 818 就是项目的进程号(假设)，你在操作时可能是另外一个号码，替换掉 818 即可，此时就会杀掉项目进程，你也可以重新部署该项目了。

  # Spring Boot 项目打成 war 包

  

有些开发者或者项目团队在部署时更倾向于 Tomcat，那么就需要把 Spring Boot 打成 war 包，接下来我们来修改咱们的项目代码并且实际的操作将其打成 war 包。

# 修改 pom.xml 文件中的打包方式

修改 pom.xml 文件中的打包方式，将默认的 jar 方式改为 war，添加如下配置文件：

```
<!--改为war方式-->
<packaging>war</packaging>
```

# 排除内置的 Tomcat 容器

移除嵌入式 Tomcat 插件 在 pom.xml 里找到 spring-boot-starter-web 依赖节点,在其中进行如下修改：

```
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <exclusions>
            <exclusion>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-starter-tomcat</artifactId>
            </exclusion>
        </exclusions>
    </dependency>
```

添加本地调试 Tomcat 依赖，为了本地调试方便，在 pom.xml 文件中 dependencies 节点下面添加：

```
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-tomcat</artifactId>
        <scope>provided</scope>
    </dependency>
```

这样，pom.xml 文件就修改完成了，最终的文件如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.site.blog.my.core</groupId>
    <artifactId>my-blog</artifactId>
    <version>4.0.0-SNAPSHOT</version>
    <packaging>war</packaging>

    <name>my-blog</name>
    <description>your personal blog</description>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/>
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-thymeleaf</artifactId>
        </dependency>
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-web</artifactId>
        <exclusions>
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
        </exclusions>
    </dependency>
        <dependency>
            <groupId>org.springframework.session</groupId>
            <artifactId>spring-session-core</artifactId>
        </dependency>
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
        </dependency>
        <!-- 验证码 -->
        <dependency>
            <groupId>com.github.penggle</groupId>
            <artifactId>kaptcha</artifactId>
            <version>2.3.2</version>
        </dependency>
        <!-- commonmark core -->
        <dependency>
            <groupId>com.atlassian.commonmark</groupId>
            <artifactId>commonmark</artifactId>
            <version>0.8.0</version>
        </dependency>
        <!-- commonmark table -->
        <dependency>
            <groupId>com.atlassian.commonmark</groupId>
            <artifactId>commonmark-ext-gfm-tables</artifactId>
            <version>0.8.0</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <scope>runtime</scope>
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

我们是在前一节实验课的项目基础上修改的。

# 修改主类继承 SpringBootServletInitializer

修改启动类，咱们的主类名称是 Application.jar，修改这个文件继承 SpringBootServletInitializer 并实现 `configure()` 方法，代码如下：

```
package com.site.blog.my.core;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@MapperScan("com.site.blog.my.core.dao")
@SpringBootApplication
public class MyBlogApplication extends SpringBootServletInitializer {
    public static void main(String[] args) {
        SpringApplication.run(MyBlogApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(MyBlogApplication.class);
    }
}
```

# 生成 war 包

直接使用 Maven 构建工具即可，大家都不陌生，构建步骤如下：

- 进入项目主目录

  比如咱们的项目名称是 My-Blog，运行如下项目即可切换目录：

  ```
  cd My-Blog
  ```

- 构建项目

  进入项目目录后，运行 mvn 构建命令即可将咱们的项目构建，构建命令是一样的：

  ```
  mvn clean package  -Dmaven.test.skip=true
  ```

  过程如下：

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564381868407/wm)

  构建完成后可以看到在 target 目录下出现了咱们的项目 war 包，拿到 war 包后将其部署到 Tomcat 服务器中就可以了。

  # 注意事项

  使用外部Tomcat部署访问的时候，application.properties (或者 application.yml ) 中配置的 `server.port` 和 `server.servlet.context-path` 将会失效，请使用 Tomcat 的端口以及当前 Tomcat 中的项目路径进行访问。

  # 实验总结

  本实验完成了，主要介绍了 Spring Boot 项目的两种打包方式，jar 包方式是默认的，war 包方式也比较简单，只需要修改 pom.xml 配置文件和主启动类即可，希望大家都可以掌握，至于使用哪种构建方式可以根据个人喜好以及公司要求来选择。

  