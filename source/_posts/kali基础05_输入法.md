更新软件信息数据库 
apt-get update 
进行系统升级 
apt-get upgrade



修改软件源 

终端执行命令

![1571329996106](C:\Users\85896\AppData\Roaming\Typora\typora-user-images\1571329996106.png)

```
leafpad /etc/apt/sources.list
```

```
#阿里云
deb http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
deb-src http://mirrors.aliyun.com/kali kali-rolling main non-free contrib
```

安装fcitx

```
apt-get install fcitx
```

