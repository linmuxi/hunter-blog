---
title: Git最最最基础命令入门
date: 2016-01-29 12:11:26
tags:
---
这篇只是和大家分享下Git的最简单的基础命令入门
<!--more-->
目录
1. 创建版本库
1. 从版本库下载文件到本地
1. 提交文件到版本库

** 创建版本库 **
直接登录github网站创建一个reps,这里就不具体描述了，我创建的resp就命名为test-git，地址为：https://github.com/linmuxi/test-git.git

** 从版本库下载文件到本地 **
输入命令：`git clone http://github.com/linmuxi/test-git.git`
~~~
E:\demo\git>git clone http://github.com/linmuxi/test-git.git
Cloning into 'test-git'...
remote: Counting objects: 3, done.
remote: Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
Unpacking objects: 100% (3/3), done.
Checking connectivity... done.
~~~
这样就把我们刚才创建的test-git下载到本地了,对应我本地目录就是：E\demo\git\test-git

** 提交文件到版本库 **
假如，我在test-git目录下面增加了一个hello-world.txt文件，那么如何把它提交到版本库上去呢。这里我们描述细致点。
路径切换到包含.git的目录也就是test-git目录下面来
先输入命令查看工作树状态:`git status`
~~~
E:\demo\git\test-git>git status
On branch master
Your branch is up-to-date with 'origin/master'.
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        hello-world.txt

nothing added to commit but untracked files present (use "git add" to track)
~~~
可以看到系统提示hello-world.txt文件在本地工作树中找不到踪迹，并提示我们使用'git add'来进行操作。

接着输入命令：`git add hello-world.txt`
到这一步,文件hello-world.txt就被添加到索引中了

然后再次查看工作树状态：`git status`
~~~
E:\demo\git\test-git>git status
On branch master
Your branch is up-to-date with 'origin/master'.
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   hello-world.txt
~~~
系统提示检测到了一个新的文件，并提示我们使用'git reset head'来进行操作，我们的目的是要将文件提交到版本库，这里就不能使用这个命令了。

我们改输入命令：`git commit -m "new file helloworld.txt"`
~~~
E:\demo\git\test-git>git commit -m "new file helloworld.txt"
[master 2d620a7] new file helloworld.txt
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 hello-world.txt
~~~
到这一步，文件hello-world.txt就被添加到本地库了，此时还没有提交到github远程库中去。

再次查看工作树状态：`git status`
~~~
E:\demo\git\test-git>git status
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)
nothing to commit, working directory clean
~~~
系统提示没有任何可以提交的文件，工作目录是干净的。

接下来，我们就要把提交到本地库中的hello-world.txt文件同步到github运程库中去了
使用命令:`git push -u origin master`
~~~
E:\demo\git\test-git>git push -u origin master
error: cannot spawn sh: No such file or directory
Username for 'https://github.com': linmuxi
Password for 'https://linmuxi@github.com':
error: cannot spawn sh: No such file or directory
Counting objects: 3, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 285 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To http://github.com/linmuxi/test-git.git
   24c6ae3..2d620a7  master -> master
Branch master set up to track remote branch master from origin.
~~~
在输入github账户和密码之后，文件hello-world.txt就被同步到github上去了


会用到基础命令：

	git --help #查看git命令帮助

	git log #查看所有提交的日志记录
	git log -2  #查看最近2次提交的日志记录

	git status #查看本地工作树的状态

	git add . #添加所有文件到索引
	git add newFile.txt #添加newFile.txt文件到索引

	git commit -m "你好" #将索引中的文件提交到本地库中

	git clone giturl #从版本库下载代码

	git rm newFile.txt --cached #将newFile.txt从索引中移出
