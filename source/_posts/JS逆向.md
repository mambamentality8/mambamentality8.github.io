# 1.搜索方法  
直接在login包的后面的JS链接里面去找讨主意观察页面是否刷新如果刷新顺着往下找排除JS框架
在值栈框里面寻找一直找到不是作为形参的地方为止
出现Digest可以再当前页面搜索一些数据摘要算法的名称例如md  sha
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

# 2.系统引擎和V8引擎有什么区别

系统引擎   IE7的引擎   ES3的标准
V8引擎   谷歌开源的  谷歌浏览器内置JS解析引擎  用的是ES5的标准

# 3.特殊参数
如果参数在JS文件里那么一般是写死的
如果参数在HTML页面里那么一般是服务器返回的

# 4.sign参数
sign参数一般是不可逆的算法
消息摘要算法MD5 SHA1 SHA256

数字签名一般用MD5 + RSA   SHA1+RSA  SHA256+RSA

# 5.掐头去尾取中间
导出的是谁就用谁去调用
module.exports = j


# 6.AES算法
if (type == null || "aes" == type.toLowerCase()) {
            keyObj = SECURITYKEY.get();
            value = CryptoJS.AES.encrypt(value, CryptoJS.enc.Utf8.parse(keyObj.key), {
                iv: CryptoJS.enc.Utf8.parse(keyObj.iv)
            }).toString()
            

参数一: value是要加密的数据  
参数二: CryptoJS.enc.Utf8.parse(keyObj.key)是加密的秘钥  
参数三: iv: CryptoJS.enc.Utf8.parse(keyObj.iv)是一个对象,里面可以放加密模式 和 iv向量  如果没有写默认是CBC模式和Pkcs7  

# 7.在JS代码中如果碰到像百度登录中的unicode码
可以把它替换成URL编码然后用的时候再去URL解码去使用

# 8.各种编码形式
1、编码
escape
encodeURIComponent

Base64/btoa/atob
•  所有的数据都能被编码为只用65个字符就能表示的文本。
•  65字符：A~Z a~z 0~9 + / =
 
2、单向散列函数 消息摘要算法
·  加密后的密文定长
·  明文不一样，散列后结果一定不一样
·  不可逆
·  一般用于签名 sign
MD5     32位
SHA1	 40位
SHA256
SHA512
HmacMD5
HmacSHA1
HmacSHA256

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


