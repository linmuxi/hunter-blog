---
title: Hexo生成静态文件异常分析
tags: [Hexo]
categories: [技术]
---
关闭Hexo默认highlight代码高亮，执行`hexo g`生成静态文件，出现异常：`FATAL Template render error: tag name expected`
<!--more-->

**前言**
想利用Google Code Prettify代码高亮来取代Hexo默认的highlight代码高亮，在修改全局配置文件_config.yml的highlight为false之后运行`hexo g`生成静态文件,结果出现异常：`FATAL Template render error: tag name expected`

**原因**
在文章内容中出现了下面两种情况：
`# }` #和}之间没有空格导致

`{ %` {和%之间没有空格导致
