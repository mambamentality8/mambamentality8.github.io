### What is redis

```
Redis is an open source (BSD licensed), in-memory data structure store, used as a database, cache and message broker. It supports data structures such as strings, hashes, lists, sets, sorted sets with range queries, bitmaps, hyperloglogs, geospatial indexes with radius queries and streams
```

### Why use it

- Advantages:

  - **Redis allows storing key and value pairs as large as 512 MB**. You can have huge keys and values of objects as big as 512 MB, which means that Redis will support up to 1GB of data for a single entry.

  - **Redis uses its own hashing mechanism called Redis Hashing**. Redis stores data in the form of a key and a map, i.e. string fields and string values. For example, the following code uses Redis hash to save user details:

    ```
    Map<String, String> user = new HashMap<>();
    user.put("username", "john123");
    user.put("firstName", "John");
    // use Jedis client
    jedis.hmset("user:john123", user);
    ```

  - ***Redis offers data replication***. Replication is the process of setting up master-slave cache nodes. The slave nodes always listen to the master node, which means that when the master node is updated, slaves will automatically be updated, as well. Redis can also update slaves asynchronously.

  - **The Redis cache can withstand failures and provide uninterrupted service**.* Since Redis can be used to set up efficient replication, at any point in time, the cache service will be up-and-running — even if any of the slave nodes are down. However, the nodes are resilient and will overcome the failure and continue providing service.

  - ***Redis has clients in all the popular programming languages***. Redis has client APIs developed in all the popular languages such as C, Ruby, Java, JavaScript, and Python. A full list of languages that Redis supports can be found on the [Redis Wikipedia page](https://en.wikipedia.org/wiki/Redis).

  - **Redis offers a pub/sub messaging system**.You can develop a high-performing messaging application using the Redis pub/sub mechanism using any language of your choice.

  - **Redis allows inserting huge amounts of data into its cache very easily**.Sometimes, it is required to load millions of pieces of data into the cache within a short period of time. This can be done easily using mass insertion, a feature supported by Redis.

  - **Redis can be installed in Raspberry Pi and ARM devices**. Redis has a small memory footprint and it can be installed in Raspberry Pi to enable IoT-based applications.

  - **Redis protocol makes it simple to implement a client**. A Redis client communicates with its server using RESP (Redis Serialization Protocol). This protocol is simple to implement and is human-readable.

  - **Redis support transactions**. Redis supports transactions, which means that commands can be executed as a queue instead of executing one at a time. Typically, commands after MULTI will be added to a queue and once EXEC is issued, all the commands saved in the queue will be executed at once.

### How to use it

```
wget yum install wget
wget http://download.redis.io/releases/redis-4.0.6.tar.gz
tar -zxvf redis-4.0.6.tar.gz
yum install gcc
cd redis-4.0.6
make MALLOC=libc
cd src ./redis-server
```

可能碰到的错误

```
could not retrieve mirrorlist
```

解决方法

```
1.sudo vim /etc/sysconfig/network-scripts/ifcfg-ens33 

2.将ONBOOT改为yes，wq!保存退出

3.重新启动网络  $ service network restart
```

### redis三种启动方式

- 直接启动

  - ```
    ./redis-server
    ```

- 通过指定配置文件启动

  - ```
    vi redis.conf
    /daemonize
    把no改为yes
    :x
    ./redis-server /usr/local/redis-4.0.6/redis.conf
    ```

- 使用redis启动脚本设置开机自启动，linux配置开启自启动 /etc/init.d

  - 配置步骤

    - 启动脚本 redis_init_script 位于Redis的 /utils/ 目录下

    - mkdir /etc/redis

    - cp redis.conf /etc/redis/6379.conf

    - 将启动脚本复制到/etc/init.d目录下，本例将启动脚本命名为redisd（通常都以d结尾表示是后台自启动服务）。

    - ```
      cp redis_init_script /etc/init.d/redisd
      ```

    - 设置为开机自启动，直接配置开启自启动 chkconfig redisd on 发现错误： service redisd does not support chkconfig

    - 解决办法，在启动脚本开头添加如下注释来修改运行级别：

    - ```
                    #!/bin/sh
                    # chkconfig:   2345 90 10
      ```

    - 设置为开机自启动服务器

    - chkconfig redisd on

    - service redisd start 打开服务

    - service redisd stop 关闭服务
    
### ssh的安装

- 检查CentOS7是否安装了openssh-server

- ```
  yum list installed | grep openssh-server
  ```

- 此处显示已经安装了 openssh-server

- 如果又没任何输出显示表示没有安装,通过输入yum install openssh-server安装

- ```
  yum install openssh-server
  ```

- 找到了 /etc/ssh/ 目录下的sshd服务配置文件 sshd_config，用Vim编辑器打开将文件中，关于监听端口、监听地址前的 # 号去除

- ```
          Port 22
          ListenAddress 0.0.0.0
          ListerAddress ::
          PermiRootLogin yes
          PasswordAuthentication yes
  ```

- 开启sshd服务，输入 sudo service sshd start

- 检查 sshd 服务是否已经开启，输入ps -ef | grep sshd

- 使用ip addr查看地址

- 为了免去每次开启 CentOS 时，都要手动开启 sshd 服务， 将 sshd 服务添加至自启动列表中，输入systemctl enable sshd.service

- 通过本机工具进行连接

### Redis和memcached的区别

- 内存管理机制
  - Memcached默认使用Slab Allocation机制管理内存，其主要思想是按照预先规定的大小， 将分配的内存分割成特定长度的块 以存储相应长度的key-value数据记录，以完全解决内存碎 片问题。空闲列表进行判断存储状态,【类似于Java虚拟机对象的分配，空闲列表】
  - Redis使用现场申请内存的方式来存储数据，并且很少使用free-list等方式来优化内存分配，会在一定程度上存在内存碎片,【CPU内存是连续，类似于Java虚拟机对象的分配，直接内存分配（指针碰撞）】
- 数据持久化方案
  - memcached不支持内存数据的持久化操作，所有的数据都以in-memory的形式存储。
  - redis支持持久化操作。redis提供了两种不同的持久化方法来讲数据存储到硬盘里面， 第一种是rdb形式，一种是aof形式
    - rdb：属于全量数据备份，备份的是数据
    - append only if,增量持久化备份，备份的是指令
  - 缓存数据过期机制
    - 概念：key，设计一个小时之后过期，超过一个小时查数据就会查不到
    - Memcached 在删除失效主键时也是采用的消极方法，即 Memcached 内部也不会监视主键是否失效，而是在通过 Get 访问主键时才会检查其是否已经失效
    - Redis 定时、定期等多种缓存失效机制，减少内存泄漏
  - 支持的数据类型
    - Memcached支持单一数据类型,[k,v]
    - redis支持多种数据类型

### redis作为数据库和作为缓存的选择

- redis作为数据库的使用有什么优缺点
  - 优点
    - 没有Scheme约束，数据结构的变更相对容易，一开始确定数据类型， 抗压能力强，性能极高，10万/qps
  - 缺点
    - 没有索引，没有外键，缺少int/date等基本数据类型，多条件查询需要通过集合内联(sinter,zinterstore) 和连接间接实现开发效率低，可维护性不佳
- redis作为缓存的使用，搭配数据库使用的两种方案
  - 第一层在缓存进行查询，如果得到数据则直接返回， 第二层在数据库进行查询，并且刷新缓存
  - 作为mybatis/hibernate二级缓存使用方案,  一级缓存：sqlSession，进程缓存，单次链接有效

### Redis五种数据类型和消息订阅

#### String
  - set/get
    - 设置key对应的值为String类型的value
    - 获取key对应的值
  - mget
    - 批量获取多个key的值，如果可以不存在则返回nil
  - incr && incrby
    - incr对key对应的值进行加加操作，并返回新的值;incrby加指定值
  - setnx
    - 设置key对应的值为String类型的value，如果key已经存在则返回0
  - setex
    - 设置key对应的值为String类型的value，并设定有效期
  - 其他命令
    - getrange 获取key对应value的子字符串
    - mset 批量设置多个key的值，如果成功表示所有值都被设置，否则返回0表示没有任何值被设置
    - msetnx，同mset，不存在就设置，不会覆盖已有的key
    - getset 设置key的值，并返回key旧的值
    - append：给指定key的value追加字符串，并返回新字符串的长度

#### Hash

- hset
  - 设置key对应的HashMap中的field的value
- hget
  - 获取key对应的HashMap中的field的value
- hgetall
  - 获取key对应的HashMap中的所有field的value
- hlen
  - 返回key对应的HashMap中的field的数量





- redis的Hash数据类型的key（hash表名称）对应的value实际的内部存储结构为一个HashMap
- Hash特别适合存储对象
- 相对于把一个对象的每个属性存储为String类型，将整个对象存储在Hash类型中会占用更少内存。
- 所存储的成员较少时数据存储为zipmap，当成员数量增大时会自动转成真正的HashMap,此时encoding为ht。
- 运用场景： 如用一个对象来存储用户信息，商品信息，订单信息等等。

#### List

- lpush
  - 在key对应的list的头部添加一个元素
- lrange
  - 获取key对应的list的指定下标范围的元素，-1表示获取所有元素
- lpop
  - 从key对应的list的尾部删除一个元素，并返回该元素
- rpush
  - 在key对应的list的尾部添加一个元素
- rpop
  - 从key对应的list的尾部删除一个元素，并返回该元素

#### Hash

- hset
  - 设置key对应的HashMap中的field的value
- hget
  - 获取key对应的HashMap中的field的value
- hgetall
  - 获取key对应的HashMap中的所有field的value
- hlen
  - 返回key对应的HashMap中的field的数量

#### SortSet(zset)

- zadd
  - 在key对应的zset中添加一个元素
- zrange
  - 获取key对应的zset中指定范围的元素，-1表示获取所有元素
- zrem
  - 删除key对应的zset中的一个元素
- zrangebyscore
  - 返回有序集key中，指定分数范围的元素列表,排行榜中运用
- zrank
  - 返回key对应的zset中指定member的排名。其中member按score值递增(从小到大）； 排名以0为底，也就是说，score值最小的成员排名为0,排行榜中运用



### redis发布订阅

- 作用：发布订阅类似于信息管道，用来进行系统之间消息解耦，类似于mq，rabbitmq、rocketmq、kafka、activemq主要有消息发布者和消息订阅者。比如运用于：订单支付成功，会员系统加积分、钱包进行扣钱操作、发货系统（下发商品）
- PUBLISH 将信息message发送到指定的频道channel。返回收到消息的客户端数量
- SUBSCRIBE 订阅给指定频道的信息
- UNSUBSCRIBE 取消订阅指定的频道，如果不指定，则取消订阅所有的频道。
- redis的消息订阅发布和mq对比？ 答：redis发布订阅功能比较薄弱但比较轻量级，mq消息持久化，数据可靠性比较差，无后台功能可msgId、msgKey进行查询消息

### Redis事务

- MULTI 与 EXEC命令
  - 以 MULTI 开始一个事务，然后将多个命令入队到事务中， 最后由 EXEC 命令触发事务， 一并执行事务中的所有命令
- DISCARD命令
  - DISCARD 命令用于取消一个事务， 它清空客户端的整个事务队列， 然后将客户端从事务状态调整回非事务状态， 最后返回字符串 OK 给客户端， 说明事务已被取消
- WATCH命令
  - WATCH 命令用于在事务开始之前监视任意数量的键： 当调用 EXEC 命令执行事务时， 如果任意一个被监视的键已经被其他客户端修改了， 那么整个事务不再执行， 直接返回失败。

### redis事务ACID

- 原子性（Atomicity）
  - 单个 Redis 命令的执行是原子性的，但 Redis 没有在事务上增加任何维持原子性的机制，所以 Redis 事务的执行并不是原子性的。如果一个事务队列中的所有命令都被成功地执行，那么称这个事务执行成功
- 一致性（Consistency）
  - 入队错误
    - 在命令入队的过程中，如果客户端向服务器发送了错误的命令，比如命令的参数数量不对，等等， 那么服务器将向客户端返回一个出错信息， 并且将客户端的事务状态设为 REDIS_DIRTY_EXEC 。
  - 执行错误
    - 如果命令在事务执行的过程中发生错误，比如说，对一个不同类型的 key 执行了错误的操作， 那么 Redis 只会将错误包含在事务的结果中， 这不会引起事务中断或整个失败，不会影响已执行事务命令的结果，也不会影响后面要执行的事务命令， 所以它对事务的一致性也没有影响
- 隔离性（Isolation）
  - WATCH 命令用于在事务开始之前监视任意数量的键： 当调用 EXEC 命令执行事务时， 如果任意一个被监视的键已经被其他客户端修改了， 那么整个事务不再执行， 直接返回失败
- 持久性（Durability）
  - 因为事务不过是用队列包裹起了一组 Redis 命令，并没有提供任何额外的持久性功能，所以事务的持久性由 Redis 所使用的持久化模式决定

### 缓存的收益和成本

- 缓存带来的回报
  - 高速读写
    - 缓存加速读写速度：缓存数据库结果
  - 降低后端负载
    - 前端缓存降低后端服务器负载
    - 业务端使用Redis降低后端MySQL负载等
- 缓存带来的代价
  - 数据不一致
    - 缓存层和数据层有时间窗口不一致，和更新策略有关
  - 代码维护成本
    - 原本只需要读写MySQL就能实现功能，但加入了缓存之后就要去维护缓存的数据，增加了代码复杂度。
  - 堆内缓存可能带来内存溢出的风险影响用户进程
  - 堆内缓存和远程服务器缓存redis的选择
    - 堆内缓存一般性能更好，远程缓存需要套接字传输
    - 用户级别缓存尽量采用远程缓存
    - 大数据量尽量采用远程缓存，服务节点化原则

### 缓存雪崩

- 什么是缓存雪崩?
  - 如果缓存集中在一段时间内失效，发生大量的缓存穿透，所有的查询都落在数据库上，造成了缓存雪崩。由于原有缓存失效，新缓存未到期间所有原本应该访问缓存的请求都去查询数据库了，而对数据库CPU 和内存造成巨大压力，严重的会造成数据库宕机
- 如何防止缓存雪崩
  - 加锁排队
    - key： whiltList value：1000w个uid 指定setNx whiltList value nullValue mutex互斥锁解决，Redis的SETNX去set一个mutex key， 当操作返回成功时，再进行load db的操作并回设缓存； 否则，就重试整个get缓存的方法
  - 数据预热
    - 缓存预热就是系统上线后，将相关的缓存数据直接加载到缓存系统。这样就可以避免在用户请求的时候，先查询数据库，然后再将数据缓存的问题!用户直接查询事先被预热的缓存数据!可以通过缓存reload机制，预先去更新缓存，再即将发生大并发访问前手动触发加载缓存不同的key
  - 双层缓存策略
    - C1为原始缓存，C2为拷贝缓存，C1失效时，可以访问C2，C1缓存失效时间设置为短期，C2设置为长期。
  - 定时更新缓存策略
    - 失效性要求不高的缓存，容器启动初始化加载，采用定时任务更新或移除缓存
  - 设置不同的过期时间，让缓存失效的时间点尽量均匀

### 缓存穿透

- 什么是缓存穿透？
  - 缓存穿透是指用户查询数据，在数据库没有，自然在缓存中也不会有。这样就导致用户查询的时候， 在缓存中找不到对应key的value，每次都要去数据库再查询一遍，然后返回空(相当于进行了两次 无用的查询)。这样请求就绕过缓存直接查数据库

- 如何防止缓存穿透?
  - 采用布隆过滤器BloomFilter
    - 将所有可能存在的数据哈 希到一个足够大的 bitmap 中，一个一定不存在的数据会被这个 bitmap 拦截掉，从而避免了对底层存储系统的查询压力
  - 缓存空值
    - 如果一个查询返回的数据为空(不管是数据不 存在，还是系统故障)我们仍然把这个空结果进行缓存，但它的过期时间会很短，最长不超过五分钟。 通过这个直接设置的默认值存放到缓存，这样第二次到缓冲中获取就有值了，而不会继续访问数据库