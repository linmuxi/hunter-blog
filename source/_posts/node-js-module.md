---
title: Node.js的模块系统
date: 2016-02-15 11:02:46
tags: [Node.js]
categories: [技术]
description: Node.js的模块系统
keywords: Node.js,模块,模块系统
---
这篇主要分享下如何自定义模块以及服务端模块的加载规则
<!--more-->
目录：
* exports和require
* 自定义模块
* 服务端模块

** 前言 **
为了让Node.js之间可以相互调用，Node.js提供了一个简单的模块系统。
模块是Node.js应用程序的基本组成部分，一个Node.js文件就是一个模块，文件内容可以是JavaScript代码、JSON或者是编译过的C/C++扩展。

** exports和require **
exports ：作为模块内部返回的对象
require ：用于从外部获取一个模块接口，即所获取模块的 exports 对象

require方法接受以下几种参数的传递：
1. http、fs、path等，原生模块。
1. ./mod或../mod，相对路径的文件模块。
1. /pathtomodule/mod，绝对路径的文件模块。
1. mod，非原生模块的文件模块。

** 自定义模块 **
首先，我们创建一个文件命名为：hello.js，内容如下：
~~~js
exports.hello = function(){
	console.log("hello");
}
/**
module.exports.hello = function(){
	console.log("hello");
}
**/
~~~
hello.js返回exports对象，即：{hello:Function}

接下来我们创建另外一个文件：main.js,内容如下：
~~~js
require("./hello")();
~~~
在main.js文件中，代码require("./hello")引入了当前目录下的hello.js文件(默认.js后缀),即引入了我们定义的hello模块。

注意：require("./hello") 是引入当前目录下面的hello.js,也可以是引入当前目录下的hello目录(hello目录中有index.js文件)，这两种方法效果一样，hexo的启动方式就是采用第二种方式进行的。
目录结构如下：
* demo
	* main.js
	* lib
		* index.js

index.js文件内容如下：
~~~js
'use strict'
module.exports = function(){
	console.log("hello world");
}
~~~

main.js文件内容如下：
~~~js
'use strict'
require('./lib')();
~~~

即：require('./lib/index.js') == require('./lib');


** 服务端模块 **
Node.js提供了很多内置的服务端模块供我们使用，大大的提高了我们的开发效率。
例如：使用提供的http模块
~~~js
var http = require("http");
...
http.createServer(...);
~~~
关于服务端内置模块的查找规则如下：

在Node.js中模块分为2类：原生模块和文件模块

其中文件模块分为3类模块，通过后缀来区分，Node.js会根据后缀来决定加载方法。
1. .js 通过fs模块同步读取js文件并编译执行。
1. .node 通过C/C++进行编写的Addon,通过dlopen方法进行加载。
1. .json 调用JSON.parse解析加载。


在Node.js中模块分为4类(原生模块和3种文件模块)，通过require很容易就加载到需要的模块了，但是其内部的加载流程却是不简单的，整个加载流程如下图所示：
![](http://7xqlat.com1.z0.glb.clouddn.com/nodejs_modules_01.png)

