### ElasticSearch第一天

##### 学习目标：

1. 能够理解ElasticSearch的作用
2. 能够安装ElasticSearch服务
3. 能够理解ElasticSearch的相关概念
4. 能够使用Postman发送Restful请求操作ElasticSearch 
5. 能够理解分词器的作用
6. 能够使用ElasticSearch集成IK分词器
7. 能够完成es集群搭建

### 第一章 ElasticSearch简介

#### 1.1 什么是ElasticSearch

​	Elaticsearch，简称为es， es是一个开源的高扩展的分布式全文检索引擎，它可以近乎实时的存储、检索数据；本 身扩展性很好，可以扩展到上百台服务器，处理PB级别的数据。es也使用Java开发并使用Lucene作为其核心来实 
现所有索引和搜索的功能，但是它的目的是通过简单的RESTful API来隐藏Lucene的复杂性，从而让全文搜索变得 简单。

#### 1.2 ElasticSearch的使用案例

- 2013年初，GitHub抛弃了Solr，采取ElasticSearch 来做PB级的搜索。 “GitHub使用ElasticSearch搜索20TB 的数据，包括13亿文件和1300亿行代码”
- 维基百科：启动以elasticsearch为基础的核心搜索架构 
  SoundCloud：“SoundCloud使用ElasticSearch为1.8亿用户提供即时而精准的音乐搜索服务” 
- 百度：百度目前广泛使用ElasticSearch作为文本数据分析，采集百度所有服务器上的各类指标数据及用户自 
  定义数据，通过对各种数据进行多维分析展示，辅助定位分析实例异常或业务层面异常。目前覆盖百度内部 20多个业务线（包括casio、云分析、网盟、预测、文库、直达号、钱包、风控等），单集群最大100台机 器，200个ES节点，每天导入30TB+数据
- 新浪使用ES 分析处理32亿条实时日志
- 阿里使用ES 构建挖财自己的日志采集和分析体系

#### 1.3 ElasticSearch对比Solr

- Solr 利用 Zookeeper 进行分布式管理，而 Elasticsearch 自身带有分布式协调管理功能;
- Solr 支持更多格式的数据，而 Elasticsearch 仅支持json文件格式；
- Solr 官方提供的功能更多，而 Elasticsearch 本身更注重于核心功能，高级功能多有第三方插件提供； 
- Solr 在传统的搜索应用中表现好于 Elasticsearch，但在处理实时搜索应用时效率明显低于 Elasticsearch

### 第二章 ElasticSearch安装与启动

#### 2.1 下载ES压缩包

ElasticSearch分为Linux和Window版本，基于我们主要学习的是ElasticSearch的Java客户端的使用，所以我们课 程中使用的是安装较为简便的Window版本，项目上线后，公司的运维人员会安装Linux版的ES供我们连接使用。

ElasticSearch的官方地址： https://www.elastic.co/products/elasticsearch

![1579225701614](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1579225701614.png)

![1579225908767](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1579225908767.png)

![1579225915351](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1579225915351.png)

![1579225919916](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1579225919916.png)

在资料中已经提供了下载好的5.6.8的压缩包：

#### 2.2 安装ES服务

Window版的ElasticSearch的安装很简单，类似Window版的Tomcat，解压开即安装完毕，解压后的ElasticSearch 的目录结构如下：

![1579225943266](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1579225943266.png)

修改elasticsearch配置文件：conﬁg/elasticsearch.yml，增加以下两句命令：

```

```

