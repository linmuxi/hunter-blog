---
title: Oracle之登录安全
date: 2016-05-31 15:01:05
tags: [Oracle]
categories: [技术]
description: Oracle登录安全
---
在安装完oracle数据库后，打开终端输入：sqlplus / as sysdba; 可以在不输入密码的情况下登录到sys用户。这种登录方式是采用操作系统认证；

这样要是谁混进了我们的数据库服务器都可以这种方式登录。这种默认配置使得数据库存在安全隐患；

可以通过修改如下配置使其必须通过密码验证方式登录
1、找到文件：%ORACLE_HOME%\NETWORK\ADMIN\sqlnet.ora
2、修改文件内容：SQLNET.AUTHENTICATION_SERVICES= (none)

修改完成后要重启实例；
shutdown immediate;// shutdown abort;
startup;

<!-- 这样就无法通过 sqlplus / as sysdba 登录了。系统会提示：ORA-01031: insufficient privileges -->
<!-- SQLNET.AUTHENTICATION_SERVICES = none|all|ntf(windows)
none：表示关闭操作系统认证，只能采用密码认证
all：用于linux或unix平台，关闭本机密码文件认证，采用操作系统认证，但远程可以使用密码文件认证。
nts：用于window平台，采用操作系统认证 -->
