### 1.Redis是什么

- Redis 是一个开源（BSD许可）的，内存中的数据结构存储系统，它可以用作数据库、缓存和消息中间件。 它支持多 种类型的数据结构，如 字符串（strings）、散列（hashes）、 列表（lists）、 集合（sets）、 有序集合（sorted sets）等。

### 2.为什么要用redis

- 从数据库类型、数据存储方式、特殊功能讲解Redis和memcached的区别
  - 内存管理机制
    - Memcached默认使用Slab Allocation机制管理内存，其主要思想是按照预先规定的大小， 将分配的内存分割成特定长度的块 以存储相应长度的key-value数据记录，以完全解决内存碎 片问题。空闲列表进行判断存储状态,【类似于Java虚拟机对象的分配，空闲列表】
    - Redis使用现场申请内存的方式来存储数据，并且很少使用free-list等方式来优化内存分配，会在一定程度上存在内存碎片,【CPU内存是连续，类似于Java虚拟机对象的分配，直接内存分配（指针碰撞）】
  - 数据持久化方案
    - memcached不支持内存数据的持久化操作，所有的数据都以in-memory的形式存储。
    - redis支持持久化操作。redis提供了两种不同的持久化方法来讲数据存储到硬盘里面， 第一种是rdb形式，一种是aof形式
      - rdb：属于全量数据备份，备份的是数据
      - aof：append only if,增量持久化备份，备份的是指令
  - 缓存数据过期机制
    - 概念：key，设计一个小时之后过期，超过一个小时查数据就会查不到
    - Memcached 在删除失效主键时也是采用的消极方法，即 Memcached 内部也不会监视主键是否失效，而是在通过 Get 访问主键时才会检查其是否已经失效
    - Redis 定时、定期等多种缓存失效机制，减少内存泄漏
    - Memcached支持单一数据类型,[k,v]
    - redis支持五种数据类型

### 3.如何使用redis

- 安装wget 			                          yum install wget
- 下载redis安装包                           wget <http://download.redis.io/releases/redis-4.0.6.tar.gz>
- 解压压缩包                                    tar -zxvf redis-4.0.6.tar.gz
- 安装gcc                                          yum install gcc
- 跳转到redis解压目录下                cd redis-4.0.6
- 编译安装                                        make MALLOC=libc
- 启动redis                                       cd src ./redis-server

### 4.redis三种启动方式以及其中的使用区别

- 直接启动

- 通过指定配置文件启动

- 使用redis启动脚本设置开机自启动，linux配置开启自启动 /etc/init.d

  - 配置步骤

    - 启动脚本 redis_init_script 位于Redis的 /utils/ 目录下
    - mkdir /etc/redis
    - cp redis.conf /etc/redis/6379.conf
    - 将启动脚本复制到/etc/init.d目录下，本例将启动脚本命名为redisd（通常都以d结尾表示是后台自启动服务）。

    ```
    cp redis_init_script /etc/init.d/redisd
    ```

  - 设置为开机自启动，直接配置开启自启动 chkconfig redisd on 发现错误： service redisd does not support chkconfig

    解决办法，在启动脚本开头添加如下注释来修改运行级别：

    ```
    #!/bin/sh
    # chkconfig:   2345 90 10
    ```

  - 设置为开机自启动服务器
    - chkconfig redisd on
    - service redisd start 打开服务
    - service redisd stop 关闭服务

