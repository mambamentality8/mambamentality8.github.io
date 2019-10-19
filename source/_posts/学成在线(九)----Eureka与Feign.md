# 课程预览 Eureka Feign

### Eureka注册中心

#### 需求分析

​	 在前后端分离架构中，服务层被拆分成了很多的微服务，微服务的信息如何管理？Spring Cloud中提供服务注册中心来管理微服务信息。

为什么 要用注册中心？

1、微服务数量众多，要进行远程调用就需要知道服务端的ip地址和端口，注册中心帮助我们管理这些服务的ip和端口。

2、微服务会实时上报自己的状态，注册中心统一管理这些微服务的状态，将存在问题的服务踢出服务列表，客户端获取到可用的服务进行调用。

#### Eureka介绍

Spring Cloud Eureka 是对Netflix公司的Eureka的二次封装，它实现了服务治理的功能，Spring Cloud Eureka提供服务端与客户端，服务端即是Eureka服务注册中心，客户端完成微服务向Eureka服务的注册与发现。服务端和客户端均采用Java语言编写。下图显示了Eureka Server与Eureka Client的关系：

![1529906349402](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529906349402.png)

1、Eureka Server是服务端，负责管理各各微服务结点的信息和状态。

2、在微服务上部署Eureka Client程序，远程访问Eureka Server将自己注册在Eureka Server。

3、微服务需要调用另一个微服务时从Eureka Server中获取服务调用地址，进行远程调用。

#### Eureka Server搭建

##### 单机环境搭建

###### 1.创建xc-govern-center工程：

包结构：com.xuecheng.govern.center

###### 2.添加依赖

在父工程添加：（有了则不用重复添加）

```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-dependencies</artifactId>
    <version>Finchley.SR1</version>
    <type>pom</type>
    <scope>import</scope>
</dependency>
```

在Eureka Server工程添加：

```
    <dependencies>
        <!-- 导入Eureka服务的依赖 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
        </dependency>
    </dependencies>
```

###### 3.启动类

```
@EnableEurekaServer//标识这是一个Eureka服务
@SpringBootApplication
public class GovernCenterApplication {
    public static void main(String[] args) {
        SpringApplication.run(GovernCenterApplication.class, args);
    }
}
```

###### 4.@EnableEurekaServer

需要在启动类上用@EnableEurekaServer标识此服务为Eureka服务

###### 5.application.yml

application.yml的配置内容如下：

```
server:
  port: 50101 #服务端口

spring:
  application:
    name: xc-govern-center #指定服务名

eureka:
  client:
    registerWithEureka: false #服务注册，是否将自己注册到Eureka服务中
    fetchRegistry: false #服务发现，是否从Eureka中获取注册信息
    serviceUrl: #Eureka客户端与Eureka服务端的交互地址，高可用状态配置对方的地址，单机状态配置自己（如果不配置则默认本机8761端口）
      defaultZone: http://localhost:50101/eureka/
  server:
    enable-self-preservation: false #是否开启自我保护模式
    eviction-interval-timer-in-ms: 60000 #服务注册表清理间隔（单位毫秒，默认是60*1000）
```

registerWithEureka：被其它服务调用时需向Eureka注册

fetchRegistry：需要从Eureka中查找要调用的目标服务时需要设置为true

serviceUrl.defaultZone 配置上报Eureka服务地址高可用状态配置对方的地址，单机状态配置自己

enable-self-preservation：自保护设置，下边有介绍。

eviction-interval-timer-in-ms：清理失效结点的间隔，在这个时间段内如果没有收到该结点的上报则将结点从服务列表中剔除。

###### 6.logback-spring.xml

```
<?xml version="1.0" encoding="UTF-8"?>

<configuration>
    <!--定义日志文件的存储地址,使用绝对路径-->
    <property name="LOG_HOME" value="e:/logs"/>

    <!-- Console 输出设置 -->
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <!--格式化输出：%d表示日期，%thread表示线程名，%-5level：级别从左显示5个字符宽度%msg：日志消息，%n是换行符-->
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            <charset>utf8</charset>
        </encoder>
    </appender>

    <!-- 按照每天生成日志文件 -->
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <!--日志文件输出的文件名-->
            <fileNamePattern>${LOG_HOME}/xc.%d{yyyy-MM-dd}.log</fileNamePattern>
        </rollingPolicy>
        <encoder>
            <pattern>%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
        </encoder>
    </appender>

    <!-- 异步输出 -->
    <appender name="ASYNC" class="ch.qos.logback.classic.AsyncAppender">
        <!-- 不丢失日志.默认的,如果队列的80%已满,则会丢弃TRACT、DEBUG、INFO级别的日志 -->
        <discardingThreshold>0</discardingThreshold>
        <!-- 更改默认的队列的深度,该值会影响性能.默认值为256 -->
        <queueSize>512</queueSize>
        <!-- 添加附加的appender,最多只能添加一个 -->
        <appender-ref ref="FILE"/>
    </appender>


    <logger name="org.apache.ibatis.cache.decorators.LoggingCache" level="DEBUG" additivity="false">
        <appender-ref ref="CONSOLE"/>
    </logger>
    <logger name="org.springframework.boot" level="DEBUG"/>
    <root level="debug">
        <!--<appender-ref ref="ASYNC"/>-->
        <appender-ref ref="FILE"/>
        <appender-ref ref="CONSOLE"/>
    </root>
</configuration>
```

###### 7.启动Eureka Server

启动Eureka Server，浏览50101端口。

![1529907648861](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529907648861.png)

说明：

```
上图红色提示信息：
THE SELF PRESERVATION MODE IS TURNED OFF.THIS MAY NOT PROTECT INSTANCE EXPIRY IN CASE OF NETWORK/OTHER PROBLEMS.
自我保护模式被关闭。在网络或其他问题的情况下就会将客户端剔除。
```

Eureka Server有一种自我保护模式，当微服务不再向Eureka Server上报状态，Eureka Server会从服务列表将此服务删除，如果出现网络异常情况（微服务正常），此时Eureka server进入自保护模式，不再将微服务从服务列表删除。

在开发阶段建议关闭自保护模式。

##### 高可用环境搭建

​	Eureka Server 高可用环境需要部署两个Eureka server，它们互相向对方注册。如果在本机启动两个Eureka需要注意两个Eureka Server的端口要设置不一样，这里我们部署一个Eureka Server工程，将端口可配置，制作两个Eureka Server启动脚本，启动不同的端口，如下图：

![1529906711400](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529906711400.png)

1、在实际使用时Eureka Server至少部署两台服务器，实现高可用。

2、两台Eureka Server互相注册。

3、微服务需要连接两台Eureka Server注册，当其中一台Eureka死掉也不会影响服务的注册与发现。

4、微服务会定时向Eureka server发送心跳，报告自己的状态。

5、微服务从注册中心获取服务地址以RESTful方式发起远程调用。

配置如下：

###### 1.端口可配置

```
server:
  port: ${PORT:50101} #服务端口
```

###### 2、Eureka服务端的交互地址可配置

```
eureka:
  client:
    registerWithEureka: true #服务注册，是否将自己注册到Eureka服务中
    fetchRegistry: true #服务发现，是否从Eureka中获取注册信息
    serviceUrl: #Eureka客户端与Eureka服务端的交互地址，高可用状态配置对方的地址，单机状态配置自己（如果不配置则默认本机8761端口）
      defaultZone: ${EUREKA_SERVER:http://eureka02:50102/eureka/}
```

###### 3.修改host文件

在此路径下找到host文件C:\Windows\System32\drivers\etc

```
127.0.0.1 eureka01
127.0.0.1 eureka02
```

###### 4.配置hostname

Eureka 组成高可用，两个Eureka互相向对方注册，这里需要通过域名或主机名访问，这里我们设置两个Eureka服务的主机名分别为 eureka01、eureka02。

完整的配置如下：

```
server:
  port: ${PORT:50101} #服务端口
spring:
  application:
    name: xc-govern-center #指定服务名
eureka:
  client:
    registerWithEureka: true #服务注册，是否将自己注册到Eureka服务中
    fetchRegistry: true #服务发现，是否从Eureka中获取注册信息
    serviceUrl: #Eureka客户端与Eureka服务端的交互地址，高可用状态配置对方的地址，单机状态配置自己（如果不配置则默认本机8761端口）
      defaultZone: ${EUREKA_SERVER:http://eureka02:50102/eureka/}
  server:
    enable-self-preservation: false #是否开启自我保护模式
    eviction-interval-timer-in-ms: 60000 #服务注册表清理间隔（单位毫秒，默认是60*1000）
  instance:
    hostname: ${EUREKA_DOMAIN:eureka01}
```

###### 5.在IDEA中制作启动脚本

启动1：

![1537320788755](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1537320788755.png)

```
-DPORT=50101 -DEUREKA_SERVER=http://eureka02:50102/eureka/ -DEUREKA_DOMAIN=eureka01
```

启动2：

![1537320809483](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1537320809483.png)

```
-DPORT=50102 -DEUREKA_SERVER=http://eureka01:50101/eureka/ -DEUREKA_DOMAIN=eureka02
```

运行两个启动脚本，分别浏览：

http://eureka01:50101/

http://eureka02:50102/

Eureka主画面如下：

![1537321017472](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1537321017472.png)

#### 服务注册

##### 将cms注册到Eureka Server

下边实现cms向Eureka Server注册。

###### 1.在cms服务中添加依赖

```
        <!-- 导入Eureka客户端的依赖 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
```

###### 2.在application.yml配置

```
eureka:
  client:
    registerWithEureka: true #服务注册开关
    fetchRegistry: true #服务发现开关
    serviceUrl: #Eureka客户端与Eureka服务端进行交互的地址，多个中间用逗号分隔
      defaultZone: ${EUREKA_SERVER:http://localhost:50101/eureka/,http://localhost:50102/eureka/}
  instance:
    prefer-ip-address:  true  #将自己的ip地址注册到Eureka服务中
    ip-address: ${IP_ADDRESS:127.0.0.1}
    instance-id: ${spring.application.name}:${server.port} #指定实例id
```

###### 3.在启动类上添加注解

```
@EnableDiscoveryClient //一个EurekaClient从EurekaServer发现服务
```

###### 4.刷新Eureka Server查看注册情况

![1529909892396](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529909892396.png)

##### 将manage-course注册到Eureka Server

###### 1.在manage-course工程中添加spring-cloud-starter-eureka依赖：

```
        <!-- 导入Eureka客户端的依赖 -->
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
        </dependency>
```

###### 2.在application.yml配置eureka

```
eureka:
  client:
    registerWithEureka: true #服务注册开关
    fetchRegistry: true #服务发现开关
    serviceUrl: #Eureka客户端与Eureka服务端进行交互的地址，多个中间用逗号分隔
      defaultZone: ${EUREKA_SERVER:http://localhost:50101/eureka/,http://localhost:50102/eureka/}
  instance:
    prefer-ip-address:  true  #将自己的ip地址注册到Eureka服务中
    ip-address: ${IP_ADDRESS:127.0.0.1}
    instance-id: ${spring.application.name}:${server.port} #指定实例id
```

###### 3.在启动类上添加注解 @EnableDiscoveryClient 

```
@EnableDiscoveryClient //一个EurekaClient从EurekaServer发现服务
```

### 远程调用

​	在前后端分离架构中，服务层被拆分成了很多的微服务，服务与服务之间难免发生交互，比如：课程发布需要调用CMS服务生成课程静态化页面，本节研究微服务远程调用所使用的技术。


下图是课程管理服务远程调用CMS服务的流程图：

![1529906137074](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529906137074.png)

工作流程如下：

1、cms服务将自己注册到注册中心。

2、课程管理服务从注册中心获取cms服务的地址。

3、课程管理服务远程调用cms服务。

#### Ribbon

​	Ribbon是Netflix公司开源的一个负载均衡的项目（https://github.com/Netflix/ribbon），它是一个基于HTTP、TCP的客户端负载均衡器。

##### 1.什么是负载均衡？

负载均衡是微服务架构中必须使用的技术，通过负载均衡来实现系统的高可用、集群扩容等功能。负载均衡可通过硬件设备及软件来实现，硬件比如：F5、Array等，软件比如：LVS、Nginx等。

如下图是负载均衡的架构图：

![1529911983041](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529911983041.png)

用户请求先到达负载均衡器（也相当于一个服务），负载均衡器根据负载均衡算法将请求转发到微服务。负载均衡算法有：轮训、随机、加权轮训、加权随机、地址哈希等方法，负载均衡器维护一份服务列表，根据负载均衡算法将请求转发到相应的微服务上，所以负载均衡可以为微服务集群分担请求，降低系统的压力。

##### 2.什么是客户端负载均衡？

上图是服务端负载均衡，客户端负载均衡与服务端负载均衡的区别在于客户端要维护一份服务列表，Ribbon从Eureka Server获取服务列表，Ribbon根据负载均衡算法直接请求到具体的微服务，中间省去了负载均衡服务。

如下图是Ribbon负载均衡的流程图：

![1529912003403](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529912003403.png)

1、在消费微服务中使用Ribbon实现负载均衡，Ribbon先从EurekaServer中获取服务列表。

2、Ribbon根据负载均衡的算法去调用微服务。

#### Ribbon使用

​	Spring Cloud引入Ribbon配合 restTemplate 实现客户端负载均衡。Java中远程调用的技术有很多，如：webservice、socket、rmi、Apache HttpClient、OkHttp等，互联网项目使用基于http的客户端较多，本项目使用OkHttp。

在xc-service-manage-course添加Ribbon依赖

##### 1.pom.xml

```
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-ribbon</artifactId>
        </dependency>
        <dependency>
            <groupId>com.squareup.okhttp3</groupId>
            <artifactId>okhttp</artifactId>
        </dependency>
```

由于依赖了spring-cloud-starter-eureka，会自动添加spring-cloud-starter-ribbon依赖

![1529912064580](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529912064580.png)

##### 2.配置Ribbon参数

这里在课程管理服务的application.yml中配置ribbon参数

```
ribbon:
  MaxAutoRetries: 2 #最大重试次数，当Eureka中可以找到服务，但是服务连不上时将会重试
  MaxAutoRetriesNextServer: 3 #切换实例的重试次数
  OkToRetryOnAllOperations: false  #对所有操作请求都进行重试，如果是get则可以，如果是post，put等操作没有实现幂等的情况下是很危险的,所以设置为false
  ConnectTimeout: 5000  #请求连接的超时时间
  ReadTimeout: 6000 #请求处理的超时时间
```

##### 3.启动两个被调用端

修改xc-service-manage-cms模块的application.xml的server.port

```
server:
  port: ${PORT:31001}
```

启动两个xc-service-manage-cms服务，注意端口要不一致

![1571236566910](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1571236566910.png)

```
-DPORT=31001
```

```
-DPORT=31002
```

##### 4.启动调用端

在xc-service-manage-course的启动类中定义RestTemplate

并且使用@LoadBalanced注解

```
    @Bean
    @LoadBalanced
    public RestTemplate restTemplate() {
        return new RestTemplate(new OkHttp3ClientHttpRequestFactory());
    }
```

##### 5.junit测试

在xc-service-manage-course工程创建单元测试代码，远程调用cms的查询页面接口：

```
@SpringBootTest
@RunWith(SpringRunner.class)
public class TestRibbon {
    @Autowired
    RestTemplate restTemplate;

    @Test
    public void testRibbon(){
        //确定要获取的服务名
        String serviceId = "XC-SERVICE-MANAGE-CMS";
        for (int i=0;i<10;i++){
            //ribbon客户端从eurekaServer中获取服务列表,根据服务名获取服务列表
            ResponseEntity<Map> forEntity = restTemplate.getForEntity("http://"+serviceId+"/cms/page/get/5a754adf6abb500ad05688d9", Map.class);
            Map body = forEntity.getBody();
            System.out.println(body);
        }

    }


}
```

##### 6.负载均衡证明

添加@LoadBalanced注解后，restTemplate会走LoadBalancerInterceptor拦截器，此拦截器中会通过RibbonLoadBalancerClient查询服务地址，可以在此类打断点观察每次调用的服务地址和端口，两个cms服务会轮流被调用。

![1529913868296](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1529913868296.png)

两次shift搜索类RibbonLoadBalancerClient并且在57行打上断点,可以看到每次请求的端口都不一样.

#### Feign

Feign是Netflix公司开源的轻量级rest客户端，使用Feign可以非常方便的实现Http 客户端。Spring Cloud引入Feign并且集成了Ribbon实现客户端负载均衡调用。

#### Feign使用 

##### 1.在客户端添加依赖

在课程管理服务添加下边的依赖：

```
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-openfeign</artifactId>
        </dependency>
        <dependency>
            <groupId>com.netflix.feign</groupId>
            <artifactId>feign-okhttp</artifactId>
        </dependency>
```

 <font size="3" color="red">spring-cloud-starter-openfeign可以把feign和ribbon都引进来,所以可以吧ribbon的依赖给去掉</font>

##### 2.定义FeignClient接口

参考Swagger文档定义FeignClient，注意接口的Url、请求参数类型、返回值类型与Swagger接口一致。

在xc-service-manage-course创建client包，定义查询cms页面的客户端接口，

```
import com.xuecheng.framework.domain.cms.CmsPage;
import com.xuecheng.framework.domain.cms.response.CmsPageResult;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

/**
 * Created by Administrator.
 */
@FeignClient(value = "XC-SERVICE-MANAGE-CMS") //指定在注册中心的远程调用的服务名
public interface CmsPageClient {
    //根据页面id查询页面信息，远程调用cms请求数据
    @GetMapping("/cms/page/get/{id}")//用GetMapping标识远程调用的http的方法类型
    public CmsPage findCmsPageById(@PathVariable("id") String id);

    //添加页面，用于课程预览
    @PostMapping("/cms/page/save")
    public CmsPageResult saveCmsPage(@RequestBody CmsPage cmsPage);
}
```

##### 3.启动类添加@EnableFeignClients注解

```
@EnableFeignClients //开始feignClient
```

##### 4.测试

在xc-service-manage-course模块中添加测试类

```
@SpringBootTest
@RunWith(SpringRunner.class)
public class TestFeign {
    @Autowired
    CmsPageClient cmsPageClient; //接口代理对象，由Feign生成代理对象

    @Test
    public void testRibbon() {
        //发起远程调用
        CmsPage cmsPage = cmsPageClient.findCmsPageById("5a754adf6abb500ad05688d9");
        System.out.println(cmsPage);

    }
}
```

##### 5.工作原理

1、 启动类添加@EnableFeignClients注解，Spring会扫描标记了@FeignClient注解的接口，并生成此接口的代理对象

2、 @FeignClient(value = "XC-SERVICE-MANAGE-CMS")即指定了cms的服务名称，Feign会从注册中心获取cms服务列表，并通过负载均衡算法进行服务调用。

3、在接口方法 中使用注解@GetMapping("/cms/page/get/{id}")，指定调用的url，Feign将根据url进行远程调用。

##### 6.Feign注意点

SpringCloud对Feign进行了增强兼容了SpringMVC的注解 ，我们在使用SpringMVC的注解时需要注意：

1、feignClient接口 有参数在参数必须加@PathVariable("XXX")和@RequestParam("XXX")

2、feignClient返回值为复杂对象时其类型必须有无参构造函数。

### 课程预览

#### 需求分析

​	课程预览是为了保证课程发布后的正确性，通过课程预览可以直观的通过课程详情页面看到课程的信息是否正确，通过课程预览看到的页面内容和课程发布后的页面内容是一致的。

下图是课程详情页面的预览图：

![1525416955328](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1525416955328.png)

课程预览所浏览到的页面就是课程详情页面，需要先确定课程详情页面的技术方案后方可确定课程预览的技术方案。

#### 技术需求

​	课程详情页面是向用户展示课程信息的窗口，课程相当于网站的商品，本页面的访问量会非常大。此页面的内容设计不仅要展示出课程核心重要的内容而且用户访问页面的速度要有保证，有统计显示打开一个页面超过4秒用户就走掉了，所以本页面的性能要求是本页面的重要需求。

​	本页面另一个需求就是SEO，要非常有利于爬虫抓取页面上信息，并且生成页面快照，利于用户通过搜索引擎搜索课程信息。

#### 解决方案

如何在保证SEO的前提下提高页面的访问速度 ：

方案1：

​	对于信息获取类的需求，要想提高页面速度就要使用缓存来减少或避免对数据库的访问，从而提高页面的访问速度。下图是使用缓存与不使用缓存的区别

![1525419286559](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1525419286559.png)

此页面为动态页面，会根据课程的不同而不同，方案一采用传统的JavaEE Servlet/jsp的方式在Tomcat完成页面渲染，相比不加缓存速度会有提升。

优点：使用redis作为缓存，速度有提升。

缺点：采用Servlet/jsp动态页面渲染技术，服务器使用Tomcat，面对高并发量的访问存在性能瓶颈。

 

方案2：

​	对于不会频繁改变的信息可以采用页面静态化的技术，提前让页面生成html静态页面存储在nginx服务器，用户直接访问nginx即可，对于一些动态信息可以访问服务端获取json数据在页面渲染。

![1525419817614](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1525419817614.png)

优点：使用Nginx作为web服务器，并且直接访问html页面，性能出色。

缺点：需要维护大量的静态页面，增加了维护的难度。

 

选择方案2作为课程详情页面的技术解决方案，将课程详情页面生成Html静态化页面，并发布到Nginx上。

 #### 技术方案

​	根据要求：课程详情页面采用静态化技术生成Html页面，课程预览的效果要与最终静态化的Html页面内容一致。

​	所以，课程预览功能也采用静态化技术生成Html页面，课程预览使用的模板与课程详情页面模板一致，这样就可以保证课程预览的效果与最终课程详情页面的效果一致。

操作流程：

1、制作课程详情页面模板

2、开发课程详情页面数据模型的查询接口（为静态化提供数据）

3、调用cms课程预览接口通过浏览器浏览静态文件

![1530743308488](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1530743308488.png)

### 课程详情页面静态化

#### 页面内容组成

我们在编写一个页面时需要知道哪些信息是静态信息，哪些信息为动态信息，下图是页面的设计图：

![1525423148437](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1525423148437.png)

打开静态页面，观察每部分的内容。

红色表示动态信息，红色以外表示静态信息。

红色动态信息：表示一个按钮，根据用户的登录状态、课程的购买状态显示按钮的名称及按钮的事件。

包括以下信息内容：

1、课程信息

​	课程标题、价格、课程等级、授课模式、课程图片、课程介绍、课程目录。

2、课程统计信息

​	课程时长、评分、收藏人数

3、教育机构信息

​	公司名称、公司简介

4、教育机构统计信息

​	好评数、课程数、学生人数

5、教师信息

​	老师名称、老师介绍

#### 页面拆分

将页面拆分成如下页面：

1、页头

本页头文件和门户使用的页头为同一个文件。

参考：代码\页面与模板\include\header.html

2、页面尾

本页尾文件和门户使用的页尾为同一个文件。

参考：代码\页面与模板\include\footer.html

3、课程详情主页面

每个课程对应一个文件，命名规则为：课程id.html（课程id动态变化）

模板页面参考：\代码\页面与模板\course\detail\course_main_template.html

4、教育机构页面

每个教育机构对应一个文件，文件的命名规则为：company_info_公司id.html（公司id动态变化）

参考：代码\页面与模板\company\company_info_template.html

5、老师信息页面

每个教师信息对应一个文件，文件的命名规则为：teacher_info_教师id.html（教师id动态变化）

参考：代码\页面与模板\teacher\teacher_info_template01.html

6、课程统计页面

每个课程对应一个文件，文件的命名规则为：course_stat_课程id.json（课程id动态变化）

参考：\代码\页面与模板\stat\course\course_stat_template.json

7、教育机构统计页面

每个教育机构对应一个文件，文件的命名规则为：company_stat_公司id.json（公司id动态变化）

参考：\代码\页面与模板\stat\company\company_stat_template.json

#### 静态页面测试

##### 页面加载思路

打开课程资料中的“静态页面目录”中的课程详情模板页面，研究页面加载的思路。

模板页面路径如下：

```
静态页面目录\static\course\detail\course_main_template.html
```

1、主页面

我们需要在主页面中通过SSI加载：页头、页尾、教育机构、教师信息

2、异步加载课程统计与教育机构统计信息

​	课程统计信息（json）、教育机构统计信息（json）

3、马上学习按钮事件

​      用户点击“马上学习”会根据课程收费情况、课程购买情况执行下一步操作。

##### 静态资源虚拟主机

1、配置静态资源虚拟主机

静态资源虚拟主机负责处理课程详情、公司信息、老师信息、统计信息等页面的请求：

将课程资料中的“静态页面目录”中的目录拷贝到F:/develop/xuecheng/static下

在nginx中配置静态虚拟主机如下：

```
	#学成网静态资源
	server {
		listen       91;
		server_name localhost;
		
		#公司信息
		location /static/company/ {  
			alias   X:/workspace/java/xczx/static/company/;
		} 
		#老师信息
		location /static/teacher/ {  
			alias   X:/workspace/java/xczx/static/teacher/;
		} 
		#统计信息
		location /static/stat/ {  
			alias   X:/workspace/java/xczx/static/stat/;
		} 
		location /course/detail/ {  
			alias   X:/workspace/java/xczx/static/detail/;
		}
	
	}
```

2、通过[www.xuecheng.com](www.xuecheng.com)虚拟主机转发到静态资源

由于课程页面需要通过SSI加载页头和页尾所以需要通过[www.xuecheng.com](www.xuecheng.com)虚拟主机转发到静态资源

配置upstream实现请求转发到资源服务虚拟主机：

```
 
#静态资源服务
 upstream static_server_pool{
server 127.0.0.1:91 weight=10;
 } 
```

在[www.xuecheng.com](www.xuecheng.com)虚拟主机加入如下配置：

```
 
location /static/company/ {  
        proxy_pass http://static_server_pool;
    } 
    location /static/teacher/ {  
        proxy_pass http://static_server_pool;
    } 
    location /static/stat/ {  
        proxy_pass http://static_server_pool;
    } 
    location /course/detail/ {  
        proxy_pass http://static_server_pool;
    } 
```

最终nginx的配置为

```

#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;
	
	#图片服务
	upstream img_server_pool{
		#server 192.168.101.64:80 weight=10; 
		 server 192.168.25.133:80 weight=10;
    }
	
	#cms页面预览
	upstream aaa_pool{
        server 127.0.0.1:31001 weight=10;
    }
	
	#静态资源服务
	upstream static_server_pool{
		server 127.0.0.1:91 weight=10;
	} 
	
    server{
		listen       80;
		server_name  www.xuecheng.com;
		ssi on;
		ssi_silent_errors on;
		location / {
			alias   X:/workspace/java/xczx/static/portal/;
			index  index.html;
		}
		
		#静态资源，包括系统所需要的图片，js、css等静态资源
		location /static/img/ {  
			alias   X:/workspace/java/xczx/static/portal/img/;
		} 
		location /static/css/ {  
			alias   X:/workspace/java/xczx/static/portal/css/;
		} 
		location /static/js/ {  
			alias   X:/workspace/java/xczx/static/portal/js/;
		} 
		location /static/plugins/ {  
			alias   X:/workspace/java/xczx/static/portal/plugins/;
			add_header Access-Control-Allow-Origin http://ucenter.xuecheng.com;  
			add_header Access-Control-Allow-Credentials true;  
			add_header Access-Control-Allow-Methods GET;
		} 
		
		
		#页面预览
		location /cms/preview/ {
				 proxy_pass http://aaa_pool/cms/preview/;
		}
		
		
		location /static/company/ {  
			proxy_pass http://static_server_pool;
		} 
		location /static/teacher/ {  
			proxy_pass http://static_server_pool;
		} 
		location /static/stat/ {  
			proxy_pass http://static_server_pool;
		} 
		location /course/detail/ {  
			proxy_pass http://static_server_pool;
		} 
	}
	
	#学成网图片服务
	server {
	    listen       80;
	    server_name img.xuecheng.com;

	    #个人中心
	    location /group1 {
	        proxy_pass http://img_server_pool;
	    }
	}
	 
	#学成网静态资源
	server {
		listen       91;
		server_name localhost;
		
		#公司信息
		location /static/company/ {  
			alias   X:/workspace/java/xczx/static/company/;
		} 
		#老师信息
		location /static/teacher/ {  
			alias   X:/workspace/java/xczx/static/teacher/;
		} 
		#统计信息
		location /static/stat/ {  
			alias   X:/workspace/java/xczx/static/stat/;
		} 
		location /course/detail/ {  
			alias   X:/workspace/java/xczx/static/course/detail/;
		}

	}


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}

}

```

##### 门户静态资源路径

门户中的一些图片、样式等静态资源统一通过/static路径对外提供服务，在[www.xuecheng.com](www.xuecheng.com)虚拟主机中配置如下：

```
		#静态资源，包括系统所需要的图片，js、css等静态资源
		location /static/img/ {  
			alias   X:/workspace/java/xczx/static/portal/img/;
		} 
		location /static/css/ {  
			alias   X:/workspace/java/xczx/static/portal/css/;
		} 
		location /static/js/ {  
			alias   X:/workspace/java/xczx/static/portal/js/;
		} 
		location /static/plugins/ {  
			alias   X:/workspace/java/xczx/static/portal/plugins/;
			add_header Access-Control-Allow-Origin http://ucenter.xuecheng.com;  
			add_header Access-Control-Allow-Credentials true;  
			add_header Access-Control-Allow-Methods GET;
		} 
```

cors跨域参数：

Access-Control-Allow-Origin：允许跨域访问的外域地址

​	如果允许任何站点跨域访问则设置为*，通常这是不建议的。

Access-Control-Allow-Credentials： 允许客户端携带证书访问

Access-Control-Allow-Methods：允许客户端跨域访问的方法

##### 页面测试

请求：http://www.xuecheng.com/course/detail/course_main_template.html测试课程详情页面模板是否可以正常浏览。

![1525517602416](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/day09-%E8%AF%BE%E7%A8%8B%E9%A2%84%E8%A7%88%20Eureka%20Feign/images/1525517602416.png)

##### 页面动态脚本

为了方便日后的维护，我们将javascript实现的动态部分单独编写一个html 文件,在门户的include目录下定义course_detail_dynamic.html文件，此文件通过ssi包含在课程详情页面中.

文件地址：资料\静态页面目录\include\course_detail_dynamic.html

所有的课程公用一个 页面动态脚本。

在课程详情主页面下端添加如下代码，通过SSI技术包含课程详情页面动态脚本文件：

```
<script>var courseId = "template"</script>
<!--#include virtual="/include/course_detail_dynamic.html"-->
</body>
</html>
```

本页面使用vue.js动态获取信息，vue实例创建的代码如下：

主要查看 created钩子函数的内容。

```
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <script src="/js/vue/vue.min.js"></script>
    <script src="/js/jwt-decode/jwt-decode.min.js"></script>
    <script src="/js/base64.min.js"></script>
    <script src="/js/axios/axios.min.js"></script>
    <script src="/js/querystring/index.js"></script>
    <script src="/js/public.js"></script>
    <script src="/js/order.js"></script>
    <script src="/js/util.js"></script>
    <script src="/css/el/index.js"></script>
    <style>
        [v-cloak] {
            display: none;
        }
    </style>
</head>
<body >
<!-- 页面 css js -->
<script type="text/javascript" src="/static/plugins/jquery/dist/jquery.js"></script>
<script type="text/javascript" src="/static/plugins/bootstrap/dist/js/bootstrap.js"></script>
<script>
    $('.vid-act').click(function() {
        $(this).find('.i-heart').css('background-position', '4px -55px')
    })


    $(function() {
        //点击下拉
        //用法：HTML 点击事件为more,父级使用overflow：hidden；限定高 more与要展开的内容为同级 要展开内容添加 drop-down的class
        function ckMove(target, ckgar, het, text, incr) {
            var inc = incr ? incr : 0;
            $(target).find(ckgar).on('click', function() {
                var h = $(this).parent().find('.drop-down ul').height();
                if (!$(this).hasClass('act')) {
                    $(this).addClass('act');
                    $(this).parent().find('.drop-down').css({
                        'height': (h + inc) + 'px'
                    });
                    $(this).find('i').removeClass('i-chevron-bot').addClass('i-chevron-top')
                } else {
                    $(this).removeClass('act');
                    $(this).parent().find('.drop-down').css({
                        'height': het + 'px'
                    });
                    $(this).find('i').removeClass('i-chevron-top').addClass('i-chevron-bot')
                }
            })
        }
        //章节收缩
        ckMove('.article-cont .article-left-box', '.title', 0);

        /* $('.learing-box .item-list').mouseover(function(e) {
         $(this).css({
         'height': '140px'
         }).addClass('hov').siblings().css({
         'height': '50px'
         })
         $(this).siblings().removeClass('hov')
         })
         $('.learing-box .item-box').mouseout(function() {
         $(this).find('.item-list:first').css({
         'height': '140px'
         }).addClass('hov')
         $(this).find('.item-list:first').siblings().css({
         'height': '50px'
         }).removeClass('hov')
         })*/
    })


    /*$(function() {
     $('.learing-box .item-list').mouseover(function(e) {
     $(this).css({
     'height': '140px'
     }).addClass('hov').siblings().css({
     'height': '50px'
     })
     $(this).siblings().removeClass('hov')
     })
     $('.learing-box .item-box').mouseout(function() {
     $(this).find('.item-list:first').css({
     'height': '140px'
     }).addClass('hov')
     $(this).find('.item-list:first').siblings().css({
     'height': '50px'
     }).removeClass('hov')
     })
     })*/


    $(function() {
        $('.active-box span').click(function() {
            $(this).css({
                'color': '#00a4ff'
            })
            if ($(this).find('i').hasClass('i-laud')) {
                $(this).find('.i-laud').css('background-position', '-80px -19px')
            } else if ($(this).find('i').hasClass('i-coll')) {
                $(this).find('.i-coll').css('background-position', '1px -75px')
            }
        })
        /*$('.learing-box .item-list').mouseover(function(e) {
         $(this).css({
         'height': '140px'
         }).addClass('hov').siblings().css({
         'height': '50px'
         })
         $(this).siblings().removeClass('hov')
         })
         $('.learing-box .item-box').mouseout(function() {
         $(this).find('.item-list:first').css({
         'height': '140px'
         }).addClass('hov')
         $(this).find('.item-list:first').siblings().css({
         'height': '50px'
         }).removeClass('hov')
         })*/
    })


    $(function() {
        //评分
        $('.star .score').map(function(n, i) {
            var x = Number($(this).find('i').text());
            var w = 109 * (1 - x / 5);
            $(this).css('width', w + 'px');
        })
        //评论打分
        $('.evaluate .star').mousemove(function(e) {
            var startX = $(this).offset().left;
            var movX = e.clientX - startX + 0.5;
            var w = 145 * (1 - movX / 145);
            $(this).find('.score').css('width', w + 'px');
            $('.star-score i').text((movX / 145 * 5).toFixed(1))
        })
        //星级评分
        $('.grade').map(function(n, i) {
            var pret = $(this).find('.percent-num i').text();
            var wt = $(this).find('.grade-percent').width();
            $(this).find('.grade-percent span').css('width', wt * pret / 100);
        })



    })


    $(function() {
        //点击下拉
        function ckMove(target, het, text, incr) {
            var inc = incr ? incr : 0;
            $(target).find('.on-off').on('click', function() {
                var h = $(this).parent().find('.drop-down p').height();
                if (!$(this).hasClass('act')) {
                    $(this).addClass('act');
                    $(this).parent().find('.drop-down').css({
                        'height': (h + inc) + 'px'
                    });
                    $(this).find('i').removeClass('i-chevron-bot').addClass('i-chevron-top')
                } else {
                    $(this).removeClass('act');
                    $(this).parent().find('.drop-down').css({
                        'height': het + 'px'
                    });
                    $(this).find('i').removeClass('i-chevron-top').addClass('i-chevron-bot')
                }
            })
        }
        ckMove('.cktop', 60);
        ckMove('.cont .item', 0);
        //点击关闭弹窗
        $('.close-popup').click(function() {
            $('.popup-box').hide();
        })
        $('.tit-list a').click(function() {
            $(this).addClass('active').siblings().removeClass('active');
            var clasNod = '.' + $(this)[0].id
            $(clasNod).show().siblings().hide()
        })
        // 资料下载
        $('.down-fill span').click(function() {
            $('.down-fill ul').css({
                display: 'block'
            });
        })
        $('.down-fill ul li').click(function() {
            $('.down-fill ul').css({
                display: 'none'
            });
        })
    })
</script>
<script>

   var body= new Vue({   //创建一个Vue的实例
        el: "#body", //挂载点是id="app"的地方

        data: {
            editLoading: false,
            title:'测试',
            courseId:'',
            charge:'',//203001免费,203002收费
            learnstatus:0,//课程状态，1：马上学习，2：立即报名、3：立即购买
            course:{},
            companyId:'template',
            company_stat:[],
            course_stat:{"s601001":"","s601002":"","s601003":""}


        },
        methods: {
            //学习报名
            addopencourse(){
                let activeUser= checkActiveUser();
                if(activeUser){
                    addOpencourse(this.courseId).then((res) => {
                        if(res.success){//报名成功
                            this.$message.success('报名成功');
                            this.getLearnstatus()
                        }else if(res.message){
                            this.$message.error(res.message);
                        }else{
                            this.$message.error('报名失败，请刷新页面重试!');
                        }
                    })
                }else{
                    //弹出登录框架
                    headVm.showlogin()
                }
            },
            //立即购买
            buy(){
                let activeUser= getActiveUser();
                if(activeUser){
                    $('.popup-box').show()
                }else{
                    //弹出登录框架
                    headVm.showlogin()
                }

            },
            createOrder(){
                createOrder(this.courseId).then((res) => {
                        this.editLoading = false;
                        if(res.success){
                            this.$message.success('订单创建成功');
                            //跳转到支付页面
                            window.location = "http://ucenter.xuecheng.com/#/pay/"+res.xcOrders.orderNumber
                        }else{
                            if(res.message){
                                this.$message.error(res.message);
                            }else{
                                this.$message.error('订单创建失败，请刷新页面重试');
                            }
                        }
                    },
                    (res) => {
                        this.editLoading = false;
                    });
            },
            getLearnstatus(){//获取学习状态
                //初始学习状态
                //根据课程收费判断
                if(this.charge == '203001'){
                    this.learnstatus = 2 //免费，报名后即可学习
                }else{
                    this.learnstatus = 3 //收费，需要购买后可学习
                }
                //如果用户登录判断该用户的学习状态
                let activeUser= getActiveUser();
                if(activeUser){
                    //判断学生的选课状态
                    /*queryLearnstatus(this.courseId).then((res)=>{
                        console.log(res)
                        if(res.success){
                            if(res.status == '501001'){//正常
                                this.learnstatus = 1 //选课状态正常，立即学习
                            }
                        }
                    })*/
                }
            }

        },
       created() {
           this.courseId = courseId;
           this.charge = charge
           this.getLearnstatus();
           //获取教育机构的统计数据
           queryCompanyStat(this.companyId).then((res)=>{
               console.log(res)
               if(res.stat){
                   this.company_stat = res.stat
                   console.log(this.company_stat)
               }

           })
           //获取课程的统计数据
           queryCourseStat(this.courseId).then((res)=>{
               console.log(res)
               if(res.stat){
                   let stat = res.stat
                  for(var i=0;i<stat.length;i++){
                      this.course_stat['s'+stat[i].id] = stat[i].value
                  }
               }
               console.log(this.course_stat)

           })


        },
        mounted(){
           // alert(courseId)

        }
    })
</script>
</body>
</html>

```

#### 课程详情数据

​	静态化操作需要模型数据方可进行静态化，课程数据模型由课程管理服务提供，仅供课程静态化程序调用使用。

##### 1.接口定义

1、响应结果类型

在xc-framework-model模块com.xuecheng.framework.domain.course.ext包下创建

```
@Data
@ToString
@NoArgsConstructor
public class CourseView  implements Serializable  {
    CourseBase courseBase;//基础信息
    CourseMarket courseMarket;//课程营销
    CoursePic coursePic;//课程图片
    TeachplanNode TeachplanNode;//教学计划

}
```

2、请求类型

String：课程id



3、接口定义如下

```
    @ApiOperation("课程预览数据查询")
    public CourseView courseview(String id);
```

##### 2.Dao

在xc-service-manage-course模块创建Dao

需要对course_base、course_market、course_pic、teachplan等信息进行查询，

 新建课程营销的dao，其它dao已经存在不用再建。

```
public interface CourseMarketRepository extends JpaRepository<CourseMarket, String> {
}
```

##### 3.Service

```
    //课程视图查询
    public CourseView getCoruseView(String id) {
        CourseView courseView = new CourseView();
        //查询课程基本信息
        Optional<CourseBase> optional = courseBaseRepository.findById(id);
        if(optional.isPresent()){
            CourseBase courseBase = optional.get();
            courseView.setCourseBase(courseBase);
        }
        //查询课程营销信息
        Optional<CourseMarket> courseMarketOptional = courseMarketRepository.findById(id);
        if(courseMarketOptional.isPresent()){
            CourseMarket courseMarket = courseMarketOptional.get();
            courseView.setCourseMarket(courseMarket);
        }
        //查询课程图片信息
        Optional<CoursePic> picOptional = coursePicRepository.findById(id);
        if(picOptional.isPresent()){
            CoursePic coursePic = picOptional.get();
            courseView.setCoursePic(picOptional.get());
        }
        //查询课程计划信息
        TeachplanNode teachplanNode = teachplanMapper.selectList(id);
        courseView.setTeachplanNode(teachplanNode);
        return courseView;
    }
```

##### 4.Controller

```
    @Override
    @GetMapping("/courseview/{id}")
    public CourseView courseview(@PathVariable("id") String id) {
        return courseService.getCoruseView(id);
    }
```

##### 5.测试

使用swagger-ui或postman测试本接口。

#### 课程详情模板

##### 1.模板内容

```
<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <meta name="description" content="">
    <meta name="author" content="">
    <meta http-equiv="pragma" content="no-cache" />
    <meta http-equiv="content-type" content="no-cache, must-revalidate" />
    <title>在线教育网--${courseBase.name}</title>
</head>
<body data-spy="scroll" data-target="#articleNavbar" data-offset="150">
<!-- 页面头部 -->
<!--#include virtual="/include/header.html"-->
<div id="body">
<!--页面头部结束sss-->
<div class="article-banner">
    <div class="banner-bg"></div>
    <div class="banner-info">
        <div class="banner-left">
            <p class="tit">${courseBase.name}</p>
            <p class="pic"><span class="new-pic">特惠价格￥${(courseMarket.price)!""}</span> <span class="old-pic">原价￥${(courseMarket.price_old)!""}</span></p>
            <p class="info">
                <a href="http://ucenter.xuecheng.com/#/learning/${courseBase.id}/0"  target="_blank" v-if="learnstatus == 1" v-cloak>马上学习</a>
                <a href="#"  @click="addopencourse" v-if="learnstatus == 2" v-cloak>立即报名</a>
                <a href="#"  @click="buy" v-if="learnstatus == 3" v-cloak>立即购买</a>
                <span><em>难度等级</em>
		 <#if courseBase.grade=='200001'>
		低级
                <#elseif courseBase.grade=='200002'>
		中级
		 <#elseif courseBase.grade=='200003'>
		高级
		</#if>
                </span>
                <span><em>课程时长</em><stat v-text="course_stat.s601001"></stat>
                </span>
                <span><em>评分</em><stat v-text="course_stat.s601002"></stat></span>
                <span><em>授课模式</em>
                  <#if courseBase.studymodel=='201001'>
		自由学习
                <#elseif courseBase.studymodel=='201002'>
		任务式学习
		</#if>
                </span>
            </p>
        </div>
        <div class="banner-rit">
	    
	    <#if (coursePic.pic)??>
	     <p><img src="http://img.xuecheng.com/${coursePic.pic}" alt="" width="270" height="156"> </p>
	     <#else>
		 <p><img src="/static/img/widget-video.png" alt="" width="270" height="156"> </p>
	    </#if>
           
            <p class="vid-act"><span> <i class="i-heart"></i>收藏 <stat v-text="course_stat.s601003"></stat> </span> <span>分享 <i class="i-weixin"></i><i class="i-qq"></i></span></p>
        </div>
    </div>
</div>
<div class="article-cont">
    <div class="tit-list">
        <a href="javascript:;" id="articleClass" class="active">课程介绍</a>
        <a href="javascript:;" id="articleItem">目录</a>
        <!--<a href="javascript:;" id="artcleAsk">问答</a>-->
        <!--<div class="down-fill">
            <span>资料下载</span>
            <ul>
                <li>java视频资料</li>
                <li>java视频资料</li>
                <li>java视频资料</li>
            </ul>
        </div>-->
    </div>
    <div class="article-box">
        <div class="articleClass" style="display: block">
            <!--<div class="rit-title">评价</div>-->
            <div class="article-cont">
                <div class="article-left-box">
                    <div class="content">

                        <div class="content-com suit">
                            <div class="title"><span>适用人群</span></div>
                            <div class="cont cktop">
                                <div >
                                    <p>${(courseBase.users)!""}</p>
                                </div>
                                <!--<span class="on-off">更多 <i class="i-chevron-bot"></i></span>-->
                            </div>
                        </div>
                        <div class="content-com course">
                            <div class="title"><span>课程制作</span></div>
                            <!--#include virtual="/teacher/teacher_info_template01.html"-->

                        </div>
                        <div class="content-com about">
                            <div class="title"><span>课程介绍</span></div>
                            <div class="cont cktop">
                                <div >
                                    <p>${(courseBase.description)!""}</p>
                                </div>
                                <!--<span class="on-off">更多 <i class="i-chevron-bot"></i></span>-->
                            </div>
                        </div>
                        <div class="content-com prob">
                            <div class="title"><span>常见问题</span></div>
                            <div class="cont">
                                <ul>
                                    <li class="item"><span class="on-off"><i class="i-chevron-bot"></i> 我什么时候能够访问课程视频与作业？</span>
                                        <div class="drop-down">
                                            <p>课程安排灵活，课程费用支付提供180天全程准入和资格证书。自定进度课程建议的最后期限，但你不会受到惩罚错过期限，只要你赚你的证书在180天内。以会话为基础的课程可能要求你在截止日期前保持正轨，但如果你落后了，你可以切换到以后的会议，你完成的任何工作将与你转移。</p>
                                        </div>
                                    </li>
                                    <li class="item"><span class="on-off"><i class="i-chevron-bot"></i> 如何需要额外的时间来完成课程会怎么样？</span>
                                        <div class="drop-down">
                                            <p>课程安排灵活，课程费用支付提供180天全程准入和资格证书。自定进度课程建议的最后期限，但你不会受到惩罚错过期限，只要你赚你的证书在180天内。以会话为基础的课程可能要求你在截止日期前保持正轨，但如果你落后了，你可以切换到以后的会议，你完成的任何工作将与你转移。</p>
                                        </div>
                                    </li>
                                    <li class="item"><span class="on-off"><i class="i-chevron-bot"></i> 我支付次课程之后会得到什么？</span>
                                        <div class="drop-down">
                                            <p>课程安排灵活，课程费用支付提供180天全程准入和资格证书。自定进度课程建议的最后期限，但你不会受到惩罚错过期限，只要你赚你的证书在180天内。以会话为基础的课程可能要求你在截止日期前保持正轨，但如果你落后了，你可以切换到以后的会议，你完成的任何工作将与你转移。</p>
                                        </div>
                                    </li>
                                    <li class="item"><span class="on-off"><i class="i-chevron-bot"></i> 退款条例是如何规定的？</span>
                                        <div class="drop-down">
                                            <p>课程安排灵活，课程费用支付提供180天全程准入和资格证书。自定进度课程建议的最后期限，但你不会受到惩罚错过期限，只要你赚你的证书在180天内。以会话为基础的课程可能要求你在截止日期前保持正轨，但如果你落后了，你可以切换到以后的会议，你完成的任何工作将与你转移。</p>
                                        </div>
                                    </li>
                                    <li class="item"><span class="on-off"><i class="i-chevron-bot"></i> 有助学金？</span>
                                        <div class="drop-down">
                                            <p>课程安排灵活，课程费用支付提供180天全程准入和资格证书。自定进度课程建议的最后期限，但你不会受到惩罚错过期限，只要你赚你的证书在180天内。以会话为基础的课程可能要求你在截止日期前保持正轨，但如果你落后了，你可以切换到以后的会议，你完成的任何工作将与你转移。</p>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="article-right-box">
                    <div class="about-teach">
                        <!--机构信息-->
                        <!--#include virtual="/company/company_info_template.html"-->

                    </div>
                    <div class="learing-box">
                        <div class="tit">看过该课的同学也在看</div>
                        <div class="item-box">
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Linux 达人养成记</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Linux 达人养成记</a>
                                </div>
                            </div>
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Redis从入门到精通</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Redis从入门到精通</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

            </div>
        </div>
        <div class="articleItem" style="display: none">
            <div class="article-cont-catalog">
                <div class="article-left-box">
                    <div class="content">
			<#if (teachplanNode.children)??>
                            <#list teachplanNode.children as firstNode>
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>${firstNode.pname}</div>
                                    <div class="about">${firstNode.description!}</div>
                                    <div class="drop-down" style="height: ${firstNode.children?size * 50}px;">
                                        <ul class="list-box">
                                            <#list firstNode.children as secondNode>
                                                <li>${secondNode.pname}</li>
                                            </#list>
                                        </ul>
                                    </div>
                                </div>
                            </#list>
                        </#if>
				<!--
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>计算机原理<span class="time">8小时</span></div>
                                    <div class="about"></div>
                                    <div class="drop-down" style="height: 100px;">
                                        <ul class="list-box">
                                                <li>计算机硬件 <span>66’15”</span></li>
                                                <li>计算机软件 <span>66’15”</span></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>计算机编程入门<span class="time">8小时</span></div>
                                    <div class="about"></div>
                                    <div class="drop-down" style="height: 100px;">
                                        <ul class="list-box">
                                                <li>java语法介绍 <span>66’15”</span></li>
                                                <li>Hello World <span>66’15”</span></li>
                                        </ul>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>数据库编程<span class="time">8小时</span></div>
                                    <div class="about"></div>
                                    <div class="drop-down" style="height: 0px;">
                                        <ul class="list-box">
                                        </ul>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>操作系统原理<span class="time">8小时</span></div>
                                    <div class="about"></div>
                                    <div class="drop-down" style="height: 100px;">
                                        <ul class="list-box">
                                                <li>操作系统原理 <span>66’15”</span></li>
                                                <li>操作系统类型介绍 <span>66’15”</span></li>
                                        </ul>
                                    </div>
                                </div>
				-->
                    </div>
                </div>
                <div class="article-right-box">
                    <div class="about-teach">
                        <!--机构信息-->
                        <!--#include virtual="/company/company_info_template.html"-->
                    </div>
                    <div class="learing-box">
                        <div class="tit">看过该课的同学也在看</div>
                        <div class="item-box">
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Linux 达人养成记</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Linux 达人养成记</a>
                                </div>
                            </div>
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Redis从入门到精通</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Redis从入门到精通</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="artcleAsk" style="display: none">
            <div class="article-cont-ask">
                <div class="article-left-box">
                    <div class="content">
                        <div class="content-title">
                            <p><a class="all">全部</a><a>精选</a><a>我的</a></p>
                            <p><a class="all">全部</a><span><a>1.1</a><a>1.2</a><a>1.3</a><a>1.4</a><a>1.5</a></span><a href="$" class="more">更多 <i class="i-chevron-bot"></i></a></p>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p><span>我来回答</span></p>
                                <p>2017-3-20 <span><i></i>回答2</span><span><i></i>浏览2</span></p>
                            </div>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p>在讨论如何将重构转化为微服务之前，退后一步，仔细观察微服务的内容和时间是很重要的。以下两个要点将会对任何微服务重构策略产生重大影响。 【最新 <i class="new">心跳347890</i> 的回答】</p>
                                <p>2017-3-20 <span class="action-box"><span><i class="i-answer"></i>回答 2</span><span><i class="i-browse"></i>浏览 12</span></span>
                                </p>
                            </div>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p>在讨论如何将重构转化为微服务之前，退后一步，仔细观察微服务的内容和时间是很重要的。以下两个要点将会对任何微服务重构策略产生重大影响。 【最新 <i class="new">心跳347890</i> 的回答】</p>
                                <p>2017-3-20 <span class="action-box"><span><i class="i-answer"></i>回答 2</span><span><i class="i-browse"></i>浏览 12</span></span>
                                </p>
                            </div>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p>在讨论如何将重构转化为微服务之前，退后一步，仔细观察微服务的内容和时间是很重要的。以下两个要点将会对任何微服务重构策略产生重大影响。 【最新 <i class="new">心跳347890</i> 的回答】</p>
                                <p>2017-3-20 <span class="action-box"><span><i class="i-answer"></i>回答 2</span><span><i class="i-browse"></i>浏览 12</span></span>
                                </p>
                            </div>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p>在讨论如何将重构转化为微服务之前，退后一步，仔细观察微服务的内容和时间是很重要的。以下两个要点将会对任何微服务重构策略产生重大影响。 【最新 <i class="new">心跳347890</i> 的回答】</p>
                                <p>2017-3-20 <span class="action-box"><span><i class="i-answer"></i>回答 2</span><span><i class="i-browse"></i>浏览 12</span></span>
                                </p>
                            </div>
                        </div>
                        <div class="item">
                            <div class="item-left">
                                <p><img src="/static/img/widget-myImg.jpg" width="60px" alt=""></p>
                                <p>毛老师</p>
                            </div>
                            <div class="item-right">
                                <p class="title">如何用微服务重构应用程序?</p>
                                <p>在讨论如何将重构转化为微服务之前，退后一步，仔细观察微服务的内容和时间是很重要的。以下两个要点将会对任何微服务重构策略产生重大影响。 【最新 <i class="new">心跳347890</i> 的回答】</p>
                                <p>2017-3-20 <span class="action-box"><span><i class="i-answer"></i>回答 2</span><span><i class="i-browse"></i>浏览 12</span></span>
                                </p>
                            </div>
                        </div>

                        <div class="itemlast">
                            <a href="#" class="overwrite">显示更多问题</a>
                        </div>
                    </div>
                </div>
                <div class="article-right-box">
                    <div class="about-teach">
                        <div class="teach-info">
                            <!--机构logo-->
                            <img src="/static/img/asset-logo.png" width="40px" alt="">
                            <p>北京传智播客教育集团</p>
                        </div>
                        <div class="teach-info">
                            <ul class="tree-list">
                                <li><p class="item-tt">好评度</p><span class="item-num">  97%  </span></li>
                                <li><p class="item-tt">课程数</p><span class="item-num js-item-num" >234</span></li>
                                <li><p class="item-tt">学生数</p><span class="item-num js-item-num" >78383</span></li>
                            </ul>
                        </div>
                        <div class="teach-info">
                            <p><a href="#" class="courselist_link">TA的课程</a></p>
                        </div>

                        <p class="synopsis">传智播客是一家专门致力于高素质软件开发人才培养的高科技公司。传智播客致力于为企业优选一流的人才的培训理念，以“学员自学入门教程，通过基础考核后进行强化培训”为招生原则，以“针对企业需求，重视基础理论建设，强化高端应用技能”为教学目标，以“高薪保证强大的资深教育团队”为教学后盾，彻底解决所有培训学员的后顾之忧，并解决用人企业难以招聘到合格人才的困扰。</p>
                    </div>
                    <div class="learing-box">
                        <div class="tit">看过该课的同学也在看</div>
                        <div class="item-box">
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Linux 达人养成记</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Linux 达人养成记</a>
                                </div>
                            </div>
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Redis从入门到精通</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Redis从入门到精通</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="artcleCod" style="display: none;">
            <div class="article-cont">
                <div class="article-left-box">
                    <div class="comment-box">
                        <div class="evaluate">
                            <div class="eva-top">
                                <div class="tit">课程评分 </div>
                                <div class="star">
                                    <div class="score"><i>5</i></div>
                                </div><span class="star-score"> <i>5</i> 分</span></div>
                            <div class="eva-cont">
                                <div class="tit">学员评语 </div>
                                <div class="text-box">
                                    <textarea class="form-control" rows="5" placeholder="扯淡、吐槽、表扬、鼓励......想说啥说啥！"></textarea>
                                    <div class="text-right"><span>发表评论</span></div>
                                </div>
                            </div>
                        </div>
                        <div class="course-evaluate">
                            <div class="top-tit">评论
                                    <span>
                        <label><input name="eval" type="radio" value="" checked /> 所有学生 </label>
                        <label><input name="eval" type="radio" value="" /> 完成者 </label>
                    </span>
                            </div>
                            <div class="top-cont">
                                <div class="cont-top-left">
                                    <div class="star-scor">
                                        <div class="star-show">
                                            <div class="score"><i>5</i></div>
                                        </div>
                                        <div class="scor">4.9分</div>
                                    </div>
                                    <div class="all-scor">总评分：12343</div>
                                </div>
                                <div class="cont-top-right">
                                    <div class="star-grade">五星
                                        <div class="grade">
                                            <div class="grade-percent"><span></span></div>
                                            <div class="percent-num"><i>95</i>%</div>
                                        </div>
                                    </div>
                                    <div class="star-grade">四星
                                        <div class="grade">
                                            <div class="grade-percent"><span></span></div>
                                            <div class="percent-num"><i>5</i>%</div>
                                        </div>
                                    </div>
                                    <div class="star-grade">三星
                                        <div class="grade">
                                            <div class="grade-percent"><span></span></div>
                                            <div class="percent-num"><i>0</i>%</div>
                                        </div>
                                    </div>
                                    <div class="star-grade">二星
                                        <div class="grade">
                                            <div class="grade-percent"><span></span></div>
                                            <div class="percent-num"><i>2</i>%</div>
                                        </div>
                                    </div>
                                    <div class="star-grade">一星
                                        <div class="grade">
                                            <div class="grade-percent"><span></span></div>
                                            <div class="percent-num"><i>1</i>%</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="comment-item-box">
                                <div class="title">评论 <span>12453条评论</span></div>
                                <div class="item">
                                    <div class="item-left">
                                        <p><img src="/static/img/widget-pic.png" width="60px" alt=""></p>
                                        <p>毛老师</p>
                                    </div>
                                    <div class="item-cent">
                                        <p>很受用，如果再深入下就更好了。虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！</p>
                                        <p class="time">2017-2-43</p>
                                    </div>
                                    <div class="item-rit">
                                        <p>
                                        <div class="star-show">
                                            <div class="score"><i>4</i></div>
                                        </div>
                                        </p>
                                        <p>评分 <span>5星</span></p>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="item-left">
                                        <p><img src="/static/img/widget-pic.png" width="60px" alt=""></p>
                                        <p>毛老师</p>
                                    </div>
                                    <div class="item-cent">
                                        <p>很受用，如果再深入下就更好了。虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！</p>
                                        <p class="time">2017-2-43</p>
                                    </div>
                                    <div class="item-rit">
                                        <p>
                                        <div class="star-show">
                                            <div class="score"><i>5</i></div>
                                        </div>
                                        </p>
                                        <p>评分 <span>5星</span></p>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="item-left">
                                        <p><img src="/static/img/widget-pic.png" width="60px" alt=""></p>
                                        <p>毛老师</p>
                                    </div>
                                    <div class="item-cent">
                                        <p>很受用，如果再深入下就更好了。虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！</p>
                                        <p class="time">2017-2-43</p>
                                    </div>
                                    <div class="item-rit">
                                        <p>
                                        <div class="star-show">
                                            <div class="score"><i>5</i></div>
                                        </div>
                                        </p>
                                        <p>评分 <span>5星</span></p>
                                    </div>
                                </div>
                                <div class="item">
                                    <div class="item-left">
                                        <p><img src="/static/img/widget-pic.png" width="60px" alt=""></p>
                                        <p>毛老师</p>
                                    </div>
                                    <div class="item-cent">
                                        <p>很受用，如果再深入下就更好了。虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！虽然都是入门级别的，但是也很使用，后续就需要自己发挥了！</p>
                                        <p class="time">2017-2-43</p>
                                    </div>
                                    <div class="item-rit">
                                        <p>
                                        <div class="star-show">
                                            <div class="score"><i>5</i></div>
                                        </div>
                                        </p>
                                        <p>评分 <span>5星</span></p>
                                    </div>
                                </div>
                                <div class="get-more">页面加载中...</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="article-right-box">
                    <div class="about-teach">
                        <div class="teach-info">
                            <!--机构logo-->
                            <img src="/static/img/asset-logo.png" width="40px" alt="">
                            <p>北京传智播客教育集团</p>
                        </div>
                        <div class="teach-info">
                            <ul class="tree-list">
                                <li><p class="item-tt">好评度</p><span class="item-num">  97%  </span></li>
                                <li><p class="item-tt">课程数</p><span class="item-num js-item-num" >234</span></li>
                                <li><p class="item-tt">学生数</p><span class="item-num js-item-num" >78383</span></li>
                            </ul>
                        </div>
                        <div class="teach-info">
                            <p><a href="#" class="courselist_link">TA的课程</a></p>
                        </div>

                        <p class="synopsis">传智播客是一家专门致力于高素质软件开发人才培养的高科技公司。传智播客致力于为企业优选一流的人才的培训理念，以“学员自学入门教程，通过基础考核后进行强化培训”为招生原则，以“针对企业需求，重视基础理论建设，强化高端应用技能”为教学目标，以“高薪保证强大的资深教育团队”为教学后盾，彻底解决所有培训学员的后顾之忧，并解决用人企业难以招聘到合格人才的困扰。</p>
                    </div>
                    <div class="learing-box">
                        <div class="tit">看过该课的同学也在看</div>
                        <div class="item-box">
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Linux 达人养成记</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Linux 达人养成记</a>
                                </div>
                            </div>
                            <div class="item-list hov" >
                                <div class="infobox">
                                    <div class="morebox" style="background: url(/static/img/widget-titBg.png) no-repeat;">

                                        <p class="top-tit"><a href="">Redis从入门到精通</a></p>
                                        <p class="top-lab">传智播客</p>
                                        <p class="top-num">2589646次播放<span>4.8分</span></p>

                                    </div>
                                    <a>Redis从入门到精通</a>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="popup-box" style="display: none">
    <div class="mask"></div>
    <!--欢迎访问课程弹窗- start -->
  <!--  <div class="popup-course-box">
        <div class="title">程序设计语言 <span class="close-popup">×</span></div>
        <div class="content">
            <p>欢迎学习本课程，您现在可以访问课程材料了。</p>
            <p><a href="#">开始学习</a></p>
        </div>
    </div>-->
    <!--欢迎访问课程弹窗- end -->

    <!--支付弹窗- start -->
    <div class="popup-pay-box">
        <div class="title">Bootstrap开发框架 <span class="close-popup">×</span></div>
        <div class="content">
            <img src="./text.png" alt="">
            <div class="info">
                <p class="info-tit">Bootstrap开发框架 <span>课程有效期:2017年9月12日-2018年9月11日</span></p>
                <p class="info-pic">课程价格 : <span>￥98</span></p>
                <p class="info-new-pic">优惠价格 : <span>￥98</span></p>
            </div>
        </div>
       <!-- <div class="fact-pic">实际支付: <span>￥999</span></div>-->
        <div class="go-pay"><a href="#" @click="createOrder" :loading="editLoading"> 确认无误，提交订单</a><!--<a class="addCar" href="">加入购物车</a>--></div>
    </div>
    <!--支付弹窗- end -->
    <div class="popup-comment-box">

    </div>
</div>
<!-- 页面底部 -->
<!--底部版权-->
<!--#include virtual="/include/footer.html"-->

<!--底部版权-->
</div>
<script>var courseId = "${courseBase.id}"</script>
<!--#include virtual="/include/course_detail_dynamic.html"-->
</body>
</html>
```

- 课程基本信息：

```
<div class="banner-left">
            <p class="tit">${courseBase.name}</p>
            <p class="pic"><span class="new-pic">特惠价格￥${courseMarket.price}</span> <span class="old-pic">原价￥${courseMarket.price_old!}</span></p>
            <p class="info">
                <a href="http://ucenter.xuecheng.com/#/learning/${courseBase.id}/0"  target="_blank" v-if="learnstatus == 1" v-cloak>马上学习</a>
                <a href="#"  @click="addopencourse" v-if="learnstatus == 2" v-cloak>立即报名</a>
                <a href="#"  @click="buy" v-if="learnstatus == 3" v-cloak>立即购买</a>
                <span><em>难度等级</em>
		 <#if courseBase.grade=='200001'>
		低级
                <#elseif courseBase.grade=='200002'>
		中级
		 <#elseif courseBase.grade=='200003'>
		高级
		</#if>
                </span>
                <span><em>课程时长</em><stat v-text="course_stat.s601001"></stat>
                </span>
                <span><em>评分</em><stat v-text="course_stat.s601002"></stat></span>
                <span><em>授课模式</em>
                  <#if courseBase.studymodel=='201001'>
		自由学习
                <#elseif courseBase.studymodel=='201002'>
		任务式学习
		</#if>
                </span>
            </p>
        </div>
     <div class="banner-rit">
	    <#if coursePic.pic??>
	     <p><img src="http://img.xuecheng.com/${coursePic.pic}" alt="" width="270" height="156"> </p>
	     <#else>
		 <p><img src="/static/img/widget-video.png" alt="" width="270" height="156"> </p>
	    </#if>
           
            <p class="vid-act"><span> <i class="i-heart"></i>收藏 <stat v-text="course_stat.s601003"></stat> </span> <span>分享 <i class="i-weixin"></i><i class="i-qq"></i></span></p>
        </div>
```

- 课程计划：

```
<div class="content">
			<#if teachplanNode.children??>
                            <#list teachplanNode.children as firstNode>
                                <div class="item">
                                    <div class="title act"><i class="i-chevron-top"></i>${firstNode.pname}</div>
                                    <div class="about">${firstNode.description!}</div>
                                    <div class="drop-down" style="height: ${firstNode.children?size * 50}px;">
                                        <ul class="list-box">
                                            <#list firstNode.children as secondNode>
                                                <li>${secondNode.pname}</li>
                                            </#list>
                                        </ul>
                                    </div>
                                </div>
                            </#list>
               </#if>
				
 </div>
```

- 页头：

局部代码如下：

```
<body data-spy="scroll" data-target="#articleNavbar" data-offset="150">
<!-- 页面头部 -->
<!--#include virtual="/include/header.html"-->
```

- 页尾：

局部代码如下：

```
<!-- 页面底部 -->
<!--底部版权-->
<!--#include virtual="/include/footer.html"-->
```

- 动态脚本文件：

```
<script>
    //课程id
    var courseId = "template"
</script>
<!--#include virtual="/include/course_detail_dynamic.html"-->
```

- 教师信息文件：

从课程数据中获取课程所属的教师Id，这里由于教师信息管理功能没有开发我们使用固定的教师信息文件：

```
<div class="content-com course">
    <div class="title"><span>课程制作</span></div>
    <!--#include virtual="/teacher/teacher_info_template01.html"-->
</div>
```

- 教育机构文件：

同教师信息一样，由于教育机构功能模块没有开发，这里我们使用固定的教育机构文件：

```
<div class="about-teach">
    <!--机构信息-->
    <!--#include virtual="/company/company_info_template.html"-->
</div>
```

##### 2.模板测试

使用test-freemarker工程测试模板

编写模板过程采用test-freemarker工程测试模板。

将course.ftl拷贝到test-freemarker工程的resources/templates下，并在test-freemarker工程的controller中添加测试方法

```
//课程详情页面测试
@RequestMapping("/course")
public String course(Map<String,Object> map){
    ResponseEntity<Map> forEntity = restTemplate.getForEntity("http://localhost:31200/course/courseview/4028e581617f945f01617f9dabc40000", Map.class);
    Map body = forEntity.getBody();
    map.put("model",body);
    return "course";
}
```

注意：上边的测试页面不显示样式，原因是页面通过SSI包含了页面头，而使用test-freemarker工程无法加载页头，测试模板主要查看html页面内容是否正确，待课程预览时解决样式不显示问题。

##### 3.模板保存

模板编写并测试通过后要在数据库保存：

1、模板信息保存在xc_cms数据库(mongodb)的cms_template表

2、模板文件保存在mongodb的GridFS中。

 

第一步：将模板文件上传到GridFS中

由于本教学项目中模板管理模块没有开发，所以我们使用Junit代码向GridFS中保存：