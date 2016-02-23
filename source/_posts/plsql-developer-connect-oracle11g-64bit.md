---
title: 使用PLSQL Developer连接64位Oracle11g数据库
date: 2016-02-01 16:45:38
tags: [Oracle]
categories: [技术]
description: 使用PLSQL Developer连接64位Oracle11g数据库
keywords: Oracle,plsql developer
---
这篇主要分享如何使用PLSQL Developer连接64位Oracle数据库。
<!--more-->
第一步：安装Oracle 11g 64位

第二步：安装32位的Oracle客户端（ [instantclient-basic-win32-11.2.0.1.0](http://www.oracle.com/technetwork/cn/topics/winsoft-095945-zhs.html)）
<font color="red">注意：Oracle客户端一定得是32位的，不要下错了版本，Oracle官网有下载</font>

第三步：将其解压至Oracle安装目录的Product下：`D:\Oracle\app\hunter\product\instantclient_11_2`

第四步：拷贝数据库安装根目录下的NETWORK目录到Oracle客户端目录的instantclient_11_2目录下面。
NETWORK目录的绝对路径：D:\Oracle\app\hunter\product\11.2.0\dbhome_1\NETWORK
instantclient_11_2目录的绝对路径：D:\Oracle\app\hunter\product\instantclient_11_2

第五步：安装PL/SQL Developer
安装 PL/SQL Developer，在perference->Connection里面设置OCI Library和Oracle_Home，例如本机设置为：
Oracle Home ：D:\Oracle\app\hunter\product\instantclient_11_2
OCI Library ：D:\Oracle\app\hunter\product\instantclient_11_2\oci.dll

第六步：设置环境变量(修改PATH和TNS_ADMIN环境变量)
对于NLS_LANG环境变量, 最好设置成和数据库端一致, 首先从数据库端查询字符集信息:
~~~dos
SQL> select userenv('language') nls_lang from dual;
NLS_LANG
----------------------------------------------------
SIMPLIFIED CHINESE_CHINA.ZHS16GBK
~~~

右击"我的电脑" - "属性" - "高级" - "环境变量" - "系统环境变量":
1>.选择"Path" - 点击"编辑", 把 "D:\Oracle\app\hunter\product\instantclient_11_2;" 加入;
2>.点击"新建", 变量名设置为"TNS_ADMIN", 变量值设置为"D:\Oracle\app\hunter\product\instantclient_11_2;", 点击"确定";
3>.点击"新建", 变量名设置为"NLS_LANG", 变量值设置为"SIMPLIFIED CHINESE_CHINA.ZHS16GBK", 点击"确定";

最后，启动 PL/SQL Developer ，运行无问题。