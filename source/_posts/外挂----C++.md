# 多态

```c
#include <iostream> 
using namespace std;
 
class Shape {
   protected:
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      int area()
      {
         cout << "Parent class area :" <<endl;
         return 0;
      }
};
class Rectangle: public Shape{
   public:
      Rectangle( int a=0, int b=0):Shape(a, b) { }
      int area ()
      { 
         cout << "Rectangle class area :" <<endl;
         return (width * height); 
      }
};
class Triangle: public Shape{
   public:
      Triangle( int a=0, int b=0):Shape(a, b) { }
      int area ()
      { 
         cout << "Triangle class area :" <<endl;
         return (width * height / 2); 
      }
};
// 程序的主函数
int main( )
{
   Shape *shape;
   Rectangle rec(10,7);
   Triangle  tri(10,5);
 
   // 存储矩形的地址
   shape = &rec;
   // 调用矩形的求面积函数 area
   shape->area();
 
   // 存储三角形的地址
   shape = &tri;
   // 调用三角形的求面积函数 area
   shape->area();
   
   return 0;
}
```

当上面的代码被编译和执行时，它会产生下列结果：

```
Parent class area
Parent class area
```



导致错误输出的原因是，调用函数 area() 被编译器设置为基类中的版本，这就是所谓的**静态多态**，或**静态链接** - 函数调用在程序执行前就准备好了。有时候这也被称为**早绑定**，因为 area() 函数在程序编译期间就已经设置好了。

但现在，让我们对程序稍作修改，在 Shape 类中，area() 的声明前放置关键字 **virtual**，如下所示：

```c
class Shape {
   protected:
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      virtual int area()
      {
         cout << "Parent class area :" <<endl;
         return 0;
      }
};
```

修改后，当编译和执行前面的实例代码时，它会产生以下结果：

```
Rectangle class area
Triangle class area
```

此时，编译器看的是指针的内容，而不是它的类型。因此，由于 tri 和 rec 类的对象的地址存储在 *shape 中，所以会调用各自的 area() 函数。

正如您所看到的，每个子类都有一个函数 area() 的独立实现。这就是**多态**的一般使用方式。有了多态，您可以有多个不同的类，都带有同一个名称但具有不同实现的函数，函数的参数甚至可以是相同的。

## 虚函数

**虚函数** 是在基类中使用关键字 **virtual** 声明的函数。在派生类中重新定义基类中定义的虚函数时，会告诉编译器不要静态链接到该函数。

我们想要的是在程序中任意点可以根据所调用的对象类型来选择调用的函数，这种操作被称为**动态链接**，或**后期绑定**。

## 纯虚函数(类似java中的接口)

您可能想要在基类中定义虚函数，以便在派生类中重新定义该函数更好地适用于对象，但是您在基类中又不能对虚函数给出有意义的实现，这个时候就会用到纯虚函数。

我们可以把基类中的虚函数 area() 改写如下：

```c
class Shape {
   protected:
      int width, height;
   public:
      Shape( int a=0, int b=0)
      {
         width = a;
         height = b;
      }
      // pure virtual function
      virtual int area() = 0;
};
```

= 0 告诉编译器，函数没有主体，上面的虚函数是**纯虚函数**。



# C++结构体对齐

```c++
#pragma pack(8)
typedef struct MyStruct1{
	char xue;
	//virtual void test1(){
	//
	//};
	//virtual void test2() {

	//};
}tt1;
#pragma pack()

int main()
{
	tt1 ss1;
	printf("%d",sizeof(ss1));
	getchar();
	return 0;
}
```

结果为1

```c++
#pragma pack(8)
typedef struct MyStruct1{
	char xue;
	virtual void test1(){
	
	};
	//virtual void test2() {

	//};
}tt1;
#pragma pack()

int main()
{
	tt1 ss1;
	printf("%d",sizeof(ss1));
	getchar();
	return 0;
}
```

结果为8

```c++
#pragma pack(8)
typedef struct MyStruct1{
	char xue;
	virtual void test1(){
	
	};
	virtual void test2() {

	};
}tt1;
#pragma pack()

int main()
{
	tt1 ss1;
	printf("%d",sizeof(ss1));
	getchar();
	return 0;
}
```

结果还是8

```c++
#pragma pack(8)
typedef struct MyStruct1{
	/*char xue;*/
	virtual void test1(){
	
	};
	//virtual void test2() {

	//};
}tt1;
#pragma pack()

int main()
{
	tt1 ss1;
	printf("%d",sizeof(ss1));
	getchar();
	return 0;
}
```

结果为4

```c++
#pragma pack(8)
typedef struct MyStruct1{
	/*char xue;*/
	virtual void test1(){
	
	};
	virtual void test2() {

	};
}tt1;
#pragma pack()

int main()
{
	tt1 ss1;
	printf("%d",sizeof(ss1));
	getchar();
	return 0;
}
```

结果还是4

# C++类对齐

```c++
class Shape {
protected:
	int a;
public:
	//Shape()
	//{

	//}
	//int area()
	//{
	//	cout << "Parent class area :" << endl;
	//	return 0;
	//}
};

// 程序的主函数
int main()
{
	Shape shape;
	cout << sizeof(shape);

	return 0;
}
```

结果为4

```c++
class Shape {
protected:
	int a;
public:
	Shape()
	{

	}
	int area()
	{
		cout << "Parent class area :" << endl;
		return 0;
	}
};

// 程序的主函数
int main()
{
	Shape shape;
	cout << sizeof(shape);

	return 0;
}
```

结果为4

```c++
class Shape {
protected:
	int a;
public:
	Shape()
	{

	}

	int area()
	{
		cout << "Parent class area :" << endl;
		return 0;
	}

	virtual int aa() {
		return 0;
	}
};

// 程序的主函数
int main()
{
	Shape shape;
	cout << sizeof(shape);

	return 0;
}
```

结果为8

```c++
using namespace std;

class Shape {
protected:
	/*int a;*/
public:
	//Shape()
	//{

	//}

	//int area()
	//{
	//	cout << "Parent class area :" << endl;
	//	return 0;
	//}

	virtual int aa() {
		return 0;
	}
};

// 程序的主函数
int main()
{
	Shape shape;
	cout << sizeof(shape);

	return 0;
}
```

结果为4

```c++
using namespace std;

class Shape {
protected:
	/*int a;*/
public:
	//Shape()
	//{

	//}

	//int area()
	//{
	//	cout << "Parent class area :" << endl;
	//	return 0;
	//}
	virtual int bb() {
		return 0;
	}
	virtual int aa() {
		return 0;
	}
};

// 程序的主函数
int main()
{
	Shape shape;
	cout << sizeof(shape);

	return 0;
}
```

结果为4

<font color = "red">说明这个类的首地址也就是this指向的是一个虚函数的列表,虚表是可以被继承的(以上测试的结果全部为x86情况下的测试)</font>

<font color = "red">当类中有虚函数存在的时候,该类会在首地址多一个指针指向虚函数列表</font>

# 引用 &

1.引用类型是C++里面的类型

2.引用类型只能被赋值一次,不能重复赋值

3.引用只是一个变量的别名(张三的奶名是二狗)

4.引用类似于一个"指针",但是这个"指针"由编译器维护,不占用空间大小

5.领过的 使用引用会增加代码的安全性,饮用可以向指针一样去修改,访问对象的内容.

```c++
using namespace std;

void test1(int* a) {
	//所以这里能够修改实参的值
	*a = 200;
	//但是这里改变不了main函数中的变量的地址
	a = (int*)888;
	printf("方法中的地址=%d\n", a);
}
int main()
{
	int a = 100;
	printf("%d\n", &a);
	//这里是将a的地址拷贝了一份 传递给了这个test1函数
	test1(&a);
	cout << a << endl;
}
```

```c++
using namespace std;

void test1(int& a) {
	//引用取值不需要加*号
	a = 200;

	//引用一旦被指定将无法再修改指向
	//&a = 0x666;
	
}
int main()
{
	int a = 100;
	printf("%d\n", &a);
	//这里是将a的地址拷贝了一份 传递给了这个test1函数
	test1(a);
	cout << a << endl;
}
```

# 模板

就是java里面的泛型

# 运算符重载

```c++
#include <iostream>
using namespace std;
 
class Box
{
   public:
 
      double getVolume(void)
      {
         return length * breadth * height;
      }
      void setLength( double len )
      {
          length = len;
      }
 
      void setBreadth( double bre )
      {
          breadth = bre;
      }
 
      void setHeight( double hei )
      {
          height = hei;
      }
      // 重载 + 运算符，用于把两个 Box 对象相加
      Box operator+(const Box& b)
      {
         Box box;
         box.length = this->length + b.length;
         box.breadth = this->breadth + b.breadth;
         box.height = this->height + b.height;
         return box;
      }
   private:
      double length;      // 长度
      double breadth;     // 宽度
      double height;      // 高度
};
// 程序的主函数
int main( )
{
   Box Box1;                // 声明 Box1，类型为 Box
   Box Box2;                // 声明 Box2，类型为 Box
   Box Box3;                // 声明 Box3，类型为 Box
   double volume = 0.0;     // 把体积存储在该变量中
 
   // Box1 详述
   Box1.setLength(6.0); 
   Box1.setBreadth(7.0); 
   Box1.setHeight(5.0);
 
   // Box2 详述
   Box2.setLength(12.0); 
   Box2.setBreadth(13.0); 
   Box2.setHeight(10.0);
 
   // Box1 的体积
   volume = Box1.getVolume();
   cout << "Volume of Box1 : " << volume <<endl;
 
   // Box2 的体积
   volume = Box2.getVolume();
   cout << "Volume of Box2 : " << volume <<endl;
 
   // 把两个对象相加，得到 Box3
   Box3 = Box1 + Box2;
 
   // Box3 的体积
   volume = Box3.getVolume();
   cout << "Volume of Box3 : " << volume <<endl;
 
   return 0;
}
```

