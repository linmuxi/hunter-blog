---
title: WebApp for Android TV
date: 2016-01-14 12:00:23
tags: [Android,WebApp,JavaScript,Echarts,HTML5]
categories: [技术,工作]
---
一款在TV上显示实时交易数据的android应用
<!--more-->
由于对android这块不是很精通，特别是android做图形化这方面，所以一开始拿到设计效果图就没有考虑用原生android来进行开发，好在项目组也没有做硬性要求。

关于图形报表选择方面，我比较熟悉fusioncharts和echarts，目前个人比较偏向使用echarts，所以就定了这个工具做图形化报表形式。

项目环境是前端我负责，后端其他同事负责，数据交互采用http协议+json格式。

由于页面是采用android的webview嵌入进去的，大家都知道webview的性能确实不咋滴。所以在使用的过程中还是存在很多问题的
1、地图图形上的地理位置光标无法正常闪动，暂时也没能解决
2、动态刷新图表数据的时候，会出现重影问题。
   数据动态刷新是调用echarts的接口方法来实现的，在web浏览器是正常的，但是在tv上就会出现重影的问题，后来没有办法就在每次刷新的时候重新init对象了，问题暂时解决
3、动画效果显示会出现卡顿或不显示的问题，后面直接关掉动画效果

android运行环境：4.4.2

全部代码已经提交到github上：https://github.com/linmuxi/realtimeData

实现之后的效果图：
![交易数据](http://7xqlat.com1.z0.glb.clouddn.com/realtimeData_2016010601.jpg)