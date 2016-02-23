---
title: Oracle单向高级流复制的使用
date: 2016-02-22 17:15:10
tags: [Oracle]
categories: [技术]
---
本篇分享下Oracle中流复制的使用。
<!--more-->

## 场景
需求：需要将A地采集到的数据发送到B地数据库中。
环境：网络环境是A到B是单项通讯

暂且称A为主库，B为从库

## A
一、在主库配置到从库的tns连接
~ tnsping boyuupq_10_19

二、修改数据库域名(注意修改完后要重启数据库)
查看数据库域名
`select * from global_name;` //boyuupq.REGRESS.RDBMS.DEV.US.ORACLE.COM

修改数据库域名
`alter database rename global_name to boyuupq_10_18;`

执行完这步之后，查询发现数据库域名还是上面的结果，新建dblink名称后面也会自动拼接上这后缀。
这时可以执行：`update global_name set global_name = boyuupq_10_18;`

三、新建流管理员strmadmin(使用sysdba帐号)
~~~ sql
SQL>conn /as sysdba
SQL> create user strmadmin identified by strmadmin default tablespace users temporary tablespace temp;
SQL> execute dbms_defer_sys.register_propagator('strmadmin');
SQL> grant execute any procedure to strmadmin;
SQL> execute dbms_repcat_admin.grant_admin_any_repgroup('strmadmin');
SQL> execute dbms_repcat_admin.grant_admin_any_schema(username => 'strmadmin');
SQL> grant comment any table to strmadmin;
SQL> grant lock any table to strmadmin;
SQL> grant select any dictionary to strmadmin;
~~~

四、用流管理员strmadmin新增到从库的dblink
~~~ sql
SQL> conn strmadmin/strmadmin
SQL> create database link "boyuupq_10_19" connect to strmadmin identified by strmadmin using 'boyuupq_10_19';
~~~

五、查询dblink
~~~ sql
SQL> select owner,db_link,host from all_db_links;
OWNER         DB_LINK                                 HOST   
STRMADMIN  boyuupq_10_19    boyuupq_10_19
~~~

## B
一、修改数据库域名(注意修改完后要重启数据库)
查看数据库域名
`select * from global_name;` //boyuupq.REGRESS.RDBMS.DEV.US.ORACLE.COM

修改数据库域名
`alter database rename global_name to boyuupq_10_19;`

执行完这步之后，查询发现数据库域名还是上面的结果，新建dblink名称后面也会自动拼接上这后缀。
这时可以执行：`update global_name set global_name = boyuupq_10_19;`

二、新建流管理员strmadmin(使用sysdba帐号)
~~~ sql
SQL>conn /as sysdba
SQL> create user strmadmin identified by strmadmin default tablespace users temporary tablespace temp;
SQL> execute dbms_defer_sys.register_propagator('strmadmin');
SQL> grant execute any procedure to strmadmin;
SQL> execute dbms_repcat_admin.grant_admin_any_repgroup('strmadmin');
SQL> execute dbms_repcat_admin.grant_admin_any_schema(username => 'strmadmin');
SQL> grant comment any table to strmadmin;
SQL> grant lock any table to strmadmin;
SQL> grant select any dictionary to strmadmin;
~~~

> 上面的操作主要是配置数据库名称、流管理员、dblink，下面将要进行流队列、捕获进程、传播进程、应用进程的配置

### 创建流队列
主库：
~~~ sql
connect strmadmin/strmadmin;
begin 
	dbms_streams_adm.set_up_queue( 
		queue_table => 'boyuupq_10_18_queue_table', 
		queue_name => 'boyuupq_10_18_queue'); 
end; 
/ 
~~~

从库：
~~~ sql
connect strmadmin/strmadmin;
begin 
	dbms_streams_adm.set_up_queue( 
		queue_table => 'boyuupq_10_19_queue_table', 
		queue_name => 'boyuupq_10_19_queue'); 
end; 
/ 
~~~

### 创建捕获进程(主库)
~~~ sql
connect strmadmin/strmadmin;
begin 
	dbms_streams_adm.add_schema_rules( 
		schema_name => 'sa', 
		streams_type => 'capture', 
		streams_name => 'capture_boyuupq_10_18', 
		queue_name => 'strmadmin.boyuupq_10_18_queue', 
		include_dml => true, 
		include_ddl => true, 
		include_tagged_lcr => false, 
		source_database => null, 
		inclusion_rule => true); 
end; 
/ 
~~~

### 创建传播进程(主库)
~~~ sql
connect strmadmin/strmadmin;
begin 
	dbms_streams_adm.add_schema_propagation_rules( 
		schema_name => 'sa', 
		streams_name => 'boyuupq18_to_boyuupq19', 
		source_queue_name => 'strmadmin.boyuupq_10_18_queue', 
		destination_queue_name => 'strmadmin.boyuupq_10_19_queue@book', 
		include_dml => true, 
		include_ddl => true, 
		include_tagged_lcr => false, 
		source_database => 'boyuupq_10_18', //主库数据库名称，注意这里的配置是否正确
		inclusion_rule => true); 
end; 
/ 
~~~

### 修改propagation休眠时间为0，表示实时传播LCR
~~~ sql
begin 
	dbms_aqadm.alter_propagation_schedule( 
		queue_name => 'boyuupq_10_18_queue', 
		destination => 'boyuupq_10_19', //到从库的dblink名称
		latency => 0); 
end; 
/ 
~~~


### 创建应用进程(从库)
~~~ sql
connect strmadmin/strmadmin;
begin 
	dbms_streams_adm.add_schema_rules( 
		schema_name => 'sa', 
		streams_type => 'apply', 
		streams_name => 'apply_boyuupq_10_19', 
		queue_name => 'strmadmin.boyuupq_10_19_queue', 
		include_dml => true, 
		include_ddl => true, 
		include_tagged_lcr => false, 
		source_database => 'boyuupq_10_18', //主库数据库名称
		inclusion_rule => true); 
end; 
/ 
~~~

### 启动应用进程(从库,先应用、后捕获，传播自动启动)
~~~ sql
connect strmadmin/strmadmin;
#启动Apply进程 
begin 
	dbms_apply_adm.start_apply( 
		apply_name => 'apply_boyuupq_10_19'); 
end; 
/ 
~~~

### 启动捕获进程(主库) 
~~~ sql
connect strmadmin/strmadmin;
#启动Capture进程 
begin 
	dbms_capture_adm.start_capture( 
		capture_name => 'capture_boyuupq_10_18'); 
end; 
/ 
~~~

> 到这里流配置就完成了，可以通过下面的sql语句进行运行状况的查询

### 查询stream运行状况
主库：
~~~ sql
--捕获进程信息
SELECT * FROM dba_capture;
--传播进程信息
SELECT * FROM dba_propagation;
--已经捕获到的表对象
SELECT * FROM DBA_CAPTURE_PREPARED_TABLES order by SCN;
--已经捕获到的schema对象
SELECT * from dba_capture_prepared_schemas;
~~~

从库：
~~~ sql
--应用进程信息
select * from dba_apply;
--应用进程错误详细信息
select * from dba_apply_error;
--当前已经实例化的schema对象
select * from dba_apply_instantiated_schemas;
--当前已经实例化并同步过来的对象(表)
select * from dba_apply_instantiated_objects;
~~~

> 下面提供了停止相应流进程的操作

### 停止捕获进程(主库)
~~~ sql
connect strmadmin/strmadmin;
#停止Capture进程 
begin 
	dbms_capture_adm.stop_capture( 
		capture_name => 'capture_boyuupq_10_18'); 
end; 
/ 
~~~

### 停止应用进程(从库) 
~~~ sql
connect strmadmin/strmadmin;
#停止Apply进程 
begin 
	dbms_apply_adm.stop_apply( 
		apply_name => 'apply_boyuupq_10_19'); 
end; 
/ 
~~~

### 删除传播进程、应用进程
~~~ sql
exec dbms_capture_adm.drop_capture("capture_boyuupq_10_18");
exec dbms_apply_adm.drop_apply('apply_boyuupq_10_19');
~~~

### 删除所有流配置信息
~~~
exec dbms_streams_adm.remove_streams_configuration();
~~~
