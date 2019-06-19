---
title: shiro
top: 9999
tags: []
date: 2019-06-07 23:11:21
permalink:
categories: java
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

# What is Apache Shiro?

```
Apache Shiro is a powerful and easy-to-use Java security framework that performs authentication, authorization, cryptography, and session management. With Shiro’s easy-to-understand API, you can quickly and easily secure any application – from the smallest mobile applications to the largest web and enterprise applications.

Apache Shiro是一个功能强大且易于使用的Java安全框架，可执行身份验证，授权，加密和会话管理。 借助Shiro易于理解的API，您可以快速轻松地保护任何应用程序 - 从最小的移动应用程序到最大的Web和企业应用程序。
```

# How to use it?

<font style="color:red">**配套代码:**</font>

```
https://github.com/mambamentality8/shiro
```

<font style="color:red">**如果觉得本文有用可以fllow作者或者star一下仓库**</font>

### 1.什么是权限控制，初学JavaWeb时处理流程

- 什么是权限控制：
  - 忽略特别细的概念，比如权限能细分很多种，功能权限，数据权限，管理权限等
  - 理解两个概念：用户和资源，让指定的用户，只能操作指定的资源（CRUD）

- 初学javaweb时怎么做

  - Filter接口中有一个doFilter方法，自己编写好业务Filter，并配置对哪个web资源进行拦截后
  - 如果访问的路径命中对应的Filter，则会执行doFilter()方法，然后判断是否有权限进行访问对应的资源
  - /api/user/info?id=1

  ```java
  	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)throws Exception {
          HttpServletRequest httpRequest=(HttpServletRequest)request;
          HttpServletResponse httpResponse=(HttpServletResponse)response;
          
          HttpSession session=httpRequest.getSession();
          
          if(session.getAttribute("username")!=null){
              chain.doFilter(request, response);
          } else {
              httpResponse.sendRedirect(httpRequest.getContextPath()+"/login.jsp");
          }
          
  }
  ```



### 2.介绍什么是ACL和RBAC

- ACL: Access Control List 访问控制列表
  - 以前盛行的一种权限设计，它的核心在于用户直接和权限挂钩
  - 优点：简单易用，开发便捷
  - 缺点：用户和权限直接挂钩，导致在授予时的复杂性，比较分散，不便于管理
  - 例子：常见的文件系统权限设计, 直接给用户加权限

- RBAC: Role Based Access Control 

  - 基于角色的访问控制系统。权限与角色相关联，用户通过成为适当角色的成员而得到这些角色的权限
  - 优点：简化了用户与权限的管理，通过对用户进行分类，使得角色与权限关联起来
  - 缺点：开发对比ACL相对复杂
  - 例子：基于RBAC模型的权限验证框架与应用 Apache Shiro、spring Security

- BAT企业 ACL，一般是对报表系统，阿里的ODPS

  

- 总结：不能过于复杂，规则过多，维护性和性能会下降， 更多分类 ABAC、PBAC等



### 3.介绍主流的权限框架 Apache Shiro、spring Security

- 什么是 spring Security：官网基础介绍
  
  - 官网：<https://spring.io/projects/spring-security
  
  ```
  Spring Security是一个能够为基于Spring的企业应用系统提供声明式的安全访问控制解决方案的安全框架。它提供了一组可以在Spring应用上下文中配置的Bean，充分利用了Spring IoC，DI（控制反转Inversion of Control ,DI:Dependency Injection 依赖注入）和AOP（面向切面编程）功能，为应用系统提供声明式的安全访问控制功能，减少了为企业系统安全控制编写大量重复代码的工作。
  
  一句话：Spring Security 的前身是 Acegi Security ，是 Spring 项目组中用来提供安全认证服务的框架
  ```
  
  

- 什么是 Apache Shiro：官网基础介绍

  - https://github.com/apache/shiro

  ```
  Apache Shiro是一个强大且易用的Java安全框架,执行身份验证、授权、密码和会话管理。使用Shiro的易于理解的API,您可以快速、轻松地获得任何应用程序,从最小的移动应用程序到最大的网络和企业应用程序。
  
  一句话：Shiro是一个强大易用的Java安全框架,提供了认证、授权、加密和会话管理等功能
  ```

  

- 两个优缺点，应该怎么选择

  - Apache Shiro比Spring Security , 前者使用更简单
  - Shiro 功能强大、 简单、灵活， 不跟任何的框架或者容器绑定，可以独立运行
  - Spring Security 对Spring 体系支持比较好，脱离Spring体系则很难开发
  - SpringSecutiry 支持Oauth鉴权 <https://spring.io/projects/spring-security-oauth>，Shiro需要自己实现
  - ......

  **总结：两个框架没有谁超过谁，大体功能一致，新手一般先推荐Shiro，学习会容易点**



### 4.Shiro架构图交互和四大核心模块 身份认证，授权，会话管理和加密

- 直达Apache Shiro官网 http://shiro.apache.org/introduction.html
- 什么是身份认证
  - Authentication，身份证认证，一般就是登录
- 什么是授权
  - Authorization，给用户分配角色或者访问某些资源的权限
- 什么是会话管理
  - Session Management, 用户的会话管理员，多数情况下是web session
- 什么是加密
  - Cryptography, 数据加解密，比如密码加解密等

![img](http://shiro.apache.org/assets/images/ShiroFeatures.png)

- Web Support: Shiro’s web support APIs help easily secure web applications.
  - Shiro的Web支持API有助于轻松保护Web应用程序
- Caching: Caching is a first-tier citizen in Apache Shiro’s API to ensure that security operations remain fast and efficient.
  - 缓存是Apache Shiro API中的第一层公民，可确保安全操作保持快速高效。
- Concurrency: Apache Shiro supports multi-threaded applications with its concurrency features.
  - Apache Shiro支持具有并发功能的多线程应用程序
- Testing: Test support exists to help you write unit and integration tests and ensure your code will be secured as expected.
  - 存在测试支持以帮助您编写单元和集成测试，并确保您的代码按预期受到保护
- “Run As”: A feature that allows users to assume the identity of another user (if they are allowed), sometimes useful in administrative scenarios.
  - 允许用户承担另一个用户身份的功能（如果允许的话），有时在管理方案中很有用
- “Remember Me”: Remember users’ identities across sessions so they only need to log in when mandatory.
  - 记住用户在会话中的身份，因此他们只需要在必要时登录。



### 5.用户访问整合Shrio的系统，权限控制的运行流程和Shiro常见名称讲解

- 直达官网 ：http://shiro.apache.org/architecture.html
- Subject
  - 我们把用户或者程序称为主体（如用户，第三方服务，cron作业），主体去访问系统或者资源
- SecurityManager
  - 安全管理器，Subject的认证和授权都要在安全管理器下进行
- Authenticator
  - 认证器，主要负责Subject的认证
- Realm
  - 数据域，Shiro和安全数据的连接器，好比jdbc连接数据库； 通过realm获取认证授权相关信息
- Authorizer
  - 授权器，主要负责Subject的授权, 控制subject拥有的角色或者权限
- Cryptography
  - 加解密，Shiro的包含易于使用和理解的数据加解密方法，简化了很多复杂的api
- Cache Manager
  - 缓存管理器，比如认证或授权信息，通过缓存进行管理，提高性能

![img](http://shiro.apache.org/assets/images/ShiroArchitecture.png)

更多资料：http://shiro.apache.org/reference.html



### 6.使用SpringBoot2.x整合Shiro权限认证

- Maven3.5  + Jdk8 + Springboot 2.X + IDEA (Eclipse也可以)
- 创建SpringBoot项目
  - https://start.spring.io/

![1560744107539](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/01.png)

![1560746046307](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/02.png)

```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
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

<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.6</version>
</dependency>
```

- 整合Shiro相关jar包

```
<dependency>
    <groupId>org.apache.shiro</groupId>
    <artifactId>shiro-spring</artifactId>
    <version>1.4.0</version>
</dependency>
```



### 7.Shrio的认证和授权实操

认证：用户身份识别，俗称为用户“登录”

![1560748769729](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/03.png)



### 8.Shiro的授权实操和常用Api 梳理

```
//是否有对应的角色
subject.hasRole("root")

//获取subject名,principal账号
subject.getPrincipal()

//检查是否有对应的角色，无返回值，直接在SecurityManager里面进行判断
subject.checkRole("admin")

//检查是否有对应的角色
subject.hasRole("admin")

//退出登录
subject.logout();
```



### 9.shiro默认自带的realm和常见使用方法

- realm作用：Shiro 从 Realm 获取安全数据

- 默认自带的realm：idae查看realm继承关系，有默认实现和自定义继承的realm

- 两个概念

  - principal : 主体的标示，可以有多个，但是需要具有唯一性，常见的有用户名，手机号，邮箱等
    - subject.getPrincipals().getPrimaryPrincipal();
  - credential：凭证,  一般就是密码
  - 所以一般我们说 principal + credential   就账号 + 密码

- 开发中，往往是自定义realm , 即集成 AuthorizingRealm

  ![1560771788661](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/05.png)

![1560771911678](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/06.png)

![1560771955816](https://blog-mamba.oss-cn-beijing.aliyuncs.com/shiro/07.png)





### 10.讲解Shiro内置 ini realm实操

- 在resources下面创建ini文件

```
# 格式 name=password,role1,role2,..roleN
[users]
# user 'root' with password 'secret' and the 'admin' role，
jack = 456, user

# user 'guest' with the password 'guest' and the 'guest' role
test = 123, admin



# 格式 role=permission1,permission2...permissionN   也可以用通配符
# 下面配置user的权限为所有video:find,video:buy，如果需要配置video全部操作crud 则 user = video:*
[roles]
user = goods:find,goods:buy
# 'admin' role has all permissions, indicated by the wildcard '*'
admin = *
```



### 11.Shiro内置 JdbcRealm

- 方式一:jdbcrealm.ini

  配置文件:

```
#注意 文件格式必须为ini，编码为ANSI

#声明Realm，指定realm类型
jdbcRealm=org.apache.shiro.realm.jdbc.JdbcRealm

#配置数据源
#dataSource=com.mchange.v2.c3p0.ComboPooledDataSource

dataSource=com.alibaba.druid.pool.DruidDataSource

# mysql-connector-java 5 用的驱动url是com.mysql.jdbc.Driver，mysql-connector-java6以后用的是com.mysql.cj.jdbc.Driver
dataSource.driverClassName=com.mysql.cj.jdbc.Driver

#避免安全警告
dataSource.url=jdbc:mysql://120.76.62.13:3606/xdclass_shiro?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false

dataSource.username=test

dataSource.password=Xdclasstest

#指定数据源
jdbcRealm.dataSource=$dataSource


#开启查找权限, 默认是false，不会去查找角色对应的权限，坑！！！！！
jdbcRealm.permissionsLookupEnabled=true


#指定SecurityManager的Realms实现，设置realms，可以有多个，用逗号隔开
securityManager.realms=$jdbcRealm
```

​	代码:

```java
//创建SecurityManager工厂，通过配置文件ini创建
Factory<SecurityManager> factory = new IniSecurityManagerFactory("classpath:jdbcrealm.ini");

SecurityManager securityManager = factory.getInstance();

//将securityManager 设置到当前运行环境中
SecurityUtils.setSecurityManager(securityManager);

Subject subject = SecurityUtils.getSubject();

//用户输入的账号密码
UsernamePasswordToken usernamePasswordToken = new UsernamePasswordToken("jack", "456");

subject.login(usernamePasswordToken);

//org.apache.shiro.realm.jdbc.JdbcRealm

System.out.println(" 认证结果:"+subject.isAuthenticated());

System.out.println(" 是否有对应的role1角色:"+subject.hasRole("role1"));

System.out.println("是否有goods:find权限:"+ subject.isPermitted("goods:find"));
```



- 方式二:new DruidDataSource()

```java
 DefaultSecurityManager securityManager = new DefaultSecurityManager();

DruidDataSource ds = new DruidDataSource();
ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
ds.setUrl("jdbc:mysql://127.0.0.1:3306/shiro?characterEncoding=UTF-8&serverTimezone=UTC&useSSL=false");
ds.setUsername("root");
ds.setPassword("root");


JdbcRealm jdbcRealm = new JdbcRealm();
jdbcRealm.setPermissionsLookupEnabled(true);
jdbcRealm.setDataSource(ds);

securityManager.setRealm(jdbcRealm);

//将securityManager 设置到当前运行环境中
SecurityUtils.setSecurityManager(securityManager);

Subject subject = SecurityUtils.getSubject();

//用户输入的账号密码
UsernamePasswordToken usernamePasswordToken = new UsernamePasswordToken("jack", "456");

subject.login(usernamePasswordToken);


System.out.println(" 认证结果:"+subject.isAuthenticated());

System.out.println(" 是否有对应的role1角色:"+subject.hasRole("role1"));

System.out.println("是否有goods:find权限:"+ subject.isPermitted("goods:find"));

System.out.println("是否有任意权限:"+ subject.isPermitted("aaaa:xxxxxxxxx"));

```

### 自定义Realm实战基础

- 步骤：

  - 创建一个类 ，继承AuthorizingRealm->AuthenticatingRealm->CachingRealm->Realm
  - 重写认证方法 doGetAuthenticationInfo      subject.login()的时候去调用
  - 重写授权方法 doGetAuthorizationInfo

- 方法：

  - 当用户登陆的时候会调用 doGetAuthenticationInfo
  - 进行权限校验的时候会调用: doGetAuthorizationInfo

- 对象介绍

  - UsernamePasswordToken ： 对应就是 shiro的token中有Principal和Credential   页面传过来账号和密码对象

    ```
    UsernamePasswordToken-》HostAuthenticationToken-》AuthenticationToken
    ```

  - SimpleAuthenticationInfo ：代表该用户的认证信息  数据库的用户名账号密码和盐

  - SimpleAuthorizationInfo：代表用户角色权限信息

