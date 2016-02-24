---
title: Github之SSH连接配置
date: 2016-02-24 16:37:02
tags: [Git]
categories: [技术]
description: 本篇介绍Github之SSH连接的配置
keywords: Github,ssh
---
虽然github推荐使用https方式进行连接，但是ssh方式咱们也得会，官网上也都有详细的[文档介绍](https://help.github.com/articles/testing-your-ssh-connection/)，步骤比较简单，记录这篇的目的是给初入门的小伙伴多一个学习的门径，同时也方便日后自己查看。
<!--more-->
## **前言**
在没有配置ssh的情况下使用ssh连接操作github库的时候会出现如下异常：
~~~bash
$ git clone git@github.com:linmuxi/test-git.git
Cloning into 'test-git'...
Warning: Permanently added the RSA host key for IP address '192.30.252.129' to the list of known hosts.
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
~~~~

## **步骤**
>前提是我们已经新建好了一个库test-git,ssh路径是：git@github.com:linmuxi/test-git.git

### **1、检查ssh keys是否存在**
~~~bash
$ ls -al ~/.ssh
~~~
如果目录下面没有id_rsa、id_rsa.pub则表示key不存在

### **2、生成ssh key**
~~~bash
$ ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/c/Users/Hunter/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /c/Users/Hunter/.ssh/id_rsa.
Your public key has been saved in /c/Users/Hunter/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:7KwlOZ4yljBZE2ZJ7dr8QGIyQeiPk49L+01fnC0hAZY your_email@example.com
The key's randomart image is:
+---[RSA 4096]----+
| o...=.          |
|. . *Eo          |
|.  + o .         |
| .o = o..        |
|  +* B .S.       |
| ++.. ++o +      |
| .+o o+o+= .     |
|....B..*o .      |
| ooo ++.         |
+----[SHA256]-----+
~~~

### **3、将ssh key添加到ssh-agent**
先确认ssh-agent是可用的
~~~bash
$ eval $(ssh-agent -s)
Agent pid 20632
~~~
将ssh key添加到ssh-agent
~~~bash
$ ssh-add ~/.ssh/id_rsa
Identity added: /c/Users/Hunter/.ssh/id_rsa (/c/Users/Hunter/.ssh/id_rsa)
~~~

### **4、将ssh key配置到github**
复制key内容
~~~bash
$ clip < ~/.ssh/id_rsa.pub
~~~

配置key到github
登录github->选择Settings->SSH keys->New SSH key

测试ssh key的配置情况
~~~bash
$ ssh -t git@github.com
Warning: Permanently added the RSA host key for IP address '192.30.252.128' to the list of known hosts.
PTY allocation request failed on channel 0
~~~

到这里就配置好了

再次执行clone操作：
~~~bash
$ git clone git@github.com:linmuxi/test-git.git
Cloning into 'test-git'...
remote: Counting objects: 56, done.
remote: Compressing objects: 100% (34/34), done.
remote: Total 56 (delta 4), reused 0 (delta 0), pack-reused 8
Receiving objects: 100% (56/56), 5.42 KiB | 0 bytes/s, done.
Resolving deltas: 100% (4/4), done.
Checking connectivity... done.
~~~
