# 实验介绍

#### 实验内容

我们将在这一节学习 Spring Boot 如何与 MyBatis 进行整合，并对其进行设置和功能讲解，最终实现对于 tb_user 表的增删改查操作。

#### 实验知识点

- Spring Boot 整合 mybatis-spring-boot-starter
- MyBatis 配置
- Spring Boot 整合 MyBatis 进行增删改查操作

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+
- MySQL

# MyBatis 简介

MyBatis 的前身是 Apache 社区的一个开源项目 iBatis，于 2010 年更名为 MyBatis。MyBatis 是支持定制化 SQL、存储过程以及高级映射的优秀的持久层框架，避免了几乎所有的 JDBC 代码和手动设置参数以及获取结果集，使得开发人员更加关注 SQL 本身和业务逻辑，不用再去花费时间关注整个复杂的 JDBC 操作过程。

MyBatis 的优点如下：

- 封装了 JDBC 大部分操作，减少开发人员工作量；
- 相比一些自动化的 ORM 框架，“半自动化”使得开发人员可以自由的编写 SQL 语句，灵活度更高；
- Java 代码与 SQL 语句分离，降低维护难度；
- 自动映射结果集，减少重复的编码工作；
- 开源社区十分活跃，文档齐全，学习成本不高。

虽然前文中已经介绍了 JdbcTemplate 的自动配置及使用，鉴于 MyBatis 框架受众更广且后续实践课程的技术选型包含 MyBatis，因此会在本章节内容中对它做一个详细的介绍，以及如何使用 Spring Boot 整合 MyBatis 框架对数据层进行功能开发。

# mybatis-springboot-starter 介绍

Spring Boot 的核心特性包括简化配置并快速开发，当我们需要整合某一个功能时，只需要引入其特定的场景启动器 ( starter ) 即可，比如 web 模块整合、jdbc 模块整合，我们在开发时只需要在 pom.xml 文件中引入对应的场景依赖即可。Spring 官方并没有提供 MyBatis 的场景启动器，但是 MyBatis 官方却紧紧的抱住了 Spring 的大腿，他们提供了 MyBatis 整合 Spring Boot 项目时的场景启动器，也就是 **mybatis-springboot-starter**，大家通过命名方式也能够发现其中的区别，Spring 官方提供的启动器的命名方式为 **spring-boot-starter-\***，与它还是有一些差别的，接下来我们来介绍一下 **mybatis-springboot-starter** 场景启动器。

其官网地址为 [mybatis-spring-boot](http://www.mybatis.org/spring-boot-starter/mybatis-spring-boot-autoconfigure/index.html)，感兴趣的朋友可以去查看更多内容，官网对 **mybatis-springboot-starter** 的介绍如下所示：

```
The MyBatis-Spring-Boot-Starter help you build quickly MyBatis applications on top of the Spring Boot. 
```

MyBatis-Spring-Boot-Starter 可以帮助开发者快速创建基于 Spring Boot 的 MyBatis 应用程序，那么使用 **MyBatis-Spring-Boot-Starter**可以做什么呢？

- 构建独立的 MyBatis 应用程序
- 零模板
- 更少的 XML 配置代码甚至无 XML 配置

# Spring Boot 整合 MyBatis 过程

接下来，我们还是通过一个案例来理解。

源码下载并解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/lou-springboot-08.zip
unzip lou-springboot-08.zip
```

切换工作空间到 lou-springboot。项目结构目录如下：

```java
lou-spring-boot
├── pom.xml
├── README.md
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── lou
    │   │           └── springboot
    │   │               ├── Application.java
    │   │               ├── controller
    │   │               │   ├── HelloController.java
    │   │               │   ├── JdbcController.java
    │   │               │   └── MyBatisController.java
    │   │               ├── dao
    │   │               │   └── UserDao.java
    │   │               └── entity
    │   │                   └── User.java
    │   └── resources
    │       ├── application.properties
    │       ├── mapper
    │       │   └── UserDao.xml
    │       └── templates
    └── test
        └── java
            └── com
                └── lou
                    └── springboot
                        └── ApplicationTests.java
```

# 添加依赖

如果要将其整合到当前项目中，首先我们需要将其依赖配置增加到 pom.xml 文件中，mybatis-springboot-starter 的最新版本为 1.3.2，需要 Spring Boot 版本达到 1.5 或者以上版本，同时，我们需要将数据源依赖和 jdbc 依赖也添加到配置文件中(如果不添加的话，将会使用默认数据源和 jdbc 配置)，由于前文中已经将这些配置放入 pom.xml 配置文件中，因此只需要将 mybatis-springboot-starter 依赖放入其中即可，更新后的 pom 文件如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.1.0.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>
    <groupId>com.lou.springboot</groupId>
    <artifactId>springboot-demo</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <name>springboot-demo</name>
    <description>Demo project for Spring Boot</description>
    <properties>
        <java.version>1.8</java.version>
    </properties>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <!-- 引入 MyBatis 场景启动器，包含其自动配置类及 MyBatis 3 相关依赖 -->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
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

这样，MyBatis 的场景启动器也整合进来项目中了。

# application.properties 配置

Spring Boot 整合 MyBatis 时几个比较需要注意的配置参数：

- **mybatis.config-location**

  配置 mybatis-config.xml 路径，mybatis-config.xml 中配置 MyBatis 基础属性，如果项目中配置了 mybatis-config.xml 文件需要设置该参数

- **mybatis.mapper-locations**

  配置 Mapper 文件对应的 XML 文件路径

- **mybatis.type-aliases-package**

  配置项目中实体类包路径

```
mybatis.config-location=classpath:mybatis-config.xml
mybatis.mapper-locations=classpath:mapper/*Dao.xml
mybatis.type-aliases-package=com.lou.springboot.entity
```

我们只配置 mapper-locations 即可，最终的 application.properties 文件如下：

```
# datasource config
spring.datasource.url=jdbc:mysql://localhost:3306/lou_springboot?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&autoReconnect=true&useSSL=false
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=root

mybatis.mapper-locations=classpath:mapper/*Dao.xml
```

# 启动类增加 Mapper 扫描

在启动类中添加对 Mapper 包扫描 `@MapperScan`，Spring Boot 启动的时候会自动加载包路径下的 Mapper 接口：

```
@SpringBootApplication
@MapperScan("com.lou.springboot.dao") //添加 @Mapper 注解
public class Application {
    public static void main(String[] args) {
        System.out.println("启动 Spring Boot...");
        SpringApplication.run(Application.class, args);
    }
}
```

当然也可以直接在每个 Mapper 接口上面添加 `@Mapper` 注解，但是如果 Mapper 接口数量较多，在每个 Mapper 加注解是挺繁琐的，建议使用扫描注解。

# Spring Boot 整合 MyBatis 实例

本次实验我们依然使用前一个实验中的 tb_user 表结构，并使用 MyBatis 进行增删改查操作，接下来是功能实现步骤。

# 新建实体类和 Mapper 接口

在 entity 包下新建 User 类，将 tb_user 中的字段映射到该实体类中：

```
package com.lou.springboot.entity;

public class User {

    private Integer id;
    private String name;
    private String password;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
```

在 dao 包中新建 UserDao 接口，并定义增删改查四个接口：

```
package com.lou.springboot.dao;
import com.lou.springboot.entity.User;
import java.util.List;
import java.util.Map;

/**
 * @author 13
 * MyBatis 测试
 */
public interface UserDao {
    /**
     * 返回数据列表
     *
     * @return
     */
    List<User> findAllUsers();

    /**
     * 添加
     *
     * @param User
     * @return
     */
    int insertUser(User User);

    /**
     * 修改
     *
     * @param User
     * @return
     */
    int updUser(User User);

    /**
     * 删除
     *
     * @param id
     * @return
     */
    int delUser(Integer id);
}
```

# 创建 Mapper 接口的映射文件

在 resources/mapper 目录下新建 Mapper 接口的映射文件 UserDao.xml，之后进行映射文件的编写。

1. 首先，定义映射文件与 Mapper 接口的对应关系，比如该示例中，需要将 UserDao.xml 的与对应的 UserDao 接口类之间的关系定义出来：

   ```
       <mapper namespace="com.lou.springboot.dao.UserDao">
   ```

2. 之后，配置表结构和实体类的对应关系：

   ```
       <resultMap type="com.lou.springboot.entity.User" id="UserResult">
           <result property="id" column="id"/>
           <result property="name" column="name"/>
           <result property="password" column="password"/>
       </resultMap>
   ```

3. 最后，针对对应的接口方法，编写具体的 SQL 语句，最终的 UserDao.xml 文件如下：

   ```
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
       <mapper namespace="com.lou.springboot.dao.UserDao">
       <resultMap type="com.lou.springboot.entity.User" id="UserResult">
           <result property="id" column="id"/>
           <result property="name" column="name"/>
           <result property="password" column="password"/>
       </resultMap>
       <select id="findAllUsers" resultMap="UserResult">
           select id,name,password from tb_user
           order by id desc
       </select>
       <insert id="insertUser" parameterType="com.lou.springboot.entity.User">
           insert into tb_user(name,password)
           values(#{name},#{password})
       </insert>
       <update id="updUser" parameterType="com.lou.springboot.entity.User">
           update tb_user
           set
           name=#{name},password=#{password}
           where id=#{id}
       </update>
       <delete id="delUser" parameterType="int">
           delete from tb_user where id=#{id}
       </delete>
   </mapper>
   ```

# 新建 MyBatisController

为了对 MyBatis 进行功能测试，在 controller 包下新建 MyBatisController 类，并新增 4 个方法分别接收对于 tb_user 表的增删改查请求，代码如下：

```
package com.lou.springboot.controller;

import com.lou.springboot.dao.UserDao;
import com.lou.springboot.entity.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@RestController
public class MyBatisController {

    @Resource
    UserDao userDao;

    // 查询所有记录
    @GetMapping("/users/mybatis/queryAll")
    public List<User> queryAll() {
        return userDao.findAllUsers();
    }

    // 新增一条记录
    @GetMapping("/users/mybatis/insert")
    public Boolean insert(String name, String password) {
        if (StringUtils.isEmpty(name) || StringUtils.isEmpty(password)) {
            return false;
        }
        User user = new User();
        user.setName(name);
        user.setPassword(password);
        return userDao.insertUser(user) > 0;
    }

    // 修改一条记录
    @GetMapping("/users/mybatis/update")
    public Boolean insert(Integer id, String name, String password) {
        if (id == null || id < 1 || StringUtils.isEmpty(name) || StringUtils.isEmpty(password)) {
            return false;
        }
        User user = new User();
        user.setId(id);
        user.setName(name);
        user.setPassword(password);
        return userDao.updUser(user) > 0;
    }

    // 删除一条记录
    @GetMapping("/users/mybatis/delete")
    public Boolean insert(Integer id) {
        if (id == null || id < 1) {
            return false;
        }
        return userDao.delUser(id) > 0;
    }
}
```

# 功能测试

#### 启动 MySQL

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

# 创建数据库和表结构

数据库和表结构在实验五已经创建了，如果没有保存环境的用户请参照实验八的 SQL 语句，如果保存了环境则无需进行该步骤。

# 线上环境中启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到 lou-springboot 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动。

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10304timestamp1552985958532.png/wm)

之后会在浏览器中弹出 `https://********.simplelab.cn` 页面，我们可以在浏览器地址栏中地址后面添加如下地址进行验证：

- 查询：/users/mybatis/queryAll
- 新增：/users/mybatis/insert?name=mybatis1&password=1233333
- 修改：/users/mybatis/update?id=2&name=mybatis2&password=1233222
- 删除：/users/mybatis/delete?id=2

如果能够正常获取到记录以及正确向 tb_user 表中新增和修改记录就表示功能整合成功！结果如下所示：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10304timestamp1552985976344.png/wm)

# 验证 MySQL 中的数据

最后，我们登录实验楼演示环境中的 MySQL 数据库，查看表中的数据是否与前一步骤中的数据一致，如果最后得到的数据确实与 web 页面中看到的数据一致则表示功能整合一切正常，本次实验到此结束！

# 实验总结

这节实验课程介绍了 MyBatis 框架相关知识点介绍以及如何整合 Spring Boot 与 MyBatis，并以 tb_user 表为例演示了如何使用 MyBatis 进行增、删、改、查操作，也希望大家能够在课后自行学习源码并根据文中的实验步骤进行练习，代码也需要多写，这样的话进步才会更加明显。

