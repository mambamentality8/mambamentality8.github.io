---
title: springboot整合微信支付
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

# springboot整合微信支付从0到1

### 使用SpringBoot start在线生成项目基本框架

```
 1、站点地址：http://start.spring.io/
 
 2、需要依赖
 spring-boot-starter-web
 spring-boot-starter-data-redis
 mybatis-spring-boot-starter
 mysql-connector-java

用什么包导什么包

注意事项：
如果一开始没加mysql的信息，则在pom.xml里面注解掉mysql相关依赖


3、启动项目hello world

4、访问入口：localhost:8080/test
```

###  springboot开启热部署

```
 1、增加依赖
         <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
		 </dependency>
3、idea里面要设置
    1、setting –> compiler ，将 Build project automatically 勾选上
    2、Shift+Ctrl+Alt+/，选择Registry
    选 compiler.automake.allow.when.app.running  
    重启项目就可以了
```

### 搭建项目基本目录结构

```
 1、基本目录结构    
 controller
 service
 	impl
 mapper
 utils
 domain
 config
 interceoter
 dto
 2、application.properties配置文件
 配置启动端口
 server.port=8082
 3、入口类应该放在根目录下面
```

### IDE根据Mysql自动生成java pojo实体类

```
1、IDEA连接数据库
	菜单View→Tool Windows→Database打开数据库工具窗口

2、左上角添加按钮“+”，选择数据库类型

3、mysql主机，账户密码
    localhost
    root
4、通过IDEA生成实体类
    选中一张表，右键--->Scripted Extensions--->选择Generate POJOS.groovy，选择需要存放的路径，完成
    
如果想自定义选择Generate POJOS.clj:

自定义包名 
	com.example.wxpay.domain
	
修改基本数据类型为引用数据类型

常用类型
java.sql.Timestamp---->java.util.Date

5、将实体类实现Serializable接口

```

