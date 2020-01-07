



# DDL

### mysql数据库创建、查看以及使用/切换

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



### mysql创建表

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

### mysql查看表的基本结构信息

  ```
  查看数据库中的所有表：show tables；
  查看表结构：desc 表名;
  查看创建表的sql语句：show create table 表名;
  \G :有结束sql语句的作用，还有把显示的数据纵向旋转90度
  \g :有结束sql语句的作用
  ```

  

### mysql表结构的修改

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


# DML

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

  

### 表数据的修改以及删除

- 修改（更新）：

  ```
  update 表名 set 字段名1=值1 where 字段名=值;
  
  update 表名 set 字段名1=值1,字段名2=值2 where 字段名=值;
  ```

- 删除：

  ```
  delete from 表名 where 字段名=值;
  
   truncate table 表名;
   delete from 表名;
   drop table 表名;
  ```

- 注意事项：

  ```
  面试时：面试官问在删改数据之前，你会怎么做？
  答案：会对数据进行备份操作，以防万一，可以进行数据回退
  
  面试时：面试官会问，delete与truncate与drop 这三种删除数据的共同点都是删除数据，他们的不同点是什么?
  delele 会把删除的操作记录给记录起来，以便数据回退，不会释放空间，而且不会删除定义。
  truncate不会记录删除操作，会把表占用的空间恢复到最初，不会删除定义
  drop会删除整张表，释放表占用的空间。
  删除速度：
  ```

- 删除速度：

  ```
  drop > truncate > delete
  ```

  

### mysql中文乱码问题

- 查看当前mysql使用的字符集：show variables like 'character%';

  ```
  mysql> show variables like 'character%';
  +--------------------------+----------------------------------+
  | Variable_name            | Value                            |
  +--------------------------+----------------------------------+
  | character_set_client     | utf8                             |
  | character_set_connection | utf8                             |
  | character_set_database   | utf8                             |
  | character_set_filesystem | binary                           |
  | character_set_results    | utf8                             |
  | character_set_server     | utf8                             |
  | character_set_system     | utf8                             |
  | character_sets_dir       | /usr/local/mysql/share/charsets/ |
  +--------------------------+----------------------------------+
  ```

- character_set_client：客户端请求数据的字符集

- character_set_connection：客户端与服务器连接的字符集

- character_set_database：数据库服务器中某个库使用的字符集设定，如果建库时没有指明，将默认使用配置上的字符集

- character_set_results：返回给客户端的字符集(从数据库读取到的数据是什么编码的)

- character_set_server：为服务器安装时指定的默认字符集设定。

- character_set_system：系统字符集(修改不了的，就是utf8)

- character_sets_dir：mysql字符集文件的保存路径

- 临时：set names gbk;

- 永久：修改配置文件my.cnf里边的

  ```
  [client]
  default-character-set=gbk
  作用于外部的显示
  
  [mysqld]
  character_set_server=gbk
  作用于内部，会作用于创建库表时默认字符集
  ```

- 修改库的字符集编码

  ```
  alter database xiaoxiao default character set gbk;
  ```

- 修改表的字符集编码

  ```
  alter table employee default character set utf8;
  ```



# DQL
### 对表中的数据进行各种查询

- 构造数据

  ```
  /*创建部门表*/
  CREATE TABLE dept(
      deptnu      INT  PRIMARY KEY comment '部门编号',
      dname       VARCHAR(50) comment '部门名称',
      addr        VARCHAR(50) comment '部门地址'
  );
  
  /*某个公司的员工表*/
  CREATE TABLE employee(
      empno       INT  PRIMARY KEY comment '雇员编号',
      ename       VARCHAR(50) comment '雇员姓名',
      job         VARCHAR(50) comment '雇员职位',
      mgr         INT comment '雇员上级编号',
      hiredate    DATE comment '雇佣日期',
      sal         DECIMAL(7,2) comment '薪资',
      deptnu      INT comment '部门编号'
  )ENGINE=MyISAM DEFAULT CHARSET=utf8;
  
  /*创建工资等级表*/
  CREATE TABLE salgrade(
      grade       INT  PRIMARY KEY comment '等级',
      lowsal      INT comment '最低薪资',
      higsal      INT comment '最高薪资'
  );
  
  /*插入dept表数据*/
  INSERT INTO dept VALUES (10, '研发部', '北京');
  INSERT INTO dept VALUES (20, '工程部', '上海');
  INSERT INTO dept VALUES (30, '销售部', '广州');
  INSERT INTO dept VALUES (40, '财务部', '深圳');
  
  /*插入emp表数据*/
  INSERT INTO employee VALUES (1009, '唐僧', '董事长', NULL, '2010-11-17', 50000,  10);
  INSERT INTO employee VALUES (1004, '猪八戒', '经理', 1009, '2001-04-02', 29750, 20);
  INSERT INTO employee VALUES (1006, '猴子', '经理', 1009, '2011-05-01', 28500, 30);
  INSERT INTO employee VALUES (1007, '张飞', '经理', 1009, '2011-09-01', 24500,10);
  INSERT INTO employee VALUES (1008, '诸葛亮', '分析师', 1004, '2017-04-19', 30000, 20);
  INSERT INTO employee VALUES (1013, '林俊杰', '分析师', 1004, '2011-12-03', 30000, 20);
  INSERT INTO employee VALUES (1002, '牛魔王', '销售员', 1006, '2018-02-20', 16000, 30);
  INSERT INTO employee VALUES (1003, '程咬金', '销售员', 1006, '2017-02-22', 12500, 30);
  INSERT INTO employee VALUES (1005, '后裔', '销售员', 1006, '2011-09-28', 12500, 30);
  INSERT INTO employee VALUES (1010, '韩信', '销售员', 1006, '2018-09-08', 15000,30);
  INSERT INTO employee VALUES (1012, '安琪拉', '文员', 1006, '2011-12-03', 9500,  30);
  INSERT INTO employee VALUES (1014, '甄姬', '文员', 1007, '2019-01-23', 7500, 10);
  INSERT INTO employee VALUES (1011, '妲己', '文员', 1008, '2018-05-23', 11000, 20);
  INSERT INTO employee VALUES (1001, '小乔', '文员', 1013, '2018-12-17', 8000, 20);
  
  /*插入salgrade表数据*/
  INSERT INTO salgrade VALUES (1, 7000, 12000);
  INSERT INTO salgrade VALUES (2, 12010, 14000);
  INSERT INTO salgrade VALUES (3, 14010, 20000);
  INSERT INTO salgrade VALUES (4, 20010, 30000);
  INSERT INTO salgrade VALUES (5, 30010, 99990);
  ```

### where条件查询  (where后面不能跟聚合函数)

- 简单查询

  ```
  select * from employee;
  select empno,ename,job as ename_job from employee;
  ```

- 精确条件查询

  ```
  select * from employee where ename='后裔';
  select * from employee where sal != 50000;
  select * from employee where sal <> 50000;
  select * from employee where sal > 10000;
  ```

- 模糊条件查询

  ```
  show variables like '%aracter%'; 
  select * from employee  where ename like '林%';
  ```

- 范围查询

  ```
  select * from employee where sal between 10000 and 30000;
  select * from employee where hiredate between '2011-01-01' and '2017-12-1';
  ```

- 离散查询

  ```
  select * from employee where ename in ('猴子','林俊杰','小红','小胡');  
  ```

- 清除重复值

  ```
  select distinct(job) from employee;
  ```

- 统计查询（聚合函数）:

  ```
         count(code)或者count(*)
          select count(*) from employee;
          select count(ename) from employee;
          
         sum()  计算总和 
          select sum(sal) from employee;
          
         max()    计算最大值
          select * from employee where sal= (select  max(sal) from employee);
          
         avg()   计算平均值
          select avg(sal) from employee;
          
         min()   计算最低值
          select * from employee where sal= (select  min(sal) from employee);
          
         concat函数： 起到连接作用
          select concat(ename,' 是 ',job) as aaaa from employee;
  ```

### group by分组查询

- 作用：把行 按 字段 分组

- 语法：group by 列1，列2....列N (将多个字段组合成一个整体进行分组)

- 适用场合：常用于统计场合，一般和聚合函数连用

  ```
  eg:
       select deptnu,count(*) from employee group by deptnu;
       select deptnu,job,count(*) from employee group by deptnu,job;
       select job,count(*) from employee group by job;
  ```

### having条件查询

- 作用：对查询的结果进行筛选操作

- 语法：having 条件 或者 having 聚合函数 条件

- 适用场合：一般跟在group by之后

  ```
  eg:
      select job,count(*) from employee group by job having job ='文员';
      select  deptnu,job,count(*) from employee group by deptnu,job having count(*)>=2;
      select  deptnu,job,count(*) as 总数 from employee group by deptnu,job having 总数>=2;
  ```

### order by排序查询

- 作用：对查询的结果进行排序操作

- 语法：order by 字段1,字段2 .....

- 适用场合：一般用在查询结果的排序

  ```
  eg:
       select * from employee order by sal;
       select * from employee order by hiredate;
       select  deptnu,job,count(*) as 总数 from employee group by deptnu,job having 总数>=2 order by deptnu desc;
       select  deptnu,job,count(*) as 总数 from employee group by deptnu,job having 总数>=2 order by deptnu asc;
       select  deptnu,job,count(*) as 总数 from employee group by deptnu,job having 总数>=2 order by deptnu;
  
       顺序：where ---- group by ----- having ------ order by 
  ```

### limit分页查询

- 作用：对查询结果起到限制条数的作用

- 语法：limit n，m n:代表起始条数值，不写默认为0；m代表：取出的条数

- 适用场合：数据量过多时，可以起到限制作用

  ```
  eg:
      select * from XD.employee limit 4,5;
  ```

### exists子查询

- exists型子查询后面是一个受限的select查询语句

- exists子查询，如果exists后的内层查询能查出数据，则返回 TRUE 表示存在；为空则返回 FLASE则不存在。

  ```
  分为俩种：exists跟 not exists
  
  select 1 from employee where 1=1;
  select * from 表名 a where exists (select 1 from 表名2 where 条件);
  
  eg:查询出公司有员工的部门的详细信息
  select * from dept a where exists (select 1 from employee b where a.deptnu=b.deptnu);
  select * from dept a where not exists (select 1 from employee b where a.deptnu=b.deptnu);
  ```

### 左连接查询与右连接查询

- 左连接称之为左外连接 右连接称之为右外连接 这俩个连接都是属于外连接

- 左连接关键字：left join 表名 on 条件 / left outer 表名 join on 条件 右连接关键字：right join 表名 on 条件/ right outer 表名 join on 条件

- 左连接说明： left join 是left outer join的简写，左(外)连接，左表(a_table)的记录将会全部表示出来， 而右表(b_table)只会显示符合搜索条件的记录。右表记录不足的地方均为NULL。

- 右连接说明：right join是right outer join的简写，与左(外)连接相反，右(外)连接，左表(a_table)只会显示符合搜索条件的记录，而右表(b_table)的记录将会全部表示出来。左表记录不足的地方均为NULL。
  ```
  eg:列出部门名称和这些部门的员工信息，同时列出那些没有的员工的部门
          dept，employee
          select a.dname,b.* from dept a  left join employee b on a.deptnu=b.deptnu;
          select b.dname,a.* from employee a  right join  dept b on b.deptnu=a.deptnu;
  
  ```

### 内连接查询与联合查询

- 内连接：获取两个表中字段匹配关系的记录

- 主要语法：INNER JOIN 表名 ON 条件;

  ```
  eg:想查出员工张飞的所在部门的地址
      select a.addr  from dept a inner join employee b on a.deptnu=b.deptnu and b.ename='张飞';
      select a.addr from dept a,employee b where a.deptnu=b.deptnu and b.ename='张飞';
  
  ```

- 联合查询：就是把多个查询语句的查询结果结合在一起

- 主要语法1：... UNION ... （去除重复） 主要语法2：... UNION ALL ...（不去重复）

- union查询的注意事项：

  ```
  (1)两个select语句的查询结果的“字段数”必须一致；
  
  (2)通常，也应该让两个查询语句的字段类型具有一致性；
  
  (3)也可以联合更多的查询结果；
  
  (4)用到order by排序时，需要加上limit（加上最大条数就行），需要对子句用括号括起来
  
  eg:对销售员的工资从低到高排序，而文员的工资从高到低排序
      (select * from employee a where a.job = '销售员'  order by a.sal limit 999999 ) union  (select * from employee b where b.job = '文员' order by b.sal desc limit 999999);
  ```

### 高级查询实战(一)

- 出至少有一个员工的部门。显示部门编号、部门名称、部门位置、部门人数。

  ```
      涉及表： employee dept
      语句：select deptnu,count(*) from employee group by deptnu
      语句：select a.deptnu,a.dname,a.addr, b.zongshu from dept a,(select deptnu,count(*) as zongshu from employee group by deptnu) b where a.deptnu=b.deptnu;
  ```

- 列出薪金比安琪拉高的所有员工。

  ```
      涉及表：employee
      语句：select * from  employee where sal > (select sal from employee where ename='安琪拉');
  ```

- 列出所有员工的姓名及其直接上级的姓名。

  ```
      涉及表：employee
      语句：select a.ename,ifnull(b.ename,'BOSS') as leader from employee a left join employee b on a.mgr=b.empno;
  ```

- 列出受雇日期早于直接上级的所有员工的编号、姓名、部门名称。

  ```
      涉及表：employee dept
      条件：a.hiredate < b.hiredate
      语句：select a.empno,a.ename,c.dname from employee a left join employee b on a.mgr=b.empno left join dept c on a.deptnu=c.deptnu where a.hiredate < b.hiredate;
  ```

- 列出部门名称和这些部门的员工信息，同时列出那些没有员工的部门。

  ```
      涉及表：dept employee
      语句：select a.dname,b.* from dept a left join employee b on a.deptnu=b.deptnu;
  ```

- 列出所有文员的姓名及其部门名称，所在部门的总人数。

  ```
      涉及表：employee dept
      条件：job='文员'
      语句：select deptnu,count(*) as zongshu from employee group by deptnu;
      语句：select b.ename,a.dname,b.job,c.zongshu from dept a ,employee b ,(select deptnu,count(*) as zongshu from employee group by deptnu) c where a.deptnu=b.deptnu and b.job='文员' and b.deptnu=c.deptnu;
  ```

### 高级查询实战(二)

- 列出最低薪金大于15000的各种工作及从事此工作的员工人数。