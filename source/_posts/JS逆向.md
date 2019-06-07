---
title: JS逆向
top: 9999
tags: []
date: 2019-03-09 23:11:21
permalink:
categories: JS逆向
image:

---

<p class="description"></p>

<meta name="referrer" content="no-referrer" />

<img src="http://blog-mamba.oss-cn-beijing.aliyuncs.com/springboot/title.png">

<!-- more -->

# 1.搜索方法  

直接在login包的后面的JS链接里面去找讨主意观察页面是否刷新如果刷新顺着往下找排除JS框架
在值栈框里面寻找一直找到不是作为形参的地方为止
出现Digest可以再当前页面搜索一些数据摘要算法的名称例如md  sha
setpublickey
登录框按钮ID
登录框提示的错误红字
登录框的登录中
还有placehoder
URL的后缀
password
password:
password=
password =
username
trim
encrypt
xhr断点  把URL里面的内容加到Breakpoints里面

# 2.系统引擎和V8引擎有什么区别

系统引擎   IE7的引擎   ES3的标准
V8引擎   谷歌开源的  谷歌浏览器内置JS解析引擎  用的是ES5的标准
比如说定义了一个对象
```javascript
var obj = {
    a:"xxxxxxxx",
    b:"yyyyyy"
};
return JSON.stringify(obj)
```
这时候使用系统引擎会报错,使用V8引擎就ok
btoa这个东西是浏览器实现的代码
# 3.特殊参数
如果参数在JS文件里那么一般是写死的
如果参数在HTML页面里那么一般是服务器返回的

# 4.sign参数
sign参数一般是不可逆的算法
消息摘要算法MD5 SHA1 SHA256

数字签名一般用MD5 + RSA   SHA1+RSA  SHA256+RSA

签名的时候一般先对你提交的表单的数据(里面可能有一个时间戳)做一个排序的操作
操作完以后再进行摘要算法

```javascript
//获取sign
var getSign = function(sPara){
    //把参数的键值取出来
    var keys = object.keys(sPara);
    //因为取出来的兼职顺序每次都不一样所以需要按键值升序排列
    keys = keys.sort();
    var split = "";
    var signString = "";
    for(var i=0;i<keys.length;i++){
        signString += split+keys[i] + "=" + (typeof sPara[keys[i]] === 'object' ? JSON.stringify(sPara[keys[i]]):sPara[keys[i]]);
        split = '&';
    }
        signString = signString + 'FD92DF750B32765DA01A119BE1601D46'
        return hexMD5(utf8encode(signString));
}
```

# 5.掐头去尾取中间
导出的是谁就用谁去调用
module.exports = j


# 6.AES算法
直接去找定义CryptoJS的地方,碰到AES如果缺少东西一定要去左边的文件栏中去看看挨个找把含有CryptoJS的文件全部复制过去  
if (type == null || "aes" == type.toLowerCase()) {
            keyObj = SECURITYKEY.get();
            value = CryptoJS.AES.encrypt(value, CryptoJS.enc.Utf8.parse(keyObj.key), {
                iv: CryptoJS.enc.Utf8.parse(keyObj.iv)
            }).toString()
            

参数一: value是要加密的数据  
参数二: CryptoJS.enc.Utf8.parse(keyObj.key)是加密的秘钥  
参数三: iv: CryptoJS.enc.Utf8.parse(keyObj.iv)是一个对象,里面可以放加密模式 和 iv向量  如果没有写默认是CBC模式和Pkcs7  

标准AES格式
```javascript
function AES(){  
    
    var pwd = "a12456"  
    var key = CryptoJS.enc.utf8.parse("4F233463B63EA99F");  //key和iv在使用之前要先解析成字节集  其实这个解析不解析无所谓
    var iv  = CryptoJS.enc.utf8.parse("9BD2C547935C46F2"); //ECB模式没有偏移向量
    var value = CryptoJS.AES.encrypt(pwd,key,{   //DES的话就把AES换成DES  一般AES的秘钥是16个字节或者是32个字节8个字节也可以DES是8个字节3DES是24个字节
        mode:CryptoJS.mode.CBC,  
        padding:CryptoJS.pad.pkcs7,  
        iv:iv  
    }).toString()
    
    return value;
}

//CryptoJS.enc.utf8.parse的几种形式
var wordArray = CryptoJS.enc.Utf8.parse(utf8String);  //把一个字符当做一个字节
var wordArray = CryptoJS.enc.Latin1.parse(latin1String);//和UTF8差不多UFT支持中文而Latin1不支持中文
var wordArray = CryptoJS.enc.Hex.parse(hexString);
var wordArray = CryptoJS.enc.Base64.parse(base64String); //把两个字符当做一个字节

ECB模式:
dfjo  dsjf  dusi  glsk  fj
填充模式会把不满足四个的去进行填充
NoPadding ZeroPadding Pkcs7(Pkcs5) Iso10126 Iso97971 AnsiX923
其中Iso10126填充方式会让密码一直变化

CBC模式(多了一个iv):
dfjo  dsjf  dusi  glsk  fj
拿着这些字符串去和iv做位或
假如iv和dfjo做位或得到a
a又和dsjf去做位或得到b
这样就能算出加密的数据

```

# 7.在JS代码中如果碰到像百度登录中的unicode码
可以把它替换成URL编码然后用的时候再去URL解码去使用

# 8.各种编码形式
1、编码
escape
encodeURIComponent

Base64/btoa/atob
•  所有的数据都能被编码为只用65个字符就能表示的文本。
•  65字符：A~Z a~z 0~9 + / =
一般base64以后都需要替换或者URL编码

2、单向散列函数 消息摘要算法
·  加密后的密文定长
·  明文不一样，散列后结果一定不一样
·  不可逆
·  一般用于签名 sign  sign一般是表单前后加了一些固定的东西
MD5     32位  加密出来是wordarray数据类型
SHA1	 40位  
SHA256  
SHA512  
HmacMD5  
HmacSHA1  
HmacSHA256  
mac算法都需要key,不同key加密出来的结果不同
这种算法一般结果都是16进制字符组成的,每两个十六进制字符形成一个字节  

3、加密
加密和解密的过程是可逆的
• 	对称加密算法
加密/解密使用相同的密钥
DES 数据加密标准 3DES
AES 高级加密标准
AES 共有ECB,CBC,CFB,OFB,CTR五种模式

• 非对称加密算法
RSA
•  使用公钥加密，使用私钥解密
•  公钥是公开的，私钥保密
•  加密处理安全，但是性能极差，单次加密长度有限制

AES加密数据
随机生成秘钥
RSA对密钥加密



parse和stringify
var wordArray = CryptoJS.enc.Utf8.parse(utf8String);
var wordArray = CryptoJS.enc.Latin1.parse(latin1String);
var wordArray = CryptoJS.enc.Hex.parse(hexString);
var wordArray = CryptoJS.enc.Base64.parse(base64String);

var utf8String = CryptoJS.enc.Utf8.stringify(wordArray);
var latin1String = CryptoJS.enc.Latin1.stringify(wordArray);
var hexString = CryptoJS.enc.Hex.stringify(wordArray);
var base64String = CryptoJS.enc.Base64.stringify(wordArray);



消息摘要算法
var hash = CryptoJS.MD5(message);
var hash = CryptoJS.MD5(wordArray);
var hmac = CryptoJS.HmacMD5(message, key);

var hash = CryptoJS.SHA1(message);
var hash = CryptoJS.SHA1(wordArray);
var hmac = CryptoJS.HmacSHA1(message, key);

var hash = CryptoJS.SHA224(message);
var hash = CryptoJS.SHA224(wordArray);
var hmac = CryptoJS.HmacSHA224(message, key);

var hash = CryptoJS.SHA256(message);
var hash = CryptoJS.SHA256(wordArray);
var hmac = CryptoJS.HmacSHA256(message, key);

var hash = CryptoJS.SHA3(message);
var hash = CryptoJS.SHA3(wordArray);
var hmac = CryptoJS.HmacSHA3(message, key);

var hash = CryptoJS.SHA384(message);
var hash = CryptoJS.SHA384(wordArray);
var hmac = CryptoJS.HmacSHA384(message, key);

var hash = CryptoJS.SHA512(message);
var hash = CryptoJS.SHA512(wordArray);
var hmac = CryptoJS.HmacSHA512(message, key);



对称加密算法
var ciphertext = CryptoJS.AES.encrypt(message, key, cfg);
var plaintext  = CryptoJS.AES.decrypt(ciphertext, key, cfg);

var ciphertext = CryptoJS.DES.encrypt(message, key, cfg);
var plaintext  = CryptoJS.DES.decrypt(ciphertext, key, cfg);

var ciphertext = CryptoJS.TripleDES.encrypt(message, key, cfg);
var plaintext  = CryptoJS.TripleDES.decrypt(ciphertext, key, cfg);

var ciphertext = CryptoJS.RC4.encrypt(message, key, cfg);
var plaintext  = CryptoJS.RC4.decrypt(ciphertext, key, cfg);



加密模式
CBC ECB CFB OFB CTRGladman(CTR)
CBC模式多了一个iv向量
填充方式
NoPadding ZeroPadding Pkcs7(Pkcs5) Iso10126 Iso97971 AnsiX923



wordArray转换到字符串
var string = wordArray + '';
var string = wordArray.toString();
var string = wordArray.toString(CryptoJS.enc.Utf8);



另外的调用方式
var hasher = CryptoJS.algo.SHA256.create();
hasher.reset();
hasher.update('message');
hasher.update(wordArray);
var hash = hasher.finalize();
var hash = hasher.finalize('message');
var hash = hasher.finalize(wordArray);

var hmacHasher = CryptoJS.algo.HMAC.create(CryptoJS.algo.SHA256, key);
hmacHasher.reset();
hmacHasher.update('message');
hmacHasher.update(wordArray);
var hmac = hmacHasher.finalize();
var hmac = hmacHasher.finalize('message');
var hmac = hmacHasher.finalize(wordArray);

# 9.反调试案例
按f12就会出现断点

setInteval(debugger)  

setInterval() 方法会不停地调用函数，直到 clearInterval() 被调用或窗口被关闭。
由 setInterval() 返回的 ID 值可用作 clearInterval() 方法的参数。

setTimeout() 

setTimeout() 方法用于在指定的毫秒数后调用函数或计算表达式。

提示： 1000 毫秒= 1 秒。

提示： 如果你只想重复执行可以使用 setInterval() 方法。

提示： 使用 clearTimeout() 方法来阻止函数的执行。 

通过函数调用栈打断点在控制台修改掉debugger
例子:_$i8 = function(){return null}

test()

function test(){
debugger
}

eval就是执行字符串的js代码


# 10.搜索的时候如果是处于断点状态那么将会卡在那里
把自己打的断点全部放行你就可以搜索到你想要的东西了

# 11.RSA
RSA:
1、p和q 是不相等的，足够大的两个质数。 p和q是保密的
2、n = p*q n是公开的
3、f(n) = (p-1)*(q-1)
4、e 是和f(n)互质的质数
5、计算参数d
6、经过上面5步计算得到公钥KU=(e,n) 私钥KR=(d,n)
RSA三步骤 :
1:初始化 n = new JSEncrypt;
2:设置公钥 n.setPublicKey(r);
3:进行加密 var e = n.encrypt($("#input1").val())
RSA加密三步骤示例代码:

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
    
    其实就是用RSA去加密AES的key
    然后把RSA的公钥提交给服务器
    把加密后的AES的key交给服务器
    把加密后的AES数据也交给服务器
    
    服务器通过RSA的公钥和被加密的AES的key计算出不加密的AES的key
    然后再把加密的AES的数据给解出来
```javascript
function AES(){  
    
    var pwd = "a12456"  
    var key = CryptoJS.enc.utf8.parse("4F233463B63EA99F");  //key和iv在使用之前要先解析成字节集
    var iv  = CryptoJS.enc.utf8.parse("9BD2C547935C46F2"); //ECB模式没有偏移向量
    var value = CryptoJS.AES.encrypt(pwd,key,{   //DES的话就把AES换成DES  一般AES的秘钥是16个字节或者是32个字节8个字节也可以DES是8个字节3DES是24个字节
        mode:CryptoJS.mode.CBC,  
        padding:CryptoJS.pad.pkcs7,
        iv:iv  
    }).toString()
    
    return value;
}
```

# 12.$().val()
$().val()如果括号中没有值代表取值,如果括号中有值代表赋值

# 13.$.fn
valAesEncryptSet($("#txtPassword").val())

$("#txtPassword").valAesEncryptSet();

通过$.fn就能实现他们两个的互转

# 14.cookie问题
有时会在请求tab图片返回状态码521然后把设置cookie的脚本藏在响应体里
window.onload=set.Timeout("du(44)",200);function du(PB)
function du(PB)

如果document未定义
var document = {}
document.cookie="";

cookie有可能会失效过一段时间就去请求一下

# 15.转义\
如果签名有\的话那么在加密的时候需要转义将\转义为\\
然后再去进行计算

# 16.时间戳
在进行sign签名的时候一定要记得用同一个时间戳