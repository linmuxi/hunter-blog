---
title: JVM字节码之整型入栈指令(iconst、bipush、sipush、ldc)
date: 2016-02-25 14:33:19
tags: [Java,JVM]
categories: [技术]
description: '本篇主要介绍下int类型变量入栈指令iconst、bipush、sipush、ldc'
keywords: jvm,iconst,bipush,sipush,ldc
---
本篇主要分享下在JVM中int类型变量采用何种指令入栈的，根据int值范围JVM入栈字节码指令就分为4类，下面分别介绍下这四类指令。
<!--more-->
## **前言**
当int取值**0~5**采用iconst指令，取值**-128~127**采用bipush指令，取值**-32768~32767**采用sipush指令，取值**-2147483648~2147483647**采用 ldc 指令。

## **iconst**
当int取值**0~5**时，JVM采用**iconst**指令将变量压入栈中。
定义**Test.java**文件
~~~ java
public static void main(String[] args) {
	int i = 5;
}
~~~

查看**class**文件
~~~ java
public static void main(java.lang.String[]);
  Code:
   0:   iconst_5
   1:   istore_1
   2:   return
}
~~~
可以看到上面代码第三行是采用**iconst**指令将变量5压入栈中。

### **bipush**
当int取值**-128~127**时，JVM采用**bipush**指令将变量压入栈中。
定义**Test.java**文件
~~~ java
public static void main(String[] args) {
	int i = 127;
}
~~~

查看**class**文件
~~~ java
public static void main(java.lang.String[]);
  Code:
   0:   bipush  127
   2:   istore_1
   3:   return
}
~~~
可以看到上面代码第三行是采用**bipush**指令将变量127压入栈中。

### **sipush**
当int取值**-32768~32767**时，JVM采用**sipush**指令将变量压入栈中。
定义**Test.java**文件
~~~ java
public static void main(String[] args) {
	int i = 32767;
}
~~~

查看**class**文件
~~~ java
public static void main(java.lang.String[]);
  Code:
   0:   sipush  32767
   3:   istore_1
   4:   return
}
~~~
可以看到上面代码第三行是采用**sipush**指令将变量32767压入栈中。

### **ldc**
当int取值**-2147483648~2147483647**时，JVM采用**ldc**指令将变量压入栈中。
定义**Test.java**文件
~~~ java
public static void main(String[] args) {
	int i = Integer.MAX_VALUE;
}
~~~

查看**class**文件
~~~ java
public static void main(java.lang.String[]);
  Code:
   0:   ldc     #2; //int 2147483647
   2:   istore_1
   3:   return
}
~~~
可以看到上面代码第三行是采用**ldc**指令将2147483647变量压入栈中，需要注意的是ldc指令是从常量池中获取值的，也就是说在这段范围（**-2147483648~2147483647**）内的int值是存储在常量池中的。

如理解有误还望明白人不吝指出。


## **参考**
[JVM规范](http://docs.oracle.com/javase/specs/jvms/se7/html/jvms-4.html)