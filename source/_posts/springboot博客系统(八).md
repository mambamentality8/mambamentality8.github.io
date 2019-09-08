# 实验介绍

#### 实验内容

前面几篇文章主要讲解了在 Spring Boot 项目中对数据层的操作，本章节将介绍在 Spring Boot 项目中如何进行事务处理。所有的数据访问技术都离不开事务处理，否则将会造成数据不一致，在目前企业级应用开发中，事务管理是必不可少的。

#### 实验知识点

- 数据库事务介绍
- 声明式事务
- Spring Boot 处理数据库事务

#### 实验环境

- JDK 1.8 或者更高版本
- Spring Boot 2.1.0-RELEASE
- Maven 3+
- MySQL

# 数据库事务简介

数据库事务是指作为单个逻辑工作单元执行的一系列操作，要么完全地执行，要么完全地不执行。 事务处理可以确保除非事务性单元内的所有操作都成功完成，否则不会永久更新面向数据的资源。

通过将一组相关操作组合为一个要么全部成功要么全部失败的单元，可以简化错误恢复并使应用程序更加可靠。一个逻辑工作单元要成为事务，必须满足所谓的 ACID（原子性、一致性、隔离性和持久性）属性，事务是数据库运行中的逻辑工作单位，由数据库中的事务管理子系统负责事务的处理。

# Spring Boot 事务机制

**首先需要明确的一点是 Spring Boot 事务机制实质上就是 Spring 的事务机制**，是采用统一的机制处理来自不同数据访问技术的事务处理，只不过 Spring Boot 基于自动配置的特性作了部分处理来节省开发者的配置工作，这一知识点我们会结合部分源码进行讲解。

Spring 事务管理分两种方式：

- 编程式事务，指的是通过编码方式实现事务；
- 声明式事务，基于 AOP，将具体业务逻辑与事务处理解耦。

# 声明式事务

声明式事务是建立在 AOP 机制之上的，其本质是对方法前后进行拦截，然后在目标方法开始之前创建或者加入一个事务，在执行完目标方法之后根据执行情况提交或者回滚事务。

声明式事务最大的优点，就是通过 AOP 机制将具体业务逻辑与事务处理解耦，不需要通过编程的方式管理事务，这样就不需要在业务逻辑代码中掺杂事务管理的代码，因此在实际使用中声明式事务用的比较多。

声明式事务有两种方式：一种是在 XML 配置文件中做相关的事务规则声明；另一种是基于 `@Transactional` 注解的方式（`@Transactional` 注解是来自 `org.springframework.transaction.annotation` 包），便可以将事务规则应用到业务逻辑中。

# 未使用 Spring Boot 时的事务配置

下面这个配置文件是普通的 SSM 框架整合时的事务配置，相信大家都比较熟悉这段配置代码：

```
    <!-- 事务管理 -->
    <bean id="transactionManager"
          class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!-- 配置事务通知属性 -->
    <tx:advice id="txAdvice" transaction-manager="transactionManager">
        <!-- 定义事务传播属性 -->
        <tx:attributes>
            <tx:method name="insert*" propagation="REQUIRED"/>
            <tx:method name="import*" propagation="REQUIRED"/>
            <tx:method name="update*" propagation="REQUIRED"/>
            <tx:method name="upd*" propagation="REQUIRED"/>
            <tx:method name="add*" propagation="REQUIRED"/>
            <tx:method name="set*" propagation="REQUIRED"/>
            <tx:method name="remove*" propagation="REQUIRED"/>
            <tx:method name="delete*" propagation="REQUIRED"/>
            <tx:method name="get*" propagation="REQUIRED" read-only="true"/>
            <tx:method name="*" propagation="REQUIRED" read-only="true"/>
        </tx:attributes>
    </tx:advice>

    <!-- 配置事务切面 -->
    <aop:config>
        <aop:pointcut id="serviceOperation"
                      expression="(execution(* com.ssm.demo.service.*.*(..)))"/>
        <aop:advisor advice-ref="txAdvice" pointcut-ref="serviceOperation"/>
    </aop:config>
```

通过这段代码我们也能够看出声明式事务的配置过程：

1. 配置事务管理器
2. 配置事务通知属性
3. 配置事务切面

这样配置后，相关方法在执行时都被纳入事务管理下了，一旦发生异常，事务会正确回滚。

# Spring Boot 项目中的事务控制

在 SpringBoot 中，建议采用注解 `@Transactional` 进行事务的控制，只需要在需要进行事务管理的方法或者类上添加 `@Transactional` 注解即可，接下来我们来通过代码讲解。

下载源码并解压：

```
wget https://labfile.oss.aliyuncs.com/courses/1367/lou-springboot-10.zip
unzip lou-springboot-10.zip
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
    │   │               ├── controller
    │   │               │   ├── HelloController.java
    │   │               │   ├── JdbcController.java
    │   │               │   ├── MyBatisController.java
    │   │               │   └── TransactionTestController.java
    │   │               ├── dao
    │   │               │   └── UserDao.java
    │   │               ├── entity
    │   │               │   └── User.java
    │   │               └── service
    │   │                   └── TransactionTestService.java
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

#  新建 TransactionTestService.java

首先新建 service 包作为业务代码包，事务处理一般在 service 层做，当然在 controller 层中处理也可以，但是建议还是在业务层进行处理，之后在包中新建 TransactionTestService 类，代码如下：

```
package com.lou.springboot.service;
import com.lou.springboot.dao.UserDao;
import com.lou.springboot.entity.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import javax.annotation.Resource;

@Service
public class TransactionTestService {
    @Resource
    UserDao userDao;

    public Boolean test1() {
        User user = new User();
        user.setPassword("test1-password");
        user.setName("test1");
        // 在数据库表中新增一条记录
        userDao.insertUser(user);
        // 发生异常
        System.out.println(1 / 0);
        return true;
    }

    @Transactional
    public Boolean test2() {
        User user = new User();
        user.setPassword("test2-password");
        user.setName("test2");
        // 在数据库表中新增一条记录
        userDao.insertUser(user);
        // 发生异常
        System.out.println(1 / 0);
        return true;
    }
}
```

首先在类上添加 `@Service` 将其注册到 IOC 容器中管理，之后注入 UserDao 对象以实现后续的数据层操作，最后实现两个业务方法 `test1()` 和 `test2()`，二者实现类似，只是两个方法添加的用户对象名称和密码字符串不同，且 `test2()` 方法上添加了 `@Transactional` 注解，而 `test1()` 方法上并没有添加，在方法中我们都添加了一句代码，让数字 1 去除以 数字 0，这段代码一定会出现异常，我们用这个来模拟在发生异常时事务处理能否成功。

按照正常理解，在执行 SQL 语句后，一旦发生异常，这次数据库更改一定会被事务进行回滚，正常情况下数据库中会有 `test1` 的数据而没有 `test2` 的数据，因为 `test1()` 方法并没有纳入事务管理中，而 `test2()` 方法由于加上了 `@Transactional` 注解是会被事务管理器处理的，那么接下来我们就来执行两个业务层方法，看看数据库中的数据变化。

# 新建 TransactionTestController.java

为了方便在实验楼线上环境进行方法测试，我们还是将方法调用写到 Controller 类中进行线上访问测试，在 controller 包中新建 TransactionTestController.java 类，代码如下：

```
package com.lou.springboot.controller;
import com.lou.springboot.service.TransactionTestService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import javax.annotation.Resource;
@Controller
public class TransactionTestController {
    @Resource
    private TransactionTestService transactionTestService;
    // 事务管理测试
    @GetMapping("/transactionTest")
    @ResponseBody
    public String transactionTest() {
        // test1 未添加 @Transactional 注解
        transactionTestService.test1();
        // test2 添加了 @Transactional 注解
        transactionTestService.test2();
        return "请求完成";
    }
}
```

这段代码很简单，就是实现一个控制器方法处理 /transactionTest 请求，方法中会进行业务层 `test1()` 方法和 `test2()` 方法的调用，也就是说在项目启动后一旦访问 /transactionTest 请求就能够看到这次事务处理测试的结果了。

# 功能测试

#### 启动 MySQL

**如果 MySQL 数据库服务没有启动的话需要进行这一步操作。**

进入实验楼线上开发环境，首先打开一个命令窗口，点击 File -> Open New Terminal 即可，之后在命令行中输入以下命令：

```
sudo service mysql start
```

因为用户权限的关系，需要增加在命令前增加 sudo 取得 root 权限，不然在启动时会报错，之后等待 MySQL 正常启动即可。

> 这里还是会继续使用前面用到到数据库，如果没有创建，请根据前面到操作自行补充。

# 线上环境中启动 Spring Boot 项目

由于默认是在 project 目录下，因此想要启动咱们的项目，首先需要切换到 lou-springboot 目录下，之后可以通过 Maven 插件的方式启动 Spring Boot 项目，命令为 `mvn spring-boot:run` ，之后就可以等待项目启动。

# 打开 Web 服务

在项目启动成功后，可以点击页面上方的 Web 服务直接在显示查看网站效果。

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10305timestamp1552986318786.png/wm)

之后会在浏览器中弹出 https://***\**\***.simplelab.cn 页面，我们可以在浏览器中输入 /transactionTest 地址进行验证，最终得到的结果如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10305timestamp1552986335104.png/wm)

这是预期中会返回的数据，因为调用了 `test1()` 方法和 `test2()` 方法肯定会发生异常，之后我们需要去查看 tb_user 表中的数据，访问 /users/mybatis/queryAll 即可查看所有记录，当然也可以直接查看数据库中的记录，最终结果如下：

![此处输入图片的描述](https://doc.shiyanlou.com/document-uid18510labid10305timestamp1552986346820.png/wm)

最终查到的记录与我们之前分析的一样，`test1()` 方法由于没有添加 `@Transactional` 注解，所以在发生异常后事务没有回滚，insert 语句依然起到了作用，而 `test2()` 方法添加了 `@Transactional` 注解，所以在发生异常后事务正常回滚，数据库中并没有 test2 的记录，本次实验到此结束！

# Spring Boot 事务管理器自动配置

在讲解声明式事务时，我们提到了声明式事务的配置过程，首先需要配置事务管理器，但是我们在开发时并没有进行该管理器的配置但是事务管理却起到了作用，这是为什么呢？

答案是 Spring Boot 在启动过程中已经将该对象自动配置完成了，所以我们在 Spring Boot 项目中可以直接使用 `@Transactional` 注解来处理事务，感兴趣的同学可以查看源码进行学习，事务管理器的自动配置类如下：

- org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration
- org.springframework.boot.autoconfigure.transaction.TransactionAutoConfiguration

可以在你本地开发工具 (IDEA 或者 Eclipse) 中搜索这两个类的源码来看。

# @Transactional 事务实现机制

**@Transactional 不仅可以注解在方法上，也可以注解在类上。当注解在类上时，意味着此类的所有 public 方法都是开启事务的。如果类级别和方法级别同时使用了 @Transactional 注解，则使用在类级别的注解会重载方法级别的注解。**

在应用系统调用声明了 `@Transactional` 的目标方法时，Spring Framework 默认使用 AOP 代理，在代码运行时生成一个代理对象，根据 `@Transactional` 的属性配置信息，这个代理对象决定该声明 `@Transactional` 的目标方法是否由拦截器 TransactionInterceptor 来使用拦截，在 TransactionInterceptor 拦截时，会在目标方法开始执行之前创建并加入事务，并执行目标方法的逻辑, 最后根据执行情况是否出现异常，利用抽象事务管理器 AbstractPlatformTransactionManager 操作数据源 DataSource 提交或回滚事务。

# 实验总结

由于 Spring Boot 的自动配置机制，我们在使用 Spring Boot 开发项目时如果需要进行事务处理，直接在对应方法上添加 `@Transactional` 即可，Spring Boot 事务机制实质上就是 Spring 的事务机制，只不过在配置方式上有所不同，Spring Boot 更简便一些，所以只要你对事务处理有一定的理解，那么在使用 Spring Boot 处理事务时也不会遇到问题。