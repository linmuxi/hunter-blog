---
title: 读《深入理解Java虚拟机》-内存分配
date: 2016-03-04 09:38:15
tags: [JVM]
categories: [技术]
description: '本篇参考《深入理解Java虚拟机》第3.6节做的测试记录'
keywords: jvm,内存分配
---
读到第3.6节，跟着文中作者的介绍与描述做了相关内容的测试，特做此记录。
<!--more-->
## **前言**
本篇参考3.6节中的三小节分别来理解和测试相关内容：
* 对象优先在Eden分配
* 大对象直接进入老年代
* 长期存活的对象将进入老年代

## **对象优先在Eden分配**
大多数情况，对象在新生代Eden区中分配内存，当Eden区没有足够的空间进行分配时，虚拟机将发起一次Minor GC。

下面我们通过具体代码来分析对象在新生代中的分配情况：
~~~ java
/**
 * VM Args: 
 * -Xms20M -Xmx20M -Xmn10M  #Java堆大小为20m，不可扩展，其中10m分配给年轻代，剩下10m分配给老年代
 * -XX:SurvivorRatio=8 #设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10，Eden区占8/10
 * -XX:+PrintGCDetails #打印GC日志 
 * -XX:+UseSerialGC #使用Serial+Serial Old的收集器组合进行内存回收
 */
public class TestMemoryAlloc {
	private static final int _1MB = 1024*1024;
	public static void main(String[] args) {
		byte[] allocation1,allocation2,allocation3,allocation4;
		allocation1 = new byte[2*_1MB];
		allocation2 = new byte[2*_1MB];
		allocation3 = new byte[2*_1MB];
		allocation4 = new byte[4*_1MB];//发生第一次Minor GC
	}
}
~~~
根据虚拟机参数初始新生代的内存是这样：
![](http://7xqlat.com1.z0.glb.clouddn.com/jvm_memory_alloc_01.png-hunterblog)

main方法中分配了3个2MB大小和1个4MB大小的对象，当在进行allocation4分配的时候会触发第一次MinorGC操作。

因为allocation4对象需要分配4MB的内存空间，此时Eden已经被前面3个2MB的对象占用了共6MB的大小，Eden还剩余2MB的大小(总Eden空间大小是8192K)，所以在进行allocation4分配的时候由于Eden空间不足会触发第一次MinorGC操作。

MinorGC操作(采用“复制算法”)会将Eden区的3个2MB对象复制到Survivor区域，由于Survivor区域总大小只有1024K，分配不下3个2MB大小的对象，所以只好通过分配担保机制提前将3个2MB的对象转移到年老代中过去。

最后MinorGC操作完成后，Eden分配着4MB的allocation4对象，Survivor区空闲，年老代分配了总共6MB(allocation1,allocation2,allocation3)的对象，下面我们通过GC日志来验证这点。

~~~
[GC[DefNew: 7146K->484K(9216K), 0.0047529 secs] 7146K->6628K(19456K), 0.0047906 secs] [Times: user=0.00 sys=0.00, real=0.01 secs] 
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

`[GC[DefNew: 7146K->484K(9216K), 0.0047529 secs] 7146K->6628K(19456K), 0.0047906 secs]`
可以看到新生代总内存9216K，由GC前占用的7146K回收到了484K，Java堆内存从7146K到6628K几乎没有怎么变化，因为GC回收时四个对象仍然是可用的(存在Eden和老年代中)。

`def new generation   total 9216K, used 4746K`
新生代总内存9216K，已经使用了4746K，被占用的区域就是Eden区

`eden space 8192K,  52% used`
新生代中Eden的内存为8192K，已经被使用了52%，就是被allocation4对象占用着

`to   space 1024K,   0%`
Survivor to区总大小1024k，空闲

`tenured generation   total 10240K, used 6144K`
年老代总内存10240K，已经被allocation1,allocation2,allocation3三个对象占用了6144K。

通过GC日志的分析已经证明了我们上面提到的内存分配规则。


## **大对象直接进入老年代**
大对象是指需要大量连续内存空间的Java对象，写程序的时候要尽量避免大对象，经常出现大对象容易导致内存还有不少空间时候就提前触发垃圾收集以获取足够的内存空间来安放这些大对象。

下面我们还是通过代码来分析下，将上面代码中allocation4对象的大小改为8MB：
~~~ java
/**
 * VM Args: 
 * -Xms20M -Xmx20M -Xmn10M  #Java堆大小为20m，不可扩展，其中10m分配给年轻代，剩下10m分配给老年代
 * -XX:SurvivorRatio=8 #设置为8,则两个Survivor区与一个Eden区的比值为2:8,一个Survivor区占整个年轻代的1/10，Eden区占8/10
 * -XX:+PrintGCDetails #打印GC日志 
 * -XX:+UseSerialGC #使用Serial+Serial Old的收集器组合进行内存回收
 */
public class TestMemoryAlloc {
	private static final int _1MB = 1024*1024;
	public static void main(String[] args) {
		byte[] allocation1,allocation2,allocation3,allocation4;
		allocation1 = new byte[2*_1MB];
		allocation2 = new byte[2*_1MB];
		allocation3 = new byte[2*_1MB];
		allocation4 = new byte[8*_1MB];
	}
}
~~~

我们看下运行之后的GC日志：
~~~
Heap
 def new generation   total 9216K, used 7310K [0x00000000f9a00000, 0x00000000fa400000, 0x00000000fa400000)
  eden space 8192K,  89% used [0x00000000f9a00000, 0x00000000fa123978, 0x00000000fa200000)
  from space 1024K,   0% used [0x00000000fa200000, 0x00000000fa200000, 0x00000000fa300000)
  to   space 1024K,   0% used [0x00000000fa300000, 0x00000000fa300000, 0x00000000fa400000)
 tenured generation   total 10240K, used 8192K [0x00000000fa400000, 0x00000000fae00000, 0x00000000fae00000)
   the space 10240K,  80% used [0x00000000fa400000, 0x00000000fac00010, 0x00000000fac00200, 0x00000000fae00000)
 compacting perm gen  total 21248K, used 2582K [0x00000000fae00000, 0x00000000fc2c0000, 0x0000000100000000)
   the space 21248K,  12% used [0x00000000fae00000, 0x00000000fb085a70, 0x00000000fb085c00, 0x00000000fc2c0000)
No shared spaces configured.
~~~
通过日志发现在分配allocation4对象内存的时候并没有触发GC操作，而是将allocation4对象直接分配到了老年代中。

另外虚拟机提供了-XX:PretenureSizeThreshold参数(默认是0)，令大于这个设置值的对象直接在老年代分配。这样做的目的是避免在Eden区和两个Survior区之间发生大量的内存复制(复制算法收集内存)操作。

**PS:PretenureSizeThreshold参数只对Serial和ParNew两款收集器有效**


## **长期存活的对象将进入老年代**
虚拟机采用分代收集的思想来管理内存，那么内存回收时如何识别哪些对象应该在新生代，哪些对象应该在老年代中。为了做到这点，虚拟机给每个对象定义了一个对象年龄计数器。即对象在Eden中出生并经过第一次Minor GC后仍然存活的且能被Survivor容纳的，将被移动到Survivor空间中，并且对象年龄设为1。对象在Survivor空间每熬过一次Minor GC，年龄就增加1，当它的年龄增加到一定程度（默认是15），就将会被迁移到老年代中。对象迁移老年代的年龄阈值可以通过参数-XX:+MaxTenuringThreshold设置。

下面我们分别通过参数-XX:+MaxTenuringThreshold=1和-XX:+MaxTenuringThreshold=15设置对象的年龄为1和15来验证下：

**-XX:+MaxTenuringThreshold=1**
~~~
/**
	VM Args: -Xms20m -Xmx20m -Xmn10m -XX:+PrintGCDetails -XX:SurvivorRatio=8 -XX:MaxTenuringThreshold=1 -XX:+UseSerialGC
**/
public class TestMaxTenuringThreshold {
	private static final int _1MB = 1024*1024;
	public static void main(String[] args) {
		//什么时候进入老年代取决于XX:MaxTenuringThreshold设置
		byte[]allocation1,allocation2,allocation3;
		allocation1 = new byte[_1MB / 4];
		allocation2 = new byte[4 * _1MB];
		allocation3 = new byte[4 * _1MB];// 第一次触发Minor GC
		allocation3 = null;
		allocation3 = new byte[4 * _1MB];// 第二次触发Minor GC
	}
}
~~~

GC日志：
~~~
[GC[DefNew: 5190K->740K(9216K), 0.0029755 secs] 5190K->4836K(19456K), 0.0030150 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[GC[DefNew: 4836K->0K(9216K), 0.0012083 secs] 8932K->4836K(19456K), 0.0012270 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
Heap
 def new generation   total 9216K, used 4259K [0x00000000f9a00000, 0x00000000fa400000, 0x00000000fa400000)
  eden space 8192K,  52% used [0x00000000f9a00000, 0x00000000f9e28fd0, 0x00000000fa200000)
  from space 1024K,   0% used [0x00000000fa200000, 0x00000000fa200000, 0x00000000fa300000)
  to   space 1024K,   0% used [0x00000000fa300000, 0x00000000fa300000, 0x00000000fa400000)
 tenured generation   total 10240K, used 4836K [0x00000000fa400000, 0x00000000fae00000, 0x00000000fae00000)
   the space 10240K,  47% used [0x00000000fa400000, 0x00000000fa8b9218, 0x00000000fa8b9400, 0x00000000fae00000)
 compacting perm gen  total 21248K, used 2582K [0x00000000fae00000, 0x00000000fc2c0000, 0x0000000100000000)
   the space 21248K,  12% used [0x00000000fae00000, 0x00000000fb085a60, 0x00000000fb085c00, 0x00000000fc2c0000)
No shared spaces configured.
~~~

通过日志可以看到一共触发了2次Minor GC操作，分别代码第11行和13行；下面我们具体分析下：

在进行第一次GC的时候，Eden区域已经被allocation1和allocation2两个对象占用了4352K的内存空间，当再分配allocation3的内存空间的时候（由于Eden总空间只有8M）会触发第一次MinorGC操作，会将allocation1和allocation2两个对象迁移到Survivor区域，然后将allocation3对象分配在Eden区共占用4M内存大小。

`[DefNew: 5190K->740K(9216K), 0.0029755 secs] 5190K->4836K(19456K), 0.0030150 secs]`
可以看到GC发生时，新生代由5190K回收到了740k；Java Heap几乎没有怎么变化；因为此时对象仍然可用。

接下来将allocation3对象失效；然后再分配allocation3对象内存空间，由于Eden空间已经被之前的allocation3老对象占用着，剩余空间不足以分配新的allocation3对象内存，所以会触发第二次Minor GC操作；

由于allocation3老对象已经被设置为失效(内存中的allocation3老对象已经没有引用指向它)，所以会在第二次GC的时候将其在Eden中占用的内存回收掉；
由于MaxTenuringThreshold参数设置为1，那么在Survivor区域的allocation1和allocation2两个对象会被迁移到老年代；
最后新的allocation3对象会被分配到Eden区域；

`[DefNew: 4836K->0K(9216K), 0.0012083 secs] 8932K->4836K(19456K), 0.0012270 secs]`
可以看到新生代由4836K回收到了0k，Java Heap由8932K回收到了4836K，回收掉的就是allocation3老对象占用的内存

最后通过日志可以看到`def new generation   total 9216K, used 4259K`,年轻代占用了4259k的内存（eden区的allocation3新对象），`tenured generation   total 10240K, used 4836K`老年代占用了4836K的内存(allocation1和allocation2两个对象)




<!--
分配担保机制：
当出现大量对象在Minor GC后仍然存活的情况（最极端的情况就是内存回收后新生代中所有对象都存活），就需要老年代进行分配担保，把Survivor无法容纳的对象直接进入老年代。与生活中的贷款担保类似，老年代要进行这样的担保，前提是老年代本身还有容纳这些对象的剩余空间，一共有多少对象会活下来在实际完成内存回收之前是无法明确知道的，所以只好取之前每一次回收晋升到老年代对象容量的平均大小值作为经验值，与老年代的剩余空间进行比较，决定是否进行Full GC来让老年代腾出更多空间。

-->