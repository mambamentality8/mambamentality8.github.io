---
title: 雷电模拟器环境搭建
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: 安卓逆向
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

### Xposed安装

- 在应用商店搜索下载Xposed
- 点击版本号
- 点击install,出现   完成!更改设备重启后生效   点击重启设备

### Inspeckage安装

- 安装Inspeckage插件

- 在Xposed菜单栏模块处勾选Inspeckage

- 打开Inspeckage如果不报红证明安装成功

- 打开Only user app

- 在choose target中选择要通杀的APP

- 选择成功之后会在Started on:中出现两个地址

- 打开cmd输入:

- ```
  adb forward tcp:8008 tcp:8008 (前提要有adb的环境)
  ```

- 如果出现device not found 需要重启雷电模拟器

- 再次输入命

- 打开127.0.0.1:8008

  