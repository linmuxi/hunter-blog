---
title: jvm-classload
date: 2017-02-08 10:15:42
tags: [Java,JVM]
categories: [技术]
description: ''
keywords: jvm,classload
---
java语言里面，类型的加载、连接和初始化过程都是在程序运行期间完成的
例如：在面向接口的应用程序中，可以在程序运行时再指定其实际的实现类；

类加载生命周期：加载、验证、准备、解析、初始化、使用、卸载
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm-classload.png-hunterblog)


### 类加载的时机
jvm规范并没有强制约束什么时候开始类的加载，但是严格规定了具备以下5种情况必须立即对类进行“初始化”，而加载、验证、准备、解析自然在初始化之前完成
1、遇到new、getstatic、putstatic、invokestatic这4个字节码指令时
2、使用java.lang.reflect包的方法对类进行反射调用的时候
3、当初始化一个类的时候，如果父类没有初始化，先完成其父类的初始化
4、初始化main方法所属的主类
5、使用jdk7的动态语言时，如果MethodHandle实例的最后解析结果是REF_getStatic、REF_putStatic、REF_invokeStatic的方法句柄，且这个方法句柄对应的类没有初始化，则先完成其初始化

加载
将class文件加载进虚拟机，加载完成之后，class文件数据存储在方法区之中，然后在内存（方法区）实例化一个java.lang.Class类的对象作为程序访问方法区的这些类型数据的外部接口

验证
分别完成文件格式验证、元数据验证、字节码验证、符号引用验证
其中符号引用验证的目的是确保解析过程能正常执行，如果符号引用验证没有通过，那么将会抛出我们常见的异常：java.lang.IllegalAccessError、java.lang.NoSuchFieldError、java.lang.NoSuchMethodError

准备
为类变量分配内存并设置类变量初始化值
例如：程序中定义“public static int value = 123;”，准备阶段完成之后value的值为0；将value赋值为123是在类的初始化阶段完成的
如果程序中定义“public static final int value = 2”

解析
将常量池内的符号引用替换成直接引用的过程

初始化
初始化阶段是执行类构造器的过程，开始执行类中定义的java代码；如给静态变量赋值，执行静态块语句


