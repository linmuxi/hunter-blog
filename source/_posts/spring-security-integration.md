---
title: 集成Spring Security
date: 2016-07-04 15:42:25
tags: [Spring]
categories: [技术]
keywords: spring,springSecurity
---
## SpringSecurity说明

Spring Security是一个强大的和高度可定制的身份认证和访问控制框架。
一个能够为基于Spring的企业应用系统提供声明式的安全访问控制解决方案的安全框架。它提供了一组可以在Spring应用上下文中配置的Bean，充分利用了**Spring IoC，DI和AOP**功能，为应用系统提供声明式的安全访问控制功能，减少了为企业系统安全控制编写大量重复代码的工作。

## SpringSecurity核心点

Spring Security核心是他提供的**过滤器**，默认情况下用到了以下过滤器，及通过实例化一个虚拟过滤器链来对这些过滤器进行递归调用，源码如下图：
![SpringSecurity核心](http://7xqlat.com1.z0.glb.clouddn.com/SpringSecurity核心.png)


## 集成代码

集成代码已经托管到**[github](https://github.com/linmuxi/SpringSecurity.git)**上，Spring Security版本是**3.2.0**，项目结构是**Maven**


