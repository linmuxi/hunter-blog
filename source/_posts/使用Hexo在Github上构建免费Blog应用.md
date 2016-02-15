---
title: 使用Hexo在Github上构建免费Blog应用
date: 2016-01-27 11:18:43
tags: [Hexo]
categories: [技术]
---
&nbsp;&nbsp;&nbsp;&nbsp;"A fast, simple & powerful blog framework"这是Hexo官方上面的介绍，Hexo是基于Node.js的一个静态blog框架，通过Hexo可以仅仅使用几条简短的命令就能方便我们快速创建自己的blog。Hexo可以部署在Node服务器上，也可以部署在github上面。当然部署在github上好处多多，不紧可以省去服务器的成本，还可以免去了相关系统运维方便的事情。
<!--more-->
目录
	1. Hexo介绍
	2. Hexo安装
	3. Hexo使用
	4. Hexo发布到Github
	5. Hexo主题

** Hexo介绍 **
&nbsp;&nbsp;&nbsp;&nbsp;"A fast, simple & powerful blog framework"这是[Hexo官方](http://hexo.io)上面的介绍，Hexo是基于Node.js的一个静态blog框架，通过Hexo可以仅仅使用几条简短的命令就能方便我们快速创建自己的blog。Hexo可以部署在Node服务器上，也可以部署在github上面。当然部署在github上好处多多，不紧可以省去服务器的成本，还可以免去了相关系统运维方便的事情。

** Hexo安装 **
~~~ nodejs
#查看Node版本
E:\demo\nodejs>node -v
v0.12.7

#查看Npm版本
E:\demo\nodejs>npm -v
3.5.3

#全局安装hexo-cli
E:\demo\nodejs>npm install hexo-cli -g

#查看hexo版本
E:\demo\nodejs>hexo -v
hexo-cli: 0.2.0
os: Windows_NT 6.1.7601 win32 x64
http_parser: 2.3
node: 0.12.7
v8: 3.28.71.19
uv: 1.6.1
zlib: 1.2.8
modules: 14
openssl: 1.0.1p

#初始化hexo
E:\demo\nodejs>hexo init blog
INFO  Cloning hexo-starter to E:\demo\nodejs\blog
Cloning into 'E:\demo\nodejs\blog'...
remote: Counting objects: 40, done.
remote: Total 40 (delta 0), reused 0 (delta 0), pack-reused 40
Unpacking objects: 100% (40/40), done.

#安装hexo
E:\demo\nodejs>cd blog&npm install

#启动hexo
E:\demo\nodejs\blog>hexo server
INFO  Hexo is running at http://0.0.0.0:4000/. Press Ctrl+C to stop.
~~~
到这里Hexo就搭建好了,打开浏览器访问：http://localhost:4000 正常情况会显示如下
![Hexo效果](http://7xqlat.com1.z0.glb.clouddn.com/hexo.png)

** Hexo使用 **
1、Hexo目录和文件
![Hexo目录和文件](http://7xqlat.com1.z0.glb.clouddn.com/hexo_file.png)
node_modules:依赖的nodejs模块文件
scaffolds：工具模版文件，文件以md扩展名，语法采用markdown
source:存放blog正文内容
source\_posts:正式发布内容
themes:存放blog皮肤样式目录
themes\landscape:blog默认样式目录
_config.yml:全局配置文件

2、_config.yml
全局配置文件，很多网站的相关信息都在这里面进行配置，例如等会要进行配置的root、deploy等属性。

3、hexo -h
可以通过help查看hexo可以使用的命令，常用的例如有init、generate、clean、publish、new等。 

4、创建新文章
有两种方式创建文章：
1：手动在_post目录下面添加md文件
2：通过hexo命令创建
~~~ nodejs
E:\demo\nodejs\blog>hexo new first
INFO  Created: E:\demo\nodejs\blog\source\_posts\first.md
~~~
可以看到在_post目录下新增了first.md文件
![](http://7xqlat.com1.z0.glb.clouddn.com/hexo_new.png)
再次访问：http://localhost:4000 可以发现我们刚才新加的文章已经发布上去了。

5、语法
关于文章内容采用的语法是有要求的，包括以下三部分：
1：基本信息：标题，发布日期，分类目录，标签，类型，固定发布链接
2：正文：markdown语法和Swig语法(掌握一个就行)
3：特殊标记：引用，链接，图片，代码块，iframe
编辑文章内容：
~~~ markdown
---
title: 我的第一篇文章
date: 2016-01-26 14:45:07
tags:
- 第一次
- 日记
categories: 
- 日志
- 2015
- 01
- 26
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
`compact([0,1,false,2,'',3]);`

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
~~~

** Hexo发布到Github **
1、静态化处理
github只托管静态文件，所以这里我们需要将hexo项目的node剥离出来生成只包括html、js、css文件的静态资源文件。
使用hexo提供的命令可以轻松实现:
~~~ nodejs
E:\demo\nodejs\blog>hexo generate
INFO  Files loaded in 314 ms
INFO  Generated: js/script.js
INFO  Generated: fancybox/jquery.fancybox.pack.js
...
INFO  36 files generated in 907 ms
~~~
生成的静态文件全部都在更目录下的public文件夹下面。

2、发布到Github
1：在github上新建rep、gh-pages分支
这里我的rep命名为：nodejs-hexo
2：修改_config.yml
~~~ yml
root: /nodejs-hexo
deploy:
  type: git
  repo: https://github.com/linmuxi/nodejs-hexo.git
  branch: gh-pages
~~~
** <span style="color:#FF0000">注意：编辑的时候注意空格问题，冒号后面是有空格的。</span> **


** Hexo主题 **
Hexo默认主题是landscape，我们可以到Hexo网站去下载其他主题并应用到我们的blog上面去。
首先，找到我们需要的主题git地址，并下载到Hexo根目录下面的thems文件夹下。
~~~
E:\demo\nodejs\blog>git clone git://github.com/tommy351/hexo-theme-light.git the
mes/light
Cloning into 'themes/light'...
remote: Counting objects: 892, done.
rRemote: Total 892 (delta 0), reused 0 (delta 0), pack-reused 892eceiving object
Receiving objects:  94% (839/892), 156.01 KiB | 124.00 KiB/s
Receiving objects: 100% (892/892), 346.40 KiB | 124.00 KiB/s, done.
Resolving deltas: 100% (391/391), done.
Checking connectivity... done.
~~~
这样主题文件就下载好了，然后修改全局配置文件_config.xml,将theme的值改成对应的them文件夹名称，这里我们下载的是light。
直接就可以打开浏览器输入：http://localhost:4000 查看应用新主题之后的效果了。