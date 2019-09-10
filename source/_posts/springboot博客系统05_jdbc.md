# 实验介绍

#### 实验内容

我们将在这一节介绍 JDBC 相关知识点，并结合实际代码来学习 Spring Boot 中如何进行数据库连接以及在 Spring Boot 项目中操作数据库。

#### 实验知识点

- JDBC
- Spring Boot 连接 MySQL
- 使用 Spring Boot 操作 MySQL 中的数据

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+
- MySQL



# JDBC

JDBC 全称为 Java Data Base Connectivity（Java 数据库连接），主要由接口组成，是一种用于执行 SQL 语句的 Java API。各个数据库厂家基于它各自实现了自己的驱动程序（Driver），如下图所示：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10302timestamp1552984502095.png/wm)

Java 程序在获取数据库连接时，需要以 URL 方式指定不同类型数据库的 Driver，在获得特定的 Connection 连接后，可按照 JDBC 规范对不同类型的数据库进行数据操作，代码如下：

```
//第一步，注册驱动程序  
//com.MySQL.jdbc.Driver  
Class.forName("数据库驱动的完整类名");
//第二步，获取一个数据库的连接  
Connection conn = DriverManager.getConnection("数据库地址","用户名","密码");    
//第三步，创建一个会话  
Statement stmt=conn.createStatement();   
//第四步，执行SQL语句  
stmt.executeUpdate("SQL语句");  
//或者查询记录  
ResultSet rs = stmt.executeQuery("查询记录的SQL语句");  
//第五步，对查询的结果进行处理  
while(rs.next()){  
//操作  
}  
//第六步，关闭连接  
rs.close();  
stmt.close();  
conn.close();
```

对上面几行代码，大家不会陌生，这是我们初学 JDBC 连接时最熟悉的代码了，虽然现在可能用到了一些数据层 ORM 框架(比如 MyBatis 或者 Hibernate )，但是底层实现依然如同上面代码一样，只不过框架对其做了一些封装而已，通过 JDBC 使得我们可以直接使用 Java 程序来对关系型数据库进行操作，接下来我们将对 Spring Boot 如何使用 JDBC 进行实例演示。



# 数据库准备

#### 启动 MySQL

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

#### 创建数据库和表结构

首先，执行如下命令登陆 MySQL 数据库：

```
sudo mysql -u root 
```

因为实验楼线上实验环境中 MySQL 数据库默认并没有设置密码，因此以上命令即可完成登陆。在开发项目之前需要在 MySQL 中先创建数据库和表作为项目演示使用，SQL 语句如下：

```
CREATE DATABASE /*!32312 IF NOT EXISTS*/`lou_springboot` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `lou_springboot`;

DROP TABLE IF EXISTS `tb_user`;

CREATE TABLE `tb_user` (
  `id` INT(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '登录名',
  `password` VARCHAR(100) NOT NULL DEFAULT '' COMMENT '密码',
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

首先创建了 lou_springboot 的数据库，之后在数据库中新建了一个名称为 tb_user 的数据表，表中有 id , name , password 三个字段，同学们在测试时可以直接将以上 SQL 拷贝到 MySQL 中执行即可。

执行完上面的操作后，再执行以下操作，就可以看见创建的数据库了

```
show databases;
```

**希望大家能保存好数据库环境，在后面的实验中还会继续用到这个数据库**



# Spring Boot 连接数据库

源码下载并解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/lou-springboot-07.zip
unzip lou-springboot-07.zip
```

切换工作空间到 lou-springboot。项目结构目录如下：

```
lou-springboot
├── pom.xml
├── README.md
└── src
    ├── main
    │   ├── java
    │   │   └── com
    │   │       └── lou
    │   │           └── springboot
    │   │               ├── Application.java
    │   │               └── controller
    │   │                   ├── HelloController.java
    │   │                   └── JdbcController.java
    │   └── resources
    │       ├── application.properties
    │       ├── static
    │       └── templates
    └── test
        └── java
            └── com
                └── lou
                    └── springboot
                        └── ApplicationTests.java
```

#### pom 依赖

在进行数据库连接前，首先将相关 jar 包依赖引入到项目中，Spring Boot 针对 JDBC 的使用提供了对应的 Starter 包：`spring-boot-starter-jdbc`，方便在 Spring Boot 生态中更好的使用 JDBC，演示项目中使用 MySQL 作为数据库，因此项目中也需要引入 MySQL 驱动包，因此在 pom.xml 文件中新增如下配置：

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
        <!-- jdbc-starter -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-jdbc</artifactId>
        </dependency>
        <!-- MySQL 驱动包 -->
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

#### 数据库配置信息

为了能够连接上数据库并进行操作，在新增依赖后，我们也需要对数据库的基本信息进行配置，比如数据库地址、账号、密码等信息，这些配置依然是在 `application.properties` 文件中增加，配置如下：

```
# datasource config
spring.datasource.url=jdbc:mysql://localhost:3306/lou_springboot?serverTimezone=UTC&useUnicode=true&characterEncoding=utf8&autoReconnect=true&useSSL=false
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username=root
spring.datasource.password=
```

以上为实验楼线上开发环境的配置信息，如果在你本机运行代码，你需要将对应的信息改为正确的配置，接下来就可以进行连接测试了。值得注意的是，在 Spring Boot 2 中，数据库驱动类推荐使用 `com.mysql.cj.jdbc.Driver`，而不是我们平时比较熟悉的 `com.mysql.jdbc.Driver` 类了。

#### 连接测试

最后，我们编写一个测试类来测试一下目前能否获得与数据库的连接，在测试类 BlogApplicationTests 中添加 datasourceTest() 单元测试方法，源码及注释如下：

```
@RunWith(SpringRunner.class)
@SpringBootTest
public class ApplicationTests {
    // 注入数据源对象
    @Autowired
    private DataSource dataSource;

    @Test
    public void datasourceTest() throws SQLException {
        // 获取数据库连接对象
        Connection connection = dataSource.getConnection();
        // 判断连接对象是否为空
        System.out.println(connection != null);
        connection.close();
    }
}
```

点击运行单元测试方法，如果 connection 对象不为空，则证明数据库连接成功，如下图所示，在对 connection 对象进行判空操作时，得到的结果是 connection 非空。如果数据库连接对象没有正常获取，则需要检查数据库是否连接或者数据库信息是否配置正确。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10302timestamp1552984528759.png/wm)

由于线上环境的原因，无法像上图一样测试，该测试也只是演示能否获取到数据库连接，后续的实验内容会在实验楼线上环境运行。

至此，Spring Boot 连接数据库的过程就讲解完成了，分别是引入依赖、增加数据库信息配置、注入数据源进行数据库操作。

# Spring Boot 数据源自动配置

通过前一小节的演示大家也能够观察到，我们在配置文件中只需要加上数据库的相关信息即可获取到数据库连接对象，那么 Spring Boot 究竟做了哪些自动配置操作使得我们可以如此简单的就直接获取到数据库连接呢？首先，我们来分析一下注入的 DataSource 数据源对象，更改测试类方法如下：

```
    @Test
    public void datasourceTest() throws SQLException {
        // 获取数据源类型
        System.out.println("默认数据源为：" + defaultDataSource.getClass());
    }
```

运行测试方法，得到的结果为：

```
默认数据源为：class com.zaxxer.hikari.HikariDataSource
```

基于以上结果我们可以得出结论，在项目启动前，Spring Boot 已经默认向 IOC 容器中注册了一个类型为 `HikariDataSource` 的数据源对象，不然我们在使用 `@Autowired` 进行数据源的引入时肯定会报错。 HikariCP 是 Spring Boot 2.0 默认使用的数据库连接池，自动配置类为 `DataSourceAutoConfiguration.class` 和 `DataSourceConfiguration.class` ，感兴趣的同学可以阅读一下源码理解一下数据源自动配置的过程。

Spring Boot 不仅仅是自动配置了 DataSource 对象，在数据源对象自动配置完成后，Spring Boot 也自动配置了 JdbcTemplate 对象，JdbcTemplate 是 Spring 对 JDBC 的封装，目的是使 JDBC 更加易于使用。 Spring Boot 默认也并没有集成相关的 ORM 框架，而是提供了 JdbcTemplate 来简化开发者对于数据库的操作，关于 ORM 框架集成到 Spring Boot 项目中的教程我会在后续实验中演示，接下来我们使用 JdbcTemplate 来进行数据库的常用 SQL 操作。

# Spring Boot 操作 MySQL

**新建 JdbcController：**

在正确配置数据源之后，开发者可以直接在代码中使用 JdbcTemplate 对象进行数据库操作，接下来就是代码实践了，为了演示方便，我们直接新建一个 Controller 类，并注入 JdbcTemplate 对象，接下来我们创建两个方法，一个是查询 tb_user 中的数据，另一个方法是根据传入的参数向 tb_user 表中新增数据，代码如下：

```
package com.lou.springboot.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
public class JdbcController {

    //自动配置，因此可以直接通过 @Autowired 注入进来
    @Autowired
    JdbcTemplate jdbcTemplate;

    // 查询所有记录
    @GetMapping("/users/queryAll")
    public List<Map<String, Object>> queryAll() {
        List<Map<String, Object>> list = jdbcTemplate.queryForList("select * from tb_user");
        return list;
    }

    // 新增一条记录
    @GetMapping("/users/insert")
    public Object insert(String name, String password) {
        if (StringUtils.isEmpty(name) || StringUtils.isEmpty(password)) {
            return false;
        }
        jdbcTemplate.execute("insert into tb_user(`name`,`password`) value (\"" + name + "\",\"" + password + "\")");
        return true;
    }
}
```

两个方法，分别取查询数据库记录和新增数据库记录。

# 功能验证

下面我们对整个功能进行验证。

#### 启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到 lou-springboot 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动。

#### 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10302timestamp1552984595724.png/wm)

之后会在浏览器中弹出 `https://********.simplelab.cn` 页面，我们可以在浏览器中输入如下地址进行验证：

- 新增：http://***\**\****.simplelab.cn/users/insert?name=shiyanlou1&password=syl123
- 查询：https://***\**\****.simplelab.cn/users/queryAll

**注意：以上 url 地址星号部分需要按照你的 web 服务地址进行修改。**

如果能够正常获取到记录以及正确向 tb_user 表中新增记录就表示功能整合成功！结果如下所示：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10302timestamp1552984612148.png/wm)

#### 验证 MySQL 中的数据

最后，我们登录实验楼演示环境中的 MySQL 数据库，查看表中的数据是否与前一步骤中的数据一致，过程如下：

1. **打开命令行工具**

2. **登录数据库**

   ```
   sudo mysql -u root
   ```

3. **查看数据库(这一步可以忽略，主要是确认 lou_springboot 是否已经创建)**

   ```
   show databases;
   ```

4. **切换数据库**

   ```
   use lou_springboot;
   ```

5. **查询 tb_user 表中数据。**

   ```
   select * from tb_user;
   ```

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10302timestamp1552984681496.png/wm)

最后得到的数据确实与 web 页面中看到的数据一致，功能一切正常，本次实验到此结束！

# 实验总结

在 Spring Boot 项目中操作数据库，仅仅需要几行配置代码即可完成数据库的连接操作，并不需要多余的设置，再加上 Spring Boot 自动配置了 JdbcTemplate 对象，开发者可以直接上手进行数据库的相关开发工作。 希望大家对于 Spring Boot 的自动配置以及 Spring Boot 项目进行数据库操作有了更好的认识，作为知识的补充和拓展，接下来的文章中我们也会讲解 Spring Boot 与 ORM 框架的整合实践，也希望大家能够在课后自行学习源码并根据文中的 SQL 实践进行练习，代码也需要多写，这样的话进步才会更加明显。