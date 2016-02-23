---
title: 发布Node.js应用到NPM
date: 2016-02-19 14:16:06
tags: [Node.js,NPM]
categories: [技术]
description: 发布Node.js应用到NPM
keywords: Node.js,NPM
---
本篇主要分享下如何将Node.js应用发布到NPM
<!--more-->

**前言**
前提NPM和Node.js环境已经安装完成。

**发布到Npm**
首页你得有一个NPM账户，没有大家可以自行到NPM官网上去[注册](https://www.npmjs.com/signup)。

1、通过npm初始化package.json文件
<!-- ![](http://7xqlat.com1.z0.glb.clouddn.com/npm_init_01.png) -->
~~~
hunter@hunter-ubuntu:~/hello-hunter$ npm init
...
Press ^C at any time to quit.
name: (hello-hunter) 
version: (1.0.0) 
description: this is node demo
entry point: (index.js) 
test command: 
git repository: 
keywords: test
author: hunter
license: (ISC) MIT
About to write to /home/hunter/hello-hunter/package.json:

{
  "name": "hello-hunter",
  "version": "1.0.0",
  "description": "this is node demo",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [
    "test"
  ],
  "author": "hunter",
  "license": "MIT"
}


Is this ok? (yes) yes
~~~

2、在目录下面新增index.js文件，内容如下：
~~~js
module.exports = function(){
	console.log("hello hunter");
}
~~~

3、登录npm
<!-- ![](http://7xqlat.com1.z0.glb.clouddn.com/npm_login_01.png) -->
~~~
hunter@hunter-ubuntu:~/hello-hunter$ npm login
Username: hunterlin
Password: 
Email: (this IS public) ***
Logged in as hunterlin on https://registry.npmjs.org/.
~~~
注意：创建的账户要到邮箱中激活才可以使用。

4、发布应用到npm
<!-- ![](http://7xqlat.com1.z0.glb.clouddn.com/npm_publish_01.png) -->
~~~
hunter@hunter-ubuntu:~/hello-hunter$ npm publish
+ hello-hunter@3.0.0
~~~

到这里我们的node应用就发布到npm上面去了，我们可以在官网查询到我们发布的应用
![](http://7xqlat.com1.z0.glb.clouddn.com/npm_search_01.png)


5、从npm下载应用
构建如下目录结构：
* hello-nodejs
	* index.js
	* package.json

index.js文件内容如下：
~~~
'use strict';
// 引入hello-hunter模块并调用
require('hello-hunter')();
~~~

package.json文件内容通过npm init来生成。

通过npm下载hello-hunter模块
<!-- ![](http://7xqlat.com1.z0.glb.clouddn.com/npm_install_01.png) -->
~~~
hunter@hunter-ubuntu:~/test-nodejs$ npm install hello-hunter --save
test-nodejs@1.0.0 /home/hunter/test-nodejs
└── hello-hunter@1.0.0 
~~~

运行node程序
<!-- ![](http://7xqlat.com1.z0.glb.clouddn.com/npm_node_run_01.png) -->
~~~
hunter@hunter-ubuntu:~/test-nodejs$ node index.js 
hello hunter
~~~
