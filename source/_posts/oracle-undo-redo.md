---
title: Undo与Redo的介绍
date: 2016-02-22 17:06:42
tags: [Oracle]
categories: [技术]
---
本篇主要分享下Oracle中Undo与Redo的介绍
<!--more-->

## undo
undo: 回滚段，分为系统存储段、非系统存储段,基于表空间数据存储,存储旧数据
根据undo_management参数来判断是基于UNDOTBS1表空间还是system表空间存储回滚段(只要数据未提交、回滚段未写满或者回滚段未超时的情况下，旧数据都能被回滚回来。)

## redo
redo：重做日志，分为在线、离线，基于日志文件存储，存储新旧数据
如果开启数据库归档，则归档日志文件为离线重做日志文件

## 演示
执行场景：id = 100,age = 100;

用户session1执行修改操作：`update scott.emp set age = 10 where id = 100;`

此时还未commit，实际已经做了如下操作：
1、在SGA区(数据缓冲区)产生回滚段记录UNDO块包含旧数据
2、在SGA区(数据缓冲区)将id=100对应的数据给修改为10
3、在SGA区中重做日志缓冲区中生成了重做记录(条目)包含修改前后的数据
4、得到所需的所有锁

PS：如果此时用户session2来查询id=100的数据，结果是age=100，这个结果是从回滚段记录undo中获取的

当commit的时候，做的操作如下：
1、为事务产生一个SCN(system change number)
2、LGWR把重做日志缓冲区条目写到磁盘(重做日志文件),并在联机重做日志中记录SCN.
3、释放锁
4、对缓冲区中的数据块进行块清理（刷新数据文件）

<!-- show parameter undo;
如果undo_management为auto，则undo块数据存储在UNDOTBS1表空间，如果为manual(手动模式),则undo块数据存储在System表空间中 -->