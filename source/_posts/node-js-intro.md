---
title: Node.js入门
date: 2016-01-17 11:57:38
tags: [Node.js]
categories: [技术]
---
本篇主要分享Node环境安装和Hello World示例
<!--more-->
目录：
* Node.js介绍
* 安装Node环境
* Hello World！

**Node.js介绍**
Node.js® is a JavaScript runtime built on Chrome's V8 JavaScript engine. Node.js uses an event-driven, non-blocking I/O model that makes it lightweight and efficient. Node.js' package ecosystem, npm, is the largest ecosystem of open source libraries in the world.
Node.js是基于Chrome V8 JavaScript引擎构建的JavaScript运行时环境，Node.js使用事件驱动、非阻塞式I/O模型，使其轻量又高效。Node.js的包管理器npm，是全球最大的开源库生态系统。

** 安装Node环境 **
本章节介绍window和Linux下安装Node的方法。
Node.js安装包及源码下载地址：https://nodejs.org/en/download/
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_01.png)

### Window上安装Node.js
1、window安装包(.msi)
下载对应操作系统的msi文件，按照提示步骤进行安装，安装完成后，检测PATH环境变量是否包含Nodejs,没有包含则需要将Nodejs的安装路径配置到PATH中。
安装配置完成后，在dos命令中输入:`node -v` 进行检测。

### Linux上安装Node.js
1、源码安装  <!-- 需要安装Git，没有安装请先安装Git：`sudo apt-get install git` -->
从Github上获取Node.js源码：`sudo git clone https://github.com/nodejs/node.git`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_02.png)

创建编译文件：`sudo ./configure`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_03.png)

编译：`sudo make`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_04.png)

安装：`sudo make install`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_05.png)

查看版本：`node -v`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_06.png)

2、apt-get安装
命令：`sudo apt-get install nodejs` 安装nodejs
命令：`sudo apt-get install npm` 安装npm

<!--
普通安装：sudo apt-get install 软件名称
修复安装：sudo apt-get -f install 软件名称
重新安装：sudo apt-get --reinstall install 软件名称

移除卸载：sudo apt-get remove 软件名称
清除卸载：sudo apt-get --purge remove 软件名称
          sudo apt-get purge 软件名称 (同时清除配置信息)

查看所有安装的包：dpkg-query -l
查看指定软件：dpkg-query -l 软件名称
-->

** Hello World **

1、交互模式
打开终端，输入node回车进入命令交互模式：
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_07.png)

2、脚本模式
新建文件helloworld.js,内容为：console.log("Hello World!");
打开终端，输入命令：`node helloworld.js`
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_install_soft_08.png)
