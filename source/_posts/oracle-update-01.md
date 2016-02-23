---
title: 对Oracle数据做批量更新的两种方法
date: 2016-02-22 15:34:11
tags: [Oracle]
categories: [技术]
description: 对Oracle数据做批量更新的两种方法
keywords: Oracle,批量更新
---
同时对多条(w)数据做update操作，我用到了下面的两种方法
<!--more-->

## 前言
其实对表数据做更新一个update操作的事情，为啥还要整出下面的两种方法，之前在工作中测试数据，需要批量对数据做更新，都是在plsql中执行update，有一会遇到数据量稍微大点的，基本就“卡死”在update了。所以对数据量大点的操作基本不推荐直接update，根据测试结果我更偏向第二种方式。

## 使用Bulk Collect
~~~ sql
DECLARE
  TYPE rowid_list IS TABLE OF UROWID INDEX BY BINARY_INTEGER;
  rowid_infos rowid_list;
  i NUMBER;
  CURSOR c_rowids IS SELECT ROWID FROM t_target;
BEGIN
  OPEN c_rowids;
  LOOP
    FETCH c_rowids BULK COLLECT INTO rowid_infos LIMIT 2000;
    FORALL i IN 1..rowid_infos.count
           UPDATE t_target SET DEVICE_MODE = to_char(LENGTH(DEVICE_MODE)+1)
           WHERE ROWID = rowid_infos(i) AND 1 = 1;
    EXIT WHEN ROWid_infos.count < 2000;
  END LOOP;
END;
~~~

## insert append
~~~ sql
--创建临时表(不产生undo)
CREATE TABLE T_TARGET_TEMP NOLOGGING AS SELECT * FROM T_TARGET WHERE 1=0;
--写入数据的同时做出更新操作(以不产生undo的方式写入数据)
INSERT /*+append*/INTO T_TARGET_TEMP 
SELECT 
       UUID,
       ASSET_NO,
       FACTORY,
       to_char(LENGTH(DEVICE_MODE)+1),/** 做出修改 */
       RUN_STATUS
FROM t_target;
--提交
COMMIT;
--删除原表
DROP TABLE T_TARGET PURGE;
--更名临时表为源表名
RENAME T_TARGET_TEMP TO T_TARGET;
--修改表结构为归档模式,参数undo
ALTER TABLE T_TARGET LOGGING;
--创建索引
create index IDX_COMM_ADDRESS on T_TARGET (COMM_ADDRESS)
  tablespace EDMP
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 4M
    minextents 1
    maxextents unlimited
  );
....
~~~