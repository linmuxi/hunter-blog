---
title: 实例化一个对象，虚拟机为我们做了哪些事情？
date: 2016-07-06 08:51:39
tags: [JVM]
categories: [技术]
description: ''
keywords: jvm,Java内存区域
---

这篇主要分享下，在实例化一个对象(new Object())的时候，虚拟机默默为我们做了哪些工作？
<!--more-->

没对象怎么办？“new”一个嘛。在java语义层面上，产生一个供我们使用的对象很容易。但虚拟机在后台却默默的做了很多事情。下面我们从**Person p = new Person()**来看下虚拟机都做了哪些事情:

供分析的源码：
~~~java
public class Person{
	public static void main(String[]args){
		Person p = new Person();
	}
}
~~~

供分析的字节码：
~~~
Classfile /E:/Person.class
  Last modified 2016-7-6; size 274 bytes
  MD5 checksum 11f32c6820fba54a4d5cacf83c6ea779
  Compiled from "Person.java"
public class Person
  SourceFile: "Person.java"
  minor version: 0
  major version: 51
  flags: ACC_PUBLIC, ACC_SUPER
Constant pool:
   #1 = Methodref          #4.#13         //  java/lang/Object."<init>":()V
   #2 = Class              #14            //  Person
   #3 = Methodref          #2.#13         //  Person."<init>":()V
   #4 = Class              #15            //  java/lang/Object
   #5 = Utf8               <init>
   #6 = Utf8               ()V
   #7 = Utf8               Code
   #8 = Utf8               LineNumberTable
   #9 = Utf8               main
  #10 = Utf8               ([Ljava/lang/String;)V
  #11 = Utf8               SourceFile
  #12 = Utf8               Person.java
  #13 = NameAndType        #5:#6          //  "<init>":()V
  #14 = Utf8               Person
  #15 = Utf8               java/lang/Object
{
  public Person();
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 1: 0

  public static void main(java.lang.String[]);
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=2, locals=2, args_size=1
         0: new           #2                  // class Person
         3: dup
         4: invokespecial #3                  // Method "<init>":()V
         7: astore_1
         8: return
      LineNumberTable:
        line 3: 0
        line 4: 8
}
~~~

过程：

1、当Java虚拟机遇到new指令的时候，会先检查在常量池中是否存在对应类的符号引用。
　Ａ：通过字节码41行可以看到new指令带了一个参数#2，#2通过看字节码12行是一个Class符号引用(Person类)

2、如果存在该类的符号引用，则检查该类是否已经加载、解析和初始化过，没有则进行相应的类加载过程
3、类加载过程结束后，Java虚拟机会在Java堆上为新对象"Person"分配内存(对象需要的内存在类加载的过程中就确定了)
4、修改内存指针，让局部变量表中的“p”引用指向java堆中的Person实例
