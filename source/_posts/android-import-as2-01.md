---
title: 利用Android Studio2.0导入Eclipse项目
date: 2016-05-12 14:30:50
tags: [AndroidStudio2.0]
categories: [技术]
description: 利用Android Studio2.0导入Eclipse项目
keywords: AndroidStudio
---
Android Studio2.0以及能够很友好的支持Eclipse项目导入。
当选择Import Project，Android Studio2.0会自动添加Gradle相关支持，我们要做的是对相关的SDK、BuildTools、JDK版本做下适当配置即可。

不过，如果选择Project from Version Control从版本控制中导入项目时，AS不会添加Gradle相关支持。所以这里可以先从版本库中将代码Check Out到本地，然后利用Import Project导入即可。





