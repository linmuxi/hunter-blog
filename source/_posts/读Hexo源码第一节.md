---
title: 读Hexo源码第一节
date: 2016-02-16 14:40:55
tags: [Hexo]
categories: [技术]
---
Hexo使用已经有几天了，昨天想对Hexo的代码做高亮配置，修改了_config.yml的highlight为false，结果在生成静态文件的时候报错，由于对Hexo内部运转不是太清楚，为了解决这个问题，我不得不深入研究下Hexo的源码来了解其运行过程。
<!--more-->
hexo-cli安装完成后，需要进行环境变量配置，这样我们才能在dos中使用hexo命令。
我这里的nodejs是安装在E:\opensource\nodejs目录下面,那么需要把E:\opensource\nodejs配置到path变量中。

我们在dos中执行：`hexo help`，其实是调用E:\opensource\nodejs目录下面的hexo.cmd批处理文件。

**hexo.cmd**
~~~bash
rem 先判断当前目录下是否存在node.exe
@IF EXIST "%~dp0\node.exe" (
  rem 存在则调用当前目录下面的node_modules\hexo-cli\bin\hexo 模块
  "%~dp0\node.exe"  "%~dp0\node_modules\hexo-cli\bin\hexo" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\node_modules\hexo-cli\bin\hexo" %*
)
~~~

**hexo模块**
~~~bash
#!/usr/bin/env node

'use strict';
//调用上一层目录lib(执行下面的index.js文件)
require('../lib')();
~~~

lib目录结构：
* lib
	* index.js
	* find_pkg.js
	* completion.js
	* logger.js
	* goodbye.js
	* console
		* index.js
		* init.js
		* version.js
		* help.js

**lib/index.js文件**
主要是调用find_pkg模块进行package.json的查找
~~~js
exports = module.exports = function() {
  //调用find_pkg模块进行包查找
  return findPkg(cwd, args).then(function(path) {
    //如果当前目录不存在则调用hexo-cli命令输出
    if (!path) return runCLICommand(args);
    //如果找到了指定的包加载Hexo模块
    return loadHexoModule(path, args);
  }).catch(handleError);
};
~~~

**lib/find_pkg.js**
主要是查找当前目录下的package.json文件
~~~js
function findPkg(path) {
  //查找当前目录下面的package.json,例如：E:/demo/nodejs/pakcage.json
  var pkgPath = pathFn.join(path, 'package.json');

  return fs.exists(pkgPath).then(function(exist) {
    //如果找到了package.json则检查是否是hexo包声明
    return exist ? checkPkg(pkgPath) : false;
  }).then(function(exist) {
    if (exist) return path;
	//如果没有找到，则往上一目录进行查找
    var parent = pathFn.dirname(path);
    if (parent === path) return;

    return findPkg(parent);
  });
}
~~~

假设我们的hexo环境已经配置好，通过find_pkg模块已经查找到了package.json，接着会加载Hexo模块
<!-- 新建一个目录E:/demo/hexo/source_analy,切换当前路径到该目录下面，然后执行:`hexo init & npm install hexo --save`。 -->
~~~js
function loadHexoModule(path, args) {
  var modulePath = pathFn.join(path, 'node_modules', 'hexo');

  try {
    //请求当前目录下面的/node_modules/hexo模块,这里我的全路径是：E:\demo\hexo\source_analy\node_modules\hexo
    var Hexo = require(modulePath);
	if(1==1){return;}
    var hexo = new Hexo(path, args);
    log = hexo.log;
	//处理hexo命令
    return runHexoCommand(hexo, args);
  } catch (_) {
    log.error('Local hexo not found in %s', chalk.magenta(tildify(path)));
    log.error('Try running: \'npm install hexo --save\'');
    process.exit(2);
  }
}
~~~
上面代码中require(modulePath)中modulePath是一个目录地址，不是js文件，下面没有index.js文件，这里是如何识别他是一个nodejs模块的呢。这就要看该目录下面的package.json文件了,在大概116行，其实是通过这里的main指定了node模块的。
~~~json
"main": "lib/hexo"
~~~

