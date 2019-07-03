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

# 哈希系列

1.搜索0x67452301 或者 1732584193

2.在所有找到的地方下断点

3.操作网页触发断点

4.回溯call stack 找到上层调用(一直找到这个语句所出现的函数,且这个函数的参数不为空.出现被加密数据明文的地方)即可看到签名字符串

​    如果找不到明文的函数调用栈那就说明不是MD5

5.找参数,这些肯定能找到的,要么在网页中,要么在提交的包里



页面上的数据(即在登录的HTML页面上的数据)一般都是动态生成的(只需在操作之前访问一下首页即可生成数据)

js文件中的数据一般是固定的





## MD5

32位

16进制

看到_createHelper和_createHmacHelper就要马上想到MD5

## SHA1

40位

16进制



## HMAC

40位带key

案例网站:<http://www.zol.com.cn/>