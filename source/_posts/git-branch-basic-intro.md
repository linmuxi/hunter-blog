---
title: Git分支的基础使用
date: 2016-02-14 10:22:02
tags: [Git]
categories: [技术]
---
这篇主要分享下Git分支的基本操作，关于具体的概念大家可以去百度搜索了解，本篇不做介绍
<!--more-->
目录
* 查看分支
* 创建分支
* 切换分支
* 修改分支名称
* 分支合并
* 删除分支

** 前提 **
在上一篇[Git最最最基础命令入门](2016/01/29/git-basic-cmd-intro)中，我已经创建了一个版本库：https://github.com/linmuxi/test-git.git 
下面的演示就基于这个版本库来操作。

第一步先将版本库clone到本地，具体操作步骤可以参考[上一篇文章](2016/01/29/git-basic-cmd-intro) ，这里就不做具体介绍


** 查看分支 **
查看远程分支：`git branch -r`
查看本地分支：`git branch -l` 或 `git branch`
查看所有分支：`git branch -a`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_01.png)
可以看到目前只有一个master主分支，这个master分支也是git默认的分支


** 创建分支 **
输入命令：`git branch myBranch01`
再次查看分支，输入命令：`git branch -l`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_02.png)
可以看到myBranch01分支已经创建成功
注意：该分支只是在本地创建了，在远程库中并不存在，大家可以登录到Github上去确认下，也可以通过命令：`git branch -r`来确认

接下来就是将刚才创建的myBranch01分支同步到远程库中去
输入命令：`git push origin myBranch01`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_03.png)
在输入账户和密码之后，创建的分支就已经同步到远程库中去了，可以登录Github进行确认，也可以通过命令：`git branch -r`来确认


** 切换分支 **
输入命令：`git checkout myBranch01`
接着查看所有分支：`git branch -l`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_04.png)
可以看到当前分支已经切换到myBranch01上面去了


** 修改分支名称 **
输入命令：`git branch -m myBranch01 myBranch001`
接着查看分支名称修改情况：
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_06.png)
本地的已经修改过来，远程的还未同步修改
执行同步修改命令：`git push origin myBranch001`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_07.png)
最后删除修改前的myBranch01分支：`git push origin :myBranch01`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_08.png)
到这里分支名称就修改完成，觉得这样的操作很麻烦。


** 分支合并 **
合并操作前先查看master和myBranch001分支下面文件的内容
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_09.png)

接下来切换当前分支到想要合并到的分支下（本例中要将myBranch001分支合并到master分支中，则切换当前分支到master下面），然后执行分支合并命令：`git merge myBranch001`
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_10.png)


** 删除分支 **
输入命令：`git branch -d myBranch01`
注意：假如当前分支是myBranch01，则这里是不允许删除的，需要切换到别的分支才能将其删除
![](http://7xqlat.com1.z0.glb.clouddn.com/git_branch_05.png)

到这里，本地的分支已经被删除了，但是远程库中的还没有被删除。
输入命令：`git push origin :myBranch01`
这样远程库中的myBranch01分支就被同步删除了。
