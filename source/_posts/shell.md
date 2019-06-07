---
title: shell
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: shell
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

# linux的基本操作命令

## 简介：30个常用的命令
```
这么多命令记不住怎么办？

	第一种方法:
        去找你命令的意思 man + 命令
        举例 man cd
            man ls

	第二种方法:
		使用ls --help

1、  cd命令 
功能说明：切换目录。
举    例：切换到根目录 ：		 cd /
         切换到上次运行的目录：cd -

2、  ls命令 
功能说明：列出目录内容。
举    例：列出/var目录的文件和目录的信息 ：ls –l /var；   
		 最常用方式 ls –ltr  list time reverse 以创建时间去排列最旧的在最上边最新的在最下边  
		 ls -lt看最旧
		 ls -lrt看最新
         ls -l 以列的形式展示出来；通常写成ll
         
3、  cat命令 
功能说明：查看小文件内容。
举   例：查看test.txt 文件内容 ：cat test.txt
		cat > test.txt  #重定向到test.txt文件
		asddsafsafsads  #向test.txt文件中输入内容
		ctrl+c			#结束输入
		cat test.txt	#输入完毕再次查看文件
		cat -n test.txt #能够带上行数查看文件

4、  chmod命令 
功能说明：修改文件或目录权限。
举   例：修改test.sh 为自己可执行：chmod u+x test.sh 

5、  chown命令 
功能说明： 变更文件或目录的拥有者或所属群组。
举    例：修改test.txt 属主为mysql ：chown mysql:mysql test.txt
		 先用ll查看所属组
		 假如之前我们的test.txt属于 root root  
		 改过之后就是  mysql mysql
		 
6、  cp命令 
功能说明：拷贝文件。
举    例：拷贝文件test.sh 为 test.sh_bak：cp test.sh test.sh_bak

7、  diff命令 
功能说明：对比文件差异。
举    例：对比文件test.sh test.sh_bak 是否有差异diff  test.sh test.sh_bak

8、  find命令 
功能说明：查询文件。
举    例：查询本目录及其子目录的文件test.txt：find ./ -name test.txt

9、  mv命令 
功能说明：移动或更名现有的文件或目录。
举   例：移动 test.sh到/bin目录下：mv test.sh /bin/

10、rm命令 
功能说明：删除文件或目录。
举    例：删除文件test.sh ：rm test.sh

11、touch命令 
功能说明：创建一个空文件。
举    例：创建一个空的test.txt文件：touch test.txt

12、which命令 
功能说明：在环境变量$PATH设置的目录里查找符合条件的文件。
举    例：查询find命令在那个目录下面：which find
which ls
/usr/bin/ls

13、ssh命令 
功能说明：远程安全登录方式。
举    例：登录到远程主机：ssh ${IP}

14、grep命令 
功能说明：查找文件里符合条件的字符串。
举   例：从test.txt文件中查询test的内容：grep test test.txt

15、wc命令 
功能说明：统计行。
举    例：统计test.txt文件有多少行：wc -l test.txt

16、date命令 
功能说明：查询主机当前时间。
举    例：查询主机当前时间：date

17、exit命令 
功能说明：退出命令。
举    例：退出主机登录：exit

18、kill命令 
功能说明：杀进程。
举   例：杀掉test用户下面的所有进程：ps -ef | awk ‘$1==”test” {print $2}’ | xargs kill -9

19、id命令 
功能说明：查看用户。
举   例：查看当前用户：id ；
		查询主机是否有test用户：id test

20、ps命令 
功能说明：查询进程情况。
举   例：查询test.sh进程：ps -ef | grep test.sh

21、sleep命令 
功能说明：休眠时间。
举   例：休眠60秒 ：sleep 60

22、uname命令 
功能说明：查询主机信息。
举   例：查询主机信息：uname -a

23、passwd命令 
功能说明：修改用户密码。
举   例：使用root修改test用户的密码：passwd test

24、ping命令 
功能说明：查看网络是否通。
举    例：查询本主机到远程IP的网络是否通：ping ${IP} 

25、df命令 
功能说明：查看磁盘空间使用情况。
举    例：查看主机的空间使用情况 ：df -h

26、echo命令 
功能说明：标准输出命令。
举    例：对变量test进行输出：echo $test
	                      echo '123' //相当于print的意思
27、pwd命令 
功能说明：查询所在目录。
举   例：查询当前所在目录：pwd

28、head命令 
功能说明：查看文件的前面N行。
举    例：查看test.txt的前10行：head -10 test.txt

29、tail命令 
功能说明：查看文件的后面N行。
举    例：查看test.txt的后10行：tail -10 test.txt

30、mkdir命令 
功能说明：创建目录。
举    例：创建test目录：mkdir test
```

# 远程连接软件以及vi编辑器
## 简介:远程连接软件 与 vi命令的基本使用
- 软件：
```
    secureCRT
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
    x 或 wq 	 	# 保存退出
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

- 常见的执行方法

方法1：添加执行权限 chmod +x shell.sh

方法1：./shell.sh

方法2：sh shell.sh 或者bash shell.sh

方法3：source shell.sh

# shell的常见变量
```
    不同于其它语言需要先声明变量
	shell的变量直接使用，eg:a=15
	调用变量的话 $或者a 或者 ${a}   ${a}能够和其它字符连在一起

	$?	#判断上一条命令执行的是否成功,如果返回0代表成功,返回1代表失败

	$0	#返回脚本的文件名称

	$1-$9 #返回对应的参数值

	$* #返回所有的参数值是什么

	$# #返回参数的个数和
```

vi shell.sh
```
#!/bin/bash
#test
#by作者XXX 20XX年XX月XX日
echo "脚本: $0"
echo "第一个参数是: $1"
echo "第一个参数是: $2"
echo "一共有多少参数: $#"
echo "这些参数都是什么: $*"
```

运行命令 sh shell.sh 12 abc 45 kkk po
输出内容:
```
脚本: shell.sh
第一个参数是:12
第二个参数是:abc
一共有多少个参数:5
这些参数是什么:12 abc 45 kkk po
```

# shell的常见的几个符号
```
>  #会覆盖原有的内容

>>  #不会覆盖原有的内容  

;	#执行多条命令

|  #管道符

&& #前面的命令执行成功，后面的才可以执行

|| #前面的命令执行失败，后面的才可以执行

"" #会输出变量值 eg:
vi abc.sh
echo "第一个参数是:$1"
echo '第一个参数是:$1'

sh abc.sh 100
第一个参数是: 100
第一个参数是: $1

'' #输出本身

`` #输出命令结果 eg:a=`date`;echo $a

2>/dev/null  #错误输出到无底洞
1>/dev/null	 #正确输出到无底洞
```

# 秒变计算器的运算符
- 整数:
```
    加：expr 12 + 6 		expr $a + $b

		echo $[12 + 6]		echo $[a + b]

		echo $((12 + 6))	echo $((a + b))
		
	减：expr 12 - 6			expr $a - $b

		echo $[12 - 6]		echo $[a - b]

		echo $((12 - 6)) 	echo $((a - b))

	乘：expr 12 \* 6		expr $a \* $b    #\*转义为乘,否则它就是个通配符

		echo $[12 * 6]	  	echo $[a * b]

		echo $((12 * 6))	echo $((a * b))

	除：expr 12 / 6			expr $a / $b

		echo $((12 / 6))	echo $((a / b))

		echo $[12 / 6]		echo $[a / b]

	求余：expr 12 % 6 		expr $a % $b

		  echo $((12 % 6))	echo $((a % b))

		  echo $[12 % 6]	echo $[a % b]

```
- 小数:
```
bc #交互模式
使用管道|  #可以不用交互模式
echo "1+2" | bc

bc计算器
保留多少位小数可以通过scale
echo "scale=2;1.2+1.3" | bc4
echo "scale=2;(1.2+1.3)/1" | bc
但是scale只对除法，取余数，乘幂 有效，对加减没有效。

echo "scale=2;(0.2+0.3)/1" | bc 	#计算出0.2+0.3的和并保留俩位小数，此时bc计算器会省略掉个位数的0
echo "scale=2;(1.2+1.3)/1" | bc   #计算出1.2+1.3的和并保留俩位小数
```

# 常见的条件判断
- 语法: [判断表达式]
```
文件（夹）或者路径：
-e  目标是否存在（exist）
[ -e xxx.sh ] && echo '存在'  #如果有这个文件就输出存在
-d  是否为路径（directory）
[ -d /home/username ] && echo '/home/username存在'
-f  是否为文件（file）
[ -e xxx.sh ] || touch xxx.sh 	#判断当前目录下是否有foer.sh这个文件，假如没有就创建出foer.sh文件
```
- 权限:
```
-r  是否有读取权限（read）
-w  是否有写入权限（write）
-x  是否有执行权限（excute）

[ -x xxx.txt ] && echo '有执行权限'
```
- 整数值（int型）：
```
-eq 等于（equal）
-ne 不等于(not equal)
-gt 大于（greater than）
-lt 小于（lesser than）
-ge 大于或者等于（greater or equal）
-le 小于或者等于（lesser or equal）

[ 9 -gt 8 ] && echo '大于'
```

- 小数(浮点型):
```
[ `echo '1.2 < 1.3' | bc` -eq 1 ] && echo '小于'
如果是一条语句就用繁体号括起来
```

- 字符串:
```
=    相等
!=   不相等

[ 'kkkkk' != 'kkkk' ] && echo '不等于'
```

- 制作一个简单的脚本
```
cat > panduan.sh

#!/bin/bash
#判断输入的第一个数是否大于输入的第二个数
#by author
if [ $s1 -eq $2 ]
then
echo "$1等于$2"

else

echo "$1 不等于 $2"
fi

sh panduan.sh 12 13
```

```
#创建一个文件如果文件创建成功就返回0
#!/bin/bash
touch $1
if [ $? -eq 0 ];then
echo "$1 创建成功!"
fi
```

# shell脚本输入之read命令
- 语法：read -参数
```
-p：给出提示符。默认不支持"\n"换行
-s：隐藏输入的内容
-t：给出等待的时间，超时会退出read
-n：限制读取字符的个数，触发到临界值会自动执行
```