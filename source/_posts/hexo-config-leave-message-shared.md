---
title: Hexo博客配置留言和分享功能
date: 2016-01-28 11:49:01
tags: [Hexo]
categories: [技术]
description: Hexo博客配置留言和分享功能
keywords: Hexo,留言,分享
---
接上一篇[《使用Hexo在Github上构建免费Blog应用》](2016/01/27/hexo-on-github-build-blog/)，这篇介绍下如何在Hexo博客上配置留言和分享功能。
<!--more-->
我们的留言控件采用[多说](http://duoshuo.com/)这款插件，话不多说，直接进入主题吧。
 
第一步，打开[多说官网](http://duoshuo.com/),点击“我要安装”，然后选择登录模式，这里可以选择QQ、微信、baidu等账户进行登录
 
第二步，登录成功后，是多说的管理平台，在左边的导航栏选择“工具”菜单，然后获取插件代码。
![多说管理平台](http://7xqlat.com1.z0.glb.clouddn.com/duosuo_1.png)

第三步，将代码拷贝到comment.ejs文件中。
![集成多说代码](http://7xqlat.com1.z0.glb.clouddn.com/duoshuo_2.png)
注意comment.ejs在themes/light/layout/_partial/目录下面，我们可以在全局配置文件_config.yml中添加一个变量duoshuo来控制是否显示多说留言控件。需要根据自身情况修改data-thread-key、data-title、data-url属性值。

第四步，重启hexo，打开浏览器访问http://localhost:4000 查看一篇博客，可以看到我们的多说留言已经集成到博客上面去了
![](http://7xqlat.com1.z0.glb.clouddn.com/duoshuo_3.png)

到这里，多说留言插件就已经正常集成到我们的博客上去了。对于留言的管理，我们可以登录到多说提供的管理平台上去操作，具体的操作步骤就不在本篇讨论了。
 
接下来，我们配置下分享功能，这里还是采用多说提供的控件
 
第一步，登录多说管理平台，点击左边菜单“分享”按钮，选好样式之后复制生成的代码。

第二步，将代码拷贝到share.ejs文件中。
![](http://7xqlat.com1.z0.glb.clouddn.com/duoshuo_4.png)
注意share.ejs在themes/light/layout/_partial/post/目录下面，我们可以在themes目录下的配置文件_config.yml中添加一个变量addthis/shared来控制分享功能的显示。同样，这里需要根据自身情况修改data-thread-key、data-title、data-images、data-content、data-url属性值

第三步，重启hexo，打开浏览器访问http://localhost:4000 查看一篇博客，可以看到我们的分享功能已经集成到博客上面去了
![](http://7xqlat.com1.z0.glb.clouddn.com/duoshuo_5.png)

到这里，留言、分享功能就已经全部集成到我们的博客上面去了。