---
title: 更改ORACLE归档路径及归档模式
date: 2016-02-22 16:19:25
tags: [Oracle]
categories: [技术]
description: 更改ORACLE归档路径及归档模式
keywords: Oracle,归档
---
本篇分享下如何更改ORACLE归档路径及归档模式
<!--more-->

## 前言
在ORACLE10g和11g版本，ORACLE默认的日志归档路径为闪回恢复区 （$ORACLE_BASE/flash_recovery_area）。对于这个路径，ORACLE有一个限制，就是默认只有2G的空间，而且不只是归 档日志的默认路径，也是备份文件和闪回日志的默认地址，这样的话归档日志锁使用的空间就达不到2G，在没有设置好这个路径大小的情况下，很多系统都遇到过 归档日志满而无法归档导致数据库夯住的问题。

## 操作
可以使用下面的SQL语句去查看归档信息。
~~~bash
SQL> archive log list
数据库日志模式             非存档模式
自动存档             禁用
存档终点            USE_DB_RECOVERY_FILE_DEST
最早的联机日志序列     321
当前日志序列           326。
~~~

上面的存档终点USE_DB_RECOVERY_FILE_DEST默认就是闪回恢复区（$ORACLE_BASE/flash_recovery_area），可以通过下面的SQL查看闪回恢复区的信息。
~~~cmd
SQL> show parameter db_recover
NAME                        TYPE         VALUE
--------------------------  ----------- ----------------------------
db_recovery_file_dest       string      D:\oracle\flash_recovery_area
db_recovery_file_dest_size  big integer   2G
~~~

通过上面的SQL结果可以看到，闪回恢复区为D:\oracle\flash_recovery_area，大小为2G，也可以通过查询v$recovery_file_dest视图查看闪回恢复的限制信息。
~~~cmd
SQL> select name,SPACE_LIMIT,SPACE_USED from v$recovery_file_dest;
NAME                           SPACE_LIMIT SPACE_USED
------------------------------ ----------- ----------
D:\oracle\flash_recovery_area   2147483648   21225472
~~~

默认情况下，归档日志会存放到闪回恢复区（D:\oracle\flash_recovery_area）内，如果闪回恢复区已经使用到2G，归档日志就有可能无法继续归档，数据库夯住，通常的解决方法是增大闪回恢复区，可以用以下SQL实现。
~~~sql
SQL> alter system set db_recovery_file_dest_size=3G;
系统已更改。
~~~

即使用这种方法解决的当前燃眉之急，但是如果备份策略不是很完善，数据库非常繁忙的情况下，还有可能遇到这种情况，通常需要修改归档日志的路径，将归档日志放到其他不受限制的路径下来解决这个问题，可通过下面的SQL来修改归档日志的存放路径。
~~~sql
SQL> alter system set log_archive_dest_1='location=D:\arch';
系统已更改。  
~~~

然后将数据库启动到MOUNT状态，将数据库修改为归档模式后建数据库启动到OPEN状态。

~~~cmd
SQL> shutdown immediate
数据库已经关闭。
已经卸载数据库。
ORACLE 例程已经关闭。
SQL> startup mount
ORACLE 例程已经启动。
数据库装载完毕。
SQL> alter database archivelog;
数据库已更改。
SQL> alter database open;
数据库已更改。
~~~

再次查看数据库的归档情况。

~~~cmd
SQL> archive log list
数据库日志模式            存档模式
自动存档             启用
存档终点            D:\arch
最早的联机日志序列     321
下一个存档日志序列   326
当前日志序列           326
~~~

可以通过切换日志，查看归档路径下是否有归档日志产生来验证归档路径设置是否正确，可以通过下面的命令切换日志。

~~~sql
SQL> alter system switch logfile;
系统已更改。  
~~~

查看归档路径（D:\arch）下是否有归档路径产生。

~~~cmd
D:\arch>dir/b
ARC0000000326_0764368160.0001
~~~

可以看到在D:\arch路径下已经产生了归档日志，归档日志的名字受log_archive_format参数限制，可以通过下面的命令查看。

~~~cmd
SQL> show parameter log_archive_format
NAME                   TYPE         VALUE
---------------------- ------------ ------------
log_archive_format     string       ARC%S_%R.%T
~~~

上面产生的归档文件名字为ARC0000000326_0764368160.0001，%S也就是0000000326是日志切换号，也就是上文archive log list中的当前日志序列，%R是场景号，%T是线程号，可以理解成是节点号，如果不是RAC环境，%T都是1，还可以在log_archive_format参数值中加上%D，%D是16进制标识的DBID，如下演示：

~~~cmd
SQL> alter system set log_archive_format='ARC%S_%R.%T_%D.log' scope=spfile;
系统已更改。  
SQL> shutdown immediate
数据库已经关闭。
已经卸载数据库。
ORACLE 例程已经关闭。
SQL> startup
ORACLE 例程已经启动。
数据库装载完毕。
数据库已经打开。
SQL> alter system switch logfile;
系统已更改。
~~~

查看归档日志的名字，5AA14A62就是16进制的DBID。

~~~cmd
D:\arch>dir/b
ARC0000000326_0764368160.0001
ARC0000000327_0764368160.0001_5AA14A62.LOG
~~~