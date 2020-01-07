# 安装mysql:

安装mysql多种方式

- yum
- rpm
- 源码编译
- docker

<font size="5" color="red">本次安装环境为centOS7.x  mysql5.7.x</font>

### 以下以rpm的方式安装mysql为例:

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

<font color="red" size="3">如果网速太慢可以使用国内镜像</font>

```
https://mirrors.huaweicloud.com/mysql/Downloads/MySQL-5.7/
```



- 将解压包上传并解压

```
tar -xf ./mysql-5.7.26-1.el7.x86_64.rpm-bundle.tar
```



- 解压完以后开始安装rpm包

```
rpm -ivh mysql-community-common-5.7.26-1.el7.x86_64.rpm
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
set password for 'root'@'localhost'='newpasswd';
```

newpasswd就是你设置的新密码，密码必须要符合要求，八位及以上，需要大小写、数字和特殊字符（尽量满足这个复杂度，以免报错）



- 设置mysql远程登录

  通过该表设置

​	登陆mysql，修改mysql库的user表，将host项，从localhost改为%。%这里表示的是允许任意host访问，如果只允许某一个ip访问，则可改为相应的ip，比如可以将localhost改为192.168.1.123，这表示只允许局域网的192.168.1.123这个ip远程访问mysql。

```
use mysql;
update user set host = '%' where user = 'root';
flush privileges;
```

### 修改默认的数据保存目录以及数据库编码

- 默认的my.cnf

```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

- 创建相关目录

```
mkdir -p /data/mysql/data
mkdir -p /data/mysql/log
```

- 修改属组  (开发环境随意可不用设置权限)

```
cd /data
chown -R mysql:mysql mysql
```

- 移动数据

这个步骤是针对已经有数据生成时的情况，如果是刚刚安装 MySQL 数据库，那么这一步可以跳过。

注意：为了确保数据的完整性，先 `systemctl stop mysqld` 停止 MySQL，然后再保存数据。

- 暂停服务：`systemctl stop mysqld`；
- 备份数据： `cp -R /var/lib/mysql /var/lib/mysql_bak`；
- 移动数据：`rsync -av /var/lib/mysql/ /data/mysql/data/`，这个会将原 mysql 下的所有数据，保存到 `/data/mysql/data` 文件夹下，

使用`-a`标志保留的权限和其他目录属性，而`-v`提供详细输出，以便能够按照进度。

### 修改配置文件

`vi /etc/my.cnf` 编辑配置文件，数据位置和套接字都指向新的目录：

```
# 修改位置
datadir=/data/mysql/data
socket=/data/mysql/mysql.sock

# 新增配置
[client]
socket=/data/mysql/mysql.sock
```

配置预览：

```
# For advice on how to change settings please see
# http://dev.mysql.com/doc/refman/5.7/en/server-configuration-defaults.html

[mysqld]
#
# Remove leading # and set to the amount of RAM for the most important data
# cache in MySQL. Start at 70% of total RAM for dedicated server, else 10%.
# innodb_buffer_pool_size = 128M
#
# Remove leading # to turn on a very important data integrity option: logging
# changes to the binary log between backups.
# log_bin
#
# Remove leading # to set options mainly useful for reporting servers.
# The server defaults are faster for transactions and fast SELECTs.
# Adjust sizes as needed, experiment to find the optimal values.
# join_buffer_size = 128M
# sort_buffer_size = 2M
# read_rnd_buffer_size = 2M
datadir=/data/mysql/data
socket=/data/mysql/mysql.sock

#服务端口号 默认3306
port = 3306
#普通项目的编码方式可以设置成 utf8
#这里设置成utf8mb4，是因为我的项目需要存储 emoji 表情，
#这种表情虽然是utf8编码，但是一个字符需要占用4个字节，而MySQL utf8编码只能存放3字节的字符。
#在MySQL 5.6 以上版本中，可以设置编码为utf8mb4，这个字符集是utf8的超集。
#注意KEY不要写错，网上很多文章都是写default-character-set是错的
character-set-server=utf8mb4 

#版本5.6.19以后必须设置这一句才能使[client]中设置的编码有效
character-set-client-handshake = FALSE
collation-server=utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'

#表名是否区分大小写：1表示不区分大小写，2表示区分
lower_case_table_names=1

# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
log-error=/data/mysql/log/mysqld.log

#如果去除注释，可以实现免密登录，不建议开启免密
#skip-grant-tables 

pid-file=/var/run/mysqld/mysqld.pid

[mysql] 
default-character-set=utf8mb4

[client]
socket=/data/mysql/mysql.sock

#普通项目的编码方式可以设置成 utf8
#这里设置成utf8mb4，是因为我的项目需要存储 emoji 表情，
#这种表情虽然是utf8编码，但是一个字符需要占用4个字节，而MySQL utf8编码只能存放3字节的字符。
#在MySQL 5.6 以上版本中，可以设置编码为utf8mb4，这个字符集是utf8的超集。
default-character-set=utf8mb4
```

### 验证

- 启动 MySQL

```
systemctl stop mysqld #停止mysql
systemctl start mysqld # 启动
systemctl status mysqld # 状态查询
systemctl enable mysqld # 开机自启
systemctl daemon-reload # 重载所有修改过的配置文件
```

- 查看编码

```
SHOW VARIABLES LIKE 'character%';
```

### 测试连接

需要关闭防火墙：(开放安全组)

```
systemctl stop firewalld # 关闭防火墙
```



### 忘记mysql密码

```
# 打开配置文件，最后增加下面一行，实现MySQL免密登录
sudo vim /etc/my.cnf 
# 跳出授权表的验证
skip-grant-tables 
systemctl restart mysqld
use mysql;
show tables;
update user set authentication_string = password('new_password') where user = 'root'; # 旧方法
flush privileges;
alter user 'root'@'%' identified by 'new_password'; 
# 将 skip-grant-tables 去掉
```

