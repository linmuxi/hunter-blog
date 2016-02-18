---
title: Oracle小数点转字符丢失0的处理方法
date: 2016-02-01 16:42:47
tags: [Oracle]
categories: [技术]
---
Oracle中将含有小数点的数值进行字符串转换，会出现0丢失的情况，大家是怎么处理这种情况的？我是这样做的：
~~~sql
SELECT to_char(0.123,'fm99999999999999990.00') FROM dual;
~~~
