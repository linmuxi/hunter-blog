---
title: 使用SQLLDR将CSV数据导入到Oracle数据库
date: 2016-02-01 11:06:36
tags: [Oracle,SQLLDR]
categories: [技术]
---
这篇分享下使用SQLLDR工具将CSV表中的数据导入到Oracle数据库中。
<!--more-->
SQLLDR是Oracle下提供的一款数据导入工具，使用简单方便，推荐有需要的使用.

命令如下：`sqlldr 用户名/密码@SID control=SQLLDR语法文件(例如：control.ctl)`

control.ctl文件内容：
~~~
LOAD DATA 
INFILE 'D:\data\inputData.csv'       --要导入到数据库中的数据文件 
INFILE 'D:\data\inputData2.csv'      --可以导入多个文件 
BADFILE 'D:\data\error\bad.bad'      --导入失败后要写入的文件 
DISCARDFILE 'D:\data\dsc\datadsc.dsc'    
DISCARDMAX 1000 
append                              --表示向表中追加数据(其他选项请参考下面变量说明) 
INTO TABLE top_excel_import_data    --插入的数据库表名 
FIELDS TERMINATED BY ','            --以","号分隔 
TRAILING NULLCOLS                   --允许插入空值 
(  
   id ,                           --数据库字段名 
   name , 
   age
  ) 
~~~

变量说明：
append：向表中追加数据 
insert：向表中插入值，但要求表开始时为空 
replace：delete表中的数据，然后插入新值 
truncate：trunctate表，然后插入新值