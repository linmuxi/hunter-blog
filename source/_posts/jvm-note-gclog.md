---
title: 读《深入理解Java虚拟机》-理解GC日志
date: 2016-03-03 16:54:57
tags: [JVM]
categories: [技术]
description: '本篇主要介绍下int类型数值入栈指令iconst、bipush、sipush、ldc'
keywords: jvm,gc
---
读到第3.5.8章，按照文章描述跟着作者的步伐一起测试了下，特做下日志分析记录。
<!--more-->

## **前言**
本篇以**Serial+Serial Old**组合收集器日志为例来分析下GC日志(-XX:+UseSerialGC)

## **GC日志**
~~~
[GC[DefNew: 7146K->484K(9216K), 0.0034871 secs] 7146K->6628K(19456K), 0.0035216 secs] [Times: user=0.00 sys=0.00, 
real=0.00 secs] 
Heap
 def new generation   total 9216K, used 4746K [0x00000000f9a00000, 0x00000000fa400000, 0x00000000fa400000)
  eden space 8192K,  52% used [0x00000000f9a00000, 0x00000000f9e297b0, 0x00000000fa200000)
  from space 1024K,  47% used [0x00000000fa300000, 0x00000000fa3791a8, 0x00000000fa400000)
  to   space 1024K,   0% used [0x00000000fa200000, 0x00000000fa200000, 0x00000000fa300000)
 tenured generation   total 10240K, used 6144K [0x00000000fa400000, 0x00000000fae00000, 0x00000000fae00000)
   the space 10240K,  60% used [0x00000000fa400000, 0x00000000faa00030, 0x00000000faa00200, 0x00000000fae00000)
 compacting perm gen  total 21248K, used 2582K [0x00000000fae00000, 0x00000000fc2c0000, 0x0000000100000000)
   the space 21248K,  12% used [0x00000000fae00000, 0x00000000fb085a70, 0x00000000fb085c00, 0x00000000fc2c0000)
No shared spaces configured.
~~~

## **GC日志说明**
1、“[GC”和“[Full GC”说明了这次垃圾收集的停顿类型，如果有“Full”则说明这次GC是发生了Stop-The-World的(就是在垃圾收集的时候停止了所有用户进程)。如果是调用System.gc()所触发的收集，那么就显示“[Full GC(System)”

2、“[DefNew”、“[Tenured”、“[Perm”表示GC发生的区域，这里显示的区域名称和使用的GC收集器是有关系的。
例如：
Serial收集器：新生代名为“Default New Generation”，所以显示“[DefNew”
ParNew收集器，新生代名为“Parallel New Generation”，所以显示“[ParNew”
Parallel Scavenge收集器，新生代名为“PSYoungGen”
老年代和永久代同理，名称也是由收集器决定的。

3、“7146K->484K(9216K)”表示“GC前该内存区域(新生代)已使用容量->GC后该内存区域已使用容量(该内存区域总容量)”

4、“0.0034871 secs”表示该内存区域GC所占用的时间，单位是秒

5、“7146K->6628K(19456K)”表示“GC前Java堆已使用容量->GC后Java堆已使用容量(Java堆总容量)”

6、“Times: user=0.00 sys=0.00, real=0.00 secs”分别代表用户态消耗的CPU时间、内核态消耗的CPU时间和操作从开始到结束所经过的墙钟时间。（CPU时间与墙钟时间的区别是，墙钟时间包括各种非运算的等待耗时，例如等待磁盘I/O、等待线程阻塞，而CPU时间不包括这些耗时，但当系统有多CPU或者多核的话，多线程操作会叠加这些CPU时间，所以当看到user或sys时间超过real时间是完全正常的）

## **其他收集器日志**
使用**ParNew+Serial Old**收集器组合日志(-XX:+UseParNewGC):
~~~
[GC[ParNew: 7146K->508K(9216K), 0.0023849 secs] 7146K->6652K(19456K), 0.0024203 secs] [Times: user=0.00 sys=0.00, 

real=0.02 secs] 
Heap
 par new generation   total 9216K, used 4770K [0x00000000f9a00000, 0x00000000fa400000, 0x00000000fa400000)
  eden space 8192K,  52% used [0x00000000f9a00000, 0x00000000f9e297b0, 0x00000000fa200000)
  from space 1024K,  49% used [0x00000000fa300000, 0x00000000fa37f1b8, 0x00000000fa400000)
  to   space 1024K,   0% used [0x00000000fa200000, 0x00000000fa200000, 0x00000000fa300000)
 tenured generation   total 10240K, used 6144K [0x00000000fa400000, 0x00000000fae00000, 0x00000000fae00000)
   the space 10240K,  60% used [0x00000000fa400000, 0x00000000faa00030, 0x00000000faa00200, 0x00000000fae00000)
 compacting perm gen  total 21248K, used 2582K [0x00000000fae00000, 0x00000000fc2c0000, 0x0000000100000000)
   the space 21248K,  12% used [0x00000000fae00000, 0x00000000fb085a70, 0x00000000fb085c00, 0x00000000fc2c0000)
No shared spaces configured.
~~~

使用**Parallel Scavenge+Parallel Old**收集器组合(-XX:+UseParallelOldGC):
~~~
Heap
 PSYoungGen      total 9216K, used 7310K [0x00000000ff600000, 0x0000000100000000, 0x0000000100000000)
  eden space 8192K, 89% used [0x00000000ff600000,0x00000000ffd23978,0x00000000ffe00000)
  from space 1024K, 0% used [0x00000000fff00000,0x00000000fff00000,0x0000000100000000)
  to   space 1024K, 0% used [0x00000000ffe00000,0x00000000ffe00000,0x00000000fff00000)
 ParOldGen       total 10240K, used 4096K [0x00000000fec00000, 0x00000000ff600000, 0x00000000ff600000)
  object space 10240K, 40% used [0x00000000fec00000,0x00000000ff000010,0x00000000ff600000)
 PSPermGen       total 21504K, used 2582K [0x00000000f9a00000, 0x00000000faf00000, 0x00000000fec00000)
  object space 21504K, 12% used [0x00000000f9a00000,0x00000000f9c85a70,0x00000000faf00000)
~~~