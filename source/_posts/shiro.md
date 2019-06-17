---
title: springboot
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

# What is Apache Shiro?

```
Apache Shiro is a powerful and easy-to-use Java security framework that performs authentication, authorization, cryptography, and session management. With Shiro’s easy-to-understand API, you can quickly and easily secure any application – from the smallest mobile applications to the largest web and enterprise applications.

Apache Shiro是一个功能强大且易于使用的Java安全框架，可执行身份验证，授权，加密和会话管理。 借助Shiro易于理解的API，您可以快速轻松地保护任何应用程序 - 从最小的移动应用程序到最大的Web和企业应用程序。
```

# How to use it?

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

