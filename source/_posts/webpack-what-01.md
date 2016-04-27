---
title: "webpack 是什么？"
date: 2016-04-13 09:15:32
tags: [webpack]
categories: [技术]
description: webpack是什么
keywords: webpack
---
webpack是一个模块打包工具。
<!--more-->
![webpack](http://webpack.github.io/assets/what-is-webpack.png)

### **为什么**
业界已经存在很多模块打包工具,为什么又要做一个出来？

业界存在的模块打包工具都不适合于大型项目（大型单页面应用）. 急欲推出这个模块打包工具是因为它包含了Code Splitting(模块按需加载)和将所有静态资源整合的功能。

作者尝试了去扩展已存在的模块打包工具，但是都不能实现所有目标。

### **目标**
* 将依赖树分割成按需加载
* 保存较短的初始化加载时间
* 所有的静态资源都是一个模块
* 具备集成第三方库的能力
* 具备可定制化的功能
* 适合于大型项目

### **webpack有什么不同**

**Code Splitting**
webpack依赖有同步和异步两种模式，异步依赖会通过一个新chunk来作为分割点，然后循环chunk按需加载。

**Loaders**
webpack默认只能处理JavaScript文件，但是它提供了很多加载器来将其他静态资源转换成JavaScript文件，通过这样做，每个静态资源都是一个模块。

**Clever parsing**
webpack具有一个非常灵活的解析器，能处理差不多每一个第三方库.在依赖中它允许的表达式如：`require("./templates/"+name+".jade")`.它能处理大部分公共模块样式：**CommonJS**和**AMD**

**Plugin system**
webpack具有丰富的插件系统，很多内部特性都是基于这个插件系统。允许自定义插件


### 参考
[webpack.github.io](http://webpack.github.io/docs/what-is-webpack.html)