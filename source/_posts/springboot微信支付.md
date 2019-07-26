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

### 配置文件自动映射到属性和实体类配置

```
1、添加 @Configuration 注解；
                
2、使用 @PropertySource 注解指定配置文件位置；(属性名称规范: 大模块.子模块.属性名)
        #=================================微信相关==================
        #公众号
        wxpay.appid=wx5beac15ca207cdd40c
        wxpay.appsecret=554801238f17fdsdsdd6f96b382fe548215e9

3、必须 通过注入IOC对象Resource 进来 ， 才能在类中使用获取的配置文件值。

例子:
        @Autowired
        private WeChatConfig weChatConfig;
        
        @Configuration
        @PropertySource(value="classpath:application.properties")
        public class WeChatConfig {
            @Value("${wxpay.appid}")
            private String appId;
        }
```

### springboot整合mybatis数据源

```
1、加入依赖(可以用 http://start.spring.io/ 下载)
        <!-- 引入starter-->
        <dependency>
            <groupId>org.mybatis.spring.boot</groupId>
            <artifactId>mybatis-spring-boot-starter</artifactId>
            <version>1.3.2</version>
        </dependency>

        <!-- MySQL的JDBC驱动包  -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <scope>runtime</scope>
        </dependency>
        <!-- 引入第三方数据源 -->
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>druid</artifactId>
            <version>1.1.6</version>
        </dependency>
        
2、加入配置文件
    #可以自动识别
    #spring.datasource.driver-class-name =com.mysql.jdbc.Driver
    
    #替换自己的数据库信息
    spring.datasource.url=jdbc:mysql://localhost:3306/classdemo?useUnicode=true&characterEncoding=utf-8&serverTimezone=UTC
    spring.datasource.username =root
    spring.datasource.password =root
    
    #如果不使用默认的数据源 （com.zaxxer.hikari.HikariDataSource）
    spring.datasource.type =com.alibaba.druid.pool.DruidDataSource
    
    加载配置，注入到sqlSessionFactory等都是springBoot帮我们完成
    
3、启动类增加mapper扫描@MapperScan("com.example.wxpay.mapper")
            
    VideoMapper类例子
    @Select("select * from video")
    List<Video> findAll();
    
    !!!如果数据库中有数据没有映射过来可以采用两种办法
    1. @Results({
                        @Result(column = "create_time",property = "createTime")  //javaType = java.util.Date.class
                })
    2.
    	在application.properties中配置数据库字段下划线和Java实体类映射
            # mybatis 下划线转驼峰配置,两者都可以
            #mybatis.configuration.mapUnderscoreToCamelCase=true
            mybatis.configuration.map-underscore-to-camel-case=true
4、开发mapper
    参考语法 http://www.mybatis.org/mybatis-3/zh/java-api.html
    xml配置：http://www.mybatis.org/mybatis-3/zh/configuration.html
```

### 使用Mybatis注解增删改查

```
1、application.properties增加控制台打印sql语句        
    #增加打印sql语句，一般用于本地开发测试
    mybatis.configuration.log-impl=org.apache.ibatis.logging.stdout.StdOutImpl

2、增加mapper代码        
    @Select("select * from video")
    List<Video> findAll();
    
    @Select("SELECT * FROM video WHERE id = #{id}")
    Video findById(int id);
    
    @Update("UPDATE video SET title=#{title} WHERE id =#{id}")
    int update(Video Video);
    
    @Delete("DELETE FROM video WHERE id =#{id}")
    int delete(int id);
    
    @Insert("INSERT INTO `video` ( `title`, `summary`, " +
    "`cover_img`, `view_num`, `price`, `create_time`," +
    " `online`, `point`)" +
    "VALUES" +
    "(#{title}, #{summary}, #{coverImg}, #{viewNum}, #{price},#{createTime}" +
    ",#{online},#{point});")
    //技巧：保存对象，获取数据库自增id 
    @Options(useGeneratedKeys=true, keyProperty="id", keyColumn="id")
    int save(Video video);

3、保存保存
    技巧：保存对象，获取数据库自增id 
    @Options(useGeneratedKeys=true, keyProperty="id", keyColumn="id")

4、技巧：
	application.properties增加
    数据库字段下划线和Java实体类映射
    # mybatis 下划线转驼峰配置,两者都可以
    #mybatis.configuration.mapUnderscoreToCamelCase=true
    mybatis.configuration.map-underscore-to-camel-case=true
    
5、接口测试:
	删除使用delete提交
	修改使用put提交在Body中选择x-www-form-urlencode
	添加时使用post提交在Body中选择x-www-form-urlencode
```

### 规范接口

```
普通用户应该只有查权限
管理员有增删改权限
删除时候参数只需要ID
修改和增加的时候参数需要一个pojo

接口测试:
	测试修改和保存时应该在Body中选择raw 提交JSON格式的数据
```

### 动态Sql语句Mybaties SqlProvider

```
1、
    在provider包中写好代码
	 public String updateVideo(final Video video){
        return new SQL(){{

            UPDATE("video");

            //条件写法.
            if(video.getTitle()!=null){
                SET("title=#{title}");
            }
            if(video.getSummary()!=null){
                SET("summary=#{summary}");
            }
            if(video.getCoverImg()!=null){
                SET("cover_img=#{coverImg}");
            }
            if(video.getViewNum()!=null){
                SET("view_num=#{viewNum}");
            }
            if(video.getPrice()!=null){
                SET("price=#{price}");
            }
            if(video.getOnline()!=null){
                SET("online=#{online}");
            }
            if(video.getPoint()!=null){
                SET("point=#{point}");
            }

            WHERE("id=#{id}");

        }}.toString();
    }

2、写法
	在VideoMapper中修改好注解
	@UpdateProvider(type = VideoProvider.class,method = "updateVideo")
	
3、使用postman测试选择Body raw JSON 
	使用JSON测试
	{
        "id":10,
        "summary":"动态语句测试"
	}
```

### PageHelper分页插件使用

```
1、引入依赖
		<!--分页插件-->
		<dependency>
			<groupId>com.github.pagehelper</groupId>
			<artifactId>pagehelper</artifactId>
			<version>4.1.0</version>
		</dependency>
		
2、增加配置文件
    @Configuration
    public class MyBatisConfig {
        @Bean
        public PageHelper pageHelper(){
            PageHelper pageHelper = new PageHelper();
            Properties p = new Properties();

            // 设置为true时，会将RowBounds第一个参数offset当成pageNum页码使用
            p.setProperty("offsetAsPageNum","true");

            //设置为true时，使用RowBounds分页会进行count查询
            p.setProperty("rowBoundsWithCount","true");
            p.setProperty("reasonable","true");
            pageHelper.setProperties(p);
            return pageHelper;
        }
}

3、开发VideoController
@GetMapping("page")
    public Object pageVideo(@RequestParam(value = "page",defaultValue = "1")int page,
                            @RequestParam(value = "size",defaultValue = "10")int size){

        PageHelper.startPage(page,size);

        List<Video> list = videoService.findAll();
        PageInfo<Video> pageInfo = new PageInfo<>(list);
        Map<String,Object> data = new HashMap<>();
        data.put("total_size",pageInfo.getTotal());//总条数
        data.put("total_page",pageInfo.getPages());//总页数
        data.put("current_page",page);//当前页
        data.put("data",pageInfo.getList());//数据

        return data;
    }
    
4、基本原理  
        sqlsessionFactory -> sqlSession-> executor -> mybatis sql statement
        通过mybatis plugin 增加拦截器，然后拼装分页
        org.apache.ibatis.plugin.Interceptor
```

### JWT微服务下的用户登录权限校验

```
为什么要用JWT?
    分布式应用中session共享
        真实的应用不可能单节点部署，所以就有个多节点登录session共享的问题需要解决
                1）tomcat支持session共享，但是有广播风暴；用户量大的时候，占用资源就严重，不推荐
                2）使用redis存储token:
                        服务端使用UUID生成随机64位或者128位token，放入redis中，然后返回给客户端并存储在cookie中
                        用户每次访问都携带此token，服务端去redis中校验是否有此用户即可
                 这样压力还是在服务端


1、JWT 是一个开放标准，它定义了一种用于简洁，自包含的用于通信双方之间以 JSON 对象的形式安全传递信息的方法。
            JWT 可以使用 HMAC 算法或者是 RSA 的公钥密钥对进行签名

            简单来说，就是通过一定规范来生成token，然后可以通过解密算法逆向解密token，这样就可以获取用户信息
            {
                id:888,
                name:'昵称',
                expire:10000
            }
            
            funtion 加密(object, appsecret){
                xxxx
                return base64( token);
            }

            function 解密(token ,appsecret){

                xxxx
                //成功返回true,失败返回false
            }

            优点：
                1）生产的token可以包含基本信息，比如id、用户昵称、头像等信息，避免再次查库

                2）存储在客户端，不占用服务端的内存资源

            缺点：
                token是经过base64编码，所以可以解码，因此token加密前的对象不应该包含敏感信息
                如用户权限，密码等

2、JWT格式组成 头部、负载、签名
           header+payload+signature

           头部：主要是描述签名算法
           负载：主要描述是加密对象的信息，如用户的id等，也可以加些规范里面的东西，如iss签发者，exp 过期时间，sub 面向的用户
           签名：主要是把前面两部分进行加密，防止别人拿到token进行base解密后篡改token(例如将存活时间修改为很久这时候你去利用header+payload算出来的值就不是signature了)

3、关于jwt客户端存储
            可以存储在cookie，localstorage和sessionStorage里面





1、加入相关依赖

            <!-- JWT相关 -->
            <dependency>
                <groupId>io.jsonwebtoken</groupId>
                <artifactId>jjwt</artifactId>
                <version>0.7.0</version>
            </dependency>

2、开发生产token方法
	public static final String SUBJECT = "subjectdemo";

    public static final long EXPIRE = 1000*60*60*24*7;  //过期时间，毫秒，一周

    //秘钥
    public static final  String APPSECRET = "miyaodemo";

    /**
     * 生成jwt
     * @param user
     * @return
     */
    public static String geneJsonWebToken(User user){

        if(user == null || user.getId() == null || user.getName() == null
                || user.getHeadImg()==null){
            return null;
        }
        String token = Jwts.builder().setSubject(SUBJECT)
                .claim("id",user.getId())
                .claim("name",user.getName())
                .claim("img",user.getHeadImg())
                .setIssuedAt(new Date())
                .setExpiration(new Date(System.currentTimeMillis()+EXPIRE))
                .signWith(SignatureAlgorithm.HS256,APPSECRET).compact();

        return token;
    }

3、开发检验token方法
/**
     * 校验token
     * @param token
     * @return
     */
    public static Claims checkJWT(String token ){

        try{
            final Claims claims =  Jwts.parser().setSigningKey(APPSECRET).
                    parseClaimsJws(token).getBody();
            return  claims;

        }catch (Exception e){
            //打印日志
        }
        return null;

    }

```

### 微信授权一键登录功能

```
前期准备
	微信开放平台介绍（申请里面的网站应用需要企业资料）
                    网站:https://open.weixin.qq.com/
                    
    获取腾讯给开发者的appid和appsecret
    开发者需要给腾讯那边一个授权回调域名,就是用户登陆成功以后要跳转到哪个URL
    
    用户扫完二维码点击确认以后,微信开发平台会返回给开发者一个code授权码
    开发者拿着appid appsecret和code授权码去微信换取access_token
```

![](https://res.wx.qq.com/op_res/D0wkkHSbtC6VUSHX4WsjP5ssg5mdnEmXO8NGVGF34dxS9N1WCcq6wvquR4K_Hcut)

```
获取二维码
    1.增加结果工具类，JsonData;
    2.在application.properties
        增加appid  appsecret  redirect_url的配置
    3.添加WeChatConfig
    4.添加WechatController
```

```
使用httpClient
	1.加入httpClient的依赖
    2.封装httpclient工具类
    3.使用内网穿透软件
   	将自己的物理机配置一个域名部署到外网,这个域名需要和你在微信开放平台申请的授权回调域名相同,微信服务器需要响应到你在微信开发平台申请的授权回调域名
   	4.再次添加回调的路由WechatController
   	5.接收微信那边传过来的授权码code
   	6.把授权码code+appid+appsecret交给腾讯那边
   	7.腾讯那边返回给我们一个
   		{ 
            "access_token":"ACCESS_TOKEN", 
            "expires_in":7200, 
            "refresh_token":"REFRESH_TOKEN",
            "openid":"OPENID", 
            "scope":"SCOPE",
            "unionid": "o6_bmasdasdsad6_2sgVt7hMZOPfL"
        }
    8.通过这个获得的token和openid去请求腾讯那边的服务器,服务器会返回给我们用户信息
    {
        "openid":"OPENID",
        "nickname":"NICKNAME",
        "sex":1,
        "province":"PROVINCE",
        "city":"CITY",
        "country":"COUNTRY",
        "headimgurl": "http://wx.qlogo.cn/mmopen/g3MonUZtNHkdmzicIlibx6iaFqAc56vxLSUfpb6n5WKSYVY0ChQKkiaJSgQ1dZuTOgvLLrhJbERQQ4eMsv84eavHiaiceqxibJxCfHe/0",
        "privilege":[
        "PRIVILEGE1",
        "PRIVILEGE2"
        ],
        "unionid": " o6_bmasdasdsad6_2sgVt7hMZOPfL"
    }
    9.封装用户信息将用户信息存入数据库
    10.存入数据库以后使用jwt将token交给前台
```

```
开发拦截器
	让某些路由没有token不能访问
   
   1.创建一个类LoginIntercepter 实现HandlerInterceptor
	 重写preHandle方法
   
   2.创建一个类IntercepterConfig 实现WebMvcConfigurer
   	 作为LoginIntercepter的配置
   	 
   	 
   3.定义一个测试接口OrderController
	 接口的路由要在拦截器的配置里面
```

### 微信扫一扫网页支付

![](<https://pay.weixin.qq.com/wiki/doc/api/img/chapter6_5_1.png>)

```
1、时序图地址：https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_5
2、开发videoOrder接口
3、封装常用工具类CommonUtils和WXpayUtils
4、开发controller，开发期间不加入拦截器登录校验
5、iputils工具类介绍
6、加入微信支付配置
            #微信商户平台
            wxpay.mer_id=1503808832
            wxpay.key=xdclasss20182018xdclass2018x018d
            wxpay.callback=16web.tunnel.qydev.com/pub/api/v1/wechat/order/callback1      
7、开发微信他一下单接口 post提交  需要带一系列参数
7、谷歌二维码工具生成扫一扫支付二维码
```

