---
title: ORA-01555：快照过旧，回滚段号10(名称为“_SYSSMU10$”)过小
date: 2016-02-22 17:01:33
tags: [Oracle]
categories: [技术]
---
前篇介绍了利用闪回查询可以将误删的数据恢复，但该操作并不能100%进行数据恢复。本篇就该问题进行分享下。
<!--more-->
## 前言
该异常的原因是UNDO表空间(System表空间或UNDOTBS1表空间)的数据已经被覆盖或是保留时间过期。因为闪回查询是基于UNDO数据来执行的。

## 分析
有两种方式可以解决该问题
1、增大UNDO表空间大小
2、或者修改undo_retention的时间

通过show parameter undo 查询UNDO的信息;
~~~
sql> show parameter undo
undo_management string AUTO
undo_retention integer 86400  (默认为分钟)
undo_tablespace string UNDOTBS1
~~~

## 说明
undo表空间用于存放undo数据，当执行DML操作（insert、update、delete）时，oracle会将这些操作的旧数据写入到undo段。

ora-01555快照过旧就是因为undo空间不够大，其中一部分undo数据被覆盖了，用户无法获得修改前的数据或是保留时间过期。

undo数据分为三种：
活动的undo：未提交事务的undo数据，这些undo数据永远不能覆盖，用于回滚rollback事务。
过期的undo：已提交事务的undo数据，这些undo数据可以覆盖。
未过期的undo：事务已提交，但事务提交前，有些查询正在进行，它要读取的是提交前的数据，这部分数据就是未过期数据。如果这部分undo数据被覆盖了，就会发生ora-01555错误。

