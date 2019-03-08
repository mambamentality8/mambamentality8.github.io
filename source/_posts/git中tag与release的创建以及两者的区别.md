---
title: git中tag与release的创建以及两者的区别
date: 
categories: 
    -github
tags: 
    -github
description: git中tag与release的创建以及两者的区别
---
#简介
本文辨析在参与开源项目时会遇到的tag与release的概念区别与联系，并比较两者的创建方法。
定义
标签（tag）是特定提交（commit)一个指针，也就是每个tag对应一个特定的commit。
Release是具有changelogs和二进制文件的一级对象，它可以代表超出Git架构本身的一个特定时间点之前的所有项目历史。也就是通过release，不但能够通过源码体现出项目历史，还能通过已经编译好的二进制文件来进一步描述此时的项目状态。“超出Git架构本身“的意思则在于，git本身只能记录项目修改，本质上不适合将编译好的项目二进制文件记录下来。而通过release则把项目二进制文件保存了下来，方便用户下载，也方便查找特定版本的二进制文件。
以下是Github official announcement所定义原文：

>Releases are first-class objects with changelogs and binary assets that present a full project history beyond Git artifacts.

创建方法
Release分为两种：lightweight and annotated.
创建lightweight类型的tag：
```
$ git tag v1.4-lw
```

创建annotated类型的tag：
```
$ git tag -a v1.4 -m "my version 1.4"
```


通过tag可以返回到项目的特定状态下，所以可以将tag看作是在大量commit中设定的书签。
创建release，则需要通过源码托管商的网页操作界面来进行，一般会要求填写tag名、分支以及相应的发布说明，还可上传编译好的程序、打包好的文件等。
比较
标签是git中的概念，而release则是Github、码云等源码托管商所提供的更高层的概念。也就是说git本身是没有release这个概念的，只有tag。
两者之间的关系则是，release基于tag，为tag添加更丰富的信息，一般是编译好的文件。
总结
Release是源码托管商对git的tag功能的增强。通过git提供的tag功能，我们可以给项目进行版本标识，以识别特定的版本，如v0.1.0、v1.0.0等。而通过源码托管商提供的release功能，在tag的基础上我们可以添加编译好的二进制文件等，如.deb、.exe等给特定的版本提供更多的信息，方便用户，也方便后期查找特定版本的程序。