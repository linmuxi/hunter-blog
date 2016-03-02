---
title: 关于String.intern方法在JDK1.6、1.7中的表现
date: 2016-03-02 09:24:44
tags: [Java]
categories: [技术]
description: '关于String.intern方法在JDK1.6、1.7中的表现'
keywords: java,string,intern
---
在读《深入理解Java虚拟机》第2.4.3节的时候，作者讨论了String.intern方法在jdk6、7中的不同表现，当时看到觉得挺有意思，自己也下来实验了一把，确实如同作者提到的那样，在JDK1.6、1.7中intern方法执行的结果不一样。
<!--more-->
## **实例代码**
~~~ java
public class RuntimeConstantPoolOOM {
	public static void main(String[] args) {
		String str1 = new StringBuffer("计算机").append("软件").toString();
		System.out.println(str1.intern() == str1);
	}
}
~~~

以上代码在JDK1.6中运行结果是false，在JDK1.7中运行结果是true。作者的解释是在JDK1.6中intern方法会把首次遇到的字符串实例复制到永久代中，返回的也是永久代中的这个字符串实例的引用，而JDK1.7中intern方法实现不会再复制实例，只是在常量池中记录首次出现的实例引用。

我们再看下官网api关于intern方法的介绍
![JDK1.6](http://7xqlat.com1.z0.glb.clouddn.com/jdk1.6_string_intern.png);
![JDK1.7](http://7xqlat.com1.z0.glb.clouddn.com/jdk1.7_string_intern.png);

两个版本关于intern的描述居然都是一样的：
>当intern方法被执行后，如果常量池中存在该字符串(通过equals判断)，那么就将该字符串从常量池中返回，否则，将该字符串对象添加到常量池中并将指向该对象的引用返回。

明明intern方法在这两个版本中的表现不一样，文档这里为什么没有一点点体现呢？

## **总结**
JDK1.6
调用intern方法如果常量池中包含该字符串则返回该字符串引用地址，如果不包括则将该字符串添加到常量池中再返回新的引用地址。所以当调用str1.intern方法时，"计算机软件"在常量池中是不存在的，所以会将该字符串添加到常量池中并返回新的引用地址，所以结果为false。

JDK1.7
调用intern方法只是在常量池中记录该字符串的实例引用地址，如果该字符串在常量池中存在，则返回该实例引用地址，不存在则记录实例引用后返回地址。所以当调用str1.intern方法时，“计算机软件”在常量池中不存在，所以常量池中会记录该字符串实例引用并返回引用地址，所以返回的引用地址和str1是同一个实例引用，最后结果为true。

## **说明**
最后需要说明一点的是，常量池中会有一些已经存在的字符串常量，看下面的例子：
~~~ java
public class RuntimeConstantPoolOOM {
	public static void main(String[] args) {
		String str1 = new StringBuffer("ma").append("in").toString();
		System.out.println(str1.intern() == str1);
	}
}
~~~
上面代码在JDK7中执行的结果为false，因为在调用intern方法的时候，常量池中已经存在main，所以返回的是main的引用地址，和str1是不同的实例对象，所以结果为false。