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

- 进入后台管理界面<http://www.yiqifeiyang.com/admin.php>

- 找到本次商业版安装，并设置为默认模板，提交保存，然后更新css缓存。

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

