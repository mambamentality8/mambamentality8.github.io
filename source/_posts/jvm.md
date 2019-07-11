---
title: jvm
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: java
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

	### JVM内存模型的概述

- Java语言为甚么优势巨大，一处编译随处运行
- Java的另外一个优势
  - 自从内存管理机制之下，不再需要为没一个new操作去写配对的内存分配和回收等代码， 不容易出现内存泄漏和内存溢出等问题
- JVM运行时数据区分布图讲解
  - 线程共享数据区：方法区、堆
  - 线程隔离数据区：虚拟机栈、本地方法栈、程序计数器



![1562761287635](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1562761287635.png)

### JVM内存模型之程序计算器

- 是什么？
  - 程序计数器是一块较小的内存空间，它可以看作是当前线程所执行的字节码的行号指示器
  - 线程是一个独立的执行单元，是由CPU控制执行的
  - 字节码解释器工作时就是通过改变这个计数器的值来选取下一条需要执行的字节码指令，分支、循环、跳转、异常处理、线程恢复等基础功能都需要依赖这个计数器来完成

- 为什么？
  - 为了线程切换后能恢复到正确的执行位置，每条线程都需要有一个独立的程序计数器，各条线程之间计数器互不影响，独立存储，我们称这类内存区域为“线程私有”的内存

- 特点？
  - 内存区域中唯一一 个没有规定任何 OutOfMemoryError 情况的区域



### JVM内存模型之java虚拟机栈讲解

- 是什么？
  - 用于作用于方法执行的一块Java内存区域
- 为什么？
  - 每个方法在执行的同时都会创建一个栈帧（Stack Framel）用于存储局部变量表、操作数栈、动态链接、方法出口等信息。每一个方法从调用直至执行完成的过程，就对应着一个栈帧在虚拟机栈中入栈到出栈的过程
- 特点？
  - 局部变量表存放了编译期可知的各种基本数据类型（boolean、byte、char、short、int、float、long、double）以及对象引用（reference 类型）
  - 如果线程请求的栈深度大于虚拟机所允许的深度，将抛出 StackOverflowError 异常