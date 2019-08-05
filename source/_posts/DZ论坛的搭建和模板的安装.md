---
title: DZ论坛搭建以及模板的安装
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

# 搭建discuz论坛

### 1. 开始搭建我们的DZ论坛

- 首先可以去云服务器的产品文档中看对应的搭建手册

- 安装好对应的镜像

- 安装好以后将**公网 IP** 粘贴到本地浏览器的地址栏中访问，进入Discuz！安装页面。如下图所示：

  ![img](https://main.qcloudimg.com/raw/c55ce0a0a24ef524c0bf0352b6651feb.png)

- 单击【我同意】，进入检查安装环境页面。如下图所示：

![å®è£2](https://mc.qcloudimg.com/static/img/c5a521673ed6f1a3528ba67ca5886ee4/image.png)

- 确认当前状态正常，单击 【下一步】，进入设置运行环境页面。如下图所示：

![å®è£3](https://mc.qcloudimg.com/static/img/11a44bd86bfdfcd1fe3dcce6e8f200e6/image.png)

- 选择全新安装，单击【下一步】，进入创建数据库页面。如下图所示：

![å®è£4æ¹](https://mc.qcloudimg.com/static/img/5d5184cfb34f98d791c243273b910065/image.png)

<font style=color:red>请使用镜像默认的 MySQL 帐号和密码（默认为 root/123456）连接数据库。并设置好系统信箱、管理员帐号、密码和 Email。
请记住自己的管理员帐号和密码。</font>



- 单击【下一步】，开始安装。
- 安装完成后，单击【您的论坛已完成安装，点此访问】，即可访问论坛。如下图所示：

![å®è£5](https://mc.qcloudimg.com/static/img/41dab1ec86120a565bdd790238f271da/image.png)



### 2.开始搭建我们的论坛模板 <font style=color:red>**(星点互联模板)**</font>

- 首先右键检查源代码看看网站的编码格式charset=utf-8

- 找到模板的对应编码包

- 将模板包template目录下的文件夹扔到服务器的/data/wwwroot/default/discuz/template目录下

  ​                                                                                 /www/wwwroot/www.yiqifeiyang.com/template

- 进入后台管理界面<http://www.yiqifeiyang.com/admin.php>

- 找到本次商业版<font style=color:red>点击安装</font>，并设置为默认模板，提交保存，然后更新css缓存。

  去工具栏目下更新一下缓存。此时已经安装好模板。

  ![1562497193263](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562497193263.png)

- 进入全局，站点功能》开启下需要的功能。建议全部开启。

  其中**门户功能建议放到主导航上面，其他功能不建议放在主导航上**

![1562497270976](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562497270976.png)

![1562497277643](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562497277643.png)

- **后台界面设置方法：论坛首页开启边栏功能；如下图：**

![1562497393022](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562497393022.png)

- 帖子列表页图片模式图片尺寸如下图；（设置为宽高固定为的是界面整齐划一，当然您可以任意设置您喜欢的宽高数字；）

![1562497530275](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562497530275.png)

- 帖子内容页设置左侧用户栏为关闭

![1562498249137](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562498249137.png)

- **论坛版块功能开启以及设置方法**

  - 开启论坛图片列表功能，开启方法：选择后台论坛栏目，添加一个新版块**，**名称可任意命名，点击这个版块后面的编辑功能进入编辑页面，“基本设置”将“在导航上显示”选择是。并保存。然后进入同一编辑页面上方“拓展设置”，“开启图片列表模式:”选择“是”并保存。
  - ![1562499532967](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562499532967.png)
  - 活动帖子功能开启方式：任意论坛子版块
  - ![1562499751859](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562499751859.png)

  - **论坛列表页开启一下右边栏功能，具体方法如下**
  - ![1562499840578](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562499840578.png)
  - **帖子内容页需要关闭左侧信息栏后再导入diy文件，倒入后同样可以决定关闭或者开启。另外论坛首页需要开启右边栏再导入diy文件**
  - ![1562500295174](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500295174.png)

- **分类信息功能**

  - ![1562500341244](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500341244.png)
  - **导入分类信息文件。然后绑定到论坛版块使用即可。**
  - ![1562500444050](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500444050.png)

  - ![1562500455405](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500455405.png)



- **添加频道页方法：后台门户栏目**
  
  - 案例频道，如下图所示。下级分类子版块每次新建一个就需要设置一次。
- ![1562500851025](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500851025.png)
  
- 资讯频道模板，如下图所示；下级分类子版块每次新建一个就需要设置一次。
  
- ![1562500872674](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500872674.png)
  
- 关于我们频道页，如下图所示；内容页不需设置。

  - ![1562500891249](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500891249.png)

  - VIP页面：

  ![1562500915137](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500915137.png)

- 下面是diy操作方式方法：
  
  - **进入前台页面，分别进行DIY数据导入操作（\**\**\**\*****即门户.xml文件就导入到门户页面中，论坛首页.xml文件导入到论坛首页中。****建议大家先发布论坛和文章数据，让导入DIY包有数据可以读取,如果您的网站没有数据，那么导入diy文件后，页面同样也是空白一片。需要说明的是，门户等频道页如果在有数据却无法读取出来的情况，是因为帖子或者文章没有插入图片造成的（或者文章没有设置封面），注意是插入图片，而不是复制黏贴图片。\**\**\**\*）**。正确方法如下图所示：

帖子:

​	![1562500962453](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500962453.png)

文章：

![1562500973126](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562500973126.png)

**注意：在修改之前，请先把需要修改的文件做好备份，以防不测。**



**论坛右边栏开启以及关闭操作说明：后台论坛栏目-论坛各个板块后面的编辑按钮进入设置页面，上方的拓展设置里面，根据情况选择是或者否。**



**头部修改：在common文件夹里面的header里修改。**

 

**底部文字修改：在common文件夹里面的footer里修改。**

 

**公共样式修改（头部和底部样式）：在common文件夹里面的Extend_common里修改。**

 

**其他页面的样式（首页、论坛部分、频道部分样式）修改在common文件夹里面的Extend_module里。**



<font style=color:red>**以上文件请到您的ftp中template文件夹里找到nex开头的文件夹，把需要修改的文件下载到本地修改后再上传回去覆盖原文件，后台工具更新缓存即可**</font>





![1562499084221](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562499084221.png)

![1562501835718](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562501835718.png)











### 网站前台

#### 计算机学习首选易起飞扬

- course1

```HTML
<div class="nexcoursetop">
                        	<a href="#" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course1.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>热<br>门</em>
                                        <span style="letter-spacing:4px;font-size:36px;">易语言</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">中国人自己的语言</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">易语言基础入门</a></h5>
                            <div class="nexcourseinterso">其非常接近自然语言，精简了很多不必要的分号和括号，非常容易阅读理解。编程简单直接，更适合初学编程者，让其专注于编程逻辑，而不是困惑于晦涩的语法细节上，比起JAVA、C#和C/C++这些编程语言相对容易很多。因此，即使是非计算机专业或者没有基础的小白，也能分分钟入门。</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★</em></div>
                                <div class="nexcourserps"><em>3669</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course2

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=21" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course2.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>热<br>门</em>
                                        <span style="letter-spacing:4px;font-size:28px;">POST&JS</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">POST&JS加解密</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">POST和JS加解密</a></h5>
                            <div class="nexcourseinterso">我们常常认为POST就是抓包，JS就是脚本。其实POST方法是HTTP协议中的一个重要组成部分。在编程人员眼中，POST方法一般用来向目的服务器发出更新请求，并附有请求实体。我们在抓包过程中，遇到的大多数数据都是POST形式发送，有用的包大多数是POST包，久而久之，大家都直接将POST理解为抓包。</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★★</div>
                                <div class="nexcourserps"><em>878</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course3

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=8" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course3.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>热<br>门</em>
                                        <span style="letter-spacing:2px;font-size:32px;">多线程</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">你经常使用，却各种难受</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">多线程原理剖析</a></h5>
                            <div class="nexcourseinterso">多线程(英文名称：multithreading)是指从软件或者硬件上实现多个线程并发执行的技术。简单的理解，就是同时开多个东西，这个东西我们称之为线程，如何处理好多线程，是程序员必备的技能。本教程将带你进入多线程的时间！</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★☆</em></div>
                                <div class="nexcourserps"><em>766</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course4

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=12" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course4.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>经<br>典</em>
                                        <span style="letter-spacing:2px;font-size:28px;">win32 API</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">使用win系统API必学之</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">编程人员必备课程</a></h5>
                            <div class="nexcourseinterso">win32 API，看似很深奥，其实很简单！其实它是Microsoft 32位平台的应用程序编程接口。所有在Win32平台上运行的应用程序都可以调用这些函数。</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★</em></div>
                                <div class="nexcourserps"><em>578</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course5

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=17" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course5.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>火<br>爆</em>
                                        <span style="letter-spacing:2px;font-size:28px;">驱动+内核</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">这是大神的世界！</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">过保护，反调试</a></h5>
                            <div class="nexcourseinterso">驱动与内核，这是菜鸟踏入大佬的必经之路，没有学会驱动与内核，永远只是菜鸟！学完之后你能达到的水平——独立制作能够过掉保护的CE，OD软件，让市面上几乎所有游戏，在你面前都是裸奔状态！前提，要懂得举一反三，触类旁通！</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★★★★</em></div>
                                <div class="nexcourserps"><em>189</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course6

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=18" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course6.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>火<br>爆</em>
                                        <span style="letter-spacing:2px;font-size:28px;">游戏脚本</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">解放双手，智能刷图！</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">电脑和手机游戏脚本</a></h5>
                            <div class="nexcourseinterso">随着时代的进步，手机游戏已经成为时代的象征。熟练的使用模拟器进行多开，从而实现自动撸金币，做任务，在解放双手的同时，也赢得了丰厚的回报！当然PC端的游戏脚本也不能忽视，比如某讯的XXX游戏，就有很多玩家使用。所以学习脚本制作，迫在眉睫！</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★★☆</em></div>
                                <div class="nexcourserps"><em>1686</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course7

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=13" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course7.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>必<br>学</em>
                                        <span style="letter-spacing:2px;font-size:28px;">汇编基础</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">踏入内存解密的门槛</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">汇编入门基础</a></h5>
                            <div class="nexcourseinterso">什么是汇编？汇编大多是指汇编语言，汇编程序。把汇编语言翻译成机器语言的过程称为汇编。学习汇编，对游戏分析，软件逆向，有着极大的帮助！不会汇编的朋友，游戏数据分析和软件逆向就不要奢望去学了。</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★★☆</em></div>
                                <div class="nexcourserps"><em>1765</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

- course8

```html
<div class="nexcoursetop">
                        	<a href="http://www.yixuebc.com/forum.php?mod=viewthread&tid=16" target="_blank">
                            	<div class="nexcoursepiv"><img src="./template/zvis_edu_180113/neoconex/index/course8.jpg"></div>
                                <div class="nexcourseiners">
                                	<div class="nexcourse_name">
                                    	<em>火<br>爆</em>
                                        <span style="letter-spacing:2px;font-size:28px;">射击类游戏</span>
                                        <div class="clear"></div>
                                    </div>
                                    <div class="nexcoursetitles">射击类游戏实战课程</div>
                                </div>
                            </a>
                        </div>
                        <div class="nexcousebtm">
                        	<h5><a href="#" target="_blank">今晚吃鸡否？</a></h5>
                            <div class="nexcourseinterso">吃鸡，早已流传至大江南北，喜欢吃鸡的朋友必然知道，有一种东西叫做高科技！那么本套课程就是为您讲述此种高科技的制作原理！</div>
                            <div class="nexcourseghtns">
                            	<div class="nexcourselps">难度<em>★★★★</em></div>
                                <div class="nexcourserps"><em>1622</em>人在学</div>
                                <div class="clear"></div>
                            </div>
                        </div>
```

#### 入门精选,稳扎稳打

```html
<a href="http://www.yiqifeiyang.com/forum.php?mod=viewthread&tid=7" target="_blank">
                        	<img src="./template/zvis_edu_180113/neoconex/index/tc1.jpg">
                            <div class="nexpricetags">
                            	<span>原价：<i>￥199.00</i></span>
                                <em>现价：<b>￥19.00</b></em>
                                <div class="clear"></div>
                            </div>
                            <div class="nexbuylinks">立即购买</div>
                        </a>
```

```html
<a href="http://www.yiqifeiyang.com/forum.php?mod=viewthread&tid=21" target="_blank">
                        	<img src="./template/zvis_edu_180113/neoconex/index/tc2.jpg">
                            <div class="nexpricetags">
                            	<span>原价：<i>￥699.00</i></span>
                                <em>现价：<b>￥399.00</b></em>
                                <div class="clear"></div>
                            </div>
                            <div class="nexbuylinks">立即购买</div>
                        </a>
```

```html
<a href="http://www.yiqifeiyang.com/forum.php?mod=viewthread&tid=17" target="_blank">
                        	<img src="./template/zvis_edu_180113/neoconex/index/tc3.jpg">
                            <div class="nexpricetags">
                            	<span>原价：<i>￥6999.00</i></span>
                                <em>现价：<b>￥3999.00</b></em>
                                <div class="clear"></div>
                            </div>
                            <div class="nexbuylinks">立即购买</div>
                        </a>
```

```html
<a href="http://www.yiqifeiyang.com/forum.php?mod=viewthread&tid=18" target="_blank">
                        	<img src="./template/zvis_edu_180113/neoconex/index/tc4.jpg">
                            <div class="nexpricetags">
                            	<span>原价：<i>￥1389.00</i></span>
                                <em>现价：<b>￥699.00</b></em>
                                <div class="clear"></div>
                            </div>
                            <div class="nexbuylinks">立即购买</div>
                        </a>
```

