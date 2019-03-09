---
title: markdown语法练习
date: 
categories: 
    -markdown
tags: 
    -markdown
    
description: markdown语法
---
#内嵌式链接
- 外部链接:[百度](www.baidu.com)  
- 内部链接1:链接仓库的其它文件[demo1](markdown_demo1.md)
- 内部链接2:链接本文档的其它部分:[代码块demo](markdown_demo2.md#代码块)

#引用式链接
- 外部链接:[百度][bieming]
- 内部链接1:链接仓库的其它文件[demo1]
- 内部链接2:链接本文档的其它部分:[代码块demo]


#图片格式一
![alt](url tips)  
- 外部图片
![baidu](https://www.baidu.com/img/bd_logo1.png "悬停提示")
- 仓库内的图片demo
![](./imges/bd_logo1.png)

#图片格式二
![alt](url tips)  
- 外部图片
![baidu][baidu_logo]
- 仓库内的图片demo
![][inpng]

#引用
>这是一个引文  

出自<出处>

多次引用
>>> 这是多重引文

#代码块
- 行内代码
这个代码中用来声明变量是`var a = 10`,打印变量内容是`console.log`函数调用
- 块式代码
```javascript
var a = 10;
System.out.println(a);
```

<!--下面是本文档中用到的链接-->
[百度]: http://www.baidu.com
[bieming]: http://www.baidu.com
[demo1]:markdown_demo1.md
[代码块demo]:markdown_demo2.md#代码块
[baidu_logo]: https://www.baidu.com/img/bd_logo1.png
[inpng]:./imges/bd_logo1.png