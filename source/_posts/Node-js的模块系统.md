---
title: Node.js的模块系统
date: 2016-02-15 11:02:46
tags: [Node.js]
categories: [技术]
---
这篇主要分享下如何自定义模块以及服务端模块的加载规则
<!--more-->
目录：
	1. exports和require
	2. 自定义模块
	3. 服务端模块

** 前言 **
为了让Node.js之间可以相互调用，Node.js提供了一个简单的模块系统。
模块是Node.js应用程序的基本组成部分，一个Node.js文件就是一个模块，文件内容可以是JavaScript代码、JSON或者是编译过的C/C++扩展。

** exports和require **
exports ：作用是将模块中定义的对象发布出去
require ：用于从外部获取一个模块接口，即所获取模块的 exports 对象

require方法接受以下几种参数的传递：
1. http、fs、path等，原生模块。
1. ./mod或../mod，相对路径的文件模块。
1. /pathtomodule/mod，绝对路径的文件模块。
1. mod，非原生模块的文件模块。

** 自定义模块 **
首先，我们创建一个文件命名为：hello.js，内容如下：
~~~js
exports.world = function(){
	console.log("hello world");
}
exports.test = function(name){
	return "test "+name;
}
exports.person = {id:101,name:"test",age:12};
var car = function(){
	this.name = "car name";
	this.say = function(name){
		console.log("hello say:"+name);
	}
}
exports.car = car;
~~~
在hello.js文件中，我们通过exports对象将我们定义好的对象发布出去，供其他nodejs应用程序调用。

接下来我们创建另外一个文件：main.js,内容如下：
~~~js
var hello = require("./hello");
hello.world();
console.log(hello.test("张三"));
console.log(hello.person);
var car = new hello.car();
console.log(car.name);
car.say("历史");
~~~
在main.js文件中，代码require("./hello")引入了当前目录下的hello.js文件(默认.js后缀),即引入了我们定义的hello模块，并能调用hello模块发布出来的对象。


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

