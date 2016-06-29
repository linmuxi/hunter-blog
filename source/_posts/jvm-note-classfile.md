---
title: 读《深入理解Java虚拟机》-类文件结构
date: 2016-06-27 16:05:03
tags: [JVM]
categories: [技术]
description: ''
keywords: jvm,class
---
读书笔记
<!--more-->

## JVM语言无关性
![JVM-语言无关性](http://7xqlat.com1.z0.glb.clouddn.com/JVM-语言无关性.png)

Java虚拟机作为一个通用的、机器无关的执行平台，任何其他语言的实现者都可以将Java虚拟机作为语言的产品交付媒介，虚拟机只识别Class文件，并不关心Class的来源是何种语言



## class类文件的结构
![Class文件格式](http://7xqlat.com1.z0.glb.clouddn.com/Class文件格式.png)

* Class文件是一组以8位字节为基础单位的二进制流，各数据项目**严格按照顺序**紧凑排列在Class文件中，中间没有任何分隔符
* Class文件格式采用类似C语言结构体的伪结构来存储数据，这种伪结构只有两种**数据类型**：**无符号数和表**
* 无符号数
	+ 属于基本的数据类型
	+ **u1、u2、u4、u8**来分别代表**1、2、4、8个字节**的无符号数
	+ 可以用来描述**数字、索引引用、数量值或者按照UTF-8编码构成的字符串值**
* 表
	+ 是由**多个无符号数**或者其他表作为数据项构成的**复合数据**类型
	+ 以“_info”结尾
	+ 整个class文件本质上就是一张表


下面来看下class文件格式中各个数据项的具体含义：

* ### 魔数与Class文件的版本
**magic**：魔数（Magic Number），占用4个字节，作用是确定这个文件是否为一个能被虚拟机接受的class文件；值为：0xCAFEBABE
**minor_version**：次版本号，占用2个字节
**major_version**：主版本号，占用2个字节;Java的版本号是从45开始的，JDK1.1之后的每个JDK大版本发布，主版本号向上加1（JDK1.0-1.1使用了45.0-45.3的版本号）,例如JDK版本为1.7，可生成的Class文件主版本号最大值为51.0


* ### 常量池

占用Class文件空间最大的数据项目之一

**constant_pool_count**：常量池容量计数值，**从1开始**；例如：常量池容量十六进制数为0x0016，即十进制为22，就表示常量池中有21项常量；Class文件结构中只有常量池的容量计数是从1开始，其他的集合类型，例如接口索引集合、字段表集合、方法表集合等的容量计数都是从0开始的。

**constant_pool**：主要存放两大类常量：字面量(Literal)和符号引用(Symbolic References)
字面量：文本字符串、声明为final的常量值等
符号引用：
+ 类和接口的全限定名
+ 字段的名称和描述符
+ 方法的名称和描述符

常量池中每一项常量都是一个表，一共有**14**种：
![常量池的项目类型](http://7xqlat.com1.z0.glb.clouddn.com/常量池的项目类型.png)

这14种表都有一个共同的特点，就是表开始第一位是一个u1类型的**标志位**(tag)，代表当前这个常量属于哪种常量类型
	
![常量池中的14中常量项的结构总表](http://7xqlat.com1.z0.glb.clouddn.com/常量池中的14中常量项的结构总表.png)
	
	
* ### 访问标志
access_flags：用于识别一些类或接口层次的访问信息，包括：这个Class是类还是接口；是否定义为public类型；是否定义为abstract类型；如果是类的话，是否被声明为final等

![访问标志](http://7xqlat.com1.z0.glb.clouddn.com/访问标志.png)

access_flags中一共有16个标志位可以使用，当前只定义了其中8个，没有使用到的标志位要求一律为0



* ### 类索引、父类索引与接口索引集合
Class文件中通过类索引（this_class）和父类索引（super_class）和接口索引集合（interfaces）这三项数据来确定这个类的继承关系。

下图显示类索引（this_class）查找全限定名的过程：
![类索引查找全限定名的过程](http://7xqlat.com1.z0.glb.clouddn.com/类索引查找全限定名的过程.png)



* ### 字段表集合
用于描述接口或者类中声明的变量，字段包括类级变量和实例级变量，不包括方法内部声明的局部变量

![字段表结构](http://7xqlat.com1.z0.glb.clouddn.com/字段表结构.png)

字段修饰符放在access_flags项目中，与类中的access_flags项目类似，都是一个u2的数据类型，含义如下：

![字段访问标志](http://7xqlat.com1.z0.glb.clouddn.com/字段访问标志.png)


紧跟access_flags标志的是两项索引值：name_index和descriptor_index，都是对常量池的引用，分别代表字段的简单名称及字段和方法的描述符

![描述符标识字符含义](http://7xqlat.com1.z0.glb.clouddn.com/描述符标识字符含义.png)

对于数组类型，每一维度将使用一个前置的“[”字符来描述，例如定义一个“java.lang.String[][]”类型的二维数组，将被记录为：”[[Ljava/lang/String;“，一个整型数组“int[]”将被记录为“[I”

用描述符来描述方法时，按照先参数列表，后返回值的顺序描述，参数列表按照参数的严格顺序放在一组小括号“()”之内。例如方法 void inc()的描述符为“()V”,方法java.lang.String.toString()的描述符为“()Ljava/lang/String;”,方法int indexOf(char[]source,int sourceOffset,int sourceCount,char[]target,int targetOffset,int targetCount,int fromIndex)的描述符为“([CII[CIII)I”

字段表集合不会列出从超类或父接口中继承而来的字段





* ### 方法表集合
Class文件存储格式对方法的描述与对字段的描述几乎采用了完全一致的方式

![方法表结构](http://7xqlat.com1.z0.glb.clouddn.com/方法表结构.png)

与字段相比，除去了volatile关键字和transient关键字对应的标志，增加了synchronized、native、strictfp和abstract关键字对应的标志

![方法访问标志](http://7xqlat.com1.z0.glb.clouddn.com/方法访问标志.png)

方法中的Java代码，经过编译器编译成字节码指令后，存放在方法属性表集合中一个名为“Code”的属性里面了



* ### 属性表集合
为了能正确解析Class文件，在《Java虚拟机规范（Java SE 7）》版中，预定义了21项属性。

![虚拟机规范预定义的属性](http://7xqlat.com1.z0.glb.clouddn.com/虚拟机规范预定义属性.png)

每个属性的名称都需从常量池中引用一个CONSTANT_Utf8_info类型的常量来表示，而属性值的结构则是完全自定义的，只需要通过一个u4的长度属性去说明属性值所占用的位数即可。

一个符合规则的属性表应该满足如下定义的结构：

![属性表结构](http://7xqlat.com1.z0.glb.clouddn.com/属性表结构.png)

**Code属性**
Java程序方法体中的代码经过Javac编译器处理后，最终变成字节码指令存储在Code属性中。

![Code属性表结构](http://7xqlat.com1.z0.glb.clouddn.com/Code属性表的结构.png)

attribute_name_index：指向CONSTANT_Utf8_info型常量的索引，常量固定值为**Code**
attribute_length：属性值的长度，由于属性名称索引和属性长度一共为6字节，所以属性值的长度固定为整个属性表长度减去6个字节
max_stack：操作数栈深度的最大值，在方法执行的任意时刻，操作数栈都不会超过这个深度，虚拟机运行的时候需要根据这个值来分配栈帧中的操作栈深度
max_locals：局部变量所需的存储空间，单位是**Slot**，Slot是虚拟机为局部变量分配内存所使用的**最小单位**，对于长度不超过32位的数据类型，每个局部变量占用1个Slot，而double和long这两种64位的数据类型需要2个Slot来存放；局部变量表中的Slot是**可以重用**的，Javac编译器会根据变量的作用域来分配Slot给各个变量使用，然后计算出max_locals的大小
code：存储Java源程序编译后生成的字节码指令
code_length：字节码长度


**LineNumberTable属性**
用于描述Java源码行号与字节码行号之间的对应关系；可以在javac中分别使用**-g:none或-g:lines**来选择取消或要求生成这项信息，如果不生成，对程序运行产生的最主要影响就是抛出异常时，堆栈中将不会显示出错的**行号**，并且在调试程序的时候，也无法按照源码行来设置**断点**


**LocalVariableTable属性**
用于描述栈帧中局部变量表中的变量与Java源码中定义的变量之间的关系；可以在javac中分别使用**-g:none或-g:vars**来选择取消或生成该信息，如果没有生成，最大的影响就是当其他人引用这个方法时，所有**参数名都将丢失**，IDE将会使用诸如**arg0、arg1**的占位符代替原有的参数名


**SourceFile属性**
记录生成这个Class文件的源码文件名称；可以分别使用javac的-g:none或-g:source来关闭或生成，如果不生成这项属性，当抛出异常时，堆栈中将不会显示出错代码所属的**文件名**


**ConstantValue属性**
作用是通知虚拟机自动为静态变量赋值。只有被static关键字修饰的变量（类变量）才可以使用这项属性。

对于非static类型的变量（**实例变量**）的赋值，虚拟机是在**实例构造器<init>**方法中进行
对于类变量，在类构造器<clinit>方法中或使用ConstantValue属性。目前Sun Javac编译器的选择是：如果同时使用final和static来修饰一个变量（常量），并且这个变量的数据类型是基本类型或者java.lang.String的话，就生成ConstantValue属性来进行初始化，如果没有被final修饰或者并非基本类型及字符串，则将会选择在<clinit>方法中进行初始化


## 字节码指令简介

这里不详细记录了，具体字节码介绍可以[参考WIKI](https://en.wikipedia.org/wiki/Java_bytecode_instruction_listings)


