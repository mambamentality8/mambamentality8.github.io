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

# AES加密

1.首先要去找AES的观察几个重要的参数Mode、Key、IV(向量)、padding(填充模式)

- Mode分为CBC和ECB

  - CBC需要IV     ECB不需要IV

  

- Key和IV一般都是固定的值,一般都是以utf8的格式去解析

  - IV有可能进行base64编码,被编码的话用原来的值即可

  

- padding常用的有两种Pkcs7和Iso10126   

  - 一共有:NoPadding ZeroPadding Pkcs7(Pkcs5) Iso10126 Iso97971 AnsiX923
  - 其中Iso10126填充方式会让密码一直变化

  

- AES有两种输出的形式 Hex和Base64

  - Base64:  6k8v530OWIGRYjKzV6jMmA==
  - Hex:        ea4f2fe77d0e5881916232b357a8cc98  (类似MD5)

  

2.在所有找到的地方下断点

3.操作网页触发断点

4.回溯call stack 找到上层调用(出现被加密数据明文的地方)即可看到签名字符串

​    如果找不到明文的函数调用栈那就说明不是MD5

5.找参数,这些肯定能找到的,要么在网页中,要么在提交的包里



页面上的数据(即在登录的HTML页面上的数据)一般都是动态生成的(只需在操作之前访问一下首页即可生成数据)

js文件中的数据一般是固定的



案例网站:<http://www.zol.com.cn/>

标准AES格式如下:

```javascript
function AES(){  
    
    var pwd = "a12456"  
    var key = CryptoJS.enc.utf8.parse("4F233463B63EA99F");  //key和iv在使用之前要先解析成字节集其实这个解析不解析无所谓,默认就是uft8解析
    var iv  = CryptoJS.enc.utf8.parse("9BD2C547935C46F2"); //ECB模式没有偏移向量
    var value = CryptoJS.AES.encrypt(pwd,key,{   //DES的话就把AES换成DES  一般AES的秘钥是16个字节或者是32个字节8个字节也可以DES是8个字节3DES是24个字节
        mode:CryptoJS.mode.CBC,  
        padding:CryptoJS.pad.pkcs7,  
        iv:iv  
    }).toString()
    
    return value;
}
```

iv和key可能有不同的解析方式:

```javascript
//CryptoJS.enc.utf8.parse的几种形式

//把一个字符当做一个字节
var wordArray = CryptoJS.enc.Utf8.parse(utf8String);  
//和UTF8差不多UFT支持中文而Latin1不支持中文
var wordArray = CryptoJS.enc.Latin1.parse(latin1String);
var wordArray = CryptoJS.enc.Hex.parse(hexString);
//把两个字符当做一个字节
var wordArray = CryptoJS.enc.Base64.parse(base64String); 
```

