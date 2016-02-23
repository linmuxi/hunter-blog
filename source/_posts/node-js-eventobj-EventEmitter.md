---
title: Node.js事件对象EventEmitter
date: 2016-02-17 09:48:30
tags: [Node.js]
categories: [技术]
description: Node.js事件对象EventEmitter
keywords: Node.js,EventEmitter
---
这篇主要分享下Node.js事件对象EventEmiiter的介绍和使用
<!--more-->

**前言**
Node.js 所有的异步 I/O 操作在完成时都会发送一个事件到事件队列。
Node.js里面的许多对象都会分发事件：一个net.Server对象会在每次有新连接时分发一个事件， 一个fs.readStream对象会在文件被打开的时候发出一个事件。 所有这些产生事件的对象都是 events.EventEmitter 的实例。 
大多数时候我们不会直接使用 EventEmitter，而是在对象中继承它。包括 fs、net、 http 在内的，只要是支持事件响应的核心模块都是 EventEmitter 的子类。

**EventEmitter类**
events模块只提供了一个对象：EventEmitter。EventEmitter的核心就是事件触发与事件监听器功能的封装。
可以通过require("events")来访问该模块。
~~~js
use 'strict'
// 引入 events 模块
var events = require('events');
// 创建 eventEmitter 对象
var eventEmitter = new events.EventEmitter();
//注册test_event事件的监听器
eventEmitter.on('test_event', function() { 
	console.log('test_event 事件触发'); 
}); 
//1秒后向eventEmitter对象发送事件test_event,此时会调用test_event的监听器
setTimeout(function() { 
	eventEmitter.emit('test_event'); 
}, 1000); 
~~~

**EventEmitter类信息**
* Events
	* Class: events.EventEmitter
		* Inheriting from 'EventEmitter'
		* Class Method: EventEmitter.listenerCount(emitter, event)
		* Event: 'newListener'
		* Event: 'removeListener'
		* EventEmitter.defaultMaxListeners
		* emitter.addListener(event, listener)
		* emitter.emit(event[, arg1][, arg2][, ...])
		* emitter.getMaxListeners()
		* emitter.listenerCount(type)
		* emitter.listeners(event)
		* emitter.on(event, listener)
		* emitter.once(event, listener)
		* emitter.removeAllListeners([event])
		* emitter.removeListener(event, listener)
		* emitter.setMaxListeners(n)

用法参考：http://nodejs.cn/doc/node/events.html

**继承EventEmitter**
~~~js
'use strict'
var util = require('util');
var EventEmitter = require('events').EventEmitter;

function MyObject() {
	EventEmitter.call(this);
}
// 通过util提供的方法使MyObject继承EventEmitter的方法
util.inherits(MyObject,EventEmitter);

var obj = new MyObject();
obj.on("data",function(arg1,arg2) {
	console.log("接受事件："+arg1+"  "+arg2);
});

setTimeout(function() {
	obj.emit("data","hello","world");
},1000);
~~~
通过继承EventEmitter，obj拥有了事件注册和触发等功能，很多node.js核心模块中的事件响应都是基于这种方法来实现的。