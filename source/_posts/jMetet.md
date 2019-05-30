---


title: springboot
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
description: springboot
image:
---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/title.jpg">

<!-- more -->

### 常用压力测试工具对比

- loadrunner

```
性能稳定，压测结果及细粒度大，可以自定义脚本进行压测，但是太过于重大，功能比较繁多
```

- apache ab(单接口压测最方便)

```
模拟多线程并发请求,ab命令对发出负载的计算机要求很低，既不会占用很多CPU，也不会占用太多的内存，但却会给目标服务器造成巨大的负载, 简单DDOS攻击等
```

- webbench

  ```
webbench首先fork出多个子进程，每个子进程都循环做web访问测试。子进程把访问的结果通过pipe告诉父进程，父进程做最终的统计结果。
  ```

  


## JMeter基础知识讲解和压测实操

- 官方文档

 ```
http://jmeter.apache.org/
 ```

  

- 压测不同的协议和应用

```
1) Web - HTTP, HTTPS (Java, NodeJS, PHP, ASP.NET, …)
2) SOAP / REST Webservices
3) FTP
4) Database via JDBC
5) LDAP  轻量目录访问协议
6) Message-oriented middleware (MOM) via JMS
7) Mail - SMTP(S), POP3(S) and IMAP(S)
8) TCP等等
```

- 使用场景及优点

```
        1）功能测试
        2）压力测试
        3）分布式压力测试
        4）纯java开发
        5）上手容易，高性能
        4）提供测试数据分析
        5）各种报表数据图形展示

```

### 本地快速安装Jmeter4.x

- 需要安装JDK8。或者JDK9,JDK10

- 快速下载

  ```
  windows：
  http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-jmeter-4.0.zip
  ```

  ```
  mac或者linux：http://mirrors.tuna.tsinghua.edu.cn/apache//jmeter/binaries/apache-          jmeter-4.0.tgz
  ```

- 建议安装JDK环境，虽然JRE也可以，但是压测https需要JDK里面的 keytool工具


### Jmeter目录文件讲解

- 目录

```
bin:核心可执行文件，包含配置
    jmeter.bat: windows启动文件
    jmeter: mac或者linux启动文件
    jmeter-server：mac或者Liunx分布式压测使用的启动文件
    jmeter-server.bat：windows分布式压测使用的启动文件
    jmeter.properties: 核心配置文件   

extras：插件拓展的包

lib:核心包
    ext:核心包
    junit:单元测试包
```



### Jmeter语言版本中英文切换

- 临时中文重启恢复

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/01.png)



- 永久中文

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/02.png)

```
bin目录 -> jmeter.properties

默认 #language=en

改为 language=zh_CN 
```

### 使用SpringBoot 2.0快速编写API测试接口

**使用java的框架springBoot快速编写几个API接口测试**

<https://start.spring.io/>

首先在利用官方文档上写一个helloworld,只用一个get接口肯定不行,所以在controller层做如下修改:

```
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class HelloController {

    @RequestMapping(value = "users", method = RequestMethod.GET)
    public @ResponseBody Object users() {
        List<String> userList = new ArrayList<>();
        userList.add("tom");
        userList.add("marry");
        userList.add("jack");
        
        return userList;
    }


    @RequestMapping(value = "login", method = RequestMethod.POST)
    public @ResponseBody Object login(String name, String pwd) {

        Map<String, Object> map = new HashMap<>();
        if("123".equals(pwd) && "jack".equals(name)){
            map.put("status", 0);
        } else {
            map.put("status", -1);
        }
      
        return map;
    }


    /**
     * 用户自定义变量测试
     */
    @RequestMapping(value = "info", method = RequestMethod.GET)
    public @ResponseBody Object info(String name, String pwd) {
        List<String> userList = new ArrayList<>();
        userList.add(name);
        userList.add(pwd);
        userList.add(name.length()+"");
        System.out.println("get request, info api");
        return userList;
    }


}
```

将应用在本地跑起来,访问<http://localhost:8080/users>

```
[
"tom",
"marry",
"jack"
]
```

能够看到返回的list则证明本地部署成功





![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/03.png)

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/04.png)

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/05.png)

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/06.png)

- 在要测试的代码中进行日志打点处理


```
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
@RestController
public class HelloController {

    @RequestMapping(value = "users", method = RequestMethod.GET)
    public @ResponseBody Object users() {
        List<String> userList = new ArrayList<>();
        userList.add("tom");
        userList.add("marry");
        userList.add("jack");
        System.out.println("get request, users api");
        return userList;
    }


    @RequestMapping(value = "login", method = RequestMethod.POST)
    public @ResponseBody Object login(String name, String pwd) {

        Map<String, Object> map = new HashMap<>();
        if("123".equals(pwd) && "jack".equals(name)){
            map.put("status", 0);
        } else {
            map.put("status", -1);
        }
        System.out.println("get request, login api");
        return map;
    }


    /**
     * 用户自定义变量测试
     */
    @RequestMapping(value = "info", method = RequestMethod.GET)
    public @ResponseBody Object info(String name, String pwd) {
        List<String> userList = new ArrayList<>();
        userList.add(name);
        userList.add(pwd);
        userList.add(name.length()+"");
        System.out.println("get request, info api");
        return userList;
    }

}
```

### Jmeter基础功能组件介绍线程组和Sampler

- 添加->threads->线程组（控制总体并发）

```
线程数：虚拟用户数。一个虚拟用户占用一个进程或线程
		
准备时长（Ramp-Up Period(in seconds)）：全部线程启动的时长，比如100个线程，20秒，则表示20秒内	 100个线程都要启动完成，每秒启动5个线程

循环次数：每个线程发送的次数，假如值为5，100个线程，则会发送500次请求，可以勾选永远循环,如果取消无线循环一定要在后面填上一个1
```

- 开启查看结果树
	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/07.png)

- 模拟测试一个用户接口

	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/08.png)

	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/09.png)

- 观察结果树

	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/10.png)

- 测试post提交

	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/11.png)

	![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/12.png)

- 多个接口同时压测

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/13.png)

### Jmeter的断言基本使用

- 添加响应断言

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/14.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/15.png)

```
apply to(应用范围):
    Main sample only: 仅当前父取样器 进行断言，一般一个请求，如果发一个请求会触发多个，则			就有sub sample（比较少用）

要测试的响应字段：
    响应文本：即响应的数据，比如json等文本
    响应代码：http的响应状态码，比如200，302，404这些
    响应信息：http响应代码对应的响应信息，例如：OK, Found
    Response Header: 响应头

模式匹配规则：
    包括：包含在里面就成功
    匹配：响应内容完全匹配，不区分大小写
    equals：完全匹配，区分大小写
```
  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/16.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/17.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/18.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/19.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/20.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/21.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/22.png)

  ![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/23.png)

- 断言结果监听器: 线程组-> 添加 -> 监听器 -> 断言结果

```
里面的内容是sampler采样器的名称
断言失败，查看结果树任务结果颜色标红(通过结果数里面双击不通过的记录，可以看到错误信息)
```

- 每个sample下面可以加单独的结果树，然后同时加多个断言，最外层可以加个结果树进行汇总

### Jmeter实战之压测结果聚合报告分析

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/24.png)

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/25.png)

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/26.png)

```
lable: sampler的名称
Samples: 一共发出去多少请求,例如10个用户，循环10次，则是 100
Average: 平均响应时间
Median: 中位数，也就是 50％ 用户的响应时间

90% Line : 90％ 用户的响应不会超过该时间 （90% of the samples took no more than this time. 		 The remaining samples at least as long as this）
95% Line : 95％ 用户的响应不会超过该时间
99% Line : 99％ 用户的响应不会超过该时间
min : 最小响应时间
max : 最大响应时间

Error%：错误的请求的数量/请求的总数
Throughput： 吞吐量——默认情况下表示每秒完成的请求数（Request per Second) 可类比为qps
KB/Sec: 每秒接收数据量
```

单机tomcat吞吐量能达到550-560+

### Jmeter压测脚本JMX讲解

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2" properties="4.0" jmeter="4.0 r1823414">
  <hashTree>
  
  <!--测试计划-->
    <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Test Plan" enabled="true">
      <stringProp name="TestPlan.comments"></stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.tearDown_on_shutdown">true</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
      <elementProp name="TestPlan.user_defined_variables" elementType="Arguments" guiclass="ArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
        <collectionProp name="Arguments.arguments"/>
      </elementProp>
      <stringProp name="TestPlan.user_define_classpath"></stringProp>
    </TestPlan>
    <hashTree>
    
    <!--测试用户线程组-->
      <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="测试用户接口" enabled="true">
        <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
        <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
          <boolProp name="LoopController.continue_forever">false</boolProp>
          <!--作两次循环-->
          <stringProp name="LoopController.loops">2</stringProp>
        </elementProp>
          
          <!--开启的线程数-->
        <stringProp name="ThreadGroup.num_threads">1000</stringProp>
          <!--全部线程启动的时长-->
        <stringProp name="ThreadGroup.ramp_time">5</stringProp>
          
        <boolProp name="ThreadGroup.scheduler">false</boolProp>
        <stringProp name="ThreadGroup.duration"></stringProp>
        <stringProp name="ThreadGroup.delay"></stringProp>
      </ThreadGroup>
      <hashTree>
          <!--http采样器login_api-->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="login_api" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments">
              <elementProp name="name" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">false</boolProp>
                <stringProp name="Argument.value">jack</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">name</stringProp>
              </elementProp>
              <elementProp name="pwd" elementType="HTTPArgument">
                <boolProp name="HTTPArgument.always_encode">false</boolProp>
                <stringProp name="Argument.value">123</stringProp>
                <stringProp name="Argument.metadata">=</stringProp>
                <boolProp name="HTTPArgument.use_equals">true</boolProp>
                <stringProp name="Argument.name">pwd</stringProp>
              </elementProp>
            </collectionProp>
          </elementProp>
          <stringProp name="HTTPSampler.domain">127.0.0.1</stringProp>
          <stringProp name="HTTPSampler.port">8080</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding"></stringProp>
          <stringProp name="HTTPSampler.path">/login</stringProp>
          <stringProp name="HTTPSampler.method">POST</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
          <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          <stringProp name="HTTPSampler.connect_timeout"></stringProp>
          <stringProp name="HTTPSampler.response_timeout"></stringProp>
        </HTTPSamplerProxy>
        <hashTree>
          <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="Response Assertion" enabled="true">
            <collectionProp name="Asserion.test_strings"/>
            <stringProp name="Assertion.custom_message"></stringProp>
            <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
            <boolProp name="Assertion.assume_success">false</boolProp>
            <intProp name="Assertion.test_type">16</intProp>
          </ResponseAssertion>
          <hashTree/>
        </hashTree>
          
          <!--http采样器user_api-->
        <HTTPSamplerProxy guiclass="HttpTestSampleGui" testclass="HTTPSamplerProxy" testname="user_api" enabled="true">
          <elementProp name="HTTPsampler.Arguments" elementType="Arguments" guiclass="HTTPArgumentsPanel" testclass="Arguments" testname="User Defined Variables" enabled="true">
            <collectionProp name="Arguments.arguments"/>
          </elementProp>
          <stringProp name="HTTPSampler.domain">127.0.0.1</stringProp>
          <stringProp name="HTTPSampler.port">8080</stringProp>
          <stringProp name="HTTPSampler.protocol">http</stringProp>
          <stringProp name="HTTPSampler.contentEncoding"></stringProp>
          <stringProp name="HTTPSampler.path">/users</stringProp>
          <stringProp name="HTTPSampler.method">GET</stringProp>
          <boolProp name="HTTPSampler.follow_redirects">true</boolProp>
          <boolProp name="HTTPSampler.auto_redirects">false</boolProp>
          <boolProp name="HTTPSampler.use_keepalive">true</boolProp>
          <boolProp name="HTTPSampler.DO_MULTIPART_POST">false</boolProp>
          <stringProp name="HTTPSampler.embedded_url_re"></stringProp>
          <stringProp name="HTTPSampler.connect_timeout"></stringProp>
          <stringProp name="HTTPSampler.response_timeout"></stringProp>
        </HTTPSamplerProxy>
        <hashTree>
          
          <!--响应断言-->
          <ResponseAssertion guiclass="AssertionGui" testclass="ResponseAssertion" testname="包含jack断言" enabled="true">
            <collectionProp name="Asserion.test_strings">
              <stringProp name="3254239">jack</stringProp>
            </collectionProp>
            <stringProp name="Assertion.custom_message">no contains jack</stringProp>
            <stringProp name="Assertion.test_field">Assertion.response_data</stringProp>
            <boolProp name="Assertion.assume_success">false</boolProp>
            <intProp name="Assertion.test_type">2</intProp>
          </ResponseAssertion>
          <hashTree/>
            
          <!--结果树-->
          <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="user结果树" enabled="true">
            <boolProp name="ResultCollector.error_logging">false</boolProp>
            <objProp>
              <name>saveConfig</name>
              <value class="SampleSaveConfiguration">
                <time>true</time>
                <latency>true</latency>
                <timestamp>true</timestamp>
                <success>true</success>
                <label>true</label>
                <code>true</code>
                <message>true</message>
                <threadName>true</threadName>
                <dataType>true</dataType>
                <encoding>false</encoding>
                <assertions>true</assertions>
                <subresults>true</subresults>
                <responseData>false</responseData>
                <samplerData>false</samplerData>
                <xml>false</xml>
                <fieldNames>true</fieldNames>
                <responseHeaders>false</responseHeaders>
                <requestHeaders>false</requestHeaders>
                <responseDataOnError>false</responseDataOnError>
                <saveAssertionResultsFailureMessage>true</saveAssertionResultsFailureMessage>
                <assertionsResultsToSave>0</assertionsResultsToSave>
                <bytes>true</bytes>
                <sentBytes>true</sentBytes>
                <threadCounts>true</threadCounts>
                <idleTime>true</idleTime>
                <connectTime>true</connectTime>
              </value>
            </objProp>
            <stringProp name="filename"></stringProp>
          </ResultCollector>
          <hashTree/>
            
          <!--users聚合报告-->
          <ResultCollector guiclass="SummaryReport" testclass="ResultCollector" testname="users聚合报告" enabled="true">
            <boolProp name="ResultCollector.error_logging">false</boolProp>
            <objProp>
              <name>saveConfig</name>
              <value class="SampleSaveConfiguration">
                <time>true</time>
                <latency>true</latency>
                <timestamp>true</timestamp>
                <success>true</success>
                <label>true</label>
                <code>true</code>
                <message>true</message>
                <threadName>true</threadName>
                <dataType>true</dataType>
                <encoding>false</encoding>
                <assertions>true</assertions>
                <subresults>true</subresults>
                <responseData>false</responseData>
                <samplerData>false</samplerData>
                <xml>false</xml>
                <fieldNames>true</fieldNames>
                <responseHeaders>false</responseHeaders>
                <requestHeaders>false</requestHeaders>
                <responseDataOnError>false</responseDataOnError>
                <saveAssertionResultsFailureMessage>true</saveAssertionResultsFailureMessage>
                <assertionsResultsToSave>0</assertionsResultsToSave>
                <bytes>true</bytes>
                <sentBytes>true</sentBytes>
                <threadCounts>true</threadCounts>
                <idleTime>true</idleTime>
                <connectTime>true</connectTime>
              </value>
            </objProp>
            <stringProp name="filename"></stringProp>
          </ResultCollector>
          <hashTree/>
        </hashTree>
          
        <!--全局结果树-->
        <ResultCollector guiclass="ViewResultsFullVisualizer" testclass="ResultCollector" testname="users_api" enabled="true">
          <boolProp name="ResultCollector.error_logging">false</boolProp>
          <objProp>
            <name>saveConfig</name>
            <value class="SampleSaveConfiguration">
              <time>true</time>
              <latency>true</latency>
              <timestamp>true</timestamp>
              <success>true</success>
              <label>true</label>
              <code>true</code>
              <message>true</message>
              <threadName>true</threadName>
              <dataType>true</dataType>
              <encoding>false</encoding>
              <assertions>true</assertions>
              <subresults>true</subresults>
              <responseData>false</responseData>
              <samplerData>false</samplerData>
              <xml>false</xml>
              <fieldNames>true</fieldNames>
              <responseHeaders>false</responseHeaders>
              <requestHeaders>false</requestHeaders>
              <responseDataOnError>false</responseDataOnError>
              <saveAssertionResultsFailureMessage>true</saveAssertionResultsFailureMessage>
              <assertionsResultsToSave>0</assertionsResultsToSave>
              <bytes>true</bytes>
              <sentBytes>true</sentBytes>
              <threadCounts>true</threadCounts>
              <idleTime>true</idleTime>
              <connectTime>true</connectTime>
            </value>
          </objProp>
          <stringProp name="filename"></stringProp>
        </ResultCollector>
        <hashTree/>
      </hashTree>
    </hashTree>
  </hashTree>
</jmeterTestPlan>
```

- Jmeter常用按钮

![](https://blog-mamba.oss-cn-beijing.aliyuncs.com/Jmeter/27.png)