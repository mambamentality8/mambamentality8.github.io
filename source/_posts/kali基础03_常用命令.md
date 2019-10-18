apt是会解决和安装模块的依赖问题，并会咨询软件仓库，是在线安装。
dpkg只能安装本地的deb文件，不会关心Ubuntu的软件仓库内的软件，不会解决模块的依赖关系。
两者的区别是dpkg绕过apt包管理数据库对软件包进行操作，所以你用dpkg安装过的软件包用apt可以再安装一遍，系统不知道之前安装过了，将会覆盖之前dpkg的安装。



安装deb软件包 

```
dpkg -i xxx.deb
```



apt-get安装卸载软件 
安装软件

```
apt-get install softname
```

![1571328430682](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1571328430682.png)

删除软件包，并删除相应的配置文件 

apt-get remove --purge softname



更新软件信息数据库 
apt-get update 
进行系统升级 
apt-get upgrade

![1571328490296](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1571328490296.png)

显示文件和目录列表
```
ls 
```

列出文件的详细信息
```
ls -l 
```

显示网络接口信息
```
ifconfig 
```

测试网络的连通性
```
ping 
```

显示网络状态信息
```
netstat 
```

立即关机
```
shutdown -h now  
```

清屏命令 
```
clear   Linux
```

### 启动网络服务

Kali Linux 自带了多种网络服务，它们在多种情况下可能很实用，并且默认是禁用 的。

#### 1.启动Apache服务器

```
service apache2 start
```

#### 2.为了启动SSH服务，首次需要生成SSH密钥

```
sshd-generate
```

#### 3.启动SSH服务器

```
service ssh start
```

#### 4.使用 netstat 命令来验证服务器是否开启并正在监听

```
netstat -tpan | grep 22
```

#### 5.启动FTP服务器

```
service pure-ftpd start
```

#### 6.使用下列命令来验证FTP服务器

```
netstat -ant | grep 21
```

#### 7.使用下列命令来停止服务

```
service <servicename> stop
```

其中 <servicename> 代表我们希望停止的网络服务

例如：

```
service apache2 stop
```

#### 8.使用下列命令来在开机时启用服务

```
update-rc.d –f <servicename> defaults
```

其中 <servicename> 代表打算启动的网络服务

例如： 

```
update-rc.d –f ssh defaults
```

