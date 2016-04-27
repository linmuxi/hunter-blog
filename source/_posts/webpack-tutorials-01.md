---
title: webpack入门教程
date: 2016-04-13 09:23:49
tags: [webpack]
categories: [技术]
description: webpack入门
keywords: webpack
---
本篇是webpack的入门教程，通过本教程来引导大家完成一些小例子。
<!--more-->
## **目录**
* 安装webpack
* 使用webpack
* 使用loaders
* 使用developement server

## **安装webpack**
前提是需要已经安装了node.js
~~~js
npm install webpack -g
~~~
进行全局安装，这样webpack命令就可以正常使用了

## **使用webpack**
先创建一个空目录
在目录下创建如下文件：
add entry.js
~~~js
document.write("hello world");
~~~

add index.html
~~~html
<html>
    <head>
        <meta charset="utf-8">
    </head>
    <body>
        <script type="text/javascript" src="bundle.js" charset="utf-8"></script>
    </body>
</html>
~~~

接下来运行程序:
~~~
webpack ./entry.js bundle.js
~~~
程序会完成编译并创建一个bundle.js文件.
如果程序运行成功你就能看到如下显示：
~~~
Hash: ac9248475027b987a559
Version: webpack 1.12.15
Time: 39ms
    Asset     Size  Chunks             Chunk Names
bundle.js  1.42 kB       0  [emitted]  main
   [0] ./entry.js 30 bytes {0} [built]
~~~

在浏览器中打开index.html，页面会显示
> hello world

接下来，我们将一部分代码移到外部文件中.
add content.js
~~~js
module.exports = "hello world from content.js";
~~~

update entry.js
~~~js
- document.write("hello world");
+ document.write(require("./content.js"));
~~~

接着重新编译：
~~~js
webpack ./entry.js bundle.js
~~~

刷新浏览器你应该能看到：
> hello world from content.js

## **使用loaders**
接下来我们想添加一个css文件到我们的程序中。

webpack默认只能处理JavaScript文件，所以我们需要使用`css-loader`和`style-loader`来处理css文件。

运行`npm install css-loader style-loader`进行安装加载器。

接下来我们做如下操作：
add style.css
~~~css
body{
	background:#FF0000;
}
~~~

update entry.js
~~~js
+ require("!style!css!./style.css");
  document.write(require("./content.js"));
~~~

重新运行编译并刷新浏览器，你应该能看到浏览器输出`hello world from content.js`并且背景是红色;


在上面entry.js文件中`require("!style!css!./style.css");`表示使用style和css加载器来加载style.css文件,如果我们不想在文件中指定加载器，可以这样做：

update entry.js
~~~js
- require("!style!css!./style.css");
+ require("./style.css");
  document.write(require("./content.js"));
~~~

运行编译：
~~~js
webpack ./entry.js bundle.js --module-bind "css=style!css"
~~~

> 注意上面必须是双引号

运行的结果和之前是一样的


接下来我们将配置项移到一个配置文件中：
add webpack.config.js
~~~js
module.exports = {
    entry: "./entry.js",
    output: {
        path: __dirname,
        filename: "bundle.js"
    },
    module: {
        loaders: [
            { test: /\.css$/, loader: "style!css" }
        ]
    }
};
~~~

现在我们运行编译：
~~~js
webpack
~~~
编译输出：
~~~
Hash: ac9248475027b987a559
Version: webpack 1.12.15
Time: 39ms
    Asset     Size  Chunks             Chunk Names
bundle.js  1.42 kB       0  [emitted]  main
   [0] ./entry.js 30 bytes {0} [built]
   ...
~~~

> webpack命令会尝试在当前目录加载**webpack.config.js**文件


### 输出设置
如果项目编译是时间比较长，我们想显示进度条，可以通过如下配置：
~~~js
webpack --progress --colors
~~~

### 监视模式
我们不想当文件发生改变每次都要重新进行编译。可以通过如下配置：
~~~js
webpack --progress --colors --watch
~~~


## **使用developement server**
先安装
~~~
npm install webpack-dev-server -g
~~~

然后运行
~~~
webpack-dev-server --progress --colors
~~~

通过http://localhost:8080/webpack-dev-server/bundle 来访问；

> 服务以监控模式在运行。


### 参考
[webpack.github.io](http://webpack.github.io/docs/tutorials/getting-started)