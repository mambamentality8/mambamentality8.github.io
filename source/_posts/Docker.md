---
title: Docker
top: 9998
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
description: springboot
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

### Docker是什么

###	为什么要使用 Docker

### 如何使用Docker

##### 1. centOS7安装Docker实战

- 添加yum源。

```
yum install epel-release –y
yum clean all
yum list
```

- 安装并运行Docker

```
yum install docker-io –y
systemctl start docker
```

- 检查安装结果。

```
docker info
```

如果出现docker的信息则证明安装成功



- Docker守护进程管理

```
systemctl start docker     #运行Docker守护进程
systemctl stop docker      #停止Docker守护进程
systemctl restart docker   #重启Docker守护进程
```



阿里云安装手册

```
https://help.aliyun.com/document_detail/51853.html?spm=a2c4g.11186623.6.820.RaToNY
```



##### 2.Docker仓库、镜像、容器核心知识讲解

```
Docker 镜像 - Docker images：
				 容器运行时的只读模板，操作系统+软件运行环境+用户程序
				 
				 class User{
					 private String userName;
					 private int age;
				 }
				 
Docker 容器 - Docker containers：
                 容器包含了某个应用运行所需要的全部环境
				
				 User user = new User()
				 
Docker 仓库 - Docker registeries： 
				用来保存镜像，有公有和私有仓库，好比Maven的中央仓库和本地私服
	
		中央镜像仓库：https://hub.docker.com/
		
		（参考）配置国内镜像仓库：https://blog.csdn.net/zzy1078689276/article/details/77371782

对比面向对象的方式
Dokcer 里面的镜像 : Java里面的类 Class
Docker 里面的容器 : Java里面的对象 Object
通过类创建对象，通过镜像创建容器
```



##### 3.Docker容器常见命令实战

```
常用命令（安装部署好Dokcer后，执行的命令是docker开头）,xxx是镜像名称

		搜索镜像：docker search xxx
		
		列出当前系统存在的镜像：docker images  (硬盘)
		
		拉取镜像：docker pull xxx   xxx是具体某个镜像名称(格式 REPOSITORY:TAG)
								  REPOSITORY：表示镜像的仓库源,TAG：镜像的标签
								 
								  
		运行一个容器：docker run -d --name "别名demo_mq" -p 5672:5672 -p 15672:15672 rabbitmq:management
		
			docker run - 运行一个容器
			-d 后台运行
			-p 端口映射  物理机端口:容器端口  两个 -p 是因为这个mq有两个程序
			rabbitmq:management  (格式 REPOSITORY:TAG)，如果不指定tag，默认使用最新的
			--name "xxx"
			
		运行完容器之后会返回一个container ID
		
		列举当前运行的容器：docker ps	 (内存)
		
		检查容器内部信息：docker inspect 容器名称
		
		删除镜像：docker rmi IMAGE_NAME
			 强制移除镜像不管是否有容器使用该镜像 增加 -f 参数，
		
		停止某个容器：docker stop 容器名称
		
		启动某个容器：docker start 容器名称
		
		移除某个容器： docker rm 容器名称 （容器必须是停止状态）
	
	docker参考文档：
		https://blog.csdn.net/permike/article/details/51879578
```

##### 4.Docker实战部署nginx服务器

```
1、docker images #查看当前镜像
2、docker run #如果有(首先会从本地找镜像，如果有则直接启动，没有的话，从镜像仓库拉起，再启动) 
3、docker search nignx #如果没有去中央仓库搜索
2、docker images #列举 
3、docker pull nignx #拉取 
4、docker run -d --name "xdclass_nginx" -p 8088:80 nginx #启动 
   docker run -d --name "xdclass_nginx2" -p 8089:80 nginx 
   docker run -d --name "xdclass_nginx3" -p 8090:80 nginx 
5、访问 如果是阿里云服务，记得配置安全组，腾讯云也需要配置，这个就是一个防火墙
6、curl "http://127.0.0.1:8088" #测试nginx是否启动 
```

##### 5.Docker镜像仓库使用讲解

```
官方公共镜像仓库和私有镜像仓库
公共镜像仓库：
官方：https://hub.docker.com/，基于各个软件开发或者有软件提供商开发的
非官方：其他组织或者公司开发的镜像，供大家免费试用
私有镜像仓库：用于存放公司内部的镜像，不提供给外部试用； 
SpringCloud 开发了一个支付系统 -》做成一个镜像 （操作系统+软件运行环境+用户程序）
```

