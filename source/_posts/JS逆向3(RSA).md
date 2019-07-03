---
title: springboot
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: springboot
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

# RSA加密

RSA:
1、p和q 是不相等的，足够大的两个质数。 p和q是保密的
2、n = p*q n是公开的
3、f(n) = (p-1)*(q-1)
4、e 是和f(n)互质的质数
5、计算参数d
6、经过上面5步计算得到公钥KU=(e,n) 私钥KR=(d,n)

**公式:密文 = (明文 的 指数次方)  取余 公钥**

**RSA的指数常见的就是10001**

<font size='4px' style=color:red>RSA解密技巧:</font>

​			1.搜索的时候先去搜索-----BEGIN PUBLIC KEY-----

​			2.或者尝试去搜索-----END PUBLIC KEY-----

​			格式以这个为准:

```
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCh5Nk2GLiyQFMIU+h3OEA4UeFb
u3dCH5sjd/sLTxxvwjXq7JLqJbt2rCIdzpAXOi4jL+FRGQnHaxUlHUBZsojnCcHv
hrz2knV6rXNogt0emL7f7ZMRo8IsQGV8mlKIC9xLnlOQQdRNUssmrROrCG99wpTR
RNZjOmLvkcoXdeuaCQIDAQAB
-----END PUBLIC KEY-----
```

​			3.将上面的公钥进行16进制的转换然后带入到调试工具中(<font size='4px' style=color:red>转换为16进制以后应该是256位的公钥</font>)

​			4.去调试密码利用Envalue  in  Console尝试看看密码是否会发生变化,如果发生变化证明是PKCS1模式

​			5.然后进行内存反转或者字符反转

RSAkey的三种来源:

1. 来源于数据包的响应体中

   (一般会在请求的URL上以Restful的形式显示/getpublick/)

2. 在JS文件中写死

3. 在内部自动生成(少见)



RSA三步曲 :

```
1:初始化 n = new JSEncrypt;
2:设置公钥 n.setPublicKey(r);
3:进行加密 var e = n.encrypt($("#input1").val())
```

example(一):

```javascript
function getPwd(pwd){

	var key = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDcV30OSW6Bd8uWyoUzajb7Rwe7NH9J8czQZSgGv9LBk0QZevURdhbME0GbCHS79mOP3+/KgvYZR5NakGd/ZGcagxhoCCY6sDYKA5iTQaXCbg5dhpfviWnj3ck0iGIVCf26QaquJttWsHEU3C0lwkJzGDTC0QjPnV4HwgDd70BcuwIDAQAB";

	var encrypt = new JSEncrypt;

    encrypt.setPublicKey(key);

    return encrypt.encrypt(pwd);

}
```

```javascript
//默认是nopadding的填充模式
function getRSA(password, pubkey) {
    setMaxDigits(131);
    var key = new RSAKeyPair("10001", '', pubkey);
    return encryptedString(key, password);
}
```

example(二):

```javascript
var rsa = function (arg) {
      setMaxDigits(130);
      //指数
      var PublicExponent = "10001";
      var modulus = "be44aec4d73408f6b60e6fe9e3dc55d0e1dc53a1e171e071b547e2e8e0b7da01c56e8c9bcf0521568eb111adccef4e40124b76e33e7ad75607c227af8f8e0b759c30ef283be8ab17a84b19a051df5f94c07e6e7be5f77866376322aac944f45f3ab532bb6efc70c1efa524d821d16cafb580c5a901f0defddea3692a4e68e6cd";
      var key = new RSAKeyPair(PublicExponent, "", modulus);
      return encryptedString(key, arg);
  };
```



它两种模式ECB和NONE但是两者的结果是一样的 
填充方式有
PKCS1padding
nopadding

假如你选择的秘钥长度为1024bit共128个byte：
1.当你在客户端选择RSA_NO_PADDING填充模式时，如果你的明文不够128字节  
加密的时候会在你的明文前面，前向的填充零。解密后的明文也会包括前面填  
充的零，这是服务器需要注意把解密后的字段前向填充的零去掉，才是真正之  
前加密的明文。  

2.当你选择RSA_PKCS1_PADDING填充模式时，如果你的明文不  
够128字节加密的时候会在你的明文中随机填充一些数据，所以会导致对同样  
的明文每次加密后的结果都不一样。对加密后的密文，服务器使用相同的填充  
方式都能解密。解密后的明文也就是之前加密的明文。  

公钥是在前端的
私钥是在服务器的
加密速度慢 长度有限制
公钥最多是1024位 1024/8 =  128个字节
如果是pkcs1的话还要-11个字节最大能加密的字节就是117个字节
如果是nopadding的话是128个字节
RSA的密文和明文保持一致
RSA加密数据的长度取决于公钥的长度

RSA.min.js文件处理的是16进制文本的rsa
setMaxDigits() 里面的数字是秘钥的  长度/2 稍微+一个数字1或2或3 防止崩溃

RSA的套路:
    本地生成一个随机的AES加密秘钥a
    用RSA加密这个a秘钥
    然后用aes加密大量数据  

```
其实就是用RSA去加密AES的key
然后把RSA的公钥提交给服务器
把加密后的AES的key交给服务器
把加密后的AES数据也交给服务器

服务器通过RSA的公钥和被加密的AES的key计算出不加密的AES的key
然后再把加密的AES的数据给解出来
```



绝大部分RSA的公钥都是

```
-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCh5Nk2GLiyQFMIU+h3OEA4UeFb
u3dCH5sjd/sLTxxvwjXq7JLqJbt2rCIdzpAXOi4jL+FRGQnHaxUlHUBZsojnCcHv
hrz2knV6rXNogt0emL7f7ZMRo8IsQGV8mlKIC9xLnlOQQdRNUssmrROrCG99wpTR
RNZjOmLvkcoXdeuaCQIDAQAB
-----END PUBLIC KEY-----
```



<font size='4px' style=color:red>如何判断自己调试出来的RSA算法