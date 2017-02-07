---
title: '设计模式の构造器'
date: 2016-07-18 14:42:04
tags: [设计模式]
categories: [技术]
description: 设计模式の构造器
keywords: 设计模式,构造器,builder
---
本篇分享有点逼格的实例化javabean的方式
<!--more-->

一般实例化javabean有如下两种方式：

### **构造器**
~~~java
User user = new User(...);
~~~
优点：代码行数较少
缺点：参数设置不够灵活


### **SET方法**
~~~java
User user = new User();
user.setXX(..);
user.setXX(..);
user.setXX(..);
user.setXX(..);
user.setXX(..);
user.setXX(..);
~~~
优点：参数设置灵活
缺点：代码行数较多


通过构造器模式可以兼容以上两种方式优点。

使用：
~~~java
User user = new User.Builder().id(1).name("hunter").age(27).build(); 
~~~

定义：
~~~java
package build;

public class User {

	private final int id;
	private final String name;
	private final int age;

	public User(int id, String name, int age) {
		super();
		this.id = id;
		this.name = name;
		this.age = age;
	}

	public int getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public int getAge() {
		return age;
	}

	public static class Builder {
		private int id;
		private String name;
		private int age;

		public Builder id(int id){
			this.id = id;
			return this;
		}
		public Builder name(String name){
			this.name = name;
			return this;
		}
		public Builder age(int age){
			this.age = age;
			return this;
		}
		
		public User build(){
			return new User(this.id,this.name,this.age);
		}
	}
}

~~~

当然也有缺点：
1、bean定义相比以上两种略显复杂
2、而外的内存开销(builder对象)
