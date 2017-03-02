---
title: GC之“Stop The World”
date: 2017-03-01 11:05:38
categories: [技术]
keywords: stop the world
---
“Stop The World”是什么，和GC有什么关系？在谈这个之前，先简要叙述以下两点：
1、对象内存分代
2、JVM垃圾收集器

大家都知道，JVM内存堆可以简单分为年轻代、老年代、持久代；其中年轻代又分为三部分：1个Eden区和2个Survivor区域（From和To）

JVM提供了多种垃圾收集器，例如：serial、parnew、parallel scavenge、serial old、parallelold、cms、G1；每种垃圾收集器采用的收集算法又不一样。

关于垃圾收集算法有标记-清除、复制算法、标记-整理、分代收集

回到正题，“Stop The World”是什么？因为JVM内存堆是分代的，不同的分代采用的垃圾收集器是不一样的；
例如在JDK1.3.1之前Serial收集器是年轻代垃圾收集的唯一选择；
Serial收集器，是单线程收集器，在进行垃圾收集时，必须暂停其他所有工作线程，直到它收集结束。这个就是Serial收集器的工作特性，我们也把这个特性称为“Stop The World”；
自然我们会想到，“Stop The World”的存在，假如GC耗时较长，那么我们的系统会处于一种假死状态。
当然随着JVM虚拟机的发展，“Stop The World”得到的很大的优化和缓解，具体大家可以了解CMS、G1垃圾收集器工作原理，大家也可以参考下我之前的读书笔记[“读《深入理解Java虚拟机》-垃圾收集器”](http://www.linmuxi.com/2016/06/23/jvm-note-gc/)
