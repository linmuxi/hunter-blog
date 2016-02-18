---
title: 'CommonJS,AMD,CMD及UMD规范介绍'
date: 2016-02-18 09:35:56
tags: [JavaScript]
categories: [技术]
---
本篇分享下关于前端模块规范CommonJS、AMD、CMD及UMD的介绍。
<!--more-->

**前言**
为什么要制定这些前端模块规范？由于JavaScript的崛起，很多基于js编写的应用组件给予了我们很大的便利，但是不可以避免会出现一个问题就是很多组件并不能愉快的在一起协同工作，例如会出现命名冲突等问题。
为了解决这些问题，一些牛人们就制定出了前端模块化规范，他们规定开发者们都采用一种约定好的模式来进行代码编写，以避免对整个生态圈的污染。
参考下[前端模块化开发的价值](https://github.com/seajs/seajs/issues/547)

**他们的异同**
CommonJS是运行在服务端的模块规范，Node.js实现了这种规范
AMD、CMD、UMD是运行在浏览器端的模块规范，常用到的库有seajs，requirejs

**CommonJS**
据CommonJS规范，一个单独的文件就是一个模块，每一个模块都是一个单独的作用域。加载模块使用require方法，该方法读取一个文件并执行，最后返回文件内部的exports对象，CommonJS以同步方式加载模块。

模块定义
~~~js
//MyUtil.js
'use strict';
function util(args){
	this.show = function(){
		console.log("hello "+args.name);
	}
}
module.exports = util;
~~~

模块加载
~~~js
//index.js
'use strict';
//require以同步方式加载模块

//加载jquery模块
var jquery = require('jquery');

//加载自定义模块.js
var MyUtil = require('./MyUtil');

//加载common目录下面的index.js
//var common = require('./common');

var util = new MyUtil({name:"hunter"});
util.show();
~~~

执行Node.js应用
~~~bash
node index.js
~~~

**AMD**
全称"Asynchronous Module Definition"(异步模块加载规范) , requirejs库实现了该规范。
<!-- 定义模块使用define，加载模块使用requirejs或require。 -->

模块定义
~~~js
define(function(){
	return {};
})
~~~

模块加载
~~~js
'use strict';
//加载jquery模块和sub模块
requirejs(['lib/jquery','app/sub'],function($,sub){
})
~~~
关于requirejs库的详细使用可以参考：http://requirejs.org


**CMD**
全称"Common Module Definition"(通用模块加载规范)，seajs库实现了该规范。

模块定义及加载
~~~js
// 所有模块都通过 define 来定义
define(function(require, exports, module) {

  // 通过 require 引入依赖
  var $ = require('jquery');
  var Spinning = require('./spinning');

  // 通过 exports 对外提供接口
  exports.doSomething = ...

  // 或者通过 module.exports 提供整个接口
  module.exports = ...

});
~~~
关于seajs库的详细使用可以参考：http://seajs.org


**UMD**
全称"Universal Module Definition"(通用模块规范)
UMD是AMD和CommonJS的糅合,因为AMD、CommonJS规范是两种不一致的规范，虽然他们应用的场景也不太一致，但是人们仍然是期望有一种统一的规范来支持这两种规范,于是UMD规范诞生了。

采用UMD规范编写的组件：
~~~js
// app.js
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        // Node, CommonJS-like
        module.exports = factory(require('jquery'));
    } else {
        // Browser globals (root is window)
        root.returnExports = factory(root.jQuery);
    }
}(this, function ($) {
    // methods
    function myFunc(){
    	console.log("Jquery:"+$);
    };

    // exposed public method
    return myFunc;
}));
~~~

RequireJS调用
~~~js
//加载require.js文件
<script src="require.js"></script>
<script>
    //加载app模块
	requirejs(['app'],function(app){
		app();
	})
</script>
~~~

Node.js调用
~~~js
'use strict';
require('./app')();
~~~

原生调用
~~~html
<script src="jquery.js"></script>
<script src="app.js"></script>
<script>
	this.returnExports();
</script>
~~~

上面三种调用方式输出的结果是一样的，如果想让编写的组件支持AMD和CommonJS规范，那么就采用UMD来包装下吧。
jQuery就采用这个方式包装了下让其可以支持AMD和CommonJS规范。
~~~js
if ( typeof module === "object" && module && typeof module.exports === "object" ) {
	// Expose jQuery as module.exports in loaders that implement the Node
	// module pattern (including browserify). Do not create the global, since
	// the user will be storing it themselves locally, and globals are frowned
	// upon in the Node module world.
	module.exports = jQuery;
} else {
	// Otherwise expose jQuery to the global object as usual
	window.jQuery = window.$ = jQuery;

	// Register as a named AMD module, since jQuery can be concatenated with other
	// files that may use define, but not via a proper concatenation script that
	// understands anonymous AMD modules. A named AMD is safest and most robust
	// way to register. Lowercase jquery is used because AMD module names are
	// derived from file names, and jQuery is normally delivered in a lowercase
	// file name. Do this after creating the global so that if an AMD module wants
	// to call noConflict to hide this version of jQuery, it will work.
	if ( typeof define === "function" && define.amd ) {
		define( "jquery", [], function () { return jQuery; } );
	}
}
~~~