---
title: 测试JVM运行时常量池溢出
date: 2016-03-02 10:26:28
tags: [JVM]
categories: [技术]
description: ''
keywords: java,jvm
---
运行时常量池属于方法区(俗称永久代)，如果要使运行时常量池溢出其实就是使方法区溢出，可以通过调整方法区的大小并配合String.intern方法来实现。
<!--more-->

## **Java代码**
~~~ java
/**
 * VM Args: -XX:PermSize=10m -XX:MaxPermSize=10m
 */
public class RuntimeConstantPoolOOM {
	public static void main(String[] args) {
		List<String> list = new ArrayList<String>();
		int i =1;
		while(true){
			list.add(String.valueOf(i++).intern());
		}
	}
}
~~~

上面代码设置方法区的初始内存和最大内存为10m，并通过intern方法不停往方法区写入数据。

最后运行的结果如自己所预料的那样，出现方法区溢出
![方法区溢出](http://7xqlat.com1.z0.glb.clouddn.com/oom_permgen_space_01.png)

不过，大家请仔细看，上面是基于jdk1.6运行的结果，我们切换到jdk1.7运行再看看，发现不会出现方法区溢出，这是为什么呢？

查看jdk1.7发布[notes](http://www.oracle.com/technetwork/java/javase/jdk7-relnotes-418459.html)发现：
>Area: HotSpot
Synopsis: In JDK 7, interned strings are no longer allocated in the permanent generation of the Java heap, but are instead allocated in the main part of the Java heap (known as the young and old generations), along with the other objects created by the application. This change will result in more data residing in the main Java heap, and less data in the permanent generation, and thus may require heap sizes to be adjusted. Most applications will see only relatively small differences in heap usage due to this change, but larger applications that load many classes or make heavy use of the String.intern() method will see more significant differences.
RFE: 6962931

在JDK7中，常量池已经从方法区中迁移到了java堆中。

为了验证这个问题，我们调整VM的堆内存大小`-Xms10m -Xmx10m`再运行，结果如下
![java堆溢出](http://7xqlat.com1.z0.glb.clouddn.com/oom_jav_heap_space_01.png)
