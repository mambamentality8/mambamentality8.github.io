---
title: 常用的git操作命令
date: 
categories: 
    git
tags: 
    git
description: 常用的git操作命令
---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/git/title.png">

<!-- more -->

######### 查看本地git的配置  
```
git config --list
git config --global user.name "XXX"
git config --global user.email "XXXXXXXXXX@qq.com"
```


### 在当前目录新建一个git代码库
```
git init
```


### 下载一个项目和他的整个代码历史
```
git clone [url]
```


### 添加指定文件到暂存区
### 一般我用git add . 添加全部文件到暂存区
```
git add [file1] [file2]
```


### 显示变更信息
```
git status
```


### 显示当前分支的历史版本
```
git log
```


### 先git log查看一下自己有几次修改

### 查看当前连接的远程仓库
```
git remote -v 
git remote add origin https://xxxxxxxxx.git
```


### 将本地仓库推送到远程仓库
```
git push origin master 
git push <远程主机名> <本地分支名>:<远程分支名>
```




### 把远程代码从仓库拽下来  远程多 本地少 即可做更新
```
git pull origin master
```



### 删除git目录
```
rm -fr .git/
```


### 删除工作区文件,并且将这次删除放入暂存区
```
git rm [file1] [file2]
```


### 改名文件,并且将这个改名放入暂存区
```
git mv [file-origin] [file-renamed]
```


### 提交暂存区到仓库
```
git commit -m [message]
```


### 直接从工作区提交到仓库
### 前提该文件已经有仓库中的历史版本信息
```
git commit -a -m [message]
```





------------简单的操作------------
### 拥有.git文件的才是本地仓库

### 在本地一个空文件夹内使用
```
git clone https://xxxxxx
```


### 查看远程仓库的版本
```
git log 
```


### 查看连接的那个远程仓库
```
git remote -v
```


### 接着修改本地文件,修改完查看本地的状态
```
git status
```


### 修改的文件需要存放到暂存区
```
git add .
```


### 将暂存区的代码放入本地仓库
```
git commit  -m "xxxxxxx"
```


### 然后推送到远程仓库
```
git push
git push <远程主机名> <本地分支名>  <远程分支名>
```


-----------分支的操作------------
1 查看远程分支
```
git branch -a
```

2 查看本地分支
```
git branch
```

3 创建分支
```
git branch test
```


4 把分支推到远程分支 

```
git push origin test
```



附上廖老师的git教程 https://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000  
在线练习 https://try.github.io/  
技术排名 https://octoverse.github.com
