---
title: Bat语法总结
date: 2016-02-16 11:53:29
tags: [Bat]
categories: [技术]
description: Bat语法总结
keywords: bat,dos,windows
---
这篇主要分享下Window下Bat相关语法的介绍和使用
<!--more-->

**echo和@**
@ 	关闭当前行回显
echo off 	从下一行开始关闭回显
@echo off 	从本行开始关闭回显，一般批处理第一行都是这个
echo on 	从下一行开始打开回显
echo 	显示当前echo是关闭还是打开状态
echo hello 	屏幕打印hello字符串

**errorlevel**
`echo %errorlevel%`   
每个命令运行结束，可以用这个命令行查看返回码，默认值为0，命令执行出错会设errorlevel为1

**dir**
显示目录下的所有文件
`dir d:temp3` 显示temp3下的所有文件，不包括隐藏、系统、只读文件、子目录文件
`dir /s/a d:temp3` 显示temp3下的所有文件，包括隐藏、系统、只读文件、子目录文件
`dir /a d:temp3` 显示temp3下的所有文件和子目录包括隐藏和系统文件
`dir /a:d d:temp3` 显示temp3下的所有目录
`dir /a:-d d:temp3` 显示temp3下的所有文件
`dir /b/p d:temp3` 分页显示temp3下的所有文件的文件名
`dir /s d:temp3\*.txt` 显示temp3目录及其子目录下面的所有txt文件

**md**
创建目录
`md d:mydir`  在d盘创建目录
`md d:"one/"two` 在d盘创建目录one/two

**rd**
删除目录
`rd abc` 删除空目录abc
`rd /s/q d:"temp` 删除d盘temp文件夹及其子文件夹和文件 

**del**
删除文件
`del d:"test.txt` 删除指定文件，不能是隐藏、系统、只读文件
`del /q/a/f d:"temp\*.*` 删除d:temp文件夹下面的所有文件、包括隐藏、只读、系统文件、不包括子目录
`del /q/a/f/s d:"temp2\*.*`删除d:temp2文件夹及其子文件夹下面的所有文件、包括隐藏、只读、系统文件、不包括子目录

**ren**
重命名
`ren d:"temp" temp2` 将d盘目录下面的temp重命名为temp2

**type**
文件内容查看
`type d:temp\child\aa.txt` 查看文件内容

**copy**
文件复制
`copy d:"temp"\"child"\"aa.txt" d:"temp"\"AA.txt"` 复制文件并重命名
`copy con d:temp\"hello world.txt"` 从屏幕上等待输入，将输入数据拷贝到指定目录，按Ctrl+Z 回车结束输入
`copy 1.txt+2.txt 3.txt` 合并1.txt和2.txt的内容拷贝到3.txt文件,如果不指定3.txt 则保存到1.txt

con：屏幕；prn：打印机；nul：空设备

**title**
`title hello` 设置cmd窗口标题为hello

**ver**
ver 显示系统版本

**pause**
pause 暂停命令

**rem和::**
注释命令
rem 这里是注释，不会被执行
:: 也是注释,不会回显

**date和time**
日期和时间
date 显示日期并提示输入新的日期
time 显示时间并提示输入新的时间
date/t 只显示日期不提示输入新日期

**goto和: 跳转命令**
:label  行首为：表示该行是标签行,标签行不执行操作
goto label 跳转到指定的标签行

**find**
查找文件内容
`find "hello" d:temp\AA.txt` 在AA.txt文件中查找含有hello字符串的行
`find /i "hello" d:temp\AA.txt` 查找含有hello的行，忽略大小写
`find /c "hello" d:temp\AA.txt` 显示含有hello的行的总行数

**more **
逐屏显示
`more "d:temp/AA.txt"`

**tree** 
显示目录结构
`tree d:temp` 以树形结构显示temp目录下的所有文件

**&** 
按顺序执行多条命令，不管命令是否执行成功
`hexo clean & hexo g & hexo d`

**&&** 
顺序执行多条命令，当碰到执行出错的命令将不执行后面的命令
`find "hello" d:temp\AA.txt && echo 找到你了`

**||** 
顺序执行多条命令，当碰到执行正确的命令将不执行后面的命令
`find "hello" d:temp\AA.txt || echo 没有找到`

**|** 
管道命令
`dir d:temp3 /s/a | find /c ".txt"`
先执行dir命令，对其输出的结果执行后面的find命令，该命令的结果是：输出当前文件夹及其所有子文件夹里面的.txt文件的个数

**>和>>** 
输出重定向命令
`>` 清除文件内容再写入
`>>` 不清除文件内容，直接追加内容到文件末尾

`type d:temp3\AA.txt > prn`
将AA.txt文件内容转向输出到打印机，不在屏幕上显示

`echo hello world > con`
在屏幕上显示hello world,实际上所有的输出都是默认 > con 的

`echo ^^1^>2 > d:temp3\test.txt`
生成内容为：^1>2
^和>是控制命令，要将他们输出，则必须在前面加^符号

**<** 
从文件中获取输入信息
~~~bash
@echo off
echo 2026-02-16 > d:temp\date.txt
date < d:temp\date.txt
del d:temp\date.txt
~~~

**%0 %1 %2 %3 %***
命令行传递给批处理的参数
%0 批处理文件本身
%1 第一个参数
%3 第二个参数
%* 第n个参数

用法：test.bat 第一个参数 第二个参数

批参数的替代已被增强，语法如下：
%~d1 将%1扩充到一个驱动器号
%~f1 将%1扩充到一个全路径名
%~p1 将%1扩充到一个相对路径
%~n1 将%1扩充到一个文件名

**if** 
判断命令
`if %1 == server echo 第一个参数是server`
运行test.bat server

`if /i %1 equ server echo 第一个参数是server`
忽略大小写

==与equ是一样的效果,其他运算符参见：if/?

~~~bash
if exist d:temp\AA.txt echo 存在AA.txt文件

if exist D:temp\AA.txt ( 
echo 存在AA文件
) else (
echo 不存在AA文件
)
~~~
注意：if、else和括号之间有空格

**for** 
循环命令
`for %%i in (1,2,3 a b c) do echo %%i`
循环小括号里面的字符串,然后执行do后面的命令
字符串分隔符可以是,空格

`for %%i in (D:temp3\*.txt) do find "hello" %%i`
循环temp3目录下的所有txt文件并执行find查找包含hello的字符串行

`for /r %%i in (D:temp3\*.txt) do find "hello" %%i`
循环temp3目录及其子目录下面的所有txt文件，并搜索包含hello的字符串行

**start**
批处理中调用外部程序的命令

**call**
批处理中调用另外一个批处理的命令

**xcopy** 
文件夹拷贝
`xcopy d:temp d:temp2 /s/e/i/y`
将temp文件夹、所有子文件夹和文件复制到指定目录，覆盖已有的文件
参数/i表示如果指定目标目录不存在则自动创建，否则会询问
注意：隐藏的文件不会复制过去

**subst** 
映射磁盘
`subst Q: \\10.0.88.10\公共盘`  #这样就将指定的公共盘符映射到本地了，可以通过Q:来访问了
`subst Q: /d`  #取消该映射
`subst`  #查看所有的映射

查看网络驱动器的ip地址
regedit>HKEY_CURRENT_USER>Network

查看命令帮助
命令 /?
例如：dir /?
