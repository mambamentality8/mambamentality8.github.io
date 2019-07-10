### 安装mysql:

安装mysql有三种方式

- yum
- rpm
- 源码编译



##### 以下以rpm的方式安装mysql为例:



- 查看是否有mariadb的依赖环境

```
rpm -qa|grep mariadb
```



- 卸载mariadb的依赖环境

```
rpm -e --nodeps mariadb-libs-5.5.60-1.el7_5.x86_64
```



- 查看是否有 mysql的依赖环境

```
rpm -qa|grep mysql
```



- 去官网下载对应版本的安装包

```
https://dev.mysql.com/downloads/mysql/
```

选择5.7版本  redhat7的操作系统  redhat7的版本

下载mysql-5.7.26-1.el7.x86_64.rpm-bundle.tar



- 将解压包上传并解压

```
tar -xf ./mysql-5.7.26-1.el7.x86_64.rpm-bundle.tar
```



- 解压完以后开始安装rpm包

```
rpm  -ivh mysql-community-common-5.7.26-1.el7.x86_64.rpm
rpm -ivh mysql-community-libs-5.7.26-1.el7.x86_64.rpm
rpm -ivh mysql-community-client-5.7.26-1.el7.x86_64.rpm
rpm -ivh mysql-community-server-5.7.26-1.el7.x86_64.rpm
rpm -ivh mysql-community-devel-5.7.26-1.el7.x86_64.rpm
```

注意在安装mysql-community-server可能会出现缺少依赖库

```
error: Failed dependencies:
    libnuma.so.1()(64bit) is needed by MySQL-server-5.6.32-1.el6.x86_64
    libnuma.so.1(libnuma_1.1)(64bit) is needed by MySQL-server-5.6.32-1.el6.x86_64
    libnuma.so.1(libnuma_1.2)(64bit) is needed by MySQL-server-5.6.32-1.el6.x86_64
```

使用命令安装上缺少的依赖库:

```
yum install numactl
```



- 启动mysql

```
service mysqld start 或者 systemctl start mysqld
```

启动后就可以去找到root的临时密码登录了

```
vi /var/log/mysqld.log
```



- 在日志中找到这样一句话

```
2019-06-30T05:27:08.656838Z 1 [Note] A temporary password is generated for root@localhost: xxx
```

xxx就是临时密码



- 登录MySQL，登录进去是没有权限任何操作的，必须修改密码
  登录代码 mysql -u root -p 回车就让你输入密码，可以直接拷贝密码，省的输错
  登录成功后就要修改密码

```
set password for 'root'@'localhost'='newpasswd' 
```

newpasswd就是你设置的新密码，密码必须要符合要求，八位及以上，需要大小写、数字和特殊字符（尽量满足这个复杂度，以免报错）



- 设置mysql远程登录

   通过该表设置

​	登陆mysql，修改mysql库的user表，将host项，从localhost改为%。%这里表示的是允许任意host访问，如果只允许某一个ip访问，则可改为相应的ip，比如可以将localhost改为192.168.1.123，这表示只允许局域网的192.168.1.123这个ip远程访问mysql。

```
update user set host = '%' where user = 'root';
flush privileges;
```





### DDL

- 直接创建数据库 db1

  ```
  create database db1; 
  ```

- 查看当前在哪个库里边

  ```
  select database();
  ```

- 进入库的操作

  ```
  use 库名; 
  ```

- 判断是否存在，如果不存在则创建数据库 db2

  ```
  create database if not exists db2;    
  ```

- 创建数据库并指定字符集为 gbk

  ```
  create database db3 default character set gbk; 
  ```

- 查看某个库是什么字符集

  ```
  show create database XD; 
  ```

- 查看当前mysql使用的字符集

  ```
  show variables like 'character%';
  ```



### mysql创建表之常用数据类型

- mysql常见数据类型

```
<1>整数型
     类型      大小      范围（有符号）               范围（无符号unsigned）    用途
     TINYINT   1 字节    (-128，127)                (0，255)                 小整数值
     SMALLINT  2 字节    (-32768，32767)            (0，65535)               大整数值
     MEDIUMINT 3 字节    (-8388608，8388607)        (0，16777215)            大整数值
     INT       4 字节    (-2147483648，2147483647)  (0，4294967295)          大整数值
     BIGINT    8 字节     （）                       (0，2的64次方减1)        极大整数值

<2>浮点型
 FLOAT(m,d）  4 字节    单精度浮点型  备注：m代表总个数，d代表小数位个数
 DOUBLE(m,d） 8 字节    双精度浮点型  备注：m代表总个数，d代表小数位个数
 
 <3>定点型
 DECIMAL(m,d）    依赖于M和D的值    备注：m代表总个数，d代表小数位个数
 
 <4>字符串类型 
 类型          大小              用途
 CHAR          0-255字节         定长字符串
 VARCHAR       0-65535字节       变长字符串
 TINYTEXT      0-255字节         短文本字符串
 TEXT          0-65535字节       长文本数据
 MEDIUMTEXT    0-16777215字节    中等长度文本数据
 LONGTEXT      0-4294967295字节  极大文本数据
 
 char的优缺点：存取速度比varchar更快，但是比varchar更占用空间
 varchar的优缺点：比char省空间。但是存取速度没有char快
 
 <5>时间型
 数据类型    字节数            格式                    备注
 date        3                yyyy-MM-dd              存储日期值
 time        3                HH:mm:ss                存储时分秒
 year        1                yyyy                    存储年
 datetime    8                yyyy-MM-dd HH:mm:ss     存储日期+时间
 timestamp   4                yyyy-MM-dd HH:mm:ss     存储日期+时间，可作时间戳
```

- 测试时间类型

```
create table test_time (
            date_value date,
            time_value time,
            year_value year,
            datetime_value datetime,
            timestamp_value timestamp
        ) engine=innodb charset=utf8;
```

```
insert into test_time values(now(), now(), now(), now(), now());
```



### mysql数据表必备知识之创建表

- 语法：

  ```
  CREATE TABLE 表名 (
                    字段名1 字段类型1 约束条件1 说明1,
                    字段名2 字段类型2 约束条件2 说明2,
                    字段名3 字段类型3 约束条件3 说明3
                    );
  ```

  TINYINT数据类型默认创建出来是有符号的数据范围是-128~127

  ```
  create table 新表名 as select * from 旧表名 where 1=2;(注意：建议这种创建表的方式用于日常测试，因为可能索引什么的会复制不过来)
  ```

  ```
  create table 新表名 like 旧表名;
  ```

- 约束条件：

  ```
  comment         ----说明解释
  not null        ----不为空
  default         ----默认值
  unsigned        ----无符号（即正数）
  auto_increment  ----自增
  zerofill        ----自动填充
  unique key      ----唯一值
  ```

- 创建sql

  ```
  CREATE TABLE student (
                      id tinyint(5) zerofill auto_increment  not null comment '学生学号',
                      name varchar(20) default null comment '学生姓名',
                      age  tinyint  default null comment '学生年龄',
                      class varchar(20) default null comment '学生班级',
                      sex char(5) not null comment '学生性别',
                      unique key (id)
                      )engine=innodb charset=utf8;;
  
  CREATE TABLE student (
                      id tinyint(5)  auto_increment  default null comment '学生学号',
                      name varchar(20) default null comment '学生姓名',
                      age  tinyint  default null comment '学生年龄',
                      class varchar(20) default null comment '学生班级',
                      sex char(5) not null comment '学生性别',
                      unique key (id)
                      )engine=innodb charset=utf8;;
  ```

- ### mysql数据表必备知识之查看表的基本结构信息

  ```
  查看数据库中的所有表：show tables；
  查看表结构：desc 表名;
  查看创建表的sql语句：show create table 表名;
  \G :有结束sql语句的作用，还有把显示的数据纵向旋转90度
  \g :有结束sql语句的作用
  ```

  

### mysql数据表必备知识之**表结构的修改**

- 修改表名

  ```
   rename table 旧表名 to 新表名;
   rename table student to user;
  ```

- 添加列

  ```
  给表添加一列：alter table 表名 add 列名 类型;
  alter table user add addr varchar(50);
  
  alter table add 列名 类型 comment '说明';
  alter table user add famliy varchar(50) comment '学生父母';
  
  给表最前面添加一列：alter table 表名 add 列名 类型 first;
  alter table user add job varchar(10) first;
  
  给表某个字段后添加一列：alter table 表名 add 列名 类型 after 字段名;
  alter table user add servnumber int(11)  after id;
  
  注意：没有给表某个字段前添加一列的说法。
  ```

- 修改列类型

  ```
  alter table 表名 modify 列名 新类型;
  alter table user modify servnumber varchar(20);
  ```

- 修改列名

  ```
  alter table 表名 change 旧列名 新列名 类型;
  alter table user change servnumber telephone varchar(20);
  ```

- 删除列

  ```
  alter table 表名 drop 列名;
  alter table user drop famliy;
  ```

- 修改字符集

  ```
  alter table 表名 character set 字符集;
  alter table user character  set GBK;
  ```

- mysql表的删除

  ```
  drop table 表名；
  drop table user;
  ```

  ```
  看表是否存在，若存在则删除表：drop table if exists 表名;
  drop table  if exists teacher;
  ```

  

### 表数据新增

- 普通的插入表数据

  ```
  insert into 表名（字段名） values（字段对应值）;
  insert into employee (empno,ename,job,mgr,hiredate,sal,deptnu) values ('1000','小明','经理','10001','2019-03-03','12345.23','10');
  
  insert into 表名 values（所有字段对应值）;
  insert into employee  values ('1001','小明','经理','10001','2019-03-03','12345.23','10');    
  ```

- 蠕虫复制（将一张表的数据复制到另一张表中）

  ```
  insert into 表名1 select * from 表名2;
  
  insert into 表名1（字段名1，字段名2） select 字段名1，字段名2 from 表名2;
  
  insert into emp (empno,ename) select empno,ename from employee;
  ```

- 建表复制

  ```
  create table 表名1 as select 字段名1，字段名2 from 表名2;
  
  create table emp as select empno,ename from employee;
  ```

- 一次性插入多个数据

  ```
  insert into 表名  (字段名) values (对应值1),(对应值2),(对应值3);   
  ```

- 创建sql：

  ```
  某个公司的员工表
  CREATE TABLE employee(
      empno       INT  PRIMARY KEY comment '雇员编号',
      ename       VARCHAR(20) comment '雇员姓名',
      job         VARCHAR(20) comment '雇员职位',
      mgr         INT comment '雇员上级编号',
      hiredate    DATE comment '雇佣日期',
      sal         DECIMAL(7,2) comment '薪资',
      deptnu      INT comment '部门编号'
      );
  ```

  