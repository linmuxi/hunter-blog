---
title: UML类图符号变量介绍
date: 2016-02-01 10:52:53
tags: [UML,PowerDesigner]
categories: [技术]
description: UML类图符号变量介绍
keywords: uml,powerdesigner
---
这篇主要分享UML类图符号变量的介绍，画图工具使用的是PowerDeisgner15
<!--more-->

1.类（Class）： 使用三层矩形框表示。 
  第一层显示类的名称，如果是抽象类，则就用斜体显示。
  第二层是字段和属性。
  第三层是类的方法。注意前面的符号，+表示public，-表示private，#表示protected。

2.接口：使用两层矩形框表示，与类图的区别主要是顶端有interface显示。
  第一层是接口名称。
  第二层是接口方法。

3.继承类（extends）：用空心三角形+实线来表示。

4.实现接口（implements）：用空心三角形+虚线来表示

5.关联（Association）：用实线箭头来表示，例如：燕子与气候

6.聚合（Aggregation）：用空心的菱形+实线箭头来表示。
  表示一种拥有关系，体现的是A对象可以包含B对象，但B对象不是A对象的一部分，例如：公司和员工

7.组合（Composition）：用实心的菱形+实线箭头来表示。
  部分和整体的关系，并且生命周期是相同的。例如：人与手。

8.依赖（Dependency）：用虚线箭头来表示，例如：动物与氧气。

9.基数：连线两端的数字表明这一端的类可以有几个实例，比如：一个鸟应该有两只翅膀。如果一个类可能有无数个实例，则就用n来表示。关联、聚合、组合

![UML类图](http://7xqlat.com1.z0.glb.clouddn.com/uml_oom.jpg)