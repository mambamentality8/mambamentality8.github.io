---
title: 逆向分析(二)----硬编码寻找序列号(作业)
top: 1110
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: windows逆向
image:




---

<p class="description"></p>
<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

- TranslateMessage

  - 当我们在GetWindowTextA和GetDlgItemTextA这两个函数上下断都没有反应的时候

  - 我们需要在command命令窗口中输入BP TranslateMessage (消息断点)

    ![1567409848287](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1567409848287.png)

  - TranslateMessage将虚拟摁键消息转换为字符消息的函数

  - 只要打上这个断点程序就会一直处于断点状态

  - 我们双击B窗口的断点

  - 所以我们需要给这个断点加上条件记录

    ![1567409553641](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1567409553641.png)

  - 

  - 

    