### 自执行函数调用

- 方式1:

```javascript
(
function (a){
	alert(a);
}
)(123);
```

- 方式2:

```javascript
!function(){
	alert(100);
}();
```



### 传入参数

```
!function(a,b){
	alert(100+a+b)
}(123,456);
```

