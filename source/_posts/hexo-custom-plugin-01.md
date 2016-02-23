---
title: 如何编写Hexo插件
date: 2016-02-19 09:32:13
tags: [Hexo]
categories: [技术]
description: 如何编写Hexo插件
keywords: Hexo,插件
---
本篇主要分享下如何在Hexo中自定义插件。
<!--more-->
**前言**
我们现在编写一个插件，功能很简单，就是将文章中的所有超链接的打开方式换成在tab或新窗口中打开。

**实现步骤**
* 在node_modules目录下面新增插件目录hexo-test(注意hexo规定自定义插件目录名称必须是hexo-开头的)
* 在hexo-test目录下面新增以下文件：
	* hexo-test(插件目录)
		* index.js
		* package.json
		* README.md
		* LICENSE
		* lib
			* filter.js
* 开始编写插件：
在_config.yml中配置插件选项：
~~~yml
test:
	_target: true
~~~
index.js文件内容：
~~~js
'use strict';
if(hexo.config.test && hexo.config.test._target){
	hexo.extend.filter.register("after_render:html",require('./lib/filter'));
}
~~~
lib\filter.js文件内容：
~~~js
'use strict';
var cheerio = require('cheerio');
module.exports = function(source){
	var $ = cheerio.load(source);
	$("a").each(function(index,element){
		$(this).attr("target","_blank");
	});
	return $.html();
}
~~~
package.json文件内容：
~~~json
{
  "name": "hexo-test",
  "version": "1.0.0"
}
~~~
<!-- 将插件依赖添加到博客package.json中：
~~~json
{
  "name": "hunter-blog",
  "version": "1.0.0",
  "private": true,
  "hexo": {
    "version": "3.1.1"
  },
  "dependencies": {
    "hexo": "^3.1.0",
    "hexo-deployer-git": "0.0.4",
    "hexo-generator-archive": "^0.1.2",
    "hexo-generator-category": "^0.1.2",
    "hexo-generator-index": "^0.1.2",
    "hexo-generator-search": "^1.0.2",
    "hexo-generator-tag": "^0.1.1",
    "hexo-renderer-ejs": "^0.1.0",
    "hexo-renderer-marked": "^0.2.4",
    "hexo-renderer-stylus": "^0.3.0",
    "hexo-server": "^0.1.2",
    "hexo-test": "1.0.0"
  }
}
~~~ -->

到这里，我们的自定义插件就完成了。

大家可以参考官网关于自定义插件文档介绍：https://hexo.io/docs/plugins.html 
另外官网上也介绍了如何将自定义插件发布到hexo站点供其他小伙伴使用。