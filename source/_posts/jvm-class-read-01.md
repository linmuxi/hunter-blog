---
title: JVM字节码之简单解读01
date: 2016-02-26 10:41:39
tags: [Java,JVM]
categories: [技术]
description: '本篇通过一段简单的代码来分析下字节码的执行，认识认识几个常见的字节码指令'
keywords: jvm,iconst,bipush,sipush,ldc
---
本篇通过一段简单的代码来分析下字节码的执行，认识认识几个常见的字节码指令
<!--more-->
## **Java源代码**
~~~ java
public static void main(String[] args) {
	int i = 100;
	int j = 200 + i - 100;
	int z = j++;
	System.out.println(z+i);
}
~~~
上面源码执行之后的结果是300，下面我们就通过分析class来看看结果是怎么得来的。

## **Class字节码**
~~~ java
public static void main(java.lang.String[]);
  Code:
   Stack=3, Locals=4, Args_size=1
   0:   bipush  100
   2:   istore_1
   3:   sipush  200
   6:   iload_1
   7:   iadd
   8:   bipush  100
   10:  isub
   11:  istore_2
   12:  iload_2
   13:  iinc    2, 1
   16:  istore_3
   17:  getstatic       #2; //Field java/lang/System.out:Ljava/io/PrintStream;
   20:  iload_3
   21:  iload_1
   22:  iadd
   23:  invokevirtual   #3; //Method java/io/PrintStream.println:(I)V
   26:  return
}
~~~

下面我们就来分析下字节码的执行：
**Stack=3, Locals=4, Args_size=1**,这段说明栈中元素有3个，局部变量表中有元素4个，参数1个

**0:   bipush  100**      # 将常量100压入栈中
**2:   istore_1**	      # 从栈中取出常量100存储到局部变量表中，下标索引为1	
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_01.png-hunterblog)

**3:   sipush  200**      # 将常量200压入栈中
**6:   iload_1**          # 将下标索引为1的常量从局部变量表中压入栈中。
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_02.png-hunterblog)

**7:   iadd      **       # 从栈中取出两个整型常量相加并将结果存储到栈中
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_03.png-hunterblog)

**8:   bipush  100  **    # 将常量100压入栈中
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_04.png-hunterblog)

**10:  isub      **       # 从栈中取出两个整型常量做相减并将结果存储到栈中
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_05.png-hunterblog)

**11:  istore_2	**      # 从栈中取出常量存储到局部变量表中，下标索引为2
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_06.png-hunterblog)

**12:  iload_2     **     # 将下标索引为2的常量从局部变量表中压入栈中
**13:  iinc    2, 1 **    # 将局部变量表中下标索引为2的变量自增。
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_07.png-hunterblog)

**16:  istore_3   **      # 从栈中取出常量存储到局部变量表中，下标索引为3
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_08.png-hunterblog)

**17:  getstatic **      #2; //Field java/lang/System.out:Ljava/io/PrintStream;
**20:  iload_3  **        # 将下标索引为3的常量从局部变量表中压入栈中
**21:  iload_1  **        # 将下标索引为1的常量从局部变量表中压入栈中
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_09.png-hunterblog)

**22:  iadd    **         # 从栈中取出两个整型常量相加并将结果存储到栈中
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_read_class_stack_10.png-hunterblog)

**23:  invokevirtual **  #3; //Method java/io/PrintStream.println:(I)V
**26:  return**

所以最后执行结果是300

大家可能注意到了，在字节码第三行**Stack=3, Locals=4, Args_size=1**，显示的是栈中有3个元素，为什么我们这里只有两个？其实栈中还有一个this元素，由于this不在本篇介绍范围之类，所以例图就省略了，特此说明下。大家可能疑惑这个this是什么时候入栈的，通过下面的代码相信大家就明白了
~~~ java
public test.Test();
  Code:
   Stack=1, Locals=1, Args_size=1
   0:   aload_0
   1:   invokespecial   #1; //Method java/lang/Object."<init>":()V
   4:   return
  LineNumberTable:
   line 3: 0
~~~

PS：由于认识较肤浅，如文中有不适当或有误的地方还望大家不吝指出。

## **参考**
[Java字节码指令列表](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings)

<!--
查看字节码
javap -c Test
javap -v Test
javap -v Test > E:/Test.dc
-->