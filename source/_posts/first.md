---
title: 我的第一篇文章
date: 2016-01-26 14:45:07
tags:
- 第一次
- 日记
categories: 
- 日志
- 工作
- 生活
---

这是**我的第一篇文章**，是用hexo创建的。

# 引用
** Swing语法 **
{% blockquote Seth Godin http://sethgodin.typepad.com/seths_blog/2009/07/welcome-to-island-marketing.html Welcome to Island Marketing %}
Every interaction is both precious and an opportunity to delight.
{% endblockquote %}

** Markdown语法 **
> Every interaction is both precious and an opportunity to delight.


# 代码块
** Swing语法 **
{% codeblock compact http://www.baidu.com Baidu.js %}
compact([0,1,false,2,'',3]);
=> [1,2,3]
{% endcodeblock %}

** Markdown语法 **
~~~{bash}
compact([0,1,false,2,'',3]);
~~~

# 链接
** Swing语法 **
{% link 我的日志 http://linmuxi.github.io/nodejs-hexo true 我的日志 %}

** Markdown语法 **
[我的日志](http://linmuxi.github.io/nodejs-hexo)

# 图片
* 图片，对于本地图片，需要在source目录下面新建一个images目录存放图片 *

** Swing语法 **
{% img images/1.png 这是第一张图片 %}

** Markdown语法 **
![这是第一张图片](images/1.png)

![这是第一张图片](http://linmuxi.github.io/me/project/realtimeData/images/realtimeData_02.png)