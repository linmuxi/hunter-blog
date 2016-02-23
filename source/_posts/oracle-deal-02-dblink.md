---
title: 解决DBLink带有后缀的问题
date: 2016-02-01 16:57:28
tags: [Oracle]
categories: [技术]
description: 解决DBLink带有后缀的问题
keywords: Oracle,dblink
---
这篇主要分享在默认配置下创建DBLink带有后缀的问题。
<!--more-->
新建DBLink默认情况下DBLink名称是带有后缀的，此后缀来自global_name;
一般生成的DBLink名称是这样的：myDBLink.REGRESS.RDBMS.DEV.US.ORACLE.COM

查看全局名称:`select * from GLOBAL_NAME;//ORCL.REGRESS.RDBMS.DEV.US.ORACLE.COM`

可以通过如下修改，屏蔽生成后缀

使用sys账户执行以下语句：`update global_name set global_name = 'hunter';`//不为空

再次创建DBLink，发现名称不再带有后缀了

<!-- 
//alter database rename global_name to ciscosys; 只是修改了global_name名称，后缀还在

如果使用DBLink进行操作的时候，提示DBLink无效，检查

show parameter global_name;是否为false -->