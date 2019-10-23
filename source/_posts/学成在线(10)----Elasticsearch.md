# Elasticearch

### 介绍

![1524301994916](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524301994916.png)

官方网址：https://www.elastic.co/cn/products/elasticsearch

Github：https://github.com/elastic/elasticsearch

总结：

1、elasticsearch是一个基于Lucene的高扩展的分布式搜索服务器，支持开箱即用。

2、elasticsearch隐藏了Lucene的复杂性，对外提供Restful 接口来操作索引、搜索。



突出优点：

1.扩展性好，可部署上百台服务器集群，处理PB级数据。

2.近实时的去索引数据、搜索数据。

 

es和solr选择哪个？

1.如果你公司现在用的solr可以满足需求就不要换了。

2.如果你公司准备进行全文检索项目的开发，建议优先考虑elasticsearch，因为像Github这样大规模的搜索都在用它。

### 原理与应用

#### 索引结构

下图是ElasticSearch的索引结构，下边黑色部分是物理结构，上边黄色部分是逻辑结构，逻辑结构也是为了更好的去描述ElasticSearch的工作原理及去使用物理结构中的索引文件。

![1530279544767](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530279544767.png)

逻辑结构部分是一个倒排索引表：

1、将要搜索的文档内容分词，所有不重复的词组成分词列表。

2、将搜索的文档最终以Document方式存储起来。

3、每个词和docment都有关联。

如下：

![1530280342780](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530280342780.png)

现在，如果我们想搜索 `quick brown` ，我们只需要查找包含每个词条的文档：

![1530280421222](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530280421222.png)

​	两个文档都匹配，但是第一个文档比第二个匹配度更高。如果我们使用仅计算匹配词条数量的简单 *相似性算法* ，那么，我们可以说，对于我们查询的相关性来讲，第一个文档比第二个文档更佳。

#### RESTful应用方法

如何使用es？

Elasticsearch提供 RESTful Api接口进行索引、搜索，并且支持多种客户端。

![1524302855806](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524302855806.png)

下图是es在项目中的应用方式：

![1524462100383](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524462100383.png)

1）用户在前端搜索关键字

2）项目前端通过http方式请求项目服务端

3）项目服务端通过Http RESTful方式请求ES集群进行搜索

4）ES集群从索引库检索数据。

### ElasticaSearch安装

安装配置：

1、新版本要求至少jdk1.8以上。

2、支持tar、zip、rpm等多种安装方式。

在windows下开发建议使用ZIP安装方式。

3、支持docker方式安装

详细参见：https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html

下载ES: Elasticsearch 6.2.1

https://www.elastic.co/downloads/past-releases

解压 elasticsearch-6.2.1.zip

![1524486958527](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524486958527.png)

bin：脚本目录，包括：启动、停止等可执行脚本

config：配置文件目录

data：索引目录，存放索引文件的地方  (自己创建一个空目录即可)

logs：日志目录

modules：模块目录，包括了es的功能模块

plugins :插件目录，es支持插件机制

#### 配置文件

ES的配置文件的地址根据安装形式的不同而不同：

使用zip、tar安装，配置文件的地址在安装目录的config下。

使用RPM安装，配置文件在/etc/elasticsearch下。

使用MSI安装，配置文件的地址在安装目录的config下，并且会自动将config目录地址写入环境变量ES_PATH_CONF。

 

本教程使用的zip包安装，配置文件在ES安装目录的config下。



配置文件如下：

elasticsearch.yml ：用于配置Elasticsearch运行参数 

jvm.options ：用于配置Elasticsearch JVM设置 

log4j2.properties：用于配置Elasticsearch日志

##### elasticsearch.yml

配置格式是YAML，可以采用如下两种方式：

方式1：层次方式

```
path:
 	data: /var/lib/elasticsearch
 	logs: /var/log/elasticsearch
```

​			data: /var/lib/elasticsearch 	logs: /var/log/elasticsearch

方式2：属性方式

```
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
```

本项目采用方式2，例子如下：

```
 
cluster.name: xuecheng
node.name: xc_node_1
network.host: 0.0.0.0
http.port: 9200
transport.tcp.port: 9300
node.master: true
node.data: true
#discovery.zen.ping.unicast.hosts: ["0.0.0.0:9300", "0.0.0.0:9301", "0.0.0.0:9302"]
discovery.zen.minimum_master_nodes: 1
bootstrap.memory_lock: false
node.max_local_storage_nodes: 1
 
path.data: D:\ElasticSearch\elasticsearch-6.2.1\data
path.logs: D:\ElasticSearch\elasticsearch-6.2.1\logs
 
http.cors.enabled: true
http.cors.allow-origin: /.*/
```

注意path.data和path.logs路径配置正确。



常用的配置项如下：

cluster.name: 

​	配置elasticsearch的集群名称，默认是elasticsearch。建议修改成一个有意义的名称。

node.name:

​	节点名，通常一台物理服务器就是一个节点，es会默认随机指定一个名字，建议指定一个有意义的名称，方便管理

​	一个或多个节点组成一个cluster集群，集群是一个逻辑的概念，节点是物理概念，后边章节会详细介绍。

path.conf:  	设置配置文件的存储路径，tar或zip包安装默认在es根目录下的config文件夹，rpm安装默认在/etc/ elasticsearch path.data: 	设置索引数据的存储路径，默认是es根目录下的data文件夹，可以设置多个存储路径，用逗号隔开。 path.logs: 	设置日志文件的存储路径，默认是es根目录下的logs文件夹 path.plugins:  	设置插件的存放路径，默认是es根目录下的plugins文件夹

bootstrap.memory_lock: true 	设置为true可以锁住ES使用的内存，避免内存与swap分区交换数据。 network.host:  	设置绑定主机的ip地址，设置为0.0.0.0表示绑定任何ip，允许外网访问，生产环境建议设置为具体的ip。 http.port: 9200 	设置对外服务的http端口，默认为9200。

transport.tcp.port: 9300  集群结点之间通信端口

node.master:  	指定该节点是否有资格被选举成为master结点，默认是true，如果原来的master宕机会重新选举新的master。 node.data:  	指定该节点是否存储索引数据，默认为true。

discovery.zen.ping.unicast.hosts: ["host1:port", "host2:port", "..."] 	设置集群中master节点的初始列表。

discovery.zen.ping.timeout: 3s 	设置ES自动发现节点连接超时的时间，默认为3秒，如果网络延迟高可设置大些。 discovery.zen.minimum_master_nodes:

​	主结点数量的最少值 ,此值的公式为：(master_eligible_nodes / 2) + 1 ，比如：有3个符合要求的主结点，那么这里要设置为2。

node.max_local_storage_nodes: 

​	单机允许的最大存储结点数，通常单机启动一个结点建议设置为1，开发环境如果单机启动多个节点可设置大于1.

##### jvm.options

设置最小及最大的JVM堆内存大小：

在jvm.options中设置 -Xms和-Xmx：

1） 两个值设置为相等

2） 将`Xmx` 设置为不超过物理内存的一半。

##### log4j2.properties

日志文件设置，ES使用log4j，注意日志级别的配置。

#### 系统配置

在linux上根据系统资源情况，可将每个进程最多允许打开的文件数设置大些。

su limit -n 查询当前文件数

使用命令设置limit:

先切换到root，设置完成再切回elasticsearch用户。

```
sudo su  
ulimit -n 65536 
su elasticsearch 
```

也可通过下边的方式修改文件进行持久设置

/etc/security/limits.conf

将下边的行加入此文件：

```
elasticsearch  -  nofile  65536
```

#### 启动ES

进入bin目录，在cmd下运行：elasticsearch.bat

![1530791794397](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530791794397.png)

浏览器输入：http://localhost:9200

显示结果如下（配置不同内容则不同）说明ES启动成功：

```
{
  "name" : "xc_node_1",
  "cluster_name" : "xuecheng",
  "cluster_uuid" : "WtUvAYwRSQeQurvizmooLg",
  "version" : {
    "number" : "6.2.1",
    "build_hash" : "7299dc3",
    "build_date" : "2018-02-07T19:34:26.990113Z",
    "build_snapshot" : false,
    "lucene_version" : "7.2.1",
    "minimum_wire_compatibility_version" : "5.6.0",
    "minimum_index_compatibility_version" : "5.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

#### head插件安装

​	head插件是ES的一个可视化管理插件，用来监视ES的状态，并通过head客户端和ES服务进行交互，比如创建映射、创建索引等，head的项目地址在https://github.com/mobz/elasticsearch-head 。

从ES6.0开始，head插件支持使得node.js运行。

1、安装node.js

 

2、下载head并运行

git clone git://github.com/mobz/elasticsearch-head.git cd elasticsearch-head npm install npm run start open HTTP：//本地主机：9100 /



3、运行

![1524491198522](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524491198522.png)

打开浏览器调试工具发现报错：

Origin null is not allowed by Access-Control-Allow-Origin.

原因是：head插件9100端口作为客户端要连接ES服务（localhost:9200），此时存在跨域问题，elasticsearch默认不允许跨域访问。

解决方案：

设置elasticsearch允许跨域访问。

在config/elasticsearch.yml    后面增加以下参数：

\#开启cors跨域访问支持，默认为false http.cors.enabled: true #跨域访问允许的域名地址，(允许所有域名)以上使用正则 http.cors.allow-origin: /.*/ 

注意：将config/elasticsearch.yml另存为utf-8编码格式。

 

成功连接ES

![1524491355402](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524491355402.png)

 ### ES快速入门

​	ES作为一个索引及搜索服务，对外提供丰富的REST接口，快速入门部分的实例使用head插件来测试，目的是对ES的使用方法及流程有个初步的认识。

#### 创建索引库

```
mysql: database   table   			  rocord     columns
	   table
es   : index	  (type)(只能存在一个)    document   field 
```

<font size="5" color="red">6.0版本index对应mysql的表,弱化了type的概念</font>

<font size="5" color="red">6.0版本之前type对应mysql的表</font>

ES的索引库是一个逻辑概念，它包括了分词列表及文档列表，同一个索引库中存储了相同类型的文档。它就相当于MySQL中的表，或相当于Mongodb中的集合。

关于索引这个语：

索引（名词）：ES是基于Lucene构建的一个搜索服务，它要从索引库搜索符合条件索引数据。

索引（动词）：索引库刚创建起来是空的，将数据添加到索引库的过程称为索引。

下边介绍两种创建索引库的方法，它们的工作原理是相同的，都是客户端向ES服务发送命令。

1）使用postman或curl这样的工具创建：

put  http://localhost:9200/索引库名称

raw   json模式

```
{
  "settings":{
  "index":{
      "number_of_shards":1,
      "number_of_replicas":0
    }  
  }
}
```

number_of_shards：设置分片的数量，在集群中通常设置多个分片，表示一个索引库将拆分成多片分别存储不同的结点，提高了ES的处理能力和高可用性，入门程序使用单机环境，这里设置为1。

number_of_replicas：设置副本的数量，设置副本是为了提高ES的高可靠性，单机环境设置为0.

 

如下是创建的例子，创建xc_course索引库，共1个分片，0个副本：

![1530281604548](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530281604548.png)

2）使用head插件创建

![1530281631848](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530281631848.png)

效果如下：

![1530281734463](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530281734463.png)

#### 创建映射

##### 概念说明

​	在索引中每个文档都包括了一个或多个field，创建映射就是向索引库中创建field的过程，下边是document和field与关系数据库的概念的类比：

​	     文档（Document）----------------Row记录

​		   字段（Field）-------------------Columns 列 

​	注意：6.0之前的版本有type（类型）概念，type相当于关系数据库的表，ES官方将在ES9.0版本中彻底删除type。

上边讲的创建索引库相当于关系数据库中的数据库还是表？

1、如果相当于数据库就表示一个索引库可以创建很多不同类型的文档，这在ES中也是允许的。

2、如果相当于表就表示一个索引库只能存储相同类型的文档，ES官方建议 在一个索引库中只存储相同类型的文档。

##### 创建映射(定义表头)

我们要把课程信息存储到ES中，这里我们创建课程信息的映射，先来一个简单的映射，如下：

发送：post http://localhost:9200/索引库名称/类型名称/_mapping

创建类型为xc_course的映射，共包括三个字段：name、description、studymondel

由于ES6.0版本还没有将type彻底删除，所以暂时把type起一个没有特殊意义的名字。

post 请求：http://localhost:9200/xc_course/doc/_mapping

表示：在xc_course索引库下的doc类型下创建映射。doc是类型名，可以自定义，在ES6.0中要弱化类型的概念，给它起一个没有具体业务意义的名称。

```
 {
    "properties": {
           "name": {
              "type": "text"
           },
           "description": {
              "type": "text"
           },
           "studymodel": {
              "type": "keyword"
           }
        }
}
```

#### 创建文档

ES中的文档相当于MySQL数据库表中的记录。

发送：put 或Post http://localhost:9200/xc_course/doc/id值

（如果不指定id值ES会自动生成ID）

http://localhost:9200/xc_course/doc/4028e58161bcf7f40161bcf8b77c0000

```
{
  "name":"Bootstrap开发框架",
  "description":"Bootstrap是由Twitter推出的一个前台页面开发框架，在行业之中使用较为广泛。此开发框架包含了大量的CSS、JS程序代码，可以帮助开发者（尤其是不擅长页面开发的程序人员）轻松的实现一个不受浏览器限制的精美界面效果。",
  "studymodel":"201001"
}
```

使用postman测试：

![1530282116894](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530282116894.png)

通过head查询数据：

![1530282065444](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530282065444.png)

#### 搜索文档

1、根据课程id查询文档

发送：get http://localhost:9200/xc_course/doc/4028e58161bcf7f40161bcf8b77c0000

使用postman测试：

![1530282217051](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1530282217051.png)

2、查询所有记录

发送 get http://localhost:9200/xc_course/doc/_search

 

3、查询名称中包括spring 关键字的的记录

发送：get http://localhost:9200/xc_course/doc/_search?q=name:bootstrap

 

4、查询学习模式为201001的记录

发送 get http://localhost:9200/xc_course/doc/_search?q=studymodel:201001



 ##### 查询结果分析

分析上边查询结果：

```
 
{
    "took": 1,
    "timed_out": false,
    "_shards": {
        "total": 1,
        "successful": 1,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": 1,
        "max_score": 0.2876821,
        "hits": [
            {
                "_index": "xc_course",
                "_type": "doc",
                "_id": "4028e58161bcf7f40161bcf8b77c0000",
                "_score": 0.2876821,
                "_source": {
                    "name": "Bootstrap开发框架",
                    "description": "Bootstrap是由Twitter推出的一个前台页面开发框架，在行业之中使用较为广泛。此开发框架包含了大量的CSS、JS程序代码，可以帮助开发者（尤其是不擅长页面开发的程序人员）轻松的实现一个不受浏览器限制的精美界面效果。",
                    "studymodel": "201001"
                }
            }
        ]
    }
}
```

took：本次操作花费的时间，单位为毫秒。

timed_out：请求是否超时

_shards：说明本次操作共搜索了哪些分片

hits：搜索命中的记录

hits.total ： 符合条件的文档总数 hits.hits ：匹配度较高的前N个文档

hits.max_score：文档匹配得分，这里为最高分

_score：每个文档都有一个匹配度得分，按照降序排列。

_source：显示了文档的原始内容。

### IK分词器

#### 测试分词器

在添加文档时会进行分词，索引中存放的就是一个一个的词（term），当你去搜索时就是拿关键字去匹配词，最终找到词关联的文档。

测试当前索引库使用的分词器：

post 发送：localhost:9200/_analyze

```
{"text":"测试分词器，后边是测试内容：spring cloud实战"}
```

结果如下：

![1524553518406](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524553518406.png)

会发现分词的效果将 “测试” 这个词拆分成两个单字“测”和“试”，这是因为当前索引库使用的分词器对中文就是单字分词。

#### 安装IK分词器

使用IK分词器可以实现对中文分词的效果。

下载IK分词器：（Github地址：https://github.com/medcl/elasticsearch-analysis-ik）

下载zip：

![1524553740977](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524553740977.png)

解压，并将解压的文件拷贝到ES安装目录的plugins下的ik目录下

![1524554125371](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524554125371.png)

<font size="5" color ="red">此时要重启ES服务</font>

测试分词效果：

发送：post localhost:9200/_analyze

```
{"text":"测试分词器，后边是测试内容：spring cloud实战","analyzer":"ik_max_word" }
```

#### 两种分词模式

ik分词器有两种分词模式：ik_max_word和ik_smart模式。

1、ik_max_word

​	会将文本做最细粒度的拆分，比如会将“中华人民共和国人民大会堂”拆分为“中华人民共和国、中华人民、中华、华人、人民共和国、人民、共和国、大会堂、大会、会堂等词语。

2、ik_smart

​	会做最粗粒度的拆分，比如会将“中华人民共和国人民大会堂”拆分为中华人民共和国、人民大会堂。

测试两种分词模式：

发送：post localhost:9200/_analyze

```
{"text":"中华人民共和国人民大会堂","analyzer":"ik_smart" }
```

#### 自定义词库

如果要让分词器支持一些专有词语，可以自定义词库。

iK分词器自带一个main.dic的文件，此文件为词库文件。

![1524554345446](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524554345446.png)

在上边的目录中新建一个my.dic文件（注意文件格式为utf-8（不要选择utf-8 BOM））

可以在其中自定义词汇：

比如定义：

```
高富帅
```

在IKAnalyzer.cfg.xml配置文件中配置my.dic，

![1524554901939](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524554901939.png)

<font size="5" color = "red">重启ES，测试分词效果：</font>

发送：post localhost:9200/_analyze

```
{"text":"高富帅","analyzer":"ik_max_word" }
```

![1524554930923](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524554930923.png)

### 映射

​	上边章节安装了ik分词器，如何在索引和搜索时去使用ik分词器呢？如何指定其它类型的field，比如日期类型、数值类型等。

本章节学习各种映射类型及映射维护方法。

#### 映射维护方法

1、查询所有索引的映射：

GET： http://localhost:9200/_mapping

 

2、创建映射

post 请求：http://localhost:9200/xc_course/doc/_mapping

一个例子：

```
 {
    "properties": {
           "name": {
              "type": "text"
           },
           "description": {
              "type": "text"
           },
           "studymodel": {
              "type": "keyword"
           }
        }
}
```

3、更新映射

映射创建成功可以添加新字段，已有字段不允许更新。

<font size="5" color="red">表头的数据类型一旦创建好就不允许修改</font>

4、删除映射

通过删除索引库来删除映射。

#### 常用映射类型

![1524559605976](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524559605976.png)

##### 1.text

通过analyzer属性指定分词器。

###### 1.analyzer

下边指定name的字段类型为text，使用ik分词器的ik_max_word分词模式。

```
 
 "name": {
                  "type": "text",
                  "analyzer":"ik_max_word"
   }
```



###### 2.search_analyzer

上边指定了analyzer是指在索引和搜索都使用ik_max_word，如果单独想定义搜索时使用的分词器则可以通过search_analyzer属性。

对于ik分词器建议是索引时使用ik_max_word将搜索内容进行细粒度分词(匹配文章)，搜索时使用ik_smart提高搜索精确性(匹配标题)。

```
 
"name": {
                  "type": "text",
                  "analyzer":"ik_max_word",
                  "search_analyzer":"ik_smart"
   }
```



###### 3.index

通过index属性指定是否索引。

默认为index=true，即要进行索引，只有进行索引才可以从索引库搜索到。

但是也有一些内容不需要索引，比如：商品图片地址只被用来展示图片，不进行搜索图片，此时可以将index设置为false。

删除索引，重新创建映射，将pic的index设置为false，尝试根据pic去搜索，结果搜索不到数据

```
 "pic": {
            "type": "text",
              "index":false
           }
```



###### 4.store

```
是否在source之外存储，每个文档索引后会在 ES中保存一份原始文档，存放在"_source"中，一般情况下不需要设置store为true，因为在_source中已经有一份原始文档了。
```



测试:

删除xc_course/doc下的索引库

1.创建索引库  <font size="5" color="red">相当于一个表</font>

PUT   http://localhost:9200/xc_course/

```
{
  "settings":{
  "index":{
      "number_of_shards":1,
      "number_of_replicas":0
    }  
  }
}
```

创建新映射：Post http://localhost:9200/xc_course/doc/_mapping

```
 {
    "properties": {
           "name": {
                  "type": "text",
                  "analyzer":"ik_max_word",
                  "search_analyzer":"ik_smart"
            },
           "description": {
              "type": "text",
              "analyzer":"ik_max_word",
              "search_analyzer":"ik_smart"
           },
           "pic":{
             "type":"text",
             "index":false
           },
           "studymodel":{
             "type":"text"
           }
    }
}
```

插入文档：

http://localhost:9200/xc_course/doc/4028e58161bcf7f40161bcf8b77c0000

```
 
{
  "name":"Bootstrap开发框架",
  "description":"Bootstrap是由Twitter推出的一个前台页面开发框架，在行业之中使用较为广泛。此开发框架包含了大量的CSS、JS程序代码，可以帮助开发者（尤其是不擅长页面开发的程序人员）轻松的实现一个不受浏览器限制的精美界面效果。",
  "pic":"group1/M00/00/01/wKhlQFqO4MmAOP53AAAcwDwm6SU490.jpg",
  "studymodel":"201002"
}
```

查询测试：

Get http://localhost:9200/xc_course/_search?q=name:开发

Get http://localhost:9200/xc_course/_search?q=description:开发

Get http://localhost:9200/xc_course/_search?q=pic:group1/M00/00/01/wKhlQFqO4MmAOP53AAAcwDwm6SU490.jpg

Get http://localhost:9200/xc_course/_search?q=studymodel:201002

通过测试发现：name和description都支持全文检索，pic不可作为查询条件。

##### 2.keyword

​	上边介绍的text文本字段在映射时要设置分词器，keyword字段为关键字字段，通常搜索keyword是按照整体搜索，所以创建keyword字段的索引时是不进行分词的，比如：邮政编码、手机号码、身份证等。keyword字段通常用于过虑、排序、聚合等。

删除xc_course/doc下的索引库

1.创建索引库  <font size="5" color="red">相当于一个表</font>

PUT   http://localhost:9200/xc_course/

```
{
  "settings":{
  "index":{
      "number_of_shards":1,
      "number_of_replicas":0
    }  
  }
}
```



2.更改映射：

Post http://localhost:9200/xc_course/doc/_mapping

```
 
{
    "properties": {
           "studymodel":{
             "type":"keyword"
           },
            "name":{
             "type":"keyword"
           }
    }
}
```

插入文档：

http://localhost:9200/xc_course/doc/4028e58161bcf7f40161bcf8b77c0000

```
 
{
 "name": "java编程基础",
 "description": "java语言是世界第一编程语言，在软件开发领域使用人数最多。",
 "pic":"group1/M00/00/01/wKhlQFqO4MmAOP53AAAcwDwm6SU490.jpg",
 "studymodel": "201001"
}
```

测试

搜索：http://localhost:9200/xc_course/_search?q=name:java编程基础

name是keyword类型，所以查询方式是精确查询。

##### 3.date

日期类型不用设置分词器。

通常日期类型的字段用于排序。

1)format

通过format设置日期格式

例子：

下边的设置允许date字段存储年月日时分秒、年月日及毫秒三种格式。

```
 
{
    "properties": {
        "timestamp": {
          "type":   "date",
          "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd"
        }
      }
}
```

插入文档：

Post :http://localhost:9200/xc_course/doc/3

```
 
{
"name": "spring开发基础",
"description": "spring 在java领域非常流行，java程序员都在用。",
"studymodel": "201001",
 "pic":"group1/M00/00/01/wKhlQFqO4MmAOP53AAAcwDwm6SU490.jpg",
 "timestamp":"2018-07-04 18:28:58"
}
```

##### 4.numeric

下边是ES支持的数值类型

![1524564108197](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524564108197.png)

1、尽量选择范围小的类型，提高搜索效率

2、对于浮点数尽量用比例因子，比如一个价格字段，单位为元，我们将比例因子设置为100这在ES中会按 分 存储，映射如下：

```
 
 "price": {
        "type": "scaled_float",
        "scaling_factor": 100
  },
```

由于比例因子为100，如果我们输入的价格是23.45则ES中会将23.45乘以100存储在ES中。

如果输入的价格是23.456，ES会将23.456乘以100再取一个接近原始值的数，得出2346。

使用比例因子的好处是整型比浮点型更易压缩，节省磁盘空间。

如果比例因子不适合，则从下表选择范围小的去用：

![1524565017550](file:///E:/%E4%BC%A0%E6%99%BA%E5%B7%A5%E4%BD%9C/%E5%A4%87%E8%AF%BE%E8%B5%84%E6%96%99/%E5%AD%A6%E6%88%90%E5%9C%A8%E7%BA%BF/HTML%E7%89%88%E6%9C%AC%E5%AD%A6%E6%88%90%E8%AE%B2%E4%B9%89/Elasticsearch%E7%A0%94%E7%A9%B6v1.2/elasticsearch_img/1524565017550.png)

更新已有映射，并插入文档：

http://localhost:9200/xc_course/doc/3

```
 
{
"name": "spring开发基础",
"description": "spring 在java领域非常流行，java程序员都在用。",
"studymodel": "201001",
 "pic":"group1/M00/00/01/wKhlQFqO4MmAOP53AAAcwDwm6SU490.jpg",
 "timestamp":"2018-07-04 18:28:58",
 "price":38.6
}
```

##### 5.综合例子

创建如下映射

post：http://localhost:9200/xc_course/doc/_mapping

```
{
                "properties": {
                    "description": {
                        "type": "text",
                        "analyzer": "ik_max_word",
                        "search_analyzer": "ik_smart"
                    },
                    "name": {
                        "type": "text",
                        "analyzer": "ik_max_word",
                        "search_analyzer": "ik_smart"
                    },
                    "pic":{
                        "type":"text",
                        "index":false
                    },
                    "price": {
                        "type": "float"
                    },
                    "studymodel": {
                        "type": "keyword"
                    },
                    "timestamp": {
                        "type": "date",
                        "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
                    }
                }
            }
```

插入文档：

Post: http://localhost:9200/xc_course/doc/1 { "name": "Bootstrap开发", "description": "Bootstrap是由Twitter推出的一个前台页面开发框架，是一个非常流行的开发框架，此框架集成了多种页面效果。此开发框架包含了大量的CSS、JS程序代码，可以帮助开发者（尤其是不擅长页面开发的程序人员）轻松的实现一个不受浏览器限制的精美界面效果。", "studymodel": "201002", "price":38.6, "timestamp":"2018-04-25 19:11:35", "pic":"group1/M00/00/00/wKhlQFs6RCeAY0pHAAJx5ZjNDEM428.jpg" }

### ES客户端

ES提供多种不同的客户端：

1、TransportClient 

ES提供的传统客户端，官方计划8.0版本删除此客户端。

2、RestClient

RestClient是官方推荐使用的，它包括两种：Java Low Level REST Client和  Java High Level REST Client。

ES在6.0之后提供  Java High Level REST Client， 两种客户端官方更推荐使用 Java High Level REST Client，不过当前它还处于完善中，有些功能还没有。

本教程准备采用  Java High Level REST Client，如果它有不支持的功能，则使用Java Low Level REST Client。

#### xc-service-search

##### 1.pom.xml

```
        <dependency>
            <groupId>com.xuecheng</groupId>
            <artifactId>xc-framework-model</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>com.xuecheng</groupId>
            <artifactId>xc-framework-common</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>com.xuecheng</groupId>
            <artifactId>xc-service-api</artifactId>
            <version>1.0-SNAPSHOT</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.elasticsearch.client</groupId>
            <artifactId>elasticsearch-rest-high-level-client</artifactId>
            <version>6.2.1</version>
        </dependency>
        <dependency>
            <groupId>org.elasticsearch</groupId>
            <artifactId>elasticsearch</artifactId>
            <version>6.2.1</version>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-io</artifactId>
        </dependency>
        <dependency>
            <groupId>org.apache.commons</groupId>
            <artifactId>commons-lang3</artifactId>
        </dependency>
```

##### 2.application.yml

```
server:
  port: ${port:40100}
spring:
  application:
    name: xc-search-service
xuecheng:
  elasticsearch:
    hostlist: ${eshostlist:127.0.0.1:9200} #多个结点中间用逗号分隔
```

##### 3.配置类

创建com.xuecheng.search.config包

在其下创建配置类

```
@Configuration
public class ElasticsearchConfig {

    @Value("${xuecheng.elasticsearch.hostlist}")
    private String hostlist;

    @Bean
    public RestHighLevelClient restHighLevelClient(){
        //解析hostlist配置信息
        String[] split = hostlist.split(",");
        //创建HttpHost数组，其中存放es主机和端口的配置信息
        HttpHost[] httpHostArray = new HttpHost[split.length];
        for(int i=0;i<split.length;i++){
            String item = split[i];
            httpHostArray[i] = new HttpHost(item.split(":")[0], Integer.parseInt(item.split(":")[1]), "http");
        }
        //创建RestHighLevelClient客户端
        return new RestHighLevelClient(RestClient.builder(httpHostArray));
    }

    //项目主要使用RestHighLevelClient，对于低级的客户端暂时不用
    @Bean
    public RestClient restClient(){
        //解析hostlist配置信息
        String[] split = hostlist.split(",");
        //创建HttpHost数组，其中存放es主机和端口的配置信息
        HttpHost[] httpHostArray = new HttpHost[split.length];
        for(int i=0;i<split.length;i++){
            String item = split[i];
            httpHostArray[i] = new HttpHost(item.split(":")[0], Integer.parseInt(item.split(":")[1]), "http");
        }
        return RestClient.builder(httpHostArray).build();
    }

}
```

##### 4.启动类

```
@SpringBootApplication
@EntityScan("com.xuecheng.framework.domain.search")//扫描实体类
@ComponentScan(basePackages={"com.xuecheng.api"})//扫描接口
@ComponentScan(basePackages={"com.xuecheng.search"})//扫描本项目下的所有类
@ComponentScan(basePackages={"com.xuecheng.framework"})//扫描common下的所有类
public class SearchApplication {

    public static void main(String[] args) throws Exception {
        SpringApplication.run(SearchApplication.class, args);
    }

}
```

#### 创建索引库

##### API

创建索引：

put  http://localhost:9200/索引名称

```
{
  "settings":{
  "index":{
      "number_of_shards":1,#分片的数量
      "number_of_replicas":0#副本数量
    }  
  }
}
```

创建映射(表头)：

发送：put http://localhost:9200/索引库名称/类型名称/_mapping

创建类型为xc_course的映射，共包括三个字段：name、description、studymodel

http://localhost:9200/xc_course/doc/_mapping

```
 {
    "properties": {
           "name": {
              "type": "text",
              "analyzer":"ik_max_word",
              "search_analyzer":"ik_smart"
           },
           "description": {
              "type": "text",
              "analyzer":"ik_max_word",
              "search_analyzer":"ik_smart"
           },
           "studymodel": {
              "type": "keyword"
           },
           "price": {
              "type": "float"
           },
           "timestamp": {
                "type":   "date",
                "format": "yyyy-MM-dd HH:mm:ss||yyyy-MM-dd||epoch_millis"
            }
        }
}
```

##### Java Client

```
@SpringBootTest
@RunWith(SpringRunner.class)
public class TestIndex {

    @Autowired
    RestHighLevelClient client;

    @Autowired
    RestClient restClient;

    //创建索引库
    @Test
    public void testCreateIndex() throws IOException {
        //创建索引对象
        CreateIndexRequest createIndexRequest = new CreateIndexRequest("xc_course");
        //设置参数
        createIndexRequest.settings(Settings.builder().put("number_of_shards","1").put("number_of_replicas","0"));
        //指定映射
        createIndexRequest.mapping("doc"," {\n" +
                " \t\"properties\": {\n" +
                "            \"studymodel\":{\n" +
                "             \"type\":\"keyword\"\n" +
                "           },\n" +
                "            \"name\":{\n" +
                "             \"type\":\"keyword\"\n" +
                "           },\n" +
                "           \"description\": {\n" +
                "              \"type\": \"text\",\n" +
                "              \"analyzer\":\"ik_max_word\",\n" +
                "              \"search_analyzer\":\"ik_smart\"\n" +
                "           },\n" +
                "           \"pic\":{\n" +
                "             \"type\":\"text\",\n" +
                "             \"index\":false\n" +
                "           }\n" +
                " \t}\n" +
                "}", XContentType.JSON);
        //操作索引的客户端
        IndicesClient indices = client.indices();
        //执行创建索引库
        CreateIndexResponse createIndexResponse = indices.create(createIndexRequest);
        //得到响应
        boolean acknowledged = createIndexResponse.isAcknowledged();
        System.out.println(acknowledged);

    }

    //删除索引库
    @Test
    public void testDeleteIndex() throws IOException {
        //删除索引对象
        DeleteIndexRequest deleteIndexRequest = new DeleteIndexRequest("xc_course");
        //操作索引的客户端
        IndicesClient indices = client.indices();
        //执行删除索引
        DeleteIndexResponse delete = indices.delete(deleteIndexRequest);
        //得到响应
        boolean acknowledged = delete.isAcknowledged();
        System.out.println(acknowledged);

    }
```

#### 添加文档

##### API

格式如下： 

PUT /{index}/{type}/{id} 

{

   "field": "value",   

​	... 

}

如果不指定id，ES会自动生成。

一个例子：

put http://localhost:9200/xc_course/doc/3

```
 {
 "name":"spring cloud实战",
 "description":"本课程主要从四个章节进行讲解： 1.微服务架构入门 2.spring cloud 基础入门 3.实战Spring Boot 4.注册中心eureka。",
 "studymodel":"201001"
 "price":5.6
 }
```

##### Java Client

```
    //添加文档
    @Test
    public void testAddDoc() throws IOException {
        //文档内容
        //准备json数据
        Map<String, Object> jsonMap = new HashMap<>();
        jsonMap.put("name", "spring cloud实战");
        jsonMap.put("description", "本课程主要从四个章节进行讲解： 1.微服务架构入门 2.spring cloud 基础入门 3.实战Spring Boot 4.注册中心eureka。");
        jsonMap.put("studymodel", "201001");
        SimpleDateFormat dateFormat =new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        jsonMap.put("timestamp", dateFormat.format(new Date()));
        jsonMap.put("price", 5.6f);

        //创建索引创建对象
        IndexRequest indexRequest = new IndexRequest("xc_course","doc");
        //文档内容
        indexRequest.source(jsonMap);
        //通过client进行http的请求
        IndexResponse indexResponse = client.index(indexRequest);
        DocWriteResponse.Result result = indexResponse.getResult();
        System.out.println(result);

    }
```

#### 查询文档

##### API

格式如下：
GET /{index}/{type}/{id}

##### Java Client

```
    //查询文档
    @Test
    public void testGetDoc() throws IOException {
        //查询请求对象
        GetRequest getRequest = new GetRequest("xc_course","doc","tzk2-mUBGsEnDOUe482B");
        GetResponse getResponse = client.get(getRequest);
        //得到文档的内容
        Map<String, Object> sourceAsMap = getResponse.getSourceAsMap();
        System.out.println(sourceAsMap);
    }
```

#### 更新文档

##### Api

ES更新文档的顺序是：先检索到文档、将原来的文档标记为删除、创建新文档、删除旧文档，创建新文档就会重建索引。

通过请求Url有两种方法：

1、完全替换

Post：http://localhost:9200/xc_test/doc/3

```
 {
 "name":"spring cloud实战",
 "description":"本课程主要从四个章节进行讲解： 1.微服务架构入门 2.spring cloud 基础入门 3.实战Spring Boot 4.注册中心eureka。",
 "studymodel":"201001"
 "price":5.6
 }
```

2、局部更新

下边的例子是只更新price字段。

post: http://localhost:9200/xc_test/doc/3/_update

```
{
	"doc":{"price":66.6}
}
```

##### Java Client

