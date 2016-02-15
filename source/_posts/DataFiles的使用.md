---
title: Data Files的使用
date: 2016-02-01 09:18:27
tags: [Hexo]
categories: [技术]
---
这篇主要分享Hexo中DataFiles的使用,记录这篇的原因是，官网提供的DataFiles Doc介绍在我本地没有运行出效果来。
<!--more-->
下面是官网的Doc：
![DataFiles Doc](http://7xqlat.com1.z0.glb.clouddn.com/hexo_datafiles.png)
步骤很简单
第一步：在source下面新建_data目录，目录下面就是定义的数据文件。可支持yml格式文件。
第二步：在模版文件(ejs、swig)中使用for标签进行迭代输出。
但是，实际运行的效果是页面不解析这种for标签写法,直接将标签源码输出
![不支持for这种写法](http://7xqlat.com1.z0.glb.clouddn.com/hexo_datafiles_02.png)
查看本地hexo版本：
![Hexo版本](http://7xqlat.com1.z0.glb.clouddn.com/hexo_version.png)

修改后的for标签写法：
~~~html
<% if (site.data.menu) { %>
	<% for (item in site.data.menu) { %>
		<li><%= item %> <%= site.data.menu[item] %></li>
	<% } %>
<% } %>
~~~
到这里，数据就能正常输出到页面了。

参考：
http://ammonsonline.com/using-hexo-data-files/


