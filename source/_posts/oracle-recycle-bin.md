---
title: Oracle回收站(Recycle Bin)的使用
date: 2016-02-22 16:30:58
tags: [Oracle]
categories: [技术]
---
我们Drop掉的表还能被找回来吗？答案是必须的。就该问题本篇分享下Oracle中Recycle Bin的使用。
<!--more-->
## 前言
回收站(Recycle Bin）从原理上来说就是一个数据字典表，放置用户删除（drop）掉的数据库对象信息。用户进行删除操作的对象并没有被数据库删除，仍然会占用空间。除非是由于用户手工进行Purge或者因为存储空间不够而被数据库清掉。

除非拥有sysdba权限，每个用户只能看到属于自己的对象。所以，对于用户来说，好像每个人都拥有自己的回收站。即使用户有删除其它schema对象的权限，也只能在recyclebin中看到属于自己的对象

## 操作
启动和关闭
`SELECT Value FROM V$parameter WHERE Name = 'recyclebin'; `
或
`show parameter recyclebin;`
如果返回值为“on”表明回收站是启动的，“off”表明是关闭的。

当然，你可以启动或者关闭回收站里的每个会话（session）和系统（system），代码如下：
~~~
ALTER SYSTEM SET recyclebin = ON; 

ALTER SESSION SET recyclebin = ON; 

ALTER SYSTEM SET recyclebin = OFF; 

ALTER SESSION SET recyclebin = OFF;
~~~
获取回收站里的内容
~~~
SELECT * FROM RECYCLEBIN; 

SELECT * FROM USER_RECYCLEBIN; 
 
SELECT * FROM DBA_RECYCLEBIN;
~~~

还原被Drop的表
`flashback table <droped_table_name> to before drop [rename <new_table_name>]`

利用flashback将删除的表闪回，不过这个flashback并不是100%将删除的表还原，具体下篇再介绍。

清空回收站
a.清空一个特定的表：purge table <table_name>
b.清空一个特定的索引：purge index <index_name>
c.清空与该表空间有关联的对象：purge tablespace <tablespace_name>
d.清空一个特定用户的表空间对象：purge tablespace <tablespace_name> user <user_name>
e.清空回收站：purge recyclebin
f.当一个表被删除（drop）时就直接从回收站中清空:drop table <table_name> purge;


注意：
以下几种drop不会将相关对象放进RecycleBin：
drop tablespace：会将RecycleBin中所有属于该tablespace的对象清除
drop user：会将RecycleBin中所有属于该用户的对象清除
drop cluster：会将RecycleBin中所有属于该cluster的成员对象清除
drop type：会将RecycleBin中所有依赖该type的对象清除

** PS：如果大家使用PlSql developer工具，该工具提供了RecycleBin窗口可视化操作。 **