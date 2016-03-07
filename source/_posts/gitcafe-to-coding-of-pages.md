---
title: 从GitCafe迁移到Coding
date: 2016-03-07 16:42:45
tags: [Hexo]
categories: [技术]
description: 将Pages从GitCafe迁移到Coding
keywords: hexo,gitcafe,coding
---
在上周，Coding宣布收购Gitcafe，且Gitcafe平台将在5月31日后关闭服务。因为我的博客是部署在Gitcafe上的，所以不得已需要将其迁移到Coding平台上去。整个修改步骤也比较容易。
<!--more-->

### **项目迁移**
我们可以直接将Gitcafe上面的库迁移到Coding上来，也可以重新在Coding上新建库都是可以的。
如果要迁移，官网也提供了一键迁移的操作页面，这里就不描述了。

### **Coding平台**
新建一个分支：**coding-pages**
![](http://7xqlat.com1.z0.glb.clouddn.com/coding_branch.png-hunterblog)

开启Pages服务并绑定自定义域名
![](http://7xqlat.com1.z0.glb.clouddn.com/coding_pages.png-hunterblog)

### **_config.yml**
在全局_config.yml中deploy新增coding节点
~~~
deploy:
  type: git
  repo:
    coding: https://git.coding.net/hunterlin/hunterlin.git,coding-pages
~~~
