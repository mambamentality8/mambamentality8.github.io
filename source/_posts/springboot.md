---
title: springboot
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
description: springboot
image:
---
<p class="description"></p>
<meta name="referrer" content="no-referrer" />
<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/title.png?Expires=1552194987&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=miwbtIlUZcouRKPcFNvsOSergAg%3D" alt="" style="width:100%" />

<!-- more -->

# springboot官方文档:

```
https://docs.spring.io/spring-boot/docs/2.1.3.RELEASE/reference/htmlsingle/
```

# What is springboot?  

```
Spring Boot makes it easy to create stand-alone, 
production-grade Spring based Applications that you can "just run".

We take an opinionated view of the Spring platform and third-party libraries so you can get started with minimum fuss. 
Most Spring Boot applications need very little Spring configuration.

Spring Boot可以轻松创建独立的，
生产级基于Spring的应用程序，您可以“运行”。

我们对Spring平台和第三方库采取了自以为是的观点，因此您可以尽量少开始。
大多数Spring Boot应用程序只需要很少的Spring配置。
```

# Why use it?

```
Create stand-alone Spring applications

Embed Tomcat, Jetty or Undertow directly (no need to deploy WAR files)

Provide opinionated 'starter' dependencies to simplify your build configuration

Automatically configure Spring and 3rd party libraries whenever possible

Provide production-ready features such as metrics, health checks and externalized configuration

Absolutely no code generation and no requirement for XML configuration

创建独立的Spring应用程序

直接嵌入Tomcat，Jetty或Undertow（无需部署WAR文件）

提供自以为是的“入门”依赖项以简化构建配置

尽可能自动配置Spring和第三方库

提供生产就绪功能，例如指标，运行状况检查和外部化配置

绝对没有代码生成，也不需要XML配置
```

# How to use it?

## 第一章   快速入门

- 进入https://start.spring.io/
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/1.png)
- 将下载的包解压并导入IDEA
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/2.png)
- 启动我们的项目,访问8080端口
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/3.png?)
看到找不到页面选项就代表成功,因为我们还没有配置静态资源  

## 第二章   http协议开发

### 1.路由配置

- 首先要明白几个注解
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/4.png)
- 创建一个controller
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/5.png)
```java
@RequestMapping("/")
    public String home(){
        return "Hello World!";
    }

@RequestMapping("/test")
public Map<String,String> testMap(){
    Map<String,String> map = new HashMap<>();
    map.put("key","value");
    return map;
}
```
- 然后进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/6.png)
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/7.png)

### 2.postman接口测试  

```
postman下载地址https://www.getpostman.com/downloads/
```
- 在GetController中添加代码进行测试  
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/8.png)

```java
private Map<String,Object> params = new HashMap<>();

    /**
     * 功能描述：测试restful协议，从路径中获取字段
     * @param cityId
     * @param userId
     * @return
     */
    @RequestMapping(path = "/{city_id}/{user_id}", method = RequestMethod.GET)
    public Object findUser(@PathVariable("city_id") String cityId,
                           @PathVariable("user_id") String userId ){
        params.clear();

        params.put("cityId", cityId);
        params.put("userId", userId);

        return params;

    }
```
然后我们用postman进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/9.png?Expires=1552191889&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=8WgW7Kx3nztU%2BeUn%2BvW6RkIK4Ho%3D)

- GetMapping
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/10.png?Expires=1552191910&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=l%2FuLzie0Sk4V3FVA7c%2FM56LQwag%3D)
```java
 /**
     * 功能描述：测试GetMapping
     * @param from
     * @param size
     * @return
     */
    @GetMapping(value="/v1/page_user1")
    public Object pageUser(int  from, int size ){
        params.clear();
        params.put("from", from);
        params.put("size", size);

        return params;

    }
```
然后我们用postman进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/11.png?Expires=1552191934&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=PsiKQlTTm6R9lFhGnW3m4W7%2B%2BGI%3D)

- GetMapping默认值
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/12.png?Expires=1552191948&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=jo5FpkRaILxoV291DTui3swBZP0%3D)
```java
/**
     * 功能描述：默认值，是否必须的参数
     * @param from
     * @param size
     * @return
     */
    @GetMapping(value="/v1/page_user2")
    public Object pageUserV2(@RequestParam(defaultValue="0",name="page") int  from, int size ){

        params.clear();
        params.put("from", from);
        params.put("size", size);

        return params;

    }
```
然后我们用postman进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/13.png?Expires=1552191963&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=5hfyyBjvTLcwzszf05LvyFuHW6c%3D)
如果没有传入参数那么将会启用默认值

- bean对象传参
在domain包下创建一个实体类
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/24.png)

```java
public class User {
    private int age;
    private String pwd;
    private int phone;

    public User() {

    }

    public User(int age, String pwd, int phone) {
        this.age = age;
        this.pwd = pwd;
        this.phone = phone;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getPwd() {
        return pwd;
    }

    public void setPwd(String pwd) {
        this.pwd = pwd;
    }

    public int getPhone() {
        return phone;
    }

    public void setPhone(int phone) {
        this.phone = phone;
    }

    @Override
    public String toString() {
        return "User{" +
                "age=" + age +
                ", pwd='" + pwd + '\'' +
                ", phone=" + phone +
                '}';
    }
}
```

![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/14.png?Expires=1552191975&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=YFxLPVeYltF%2BVgQMoMl7ZdlGlm4%3D)
```java
 /**
     * 功能描述：bean对象传参
     * 注意：1、注意需要指定http头为 content-type为application/json
     * 		2、使用body传输数据
     * @param user
     * @return
     */
    @RequestMapping("/v1/save_user")
    public Object saveUser(@RequestBody User user){
        params.clear();
        params.put("user", user);
        return params;
    }
```
然后我们用postman进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/15.png?Expires=1552191992&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=M5hPnQqNj0aym2YEXtA0nYP8J48%3D)

- 获取请求头信息
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/16.png?Expires=1552192004&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=Rx3MUDGr%2FyB%2Fpj6lY1%2FJdFI%2FRhM%3D)
```java
/**
     * 功能描述：测试获取http头信息
     * @param accessToken
     * @param id
     * @return
     */
    @GetMapping("/v1/get_header")
    public Object getHeader(@RequestHeader("access_token") String accessToken, String id){
        params.clear();
        params.put("access_token", accessToken);
        params.put("id", id);
        return params;
    }
```
然后我们用postman进行测试
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/17.png?Expires=1552192018&OSSAccessKeyId=TMP.AQEgtsLEyObEK7RPOH5L9U0CS_EV2PzgEwkmxLnbFWPDuMjD2UYg5jhs4VkoMC4CFQDmrpV3tbPVf3EfSlK6eCVNYlr1ogIVAI-_cBMnqmozlouLhxj82DlrazUO&Signature=ld8c5nk5GAmKjd4BAyH46jkqZ7U%3D)

- post提交方式
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/18.png)

```java
private Map<String,Object> params = new HashMap<>();
    /**
     * 功能描述：测试PostMapping
     * @param id
     * @param pwd
     * @return
     */
    @PostMapping("/v1/login")
    public Object login(String id, String pwd){
        params.clear();
        params.put("id", id);
        params.put("pwd", pwd);
        return params;
    }
```

然后我们用postman进行测试
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/19.png)

- put提交方式
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/20.png)

```java
  @PutMapping("/v1/put")
    public Object put(String id){
        params.clear();
        params.put("id", id);
        return params;
    }
```
然后我们用postman进行测试
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/21.png)

- delete提交方式
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/22.png)

```java
   @DeleteMapping("/v1/del")
    public Object del(String id){
        params.clear();
        params.put("id", id);
        return params;
    }
```

然后我们用postman进行测试
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/23.png)

### 3.常用json框架介绍和jackson返回结果处理
```
常用框架 阿里 fastjson,谷歌gson等  
JavaBean序列化为Json，性能：Jackson > FastJson > Gson > Json-lib 同个结构
Jackson、FastJson、Gson类库各有优点，各有自己的专长
空间换时间，时间换空间
```
为我们的User类添加一个新字段重新生成get/set方法
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/25.png)

在SampleController中添加一个新接口
```java
 @GetMapping("/testjson")
    public Object testjson(){

        return new User(111, "abc123", "10001000", new Date());
    }
```
测试结果
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/26.png)
但是密码不应该暴露给前端,我们在User类中添加一个注解
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/27.png)
添加完之后启动应用再次测试
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/28.png)
这样就保证了我们的数据安全

```
类似的注解还有:
指定字段不返回：@JsonIgnore
指定日期格式：@JsonFormat(pattern="yyyy-MM-dd hh:mm:ss",locale="zh",timezone="GMT+8")
空字段不返回：@JsonInclude(Include.NON_NUll)
指定别名：@JsonProperty
```

### 4.springboot目录结构讲解
```
src/main/java：存放代码
src/main/resources
    static: 存放静态文件，比如 css、js、image, （访问方式 http://localhost:8080/js/main.js）
    templates:存放静态页面jsp,html,tpl
    config:存放配置文件,application.properties
    resources:脚本文件

Spring Boot 默认会挨个从
resources > static外 > public 里面找是否存在相应的资源，如果有则直接返回。
src/main/resources目录下资源加载的顺序

```
我们先把restful风格的接口注释掉防止影响
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/29.png)
然后按照图中示例进行测试
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/30.png)

<font color=red>templates下的文件一般是静态模板没有加入classpath中,直接访问会找不到资源路径需要引入依赖</font>  

在pom文件中引入依赖
```
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
```
新建一个FileController
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/31.png)
加入代码
```java
 @RequestMapping(value = "/api/v1/gopage")
    public Object index() {

        return "index";
    }
```
在templates文件夹下加入html文件
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
</head>
<body>
    hello  thymeleaf!!!
</body>
</html>
```
再次访问url
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/32.png)

官方默认spring加载静态资源配置路径
```
spring.resources.static-locations = classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/ 
```
如果想自定义spring加载静态资源配置路径在后面追加即可(加载的有限顺序调整顺序即可),示例如下:
```
spring.resources.static-locations = classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/ ,classpath:/test/
```
### 5.springboot文件上传实战
在static加入上传文件的页面
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/33.png)
```html
<!DOCTYPE html>
<html>
  <head>
    <title>uploadimg.html</title>

    <meta name="keywords" content="keyword1,keyword2,keyword3"></meta>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

    <script src="/js/test.js" type="text/javascript"></script>

  </head>

  <body>
	  <form enctype="multipart/form-data" method="post" action="/upload">
	    文件:<input type="file" name="head_img"/>
	    姓名:<input type="text" name="name"/>
	    <input type="submit" value="上传"/>
	   </form>
   
  </body>
</html>
```
然后在FileController中添加后台代码
<font color=red>注意替换自己存放文件的路径</font>  
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/34.png)
```java
//注意替换路径
 private static final String filePath = "D:\\springboot_workspace\\demo\\src\\main\\resources\\static\\image\\";

@RequestMapping(value = "upload")
    @ResponseBody
    public JsonData upload(@RequestParam("head_img") MultipartFile file, HttpServletRequest request) {

        //file.isEmpty(); 判断图片是否为空
        //file.getSize(); 图片大小进行判断

        String name = request.getParameter("name");
        System.out.println("用户名："+name);

        // 获取文件名
        String fileName = file.getOriginalFilename();
        System.out.println("上传的文件名为：" + fileName);

        // 获取文件的后缀名,比如图片的jpeg,png
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        System.out.println("上传的后缀名为：" + suffixName);

        // 文件上传后的路径
        fileName = UUID.randomUUID() + suffixName;
        System.out.println("转换后的名称:"+fileName);

        File dest = new File(filePath + fileName);

        try {
            //MultipartFile 对象的transferTo方法，用于文件保存（效率和操作比原先用FileOutStream方便和高效）
            file.transferTo(dest);

            return new JsonData(0, fileName);
        } catch (IllegalStateException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return  new JsonData(-1, "fail to save ", null);
    }
```
响应的时候应该返回给前台一个包装的json类
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/35.png)
```java
	private static final long serialVersionUID = 1L;

	//状态码,0表示成功，-1表示失败
	private int code;
	
	//结果
	private Object data;

	//错误描述
	private String msg;
	
	public int getCode() {
		return code;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public JsonData(int code, Object data) {
		super();
		this.code = code;
		this.data = data;
	}

	public JsonData(int code, String msg,Object data) {
		super();
		this.code = code;
		this.msg = msg;
		this.data = data;
	}
```
向后台发送文件之后
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/36.png)
这里会有一个问题当上传文件过大时,会抛出异常,那么我们应该如何去配置呢?
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/37.png)
在含有Config注解的类下配置一个bean注解,解决文件上传问题
```java
@Bean
    public MultipartConfigElement multipartConfigElement() {
        MultipartConfigFactory factory = new MultipartConfigFactory();
        //单个文件最大
        factory.setMaxFileSize("10240KB"); //KB,MB
        /// 设置总上传数据总大小
        factory.setMaxRequestSize("1024000KB");
        return factory.createMultipartConfig();
    }
```
### 6.jar包方式启动项目并访问资源
检查自己的pom.xml是否有打包插件,如果没加相关依赖，执行maven打包，运行后会报错:no main manifest attribute, in XXX.jar
```
<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>
```
使用 mvn install 将项目打包
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/38.png)
将jar包后缀换成zip并解压查看目录
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/39.png)
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/40.png)
如果你上传的图片路径是自定义的,请自行在配置文件中添加
web.images-path=自定义路径
spring.resources.static-locations=classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/,classpath:/test/,file:${web.upload-path} 
为了解决高并发你应该去使用:fastdfs，阿里云oss，nginx搭建一个简单的文件服务器

### 7.SpringBoot2.x使用Dev-tool热部署
1. 添加依赖
    <dependency>  
         <groupId>org.springframework.boot</groupId>  
         <artifactId>spring-boot-devtools</artifactId>  
         <optional>true</optional>  
   	</dependency>
2. 在IDEA设置中打开自动编译
 ![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/41.png)
3. 打开运行时编译,按快捷键 Shift+Ctrl+Alt+/ ，打开maintenance面板, 选择 Registry  
   勾选如图所示:
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/42.png)
不被热部署的文件  
 		1、/META-INF/maven, /META-INF/resources, /resources, /static, /public, or /templates  
 		2、指定文件不进行热部署 spring.devtools.restart.exclude=static/**,public/**  
 		3、手工触发重启 spring.devtools.restart.trigger-file=trigger.txt(trigger.txt放在最外层的resource下)
 			改代码不重启，通过一个文本去控制

官方地址：https://docs.spring.io/spring-boot/docs/2.1.0.BUILD-SNAPSHOT/reference/htmlsingle/#using-boot-devtools

### 8.SpringBoot2.x配置文件
简介：SpringBoot2.x常见的配置文件 xml、yml、properties的区别和使用
```
xml、properties、json、yaml
1、常见的配置文件 xx.yml, xx.properties，
    1)YAML（Yet Another Markup Language）
        写 YAML 要比写 XML 快得多(无需关注标签或引号)
        使用空格 Space 缩进表示分层，不同层次之间的缩进可以使用不同的空格数目
        注意：key后面的冒号，后面一定要跟一个空格,树状结构
    application.properties示例
        server.port=8090  
        server.session-timeout=30  
        server.tomcat.max-threads=0  
        server.tomcat.uri-encoding=UTF-8 

    application.yml示例
        server:  
            port: 8090  
            session-timeout: 30  
            tomcat.max-threads: 0  
            tomcat.uri-encoding: UTF-8 


2、默认示例文件仅作为指导。 不要将整个内容复制并粘贴到您的应用程序中，只挑选您需要的属性。

3、参考：https://docs.spring.io/spring-boot/docs/2.1.0.BUILD-SNAPSHOT/reference/htmlsingle/#common-application-properties

如果需要修改，直接复制对应的配置文件，加到application.properties里面
```
### 9.SpringBoot注解配置文件自动映射到属性和实体类实战
1、配置文件加载  
	方式一:    
        1、Controller上面配置  
            @PropertySource({"classpath:resource.properties"})  
            resource.properties里面的内容为k,v  
            2、增加属性  
                @Value("${test.name}")  
                private String name;  
        方式二：  
            实体类配置文件  
            步骤：  
                1、添加 @Component 注解；  
                2、使用 @PropertySource 注解指定配置文件位置；  
                3、使用 @ConfigurationProperties 注解，设置相关属性；  
                4、必须 通过注入IOC对象Resource 进来 ， 才能在类中使用获取的配置文件值。  
                    @Autowired  
                    private ServerSettings serverSettings;  
                    例子：  
                        新建一个domain  
```java
@Component
@PropertySource({"classpath:application.properties"})
@ConfigurationProperties
public class ServerSettings {
//名称
@Value("${test.name}")
private String name;
@Value("${test.domain}")
private String domain;
public String getName() {
    return name;
}
public void setName(String name) {
    this.name = name;
}
public String getDomain() {
    return domain;
}
public void setDomain(String domain) {
    this.domain = domain;
}
@Override
public String toString() {
    return "ServerSettings{" +
            "name='" + name + '\'' +
            ", domain='" + domain + '\'' +
            '}';
}
}
```
使用前缀
@ConfigurationProperties（prefix = "xxx"）
如果使用前缀的话则不需要@Value注解
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/43.png)  
常见问题：  
    1、配置文件注入失败，Could not resolve placeholder  
        解决：根据springboot启动流程，会有自动扫描包没有扫描到相关注解,   
        默认Spring框架实现会从声明@ComponentScan所在的类的package进行扫描，来自动注入，  
        因此启动类最好放在根路径下面，或者指定扫描包范围  
        spring-boot扫描启动类对应的目录和子目录  
    2、注入bean的方式，属性名称和配置文件里面的key一一对应，就用加@Value 这个注解  
        如果不一样，就要加@value("${XXX}")  

### 10.SpringBoot单元测试  
1. 引入相关依赖
```
  <!--springboot程序测试依赖，如果是自动创建项目默认添加-->
    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-test</artifactId>
        <scope>test</scope>
    </dependency>
```
2. 使用@RunWith(SpringRunner.class)  //底层用junit  SpringJUnit4ClassRunner 
       @SpringBootTest(classes={DemoApplication.class})//启动整个springboot工程  
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/44.png)  

SpringBoot测试进阶高级篇之MockMvc讲解   
简介:讲解MockMvc类的使用和模拟Http请求实战   
1、增加类注解 @AutoConfigureMockMvc   
        @SpringBootTest(classes={XdclassApplication.class})    
2、相关API   
perform：执行一个RequestBuilder请求  
andExpect：添加ResultMatcher->MockMvcResultMatchers验证规则  
andReturn：最后返回相应的MvcResult->Response  


### 11.SpringBoot2.x个性化启动banner设置和debug日志  
简介：自定义应用启动的趣味性日志图标和查看调试日志  
1、启动获取更多信息 java -jar xxx.jar --debug  
2、修改启动的banner信息  
1）在类路径下增加一个banner.txt，里面是启动要输出的信息  
2）在applicatoin.properties增加banner文件的路径地址   
    spring.banner.location=banner.txt  
3）官网地址 https://docs.spring.io/spring-boot/docs/2.1.0.BUILD-SNAPSHOT/reference/htmlsingle/#boot-features-banners  
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/45.png)

### 12.SpringBoot2.x配置全局异常实战  
讲解：服务端异常讲解和SpringBoot配置全局异常实战  
1、默认异常测试  int i = 1/0，不友好,如果是前后端分离前端你抛一个404的页面前端不知道该如何去处理  
先定义一个异常
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/46.png)
```java
@RestController  
public class ExcptionController {  
    @RequestMapping(value = "/api/v1/test_ext")  
    public Object index() {  
        int i= 1/0;  
        return new User(11, "sfsfds", "1000000", new Date());  
    }  
}  
```

2、异常注解介绍  
@ControllerAdvice 如果是返回json数据 则用 RestControllerAdvice,就可以不加 @ResponseBody  
//捕获全局异常,处理所有不可知的异常  
@ExceptionHandler(value=Exception.class)  
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/47.png)
```java
@RestControllerAdvice
public class CustomExtHandler {
    private static final Logger LOG = LoggerFactory.getLogger(CustomExtHandler.class);

	//捕获全局异常,处理所有不可知的异常
	@ExceptionHandler(value=Exception.class)
	//@ResponseBody
    Object handleException(Exception e,HttpServletRequest request){
		LOG.error("url {}, msg {}",request.getRequestURL(), e.getMessage()); 
		Map<String, Object> map = new HashMap<>();
	        map.put("code", 100);
	        map.put("msg", e.getMessage());
	        map.put("url", request.getRequestURL());
	        return map;
    }
}
```
这样就能返回一个json数据给前端了

### 13.SpringBoot2.x配置自定义异常实战  
简介：使用SpringBoot自定义异常和错误页面跳转实战  
1、返回自定义异常界面，需要引入thymeleaf依赖  
```
<dependency>  
   <groupId>org.springframework.boot</groupId>  
   <artifactId>spring-boot-starter-thymeleaf</artifactId>  
</dependency>

```
2、创建自定义异常类
![](./http://blog-mamba.oss-cn-beijing.aliyuncs.com/48.png)
```java
public class MyException extends RuntimeException {

    public MyException(String code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    private String code;
    private String msg;
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}

}
```
3、写一个异常路由
```java
/**
	 * 功能描述：模拟自定义异常
	 * @return
	 */
	@RequestMapping("/api/v1/myext")
	public Object myexc(){

		throw new MyException("499", "my ext异常");

	}
```

4、处理自定义异常
```java
	/**
	 * 功能描述：处理自定义异常
	 * @return
	 */
	@ExceptionHandler(value=MyException.class)
	Object handleMyException(MyException e,HttpServletRequest request){
		//进行页面跳转
//		ModelAndView modelAndView = new ModelAndView();
//	    modelAndView.setViewName("error.html");
//	    modelAndView.addObject("msg", e.getMessage());
//	    return modelAndView;

		//返回json数据，由前端去判断加载什么页面
		Map<String, Object> map = new HashMap<>();
		map.put("code", e.getCode());
		map.put("msg", e.getMsg());
		map.put("url", request.getRequestURL());
		return map;

	}
```
https://docs.spring.io/spring-boot/docs/2.1.0.BUILD-SNAPSHOT/reference/htmlsingle/#boot-features-error-handling


### 14.SpringBoot启动方式讲解和部署war项目到tomcat
1、ide启动
	2、jar包方式启动
				maven插件:
				<build>
				<plugins>
					<plugin>
						<groupId>org.springframework.boot</groupId>
						<artifactId>spring-boot-maven-plugin</artifactId>
					</plugin>
				</plugins>
				</build>
				如果没有加，则执行jar包 ，报错如下
					java -jar spring-boot-demo-0.0.1-SNAPSHOT.jar
					no main manifest attribute, in spring-boot-demo-0.0.1-SNAPSHOT.jar
				如果有安装maven 用 mvn spring-boot:run
		项目结构
			example.jar
					 |
					 +-META-INF
					 |  +-MANIFEST.MF
					 +-org
					 |  +-springframework
					 |     +-boot
					 |        +-loader
					 |           +-<spring boot loader classes>
					 +-BOOT-INF
					    +-classes
					    |  +-mycompany
					    |     +-project
					    |        +-YourClasses.class
					    +-lib
					       +-dependency1.jar
					       +-dependency2.jar
	目录结构讲解
	https://docs.spring.io/spring-boot/docs/2.1.0.BUILD-SNAPSHOT/reference/htmlsingle/#executable-jar-jar-file-structure

3、war包方式启动
1)在pom.xml中<version>下方将打包形式jar修改为war        
  ```
  <packaging>war</packaging>
  ```
构建项目名称
```
<finalName>demo_springboot</finalName>
```
如下
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
		 xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
	<modelVersion>4.0.0</modelVersion>
	<parent>
		<groupId>org.springframework.boot</groupId>
		<artifactId>spring-boot-starter-parent</artifactId>
		<version>2.1.3.RELEASE</version>
		<relativePath/> <!-- lookup parent from repository -->
	</parent>
	<groupId>com.example</groupId>
	<artifactId>demo</artifactId>
	<packaging>war</packaging>
	<version>0.0.1-SNAPSHOT</version>
	<name>demo</name>
	<description>Demo project for Spring Boot</description>

	<properties>
		<java.version>1.8</java.version>
	</properties>

	<!--web启动器-->
	<dependencies>
		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-web</artifactId>
		</dependency>

		<dependency>
			<groupId>org.springframework.boot</groupId>
			<artifactId>spring-boot-starter-test</artifactId>
			<scope>test</scope>
		</dependency>
	</dependencies>

	<!--打包插件-->
	<build>
		<finalName>demo_springboot</finalName>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
		</plugins>
	</build>

</project>

```



2)tocmat下载 https://tomcat.apache.org/download-90.cgi

3)修改启动类
```java
@SpringBootApplication
public class DemoApplication extends SpringBootServletInitializer {

 @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(DemoApplication.class);
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```
4)执行meaven命令mvn install打包项目  
5)将打好的包放在tomcat容器webapp目录下中,tomcat会自动解压这个war包









<hr />