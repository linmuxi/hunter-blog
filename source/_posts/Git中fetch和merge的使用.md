---
title: Git中fetch和merge的使用
date: 2016-02-14 14:12:50
tags: [Git]
categories: [技术]
---
这篇主要分享下Git中fetch和merge命令的使用，使用过svn的同学应该都知道，如果远程版本库有更新，我们要同步本地代码与版本库保持一致可以使用update操作。git上是通过fetch和merge命令来从远程库中获取最新的版本并合并到本地版本中去的。
<!--more-->
目录
	1. fetch命令
	2. merge命令

** fetch命令 **
命令：`git fetch origin master` 从远程origin的master分支下载最新的版本到本地master分支
命令：`git log -p master..origin/master` 比较本地的master分支和远程origin/master分支的日志差异
命令：`git log -1 master..origin/master` 只显示一行日志差异
<!-- git log -p myBranch001..origin/myBranch001 -->

** merge命令 **
命令：`git merge origin/master` 合并master分支版本

** 查看origin指向 **
命令：`git remote -v`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_11.png)