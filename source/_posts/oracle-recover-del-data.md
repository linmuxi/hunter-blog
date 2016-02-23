---
title: Oracle恢复被误删的数据
date: 2016-02-22 16:46:28
tags: [Oracle]
categories: [技术]
description: Oracle恢复被误删的数据
keywords: Oracle,恢复数据
---
这篇分享下如何恢复被Delete掉的数据。
<!--more-->

下面一共介绍三种恢复数据的方法：

## 利用闪回

~~~sql
// 开启行移动功能
ALTER TABLE my_test ENABLE ROW MOVEMENT;
// 闪回表到指定时间点(需要开启行移动功能)
FLASHBACK TABLE my_test TO TIMESTAMP to_timestamp('2013-10-17 17:05:00','yyyy-mm-dd hh24:mi:ss')
~~~

## 利用Oracle的快照进行某个时间点的数据查询

~~~sql
// 查询在当前时间之前的8分钟时候的数据
SELECT * FROM my_test AS OF TIMESTAMP (SYSDATE - INTERVAL '8' MINUTE)
// 查询指定时间点的数据
SELECT * FROM my_test AS OF TIMESTAMP to_timestamp('2013-10-17 17:05:00','yyyy-mm-dd hh24:mi:ss');
~~~

## 基于SCN
~~~sql
// 查询指定时间点的SCN
SELECT timestamp_to_scn(to_timestamp('2013-10-17 17:05:00','yyyy-mm-dd hh24:mi:ss')) FROM dual;
// 查询指定SCN点的数据
select * FROM my_test AS OF SCN 10305758694685
~~~

** PS:如果是在被删除的第一时间进行数据恢复，则可能性很大，否则可能性会大大减小。**
因为回滚段可能会被后来的数据覆盖掉(进行快照查询会出现：ORA-01555:快照过旧)。当然，也可以通过增大回滚表空间(UNDOTBS1)的大小来提高回滚数据存放的时间

 

<!--
//指定删除时间、对象名称，返回存储过程或函数的执行sql
~~~ sql
CREATE OR REPLACE FUNCTION RECOVE_PROCE(DEL_TIME IN VARCHAR2,PROC_NAME IN VARCHAR2) RETURN VARCHAR2 IS
/**
	*
	* function Name :存储过程或function 删除后恢复方法
	* del_time 对象被删除时间
	* proc_Name :被删除对象名称
	* return :返回重建对象的语句
	*
*/
OBJ_NUM NUMBER;
STR_PROC VARCHAR2(2000);
STR_END VARCHAR2(2000) := '';
STR_SQL VARCHAR2(2000);
BEGIN
	SELECT OBJ# INTO OBJ_NUM
		FROM OBJ$ AS OF TIMESTAMP TO_TIMESTAMP(DEL_TIME, 'YYYY-MM-DD HH24:MI:SS')
	WHERE NAME = UPPER(PROC_NAME);

	FOR I IN (
		SELECT ROWID RID, SOURCE FROM SOURCE$ AS OF TIMESTAMP TO_TIMESTAMP(DEL_TIME, 'YYYY-MM-DD HH24:MI:SS')
		WHERE OBJ# = OBJ_NUM ORDER BY LINE
			) LOOP
	
		SELECT SOURCE INTO STR_PROC 
			FROM SOURCE$ AS OF TIMESTAMP TO_TIMESTAMP(DEL_TIME, 'YYYY-MM-DD HH24:MI:SS')
		WHERE OBJ# = OBJ_NUM AND ROWID = I.RID ORDER BY LINE;
		
		STR_END := STR_END || STR_PROC;
	
	END LOOP;

	STR_SQL := 'CREATE OR REPLACE ' || STR_END;
	
	RETURN STR_SQL;
	
	EXCEPTION
		WHEN OTHERS THEN
			DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);

	RETURN NULL;

END RECOVE_PROCE;
~~~
-->