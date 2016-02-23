---
title: '问题：ORA-00257: 归档程序错误。在释放之前仅限于内部连接'
date: 2016-02-22 15:57:14
tags: [Oracle]
categories: [技术]
description: '问题：ORA-00257: 归档程序错误。在释放之前仅限于内部连接'
keywords: Oracle,归档错误
---
本篇分享下Oracle异常问题的处理方法
<!--more-->
## 前言
前段时间发现测试环境Oracle数据库连接不上了，到后台看日志输出：'问题：ORA-00257: 归档程序错误。在释放之前仅限于内部连接'，经分析是归档日志文件占满FLASH_RECOVERY_AREA的空间，下面就该问题分析下具体的解决方法。

## 解决方法
### 1、查询FLASH_RECOVERY_AREA空间大小
~~~ sql
//查看恢复区各文件占用百分比情况
select * from v$flash_recovery_area_usage;
//查看恢复区总大小
show parameter db_recovery_file_dest;
~~~

### 2、扩大FLASH_RECOVERY_AREA的空间或删除归档日志
A.扩大FLASH_RECOVERY_AREA的空间
执行`alter system set db_recovery_file_dest_size=扩容大小 scope=both; `

B.删除归档日志



* 先手动删除归档日志物理文件(PS:没有完全删除，控制文件中还有记录，所以实际占用的容量并没有调整，此时应该是无效的归档日志文件)
* 利用RMAN删除无效归档日志文件
	* rman target/@edmp （使用sysdba登录，rman target sys/pwd@orcl）
	* crosscheck archivelog all;（检查控制文件和实际物理文件的差别）
	  ps：出现验证失败的，表示该归档日志文件已经被物理删除
	* list expired archivelog all;（查看所有过期归档日志文件列表,PS:要使用crosscheck archivelog all进行同步之后才能正确显示过期归档日志列表）
	* delete expired archivelog all;（删除所有过期归档文件）
	* list archivelog all;（查看所有归档日志文件列表）
	到这里，归档文件就已经被正确删除了。
* 删除归档日志（做好备份）
	* DELETE ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-7';（删除7天前的备份）
	* DELETE ARCHIVELOG FROM TIME 'SYSDATE-7';（删除从7天前到现在的全部日志）