---
title: Oracle中的pfile和spfile文件介绍
date: 2016-02-01 17:05:06
tags: [Oracle]
categories: [技术]
---
这篇主要分享Oracle中pfile和spfile文件，以及一些基本的使用方法
<!--more-->
1、pfile和spfile都是用于存储Oracle初始化参数信息的文件。

2、pfile是9i以前采用的方式；spfile是9i以后出来的，oracle推荐使用spfile。

3、pfile基于文本，修改通过手动编辑文件，需要重启数据库；spfile基于二进制文件，修改通过alter system、alter session

4、默认情况下oracle使用pfile启动数据库。

5、spfile的创建是依赖pfile文件的
语法：`create spfile='E:/xx' from pfile='pfilename'`
例如：`create spfile from pfile;`
默认spfile创建到系统默认目录$ORACLE_HOME\database，新建spfile需要下次重启数据库生效

6、spfile的修改：
ALTER SYSTEM增加了一个新选项：SCOPE。
SCOPE参数有三个可选值：
MEMORY ,SPFILE , BOTH
MEMORY:只改变当前实例运行
SPFILE:只改变SPFILE的设置
BOTH:改变实例及SPFILE

7、查看Oracle是否使用spfile
1）执行查询`SELECT name,value FROM v$parameter WHERE name='spfile';` 如何返回空值，那么表示没有使用spfile
2）执行查询`SHOW PARAMETER spfile;`返回空值，那么表示没有使用spfile
3）执行查询`select * from v$spparameter`,isspecified字段全为false，表示没有使用spfile