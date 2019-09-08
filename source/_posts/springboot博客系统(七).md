# 实验介绍

#### 实验内容

我们将在这一节学习 Mybatis Generator 插件的相关知识，以及如何将 Spring Boot 与 Mybatis Generator 进行整合，并自动生成 DAO 层的相关代码，从而减少开发人员的工作量，使用工具来提升开发者的工作效率。

#### 实验知识点

- 认识 Mybatis Generator 插件
- Spring Boot 整合 Mybatis Generator 插件步骤
- 使用 Mybatis Generator 自动生成 DAO 层代码

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+
- MySQL

# 认识 MyBatis-Generator

#### MyBatis-Generator 介绍

MyBatis Generator 是 MyBatis 官方提供的代码生成器插件，可以用于 MyBatis 和 iBatis 框架的代码生成，支持所有版本的 MyBatis 框架以及 2.2.0 版本及以上的 iBatis 框架。

在前文中我们也介绍了如何使用 MyBatis 进行数据库操作，在进行功能开发时，一张表我们需要编写实体类、DAO 接口类以及 Mapper 文件，这些是必不可少的文件，如果表的数量较大，我们就需要重复的去创建实体类、Mapper 文件以及 DAO 类并且需要配置它们之间的依赖关系，这无疑是一个很麻烦的事情，而 MyBatis Generator 插件就可以帮助我们去完成这些开发步骤，使用该插件可以帮助开发者自动去创建实体类、Mapper 文件以及 DAO 类并且配置好它们之间的依赖关系，我们可以直接在项目中使用这些代码，后续只需要关注业务方法的开发即可。

# 为什么要使用 MyBatis-Generator

通过介绍我们可以将 MyBatis-Generator 简单的理解为一个 MyBatis 框架的代码生成器，至于我推荐大家使用它的原因，理由整理如下：

- 减少重复工作
- 减少人为操作带来的错误
- 提升开发效率
- 使用灵活

MyBatis 属于半自动 ORM 框架，在使用这个框架中，工作量最大的就是书写 Mapper 及相关映射文件，同时需要配置其依赖关系，由于手动书写很容易出错，我们可以利用 MyBatis-Generator 来帮我们自动生成文件。

其次，一个项目通常有很多张表，比如接下来要开发的 my_blog 项目，所有的实体类、SQL 语句都要手动编写，这是一个比较繁琐的过程，如果有这么一个插件能够适当的减少我们的一些工作量，自动将这些代码生成到对应的项目目录中，将是一件十分幸福的事情，当然，该插件生成的代码都是常用的一些增删改查代码，如果有其他功能或方法依然需要自己去编写代码，它只是一个提升效率的工具，给予开发者一定程度的帮助。

# MyBatis-Generator 整合

接下来，我们还是通过一个案例来理解 MyBatis-Generator 插件整合以及使用它来生成代码的步骤。

# 添加依赖

如果要使用该插件，首先我们需要将其依赖配置增加到 pom.xml 文件中，增加的配置文件如下，将该部分配置放到原 pom.xml 文件的 plugins 节点下即可：

```
    <plugin>
        <groupId>org.mybatis.generator</groupId>
        <artifactId>mybatis-generator-maven-plugin</artifactId>
        <version>1.3.5</version>
        <dependencies>
            <dependency>
                <groupId> mysql</groupId>
                <artifactId>mysql-connector-java</artifactId>
                <version> 5.1.39</version>
            </dependency>
            <dependency>
                <groupId>org.mybatis.generator</groupId>
                <artifactId>mybatis-generator-core</artifactId>
                <version>1.3.5</version>
            </dependency>
        </dependencies>
        <executions>
            <execution>
                <id>Generate MyBatis Artifacts</id>
                <phase>package</phase>
                <goals>
                    <goal>generate</goal>
                </goals>
            </execution>
        </executions>
        <configuration>
            <verbose>true</verbose>
            <!-- 是否覆盖 -->
            <overwrite>true</overwrite>
            <!-- MybatisGenerator的配置文件位置 -->
            <configurationFile>src/main/resources/mybatisGeneratorConfig.xml</configurationFile>
        </configuration>
    </plugin>
```

如果是在本地开发的话，接下来等待 jar 包及相关依赖下载完成即可。

# 新增 MyBatis-Generator 的配置文件

在添加插件依赖到 pom.xml 文件中时，我们定义了 Mybatis Generator 的配置文件位置为 src/main/resources/mybatisGeneratorConfig.xml，该文件即为代码生成器插件最重要的配置文件，后续生成代码的规则、数据库连接信息、代码生成后的存放目录等等配置都需要在该配置文件中定义，配置文件内容及相关注释如下：

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE generatorConfiguration
        PUBLIC "-//mybatis.org//DTD MyBatis Generator Configuration 1.0//EN"
        "http://mybatis.org/dtd/mybatis-generator-config_1_0.dtd">
<generatorConfiguration>
    <context id="my-blog-generator-config" targetRuntime="MyBatis3">
        <!-- 生成的Java文件的编码 -->
        <property name="javaFileEncoding" value="utf-8"/>
        <!-- 格式化java代码 -->
        <property name="javaFormatter" value="org.mybatis.generator.api.dom.DefaultJavaFormatter"/>
        <!-- 格式化XML代码 -->
        <property name="xmlFormatter" value="org.mybatis.generator.api.dom.DefaultXmlFormatter"/>
        <plugin type="org.mybatis.generator.plugins.ToStringPlugin"/>
        <!--创建Java类时对注释进行控制-->
        <commentGenerator>
            <property name="suppressDate" value="true"/>
            <!-- 是否去除自动生成的注释 true：是 ： false:否 -->
            <property name="suppressAllComments" value="true"/>
        </commentGenerator>
        <!--数据库地址及登陆账号密码 改成你自己的配置-->
        <jdbcConnection
                driverClass="com.mysql.jdbc.Driver"
                connectionURL="jdbc:mysql://localhost:3306/lou_springboot"
                userId="root"
                password="">
        </jdbcConnection>
        <javaTypeResolver>
            <property name="forceBigDecimals" value="false"/>
        </javaTypeResolver>
        <!--生成实体类设置-->
        <javaModelGenerator targetPackage="com.lou.springboot.entity" targetProject="src/main/java">
            <property name="enableSubPackages" value="true"/>
            <property name="trimStrings" value="true"/>
        </javaModelGenerator>
        <!--生成Mapper文件设置-->
        <sqlMapGenerator targetPackage="mapper" targetProject="src/main/resources">
            <property name="enableSubPackages" value="true"/>
        </sqlMapGenerator>
        <!--生成Dao类设置-->
        <javaClientGenerator type="XMLMAPPER" targetPackage="com.lou.springboot.dao"
                             targetProject="src/main/java">
            <property name="enableSubPackages" value="true"/>
        </javaClientGenerator>
        <!--需要自动生成代码的表及对应的类名设置-->
        <table tableName="generator_test" domainObjectName="GeneratorTest"
               enableCountByExample="false"
               enableUpdateByExample="false"
               enableDeleteByExample="false" enableSelectByExample="false" selectByExampleQueryId="false">
        </table>
    </context>
</generatorConfiguration>
```

需要自动生成代码的表及对应类名的配置是写在 `table` 标签中的，如上所示，generator_test 表对应的实体类可以配置为 GeneratorTest，这些是开发者自定义的，也可以改成其他合适的类名。 如果有多张表同时生成，增加多个 `table` 标签配置即可。

# 生成代码

配置文件和表结构都处理完成后就可以进行代码生成步骤了，这里整理了两种方式来进行代码生成：

- 方式一：IDEA 工具中的 Maven 插件中含有 mybatis-generator 的选项，点击 generate 即可，如下图所示：

  ![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564370253441/wm)

- 方式二：执行 mvn 如下命令来进行代码生成，这是不通过开发工具提供的图形界面来进行的步骤。

  ```
  mvn mybatis-generator:generate
  ```

执行这些步骤之后就可以看到实体类、DAO 接口类、Mapper 文件已经生成在对应的目录中了，接下来我们会进行演示。

# 将 DAO 接口注册至 IOC 容器

接下来是最后一个步骤，在代码生成后，我们需要在 DAO 接口类上增加 `@Mapper` 注解，将其注册到 Spring 的 IOC 容器中以供其他类调用，在生成的文件中默认是没有这个注解的，或者是在主类中添加 `@MapperScan` 注解将相应包下的所有 Mapper 接口扫描到容器中。

# 功能验证

下面我们对整个功能进行验证。

# 启动 MySQL

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

# 创建数据库和表结构

首先，执行如下命令登陆 MySQL 数据库：

```
sudo mysql -u root 
```

因为实验楼线上实验环境中 MySQL 数据库默认并没有设置密码，因此以上命令即可完成登陆，登陆后执行如下命令创建表：

```
USE lou_springboot;
/*Table structure for table `generator_test` */
CREATE TABLE `generator_test` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id',
  `test` varchar(100) NOT NULL COMMENT '测试字段',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

如果不存在我们本节课所需的 lou_springboot 数据库，则需要参照前面的实验将数据库建好。

# 下载并解压代码

本节课程的代码已经上传，直接下载至实验环境中即可，下载之后执行如下命令进行解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/spring-boot-mybatis-generator.zip
unzip spring-boot-mybatis-generator.zip
```

接下来就能够看到本次代码的代码结构及相关配置文件。

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564370335894/wm)

# 执行代码生成命令

由于默认是在 project 目录下，因此执行生成代码的 mvn 命令前，首先需要切换到 spring-boot-mybatis-generator 目录下，之后执行命令 `mvn mybatis-generator:generate` ，接着就能够看到对应的代码已经生成在项目目录中了，过程如下：

![图片描述](https://doc.shiyanlou.com/courses/uid987099-20190729-1564370352139/wm)

# 总结

至此，MyBatis-Generator 插件整合完成，也生成了对应的代码，接下来在项目开发时，我们都会使用它来生成我们 DAO 层的代码，之后再根据功能对 Mapper 文件进行修改，使用该插件时的注意事项如下：

- 由于数据库连接信息是单独定义在配置文件中的，所以在使用时一定要仔细检查，确保数据库连接正常。
- 在生成代码后，建议将 table 标签注释掉，不然在打包或者生成其他表的代码时会将原先已经生成的代码覆盖，可能会造成一些小麻烦。
- 代码生成后将 DAO 接口注册至 IOC 容器以供业务方法调用。