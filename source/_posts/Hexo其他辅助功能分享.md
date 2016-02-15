---
# layout: false
title: Hexo其他辅助功能分享
date: 2016-01-29 09:09:50
tags: [Hexo]
categories: [技术]
photos: 
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing1.jpg
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing2.jpg
---
这是关于Hexo的第三篇文章了，这里主要分享下Hexo上一些辅助功能项。
<!--more-->
目录：
    1. fancybox使用
    2. 取消默认hexo处理文件
    3. 文章摘要
    4. 自定义目录
    5. 草稿文章的处理
    6. 百度统计
    7. 自定义挂件
    8. 配置404页面
    9. 图床
    10. 博客访问量统计


** fancybox使用 **
fancybox效果使用，就是在文章头部增加可以切换显示的图片效果，具体效果如下：
![fancybox效果](http://7xqlat.com1.z0.glb.clouddn.com/fancybox1.png)
 
具体配置是在文章头部添加photos配置项：
~~~markdown
---
photos: 
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing1.jpg
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing2.jpg
---
~~~
 
** 取消默认hexo处理文件 **
如果不想让hexo默认处理文章，可以在文章头部定义：layout: false
~~~mardown
---
layout: false
---
~~~
 
** 文章摘要 **
在首页只显示more以上的内容，余文需要点击【> Read More】连接打开全文才能显示，效果如下：
![文章摘要效果](http://7xqlat.com1.z0.glb.clouddn.com/more1.png)
具体配置是使用<!-more-->:
~~~markdown
---
# layout: false
title: Hexo其他辅助功能分享
date: 2016-01-29 09:09:50
tags: [第一次]
categories: [日志,生活]
photos: 
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing1.jpg
- http://7xqlat.com1.z0.glb.clouddn.com/gaoqing2.jpg
---
上面都是在首页显示的摘要信息
<!--more-->
这里是正文信息，只有点击首页的more连接才会显示
~~~

** 自定义目录 ** 
使用命令：`hexo new page about`
在source下面会创建一个about目录，里面有个index.md文件
将自定义目录挂接到博客首页菜单上去，需要在全局配置文件_config.yml中的menu下面新增About: about即可，其中Abount是在页面显示的名称，可自定义，about是新创建的目录，名称必须一致

** 草稿文章的处理 ** 
在source/_drafts目录下面存放的是草稿文章，默认情况下草稿文章是不会发布到博客上面去，可以通过以下两种方式进行发布。
1、修改全局配置文件_config.yml的render_drafts为true，此时文章还在_drafts目录下面
2、可以通过如下命令将文章迁移到_post目录进行发布，此时文章就在_post目录下面了，_drafts目录下就会被删除掉
`hexo publish draft 草稿文件名称`
新增草稿文章有两种方式：
1、自己手动在_drafts目录下新建md文件。
2、通过下面命令来新建
`hexo new draft 草稿名称`

** 百度统计 ** 
百度统计，可以对博客网站的UV、PV等情况进行监控统计。
第一步，需要到[百度统计](http://tongji.baidu.com/web/welcome/login)去注册账户
第二步，登录百度统计管理平台，在网站中心选项卡配置我们的博客地址信息
第三步，获取统计的JS代码
第四步，在themes/主题/layout/_partial目录下面新建baidu_tongji.ejs文件，将复制的统计js代码粘贴进去，可以在主题_config.yml配置文件中定义一个变量来控制是否启用百度统计。
~~~js
<% if(theme.baidu_tongji){ %>
  <!-- baidu统计 -->
  <script>
	var _hmt = _hmt || [];
	(function() {
	  var hm = document.createElement("script");
	  hm.src = "//hm.baidu.com/hm.js?265d75f1ac95ef1760822f57dba2111c";
	  var s = document.getElementsByTagName("script")[0]; 
	  s.parentNode.insertBefore(hm, s);
	})();
	</script>
  <!-- baidu统计end -->
<% } %>
~~~
第五步，编辑同目录下面的head.ejs，在&lt;/head&gt;之前增加代码
~~~html
 <!-- 添加baidu统计 -->
  <%- partial('baidu_tongji') %>
  <!-- end 添加baidu统计 -->
~~~
第六步，发布hexo博客到github，不知道怎么发布可以参看第一篇文章[《使用Hexo在Github上构建免费Blog应用》](http://linmuxi.github.io/hunter-blog/2016/01/27/使用Hexo在Github上构建免费Blog应用/)
第七步，在百度统计管理平台-网站中心去验证下首页代码是否安装正确
第八步，如果安装正确，一般过24小时就可以百度统计就可以采集到博客的统计信息了

** 自定义挂件 ** 
在博客的右边显示了很多挂件，hexo默认提供了5个挂件：分类、最近发布的文章、标签、标签云、查询
自定义挂件第一步在themes/主题/layout/_widget目录下面新建myWidget.ejs文件
~~~html
<div class="widget tag">
  <h3 class="title">自定义挂件</h3>
  <ul class="entry">
  	<li>自定义挂件1</li>
  	<li>自定义挂件2</li>
  	<li>自定义挂件3</li>
  	<li><a href="404">404</a></li>
  </ul>
</div>
~~~
第二步：编辑主题下面的配置文件_config.yml,在widgets变量下面增加新建的自定义挂件ejs文件名
~~~json
widgets:
- search
- category
- tag
- recent_posts
- tagcloud
- myWidget
~~~
第三步：重启服务并访问
其实自定义挂件这里可以放些第三方的小插件等等..

** 配置404页面 ** 
404页面，用于在请求不到对应资源的时候响应给用户的界面。关于404页面，我们可以做的更有意义些，有很多关于404的公益项目，在这里我们选择[腾讯公益404](http://www.qq.com/404/)。
第一步，在blog根目录下面新建404.html，将腾讯公益404js代码粘贴进去
`<script type="text/javascript" src="http://www.qq.com/404/search_children.js" charset="utf-8"></script>`
第二步，发布blog到github上面，本地是无法看到效果的，一定要发布到github上面去。
第三步，[查看效果](http://linmuxi.github.io/hunter-blog/2016/01/29/hello/1)

** 图床 **
之前把所有图片都托管在github上，发现访问有点慢，后来改把所有图片资源都放到[七牛云](https://portal.qiniu.com/signin)上托管了，速度还可以。
七牛注册成功后，会有10GB永久免费存储空间+每月10GB下载流量、10万次PUT请求、100万次Get请求，对于目前个人博客来说已经够用了。在这里我也发一个[七牛邀请码](https://portal.qiniu.com/signup?code=3ldifmoydek42)


先到这里，下面以后再补上
~~** 博客访问量统计 **~~