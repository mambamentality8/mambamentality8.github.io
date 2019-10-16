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

两次shift搜索类RibbonLoadBalancerClient并且在57行打上断点