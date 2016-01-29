---
title: Node.js基础中间件Connect
date: 2016-01-26 11:58:37
tags: [Node.js]
categories: [技术]
---
什么是中间件？什么是Connect？
<!--more-->
中间件应该是个比较广的概念，我们常常听到或接触到的例如有ESB中间件、消息中间件、应用服务器中间件等等,百度之概念为中间件是一种独立的系统软件或服务程序，分布式应用软件借助这种软件在不同的技术之间共享资源。

Connect是Node平台的中间件框架，著名的Express就是基于Connect的。

Nodejs提供了20多种内置的中间件：
1. logger: 用户请求日志中间件
1. csrf: 跨域请求伪造保护中间件
1. compress: gzip压缩中间件
1. basicAuth: basic认证中间件
1. bodyParser: 请求内容解析中间件
1. json: JSON解析中间件
1. urlencoded: application/x-www-form-urlencode请求解析中间件
1. multipart: multipart/form-data请求解析中间件
1. timeout: 请求超时中间件
1. cookieParser: cookie解析中间件
1. session: 会话管理中间件
1. cookieSession: 基于cookies的会话中间件
1. methodOverride: HTTP伪造中间件
1. reponseTime: 计算响应时间中间件
1. staticCache: 缓存中间件
1. static: 静态文件处理中间件
1. directory: 目录列表中间件
1. vhost: 虚拟二级域名映射中间件
1. favicon: 网页图标中间件
1. limit: 请求内容大小限制中间件
1. query: URL解析中间件
1. errorHadnler: 错误处理中间件

当然还有很多[第三方中间件](https://github.com/senchalabs/connect/wiki)

关于内置中间件的具体用法可以参考：[Nodejs内置中间件用法](http://blog.fens.me/nodejs-connect/) [Nodejs内置中间件API](https://github.com/senchalabs/connect#middleware)

这里，我们主要分享下如何实现自定义中间件,下面我们定义了一个中间件，处理逻辑是禁止早上9点以前的访问：
~~~
var connect = require("connect");
var app = connect();

//注册自定义中间件(将中间件添加到中间件队列中，等待事件触发执行)
app.use(access).use(test);

function access(req,res,next){
	var hour = new Date().getHours();
	if(hour < 9){
		res.writeHead(503,{"Content-Type":"text/plain;charset=utf-8"});
		res.end("禁止访问");
	}else{
		next();//转入下一个中间件处理
	}
}

function test(req,res,next){
	res.writeHead(200,{"Content-Type":"text/plain"});
	res.end("Hello World !!!");
}
app.listen(3000);
~~~

其实我对中间件的理解就是，定义一个函数对象并注册到中间件队列中，然后等待事件触发进行回调该函数对象。

