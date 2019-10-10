# mysql5.7.27安装(mac版)

### 下载地址

```
https://dev.mysql.com/downloads/mysql/
```

### 选择5.7.27版

![1569724009708](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/01.png)

![1569724127297](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/02.png)

### 直接点击下面位置进行下载

![1570207336232](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/03.png)

### 下载完成后, 双击打开

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/04.png)

### 点击继续即可

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/05.png)

​     下面一直点继续

### 启动MySQL

安装完毕后,到设置当中查看以下选项,如果里面有MySQL说明已经安装成功

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/06.png)

点击后, 启动MySQL 

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/07.png)

### 修改数据库密码

启动完成后,打开终端

```
alias mysql=/usr/local/mysql/bin/mysql
```

```
alias mysqladmin=/usr/local/mysql/bin/mysqladmin
```

把上面两条指令复制到终端当中运行,给两个地址给一个临时别名

目的是下一次执行可以直接执行mysql或者mysqladmin

不需要再去来回切换目录

![img](https://images2017.cnblogs.com/blog/624076/201711/624076-20171105162150123-401675503.png)

接下来修改数据库密码,执行以下命令

mysqladmin -u root -p password root

root是我的新密码,自行修改成自己想要设置的密码

按回车后, 提示输入密码,此时让输入的密码不是你电脑的密码

而是数据库默认的密码



默认的密码会自动给你分配,在安装的时候就会给你自动分配

可以从mac通知栏当中来去查看

下图当中就是自动生成一个数据库密码

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/08.png)

默认的密码就是localhost:后面的所有内容,把它输入后,回车.

(在命令行当中输入密码是看不到的,所以输入密码的时候,注意不要输入错误)

![img](https://images2017.cnblogs.com/blog/624076/201711/624076-20171105162349341-2138765420.png)

看到如上信息,修改成功

### 进入数据库

接下来进入数据库当中

确保执行了

```
alias mysql=/usr/local/mysql/bin/mysql
```

如果没有执行, 要自行切换到上面的目录当中,才能执行mysql命令

否则提示找到不mysql



接下来执行以下指令:mysql -u root -p

注意-p后面什么都不写,然后回车

会让你输入密码, 此时的密码就是你在上面修改的密码

我在这里输入的是:root

看到如下信息,全部说明已经进入数据库当中

![img](https://blog-mamba.oss-cn-beijing.aliyuncs.com/database/mysql/mac_install_mysql/09.png)