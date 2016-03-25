---
title: 使用gulp来压缩hexo中的静态资源文件
date: 2016-03-25 14:46:40
tags: [gulp,hexo]
categories: [技术]
description: 使用gulp来对hexo生成的html、css、js、png进行压缩
keywords: gulp,hexo
---
标题取的有点模糊不清，主要是想说下如何通过gulp来压缩hexo生成的html、js、css、png内容
<!--more-->
## 前言
gulp：基于nodejs流的自动化构建工具
关于gulp的介绍与安装请自行参考官网描述，本章不做阐述

## 步骤
### Step1：hexo根目录新增gulpfile.js文件
~~~js
var gulp = require('gulp');
//html压缩
var htmlmin = require('gulp-htmlmin');
//js压缩
var jsmin = require('gulp-jsmin');
//文件重命名
var rename = require('gulp-rename');
//图片压缩png/jpg/gif
var imagemin = require('gulp-imagemin');
//png压缩
var pngquant = require('imagemin-pngquant');
//css压缩
var csso = require('gulp-csso');

var root = "./public";
var buildDir = root;
var datas={
	html:[root+"/**/*.html"],
	image:[root+"/**/*.png"],
	css:[root+"/**/*.css"],
	js:[root+"/**/*.js",'!*min.js']
}

// 压缩html
gulp.task("htmlmin",function(){
	gulp.src(datas.html)
	.pipe(htmlmin({collapseWhitespace:true,minifyJS:true,minifyCSS:true,removeComments:true}))
	.pipe(gulp.dest(buildDir));
});

// png图片压缩
gulp.task("imagemin",function(){
	gulp.src(datas.image)
	.pipe(imagemin({
		progressive:true,
		svgoPlugins:[{removeViewBox:false}],
		use:[pngquant()] //压缩率64%
	}))
	.pipe(gulp.dest(buildDir));
});

// js压缩
gulp.task("jsmin",function(){
	gulp.src(datas.js)
	.pipe(jsmin())
	//.pipe(rename({suffix:'.min'}))
	.pipe(gulp.dest(buildDir));
});

// css压缩
gulp.task("cssmin",function(){
	gulp.src(datas.css)
	.pipe(csso())
	.pipe(gulp.dest(buildDir));
});

gulp.task("default",["htmlmin","imagemin","jsmin","cssmin"]);

~~~

### Step2：执行命令
~~~
hexo clean
hexo ge
gulp
hexo d
~~~

## 最后
gulp提供了相当多的插件，大家可以自行去了解使用，还是挺好使的

## 参考
[gulp官网](http://gulpjs.com/)
[gulp中文](http://www.gulpjs.com.cn/)

