# linux的基本操作命令
## 简介：30个常用的命令
```
        这么多命令记不住怎么办？
            第一种方法去找你命令的意思 man + 命令
            举例 man cd
                 man ls
            第二种方法使用ls --help
            1、  cd命令 
            功能说明：切换目录。
            举    例：却换到根目录 ：cd /
            ​         切换到上次运行的目录：cd -
            2、  ls命令 
            功能说明：列出目录内容。
            举    例：列出/var目录的文件和目录的信息 ：ls –l /var；   
                      最常用方式 ls –ltr  list time reverse 以创建时间去排列最旧的在最上边最新的在最下边  
                      ls -lt看最旧
                      ls -lrt看最新
                                                      
            ​         ls -l 以列的形式展示出来；通常写成ll
            3、  cat命令 
            功能说明：查看小文件内容。
            举    例：查看test.txt 文件内容 ：cat test.txt
                      cat >test.txt
                      
                      asddsafsafsads
                      
                      ctrl+c
            ​         
                      cat test.txt
                      cat -n test.txt能够带上行数
            4、  chmod命令 
            功能说明：修改文件或目录权限。
            举    例：修改test.sh 为自己可执行：chmod u+x test.sh 
            ​
            5、  chown命令 
            功能说明：变更文件或目录的拥有者或所属群组。
            举    例：修改test.txt 属主为mysql ：chown mysql:mysql test.txt
            ​         假如之前我们的test.txt属于 root root  
                                   改过之后就是  mysql mysql
            6、  cp命令 
            功能说明：拷贝文件。
            举    例：拷贝文件test.sh 为 test.sh_bak：cp test.sh test.sh_bak
            ​
            7、  diff命令 
            功能说明：对比文件差异。
            举    例：对比文件test.sh test.sh_bak 是否有差异diff  test.sh test.sh_bak
            ​
            8、  find命令 
            功能说明：查询文件。
            举    例：查询本目录下面的test.txt：find ./ -name test.txt
            ​
            9、  mv命令 
            功能说明：移动或更名现有的文件或目录。
            举    例：移动 test.sh到/bin目录下：mv test.sh /bin/
            ​
            10、rm命令 
            功能说明：删除文件或目录。
            举    例：删除文件test.sh ：rm test.sh
            ​
            11、touch命令 
            功能说明：创建一个空文件。
            举    例：创建一个空的test.txt文件：touch test.txt
            ​
            12、which命令 
            功能说明：在环境变量$PATH设置的目录里查找符合条件的文件。
            举    例：查询find命令在那个目录下面：which find
                      which ls
                      /usr/bin/ls
            ​
            13、ssh命令 
            功能说明：远程安全登录方式。
            举    例：登录到远程主机：ssh ${IP}
            ​
            14、grep命令 
            功能说明：查找文件里符合条件的字符串。
            举    例：从test.txt文件中查询test的内容：grep test test.txt
            ​
            15、wc命令 
            功能说明：统计行。
            举    例：统计test.txt文件有多少行：wc -l test.txt
            ​
            16、date命令 
            功能说明：查询主机当前时间。
            举    例：查询主机当前时间：date
            ​
            17、exit命令 
            功能说明：退出命令。
            举    例：退出主机登录：exit
            ​
            18、kill命令 
            功能说明：杀进程。
            举    例：杀掉test用户下面的所有进程：ps -ef | awk ‘$1==”test” {print $2}’ | xargs kill -9
            ​
            19、id命令 
            功能说明：查看用户。
            举    例：查看当前用户：id ；查询主机是否有test用户：id test
            ​
            20、ps命令 
            功能说明：查询进程情况。
            举    例：查询test.sh进程：ps -ef | grep test.sh
            ​
            21、sleep命令 
            功能说明：休眠时间。
            举    例：休眠60秒 ：sleep 60
             
            22、uname命令 
            功能说明：查询主机信息。
            举    例：查询主机信息：uname -a
            ​
            23、passwd命令 
            功能说明：修改用户密码。
            举    例：使用root修改test用户的密码：passwd test
            ​
            24、ping命令 
            功能说明：查看网络是否通。
            举    例：查询本主机到远程IP的网络是否通：ping ${IP} 
            ​
            25、df命令 
            功能说明：查看磁盘空间使用情况。
            举    例：查看主机的空间使用情况 ：df -h
            ​
            26、echo命令 
            功能说明：标准输出命令。
            举    例：对变量test进行输出：echo $test
            ​                           echo '123' //相当于print的意思
            27、pwd命令 
            功能说明：查询所在目录。
            举    例：查询当前所在目录：pwd
            ​
            28、head命令 
            功能说明：查看文件的前面N行。
            举    例：查看test.txt的前10行：head -10 test.txt
            ​
            29、tail命令 
            功能说明：查看文件的后面N行。
            举    例：查看test.txt的后10行：tail -10 test.txt
            ​
            30、mkdir命令 
            功能说明：创建目录。
            举    例：创建test目录：mkdir test
```

# 远程连接软件以及vi编辑器
## 简介:远程连接软件 与 vi命令的基本使用
- 软件：
```
    CRT
    putty
    echo $LANG
```
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/linux/shell/01.png)
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/linux/shell/02.png)
- vi编辑器：
```
vi编辑器是所有Unix及Linux系统下标准的编辑器，它的强大不逊色于任何最新的文本编辑器
```
- vi的基本概念：
```
1) 命令行模式
    x 			 # 删除一个字符
    dd			 # 删除一整行

2) 插入模式
    i 			 # 在光标前插入内容
    o 			 # 在当前行之下新开一行 

3) 底行模式
    x 或 wq 	 # 保存退出
    q! 			 # 退出不保存 
    set nu  	 # 显示行数
    /			 # 搜索内容
```

# shell常见的解释器
## 简介：常见的解释器
```
解释器:是一种命令解释器，主要作用是对命令进行运行和解释，将需要执行的操作传递给操作系统内核并执行
```

```
# !/bin/bash（默认）

# !/bin/ksh

# !/bin/bsh

# !/bin/sh
```

- 创建第一个shell脚本
```
#!/bin/bash
#功能作用
#by作者XXX 20XX年XX月XX日
echo 'helloword'
```
第一行#!是选择解释器
剩下的#都是注释

```
注意：shell一定得有解释器吗？
答案：不一定,最好要加解释器
```

## shell脚本文件权限
```
文件权限：-	rw-	r--	r--
目录权限：drw-r--r--
分三列：每三个为一列，分别是所有者(owner)，所属组(group)，其他(others)

rwx r:4 w:2 x:1
所有者(可读可写可执行)   所属组(可读可执行)   其他(可读可执行)
7	                         5	                  5
```
- 为什么这个文件没有执行权限仍然可以执行呢?
![](http://blog-mamba.oss-cn-beijing.aliyuncs.com/linux/shell/03.png)
- 因为sh是一个执行脚本的命令只要sh有执行权限而且你这个文件是可读的那么就可以去执行这个文件
