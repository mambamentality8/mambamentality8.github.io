# 指针

### 1.概念一

带*类型的变量赋值时只能使用"完整写法"

int* a = 100

b = (int*) a

带*类型的变量宽度永远是4字节 无论类型是什么 无论有几个 *



### 2.概念二

带*类型的变量 , ++ 或者 --新增(减少)的数量是去掉一个 *后变量的宽度

short* s = 100;

s++;

s的结果为102



short** s =100;

s++;

s的结果为104



### 3.概念三

char** d = NULL;

d=(char**)100;

d=d+5;

printf("%d\n",d)



char** 去掉一个 *以后是4个字节

向右偏移5个char*的宽度

所以结果为120



char* d = NULL;

d=(char*)100;

d=d+5;

printf("%d\n",d)



char* 去掉一个 *以后是1个字节

向右偏移5个char的宽度

所以结果为105



1.带*类型的变量可以加、减一个整数,单不能乘或者除

2.带*类型变量与其他整数相加或者相减时,

​		带*类型变量 + N = 带*类型变量 + N*(去掉一个 *后类型的宽度)

​		带*类型变量 - N = 带 *类型变量 - N *（去掉一个 *后类型的宽度）



### 4.概念四

```c
int[] arr = {0,1,2,3,4,5,6,7,8,9}
for(int i = 0; i < 10; i++){
    printf("%d\n",*(arr+i));
}
```

这里printf函数里面的arr就相当于&arr[0] 取数组首地址

它需要用一个int* 类型的变量去接收

那么arr+1的时候就相当于int* arr向右偏移4(去掉一个*sizeof)个字节刚好指向下一个int型的整数

### 5.概念五

```c
short* a;
short* b;
a = (short*)200;
b = (short*)100;
int x = a - b;
printf("%d\n",x);
```

结果为50



两个类型相同的带*类型的变量可以进行减法操作

相减的结果要除以去掉一个*的数据宽度

### 6.概念六

```c
char** a;
char** b;
a = (char**)200;
b = (char**)100;
if(a>b){
    printf("%d\n",1);
}else{
    printf("%d\n",2)
}
```

结果为1

### 作业题

计算char** arr[10];的长度

```c
int main() {
	char** arr[10];
	int len = sizeof(arr);
	printf("%d",len);
	getchar();
	return 0;
}
```

带*的变量,如果类型相同,可以做大小比较.

# 结构体

### 定义结构体

格式:

```c
struct tag { 
    member-list
    member-list 
    member-list  
    ...
} variable-list ;
```

**tag** 是结构体标签。

**member-list** 是标准的变量定义，比如 int i; 或者 float f，或者其他有效的变量定义。

**variable-list** 结构变量，定义在结构的末尾，最后一个分号之前，您可以指定一个或多个结构变量。下面是声明 Book 结构的方式：

```c
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} book;
```

### 结构体声明变量

#### 方式一:

```c
struct SIMPLE
{
    int a;
    char b;
    double c;
};

struct SIMPLE t1, t2, t3;
```

#### 方式二:

```c
typedef struct
{
	int a;
	char b;
	double c;
} Simple2;

Simple2 s1, s2, s3;
```

### 方式三:

```
typedef struct MyStruct1
{
	int a;
	char b;
	double c;
} tt;

tt t1, t2, t3;
```

### 结构体的成员

结构体的成员可以包含其他结构体，也可以包含指向自己结构体类型的指针，

```c
struct SIMPLE
{
	int a;
	char b;
	double c;
};

struct COMPLEX
{
	char string[100];
	struct SIMPLE a;
};
```



```c
//此结构体的声明包含了指向自己类型的指针
struct NODE
{
    char string[100];
    struct NODE* next_node;
};
```



如果两个结构体互相包含，则需要对其中一个结构体进行不完整声明

```c
struct B;    //对结构体B进行不完整声明
 
//结构体A中包含指向结构体B的指针
struct A
{
    struct B *partner;
    //other members;
};
 
//结构体B中包含指向结构体A的指针，在A声明完后，B也随之进行声明
struct B
{
    struct A *partner;
    //other members;
};
```

### 结构体的初始化

```c
#include <stdio.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
} book = {"C 语言", "RUNOOB", "编程语言", 123456};
 
int main()
{
    printf("title : %s\nauthor: %s\nsubject: %s\nbook_id: %d\n", book.title, book.author, book.subject, book.book_id);
}
```

结果为:

```
title : C 语言
author: RUNOOB
subject: 编程语言
book_id: 123456
```

### 访问结构成员

```c
#include <stdio.h>
#include <string.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};
 
int main( )
{
   struct Books Book1;        /* 声明 Book1，类型为 Books */
   struct Books Book2;        /* 声明 Book2，类型为 Books */
 
   /* Book1 详述 */
   strcpy( Book1.title, "C Programming");
   strcpy( Book1.author, "Nuha Ali"); 
   strcpy( Book1.subject, "C Programming Tutorial");
   Book1.book_id = 6495407;
 
   /* Book2 详述 */
   strcpy( Book2.title, "Telecom Billing");
   strcpy( Book2.author, "Zara Ali");
   strcpy( Book2.subject, "Telecom Billing Tutorial");
   Book2.book_id = 6495700;
 
   /* 输出 Book1 信息 */
   printf( "Book 1 title : %s\n", Book1.title);
   printf( "Book 1 author : %s\n", Book1.author);
   printf( "Book 1 subject : %s\n", Book1.subject);
   printf( "Book 1 book_id : %d\n", Book1.book_id);
 
   /* 输出 Book2 信息 */
   printf( "Book 2 title : %s\n", Book2.title);
   printf( "Book 2 author : %s\n", Book2.author);
   printf( "Book 2 subject : %s\n", Book2.subject);
   printf( "Book 2 book_id : %d\n", Book2.book_id);
 
   return 0;
}
```

结果为:

```
Book 1 title : C Programming
Book 1 author : Nuha Ali
Book 1 subject : C Programming Tutorial
Book 1 book_id : 6495407
Book 2 title : Telecom Billing
Book 2 author : Zara Ali
Book 2 subject : Telecom Billing Tutorial
Book 2 book_id : 6495700
```

### 结构体作为函数参数

```c
#include <stdio.h>
#include <string.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};
 
/* 函数声明 */
void printBook( struct Books book );
int main( )
{
   struct Books Book1;        /* 声明 Book1，类型为 Books */
   struct Books Book2;        /* 声明 Book2，类型为 Books */
 
   /* Book1 详述 */
   strcpy( Book1.title, "C Programming");
   strcpy( Book1.author, "Nuha Ali"); 
   strcpy( Book1.subject, "C Programming Tutorial");
   Book1.book_id = 6495407;
 
   /* Book2 详述 */
   strcpy( Book2.title, "Telecom Billing");
   strcpy( Book2.author, "Zara Ali");
   strcpy( Book2.subject, "Telecom Billing Tutorial");
   Book2.book_id = 6495700;
 
   /* 输出 Book1 信息 */
   printBook( Book1 );
 
   /* 输出 Book2 信息 */
   printBook( Book2 );
 
   return 0;
}
void printBook( struct Books book )
{
   printf( "Book title : %s\n", book.title);
   printf( "Book author : %s\n", book.author);
   printf( "Book subject : %s\n", book.subject);
   printf( "Book book_id : %d\n", book.book_id);
}
```

结果为:

```
Book title : C Programming
Book author : Nuha Ali
Book subject : C Programming Tutorial
Book book_id : 6495407
Book title : Telecom Billing
Book author : Zara Ali
Book subject : Telecom Billing Tutorial
Book book_id : 6495700
```

### 指向结构体的指针

定义指向结构体的指针，方式与定义指向其他类型变量的指针相似

```
struct Books* struct_pointer;
```

在上述定义的指针变量中存储结构变量的地址

```
struct_pointer = &Book1;
```

使用指向该结构的指针访问结构的成员，必须使用 -> 运算符

```
struct_pointer->title;
```



example:

```c
#include <stdio.h>
#include <string.h>
 
struct Books
{
   char  title[50];
   char  author[50];
   char  subject[100];
   int   book_id;
};
 
/* 函数声明 */
void printBook( struct Books *book );
int main( )
{
   struct Books Book1;        /* 声明 Book1，类型为 Books */
   struct Books Book2;        /* 声明 Book2，类型为 Books */
 
   /* Book1 详述 */
   strcpy( Book1.title, "C Programming");
   strcpy( Book1.author, "Nuha Ali"); 
   strcpy( Book1.subject, "C Programming Tutorial");
   Book1.book_id = 6495407;
 
   /* Book2 详述 */
   strcpy( Book2.title, "Telecom Billing");
   strcpy( Book2.author, "Zara Ali");
   strcpy( Book2.subject, "Telecom Billing Tutorial");
   Book2.book_id = 6495700;
 
   /* 通过传 Book1 的地址来输出 Book1 信息 */
   printBook( &Book1 );
 
   /* 通过传 Book2 的地址来输出 Book2 信息 */
   printBook( &Book2 );
 
   return 0;
}
void printBook( struct Books *book )
{
   printf( "Book title : %s\n", book->title);
   printf( "Book author : %s\n", book->author);
   printf( "Book subject : %s\n", book->subject);
   printf( "Book book_id : %d\n", book->book_id);
}
```

```
Book title : C Programming
Book author : Nuha Ali
Book subject : C Programming Tutorial
Book book_id : 6495407
Book title : Telecom Billing
Book author : Zara Ali
Book subject : Telecom Billing Tutorial
Book book_id : 6495700
```

# 位域

定义格式:

```c
struct 位域结构名 
{
	位域名: 位域长度 
    位域名: 位域长度 
    位域名: 位域长度 
};
```

案例:

```c
struct bs{
    int a:8;
    int b:2;
    int c:6;
}data;
```

data 为 bs 数据类型的一个对象，共占两个字节。其中位域 a 占 8 位，位域 b 占 2 位，位域 c 占 6 位

案例:

```c
struct packed_struct {
  unsigned int a:1;
  unsigned int b:1;
  unsigned int c:1;
  unsigned int d:1;
  unsigned int e:4;
  unsigned int f:9;
} pack;
```

packed_struct 包含了 6 个成员：四个 1 位的标识符 a..d、一个 4 位的 e 和一个 9 位的 f。

### 空域

```c
struct bs{
    unsigned a:4;
    unsigned  :4;    /* 空域 */
    unsigned b:4;    /* 从下一单元开始存放 */
    unsigned c:4
}
```

在这个位域定义中，a 占第一字节的 4 位，后 4 位填 0 表示不使用，b 从第二字节开始，占用 4 位，c 占用 4 位。

### 无名位域

```c
struct k{
    int a:1;
    int  :2;    /* 该 2 位不能使用 */
    int b:3;
    int c:2;
};
```

位域可以是无名位域，这时它只用来作填充或调整位置。无名的位域是不能使用的

### 总结:

```
从以上分析可以看出，位域在本质上就是一种结构类型，不过其成员是按二进位分配的。
```

### 位域的使用

位域的使用和结构成员的使用相同，其一般形式为：

```
位域变量名.位域名
位域变量名->位域名
```

案例:

```c
main(){
    struct bs{
        unsigned a:1;
        unsigned b:3;
        unsigned c:4;
    } bit,*pbit;
    bit.a=1;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    bit.b=7;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    bit.c=15;    /* 给位域赋值（应注意赋值不能超过该位域的允许范围） */
    printf("%d,%d,%d\n",bit.a,bit.b,bit.c);    /* 以整型量格式输出三个域的内容 */
    pbit=&bit;    /* 把位域变量 bit 的地址送给指针变量 pbit */
    pbit->a=0;    /* 用指针方式给位域 a 重新赋值，赋为 0 */
    pbit->b&=3;    /* 使用了复合的位运算符 "&="，相当于：pbit->b=pbit->b&3，位域 b 中原有值为 7，与 3 作按位与运算的结果为 3（111&011=011，十进制值为 3） */
    pbit->c|=1;    /* 使用了复合位运算符"|="，相当于：pbit->c=pbit->c|1，其结果为 15 */
    printf("%d,%d,%d\n",pbit->a,pbit->b,pbit->c);    /* 用指针方式输出了这三个域的值 */
}
```

上例程序中定义了位域类型的结构体 bs，三个位域为 a、b、c。声明了 bs 类型的变量 bit 和指向 bs 类型的指针变量 pbit。这表示位域也是可以使用指针的。

# 对齐

```c
#pragma pack(1)
typedef struct MyStruct{
    int money;//4
    __int64 xue;//8
    char sudu;//1
}tt;

typedef struct MyStruct1{
    int money;//4
    char sudu;//1
    __int64 xue;//8
}tt1;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```

| int money(1)   |
| -------------- |
| int money(2)   |
| int money(3)   |
| int money(4)   |
| __int64 xue(1) |
| __int64 xue(2) |
| __int64 xue(3) |
| __int64 xue(4) |
| __int64 xue(5) |
| __int64 xue(6) |
| __int64 xue(7) |
| __int64 xue(8) |
| char sudu(1)   |

```c
#pragma pack(2)
typedef struct MyStruct{
    int money;//4
    __int64 xue;//8
    char sudu;//1
}tt;

typedef struct MyStruct1{
    int money;//4
    char sudu;//1
    __int64 xue;//8
}tt1;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```
| int money(1)   | int money(2)   |
| -------------- | -------------- |
| int money(3)   | int money(4)   |
| __int64 xue(1) | __int64 xue(2) |
| __int64 xue(3) | __int64 xue(4) |
| __int64 xue(5) | __int64 xue(6) |
| __int64 xue(7) | __int64 xue(8) |
| char sudu(1)   | 0              |

填充字节我们一般用1,2,4,8等等的数据区填充

```c
#pragma pack(2)
typedef struct MyStruct{
    int money;//4
    __int64 xue;//8
    char sudu;//1
}tt;

typedef struct MyStruct1{
    int money;//4
    char sudu;//1
    __int64 xue;//8
}tt1;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```
| int money(1)   | int money(2)   | int money(3)   | int money(4)   | 0              | 0              | 0              | 0              |
| -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- |
| __int64 xue(1) | __int64 xue(2) | __int64 xue(3) | __int64 xue(4) | __int64 xue(5) | __int64 xue(6) | __int64 xue(7) | __int64 xue(8) |
| char sudu(1)   | 0              | 0              | 0              | 0              | 0              | 0              | 0              |


| int money(1)   | int money(2)   | int money(3)   | int money(4)   | char sudu(1)   | 0              | 0              | 0              |
| -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- |
| __int64 xue(1) | __int64 xue(2) | __int64 xue(3) | __int64 xue(4) | __int64 xue(5) | __int64 xue(6) | __int64 xue(7) | __int64 xue(8) |

### 结论1

```
#pragma pack()里面以几对齐就画几列,如果当前变量放不下则另起一行放入
```

<font color="red">但是这个结论不完全正确!!!</font>



例如:

```c
#pragma pack(8)
typedef struct MyStruct1{
	char xue;
    char a;
    int arr[3];
    int b;
}tt1;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```

```c
#pragma pack(8)
typedef struct MyStruct1{
	char xue;
    char a;
    char arr[3];
    char b;
}tt1;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```

<font color="red">如果以数组进行存放是把数组拆开放入到pack中,数组中的每个元素都是一个单独的个体并不是整个数组必须独占一行</font>

### 结论2

```
此时如果结构体中的数据类型小于对齐的字节长度则以结构体中最大的那个数据类型为准
```

<font color="red">此时不再以8个字节对齐,而是以4个字节对齐</font>



### 结构体中套结构体

```c
#pragma pack(8)
typedef struct MyStruct1{
    int money;//4
    char sudu;//1
    __int64 xue;//8
}tt1;

typedef struct MyStruct{
	char xue;
    int a;
    char arr[3];
    char b;
    tt1 kk;
}tt;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```
| char xue(1)    | int a(1)       | int a(2)       | int a(3)       | int a(4)       | char arr[0]    | char arr[1]    | char arr[2]    |
| -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- | -------------- |
| char b         | 0              | 0              | 0              | 0              | 0              | 0              | 0              |
| int money(1)   | int money(2)   | int money(3)   | int money(4)   | char sudu      |                |                |                |
| __int64 xue(1) | __int64 xue(2) | __int64 xue(3) | __int64 xue(4) | __int64 xue(5) | __int64 xue(6) | __int64 xue(7) | __int64 xue(8) |

### 结论3

```
凡是碰到结构体必须重新起一行
```



```c
#pragma pack(8)
typedef struct MyStruct1{
    int money;//4
    char sudu;//1
    int xue;//4
}tt1;

typedef struct MyStruct{
	char xue;
    int a;
    char arr[3];
    char b;
    tt1 kk;
}tt;
#pragma pack()

int main()
{
	tt ss;
	tt1 ss1;
	printf("%d,%d\n", sizeof(ss), sizeof(ss1));
	getchar();
	return 0;
}
```

### 结论4

```
如果结构体中套结构体那么相当于继承 以里面最大的数据类型为准(不超过8)  比如上面的例子就不再是画8列而是画4列
```

# *和&

*用在声明时,是声明一个指针

*用在使用时,是取指针的一个值

*这个取地址内容,来接收它的数据类型必须是 被区的这个数据减掉一个 *

&是取出某个变量的地址



### 指针操作数组

```c
int arr[10];
int* p = &arr[0];
int* p1 = arr;
```

p和p1都是一样的都是取数组的首地址

*(p+i)

此时p是数组的首地址同时也是一个指针,相当于一个指针指向数组的第一个元素,然后向后偏移,最后再进行一个取值.



ps: 指针的加法我们之前已经学习过了:

```c
int[] arr = {0,1,2,3,4,5,6,7,8,9}
for(int i = 0; i < 10; i++){
    printf("%d\n",*(arr+i));
}
```

这里printf函数里面的arr就相当于&arr[0] 取数组首地址

它需要用一个int* 类型的变量去接收

那么arr+1的时候就相当于int* arr向右偏移4(去掉一个*sizeof)个字节刚好指向下一个int型的整数

### 指针操作结构体

```c
#pragma pack(8)//假如我这里不写也默认是#pragma pack(8)
typedef struct stu {
	int a;//4
	char b;//1
	int c;//4
}ss;
#pragma pack()


void main() {
	struct stu str; //重新声明一个结构体对象
	str.a = 10;
	str.b = 20;
	str.c = 30;

	char* aa;
	aa = (char*)&str; //把结构体的首地址赋值给aa指针
	printf("%d\n", *(aa + 0)); //10
	printf("%d\n", *(aa + 4)); //20
	printf("%d\n", *(aa + 8));
}
```

| int a(1)  | int a(2) | int a(3) | int a(4) |
| --------- | -------- | -------- | -------- |
| char b(1) |          |          |          |
| int c(1)  | int c(2) | int c(3) | int c(4) |

第一行第一列就是我的*(aa + 0) 剩下的依次类推  这里也是使用了指针的加法



# 模拟CE

### 作业

这一堆数据中存储了角色的名字信息(WOW)，请列出角色名的内存地址

```c
//这一堆数据中存储了角色的名字信息(WOW)，请列出角色名的内存地址.
char arr[] = {
	0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x07,0x09,
	0x00,0x20,0x10,0x03,0x03,0x0C,0x00,0x00,0x44,0x00,
	0x00,0x33,0x00,0x47,0x0C,0x0E,0x00,0x0D,0x00,0x11,
	0x00,0x00,0x00,0x02,0x64,0x00,0x00,0x00,0xAA,0x00,
	0x00,0x00,0x64,0x10,0x00,0x00,0x00,0x00,0x00,0x00,
	0x00,0x00,0x02,0x00,0x74,0x0F,0x41,0x00,0x00,0x00,
	0x01,0x00,0x00,0x00,0x05,0x00,0x00,0x00,0x0A,0x00,
	0x00,0x02,0x57,0x4F,0x57,0x00,0x06,0x08,0x00,0x00,
	0x00,0x00,0x00,0x64,0x00,0x0F,0x00,0x00,0x0D,0x00,
	0x00,0x00,0x23,0x00,0x00,0x64,0x00,0x00,0x64,0x00
};



void main() {
	char* p_start;
	char* p_name;
	p_start = p_name = arr;

	printf("数组的长度为: %d\n",sizeof(arr));

	//最后一个索引应该是98
	for (size_t i = 0; i < sizeof(arr)-2; i++){
		if (*p_name == 'W' && *(p_name+1) == 'O' && *(p_name + 2) == 'W') {
			printf("%x,索引值为: %d\n", p_start, i);
		}
		p_name = p_start++;
	}
	getchar();
}
```

### 指针高级

#### 一维指针数组和数组指针

```c
int main() {
	int* arr[10] = { 0,1,2,3,4,5,6,7,8,9 }; //指针数组
	int (*p)[5]; //数组指针 里面存放的就是数组的指针(即数组的首地址)
	//它的变量名是p
	//它的数据类型是int (*)[5]
	int m;

	p = (int(*)[5])arr;

	m = *(*(p + 1) + 1);

	//p是一个数组指针 
	//因为 p+1的偏移量为 p+4*5 4*5代表int[5] 20个字节
	//因为 *p = arr = &arr[0]
	//所以 *(p+1) 相当于在原基础上偏移20个字节 也就是&arr[5]
	//所以 m = *( &arr[5] + 1 )

	//因为 int* p1 = &arr[5]
	//所以 &arr[5] + 1 的偏移量为 &arr[5] + 1*4 1*4代表int 4个字节
	//所以 *( &arr[5] + 1 ) = *( &arr[6] ) = 6
	printf("%d", m);
    printf("%d\n%d\n%d\n", p,arr,*p);
}
```

在这里*p才是数组的首地址  p是指向 *p(即数组首地址  即&arr[0]  即arr)



#### 二维指针数组和数组指针

```c
int main() {
	int* arr[10] = { 1,2,3,4,5,6,7,8,9,10 }; //指针数组
	int (*p)[2][2]; //数组指针 里面存放的就是数组的指针(即数组的首地址)
	//它的变量名是p
	//它的数据类型是int (*)[2][2]
	int m;

	p = (int (*)[2][2])arr;

	m = *(*(*(p + 1) + 2));

	//p是一个数组指针 
	//因为 p+1的偏移量为 p+1*4*2*2 4*2*2代表int[2][2] 16个字节
	//因为 *p = arr = &arr[0]
    //所以 *(p+1) 相当于在原基础上偏移16个字节 也就是&arr[4]
	//所以 *(p+1)+2 相当于在原基础上偏移2*4*2个字节 int[x][2] 第一个2代表+2 4代表int 第二个2代表二维数组的第二个2 所以又在原有基础上偏移16个字节 也就是&arr[8]

	printf("%d", m);
    printf("%d\n%d\n%d\n", p,arr,*p);
}
```

#### 三维指针数组和数组指针

```c
int main() {
	int* arr[16] = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16}; //指针数组
	int (*p)[2][2][1]; //数组指针 里面存放的就是数组的指针(即数组的首地址)
	//它的变量名是p
	//它的数据类型是int (*)[2][2]
	int m;

	p = (int (*)[2][2][1])arr;

	m = *(*(*(*(p + 1) + 2)+1)+1);

	//p是一个数组指针 
	//因为 p+1的偏移量为 p+1*4*2*2*1 4*2*2*1代表int[2][2][1] 16个字节
	//因为 *p = arr = &arr[0]
    //所以 *(p+1) 相当于在原基础上偏移16个字节 也就是&arr[4]
	//所以 *(p+1)+2 相当于在原基础上偏移2*4*2*1个字节 int[x][2][1] 第一个2代表+2 4代表int 第二个2代表三维数组的第二个2 最后一个1代表三维数组的最后一个1 所以又在原有基础上偏移16个字节 也就是&arr[8]
    //所以 *(*(p + 1) + 2)+1 相当于在原基础上偏移1*4*1个字节 int[x][x][1] 第一个1代表+1 4代表int 第二个1代表三维数组最后一个1 所以又在原有基础上偏移4个字节 也就是&arr[9]
    //所以 *(*(*(p + 1) + 2)+1) 相当于在原基础上偏移1*4个字节 int[x][x][x] 第一个1代表+1 4代表int 所以又在原有基础上偏移4个字节 也就是&arr[10]

	printf("%d", m);
    printf("%d\n%d\n%d\n", p,arr,*p);
}
```



​	

}