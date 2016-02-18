---
title: 读Hexo源码第二节
date: 2016-02-17 09:12:56
tags: [Hexo]
categories: [技术]
---
在[上一篇](https://linmuxi.github.io/hunter-blog/2016/02/16/hexo-source-analy-01/)中已经介绍了Hexo-cli是如何加载到Hexo模块的，这篇着重分析下Hexo模块代码。
<!--more-->

**hexo-cli/lib/index.js**
loadHexoModule方法
主要是加载Hexo模块并实例化Hexo对象
~~~js
function loadHexoModule(path, args) {
  var modulePath = pathFn.join(path, 'node_modules', 'hexo');

  try {
    //加载Hexo模块(\hexo\lib\hexo\index.js),关于这里是如何加载到的，上一篇文章“读Hexo源码第一节”已经做了说明
    var Hexo = require(modulePath);
    //Hexo模块构造函数下面有介绍
    var hexo = new Hexo(path, args);
    log = hexo.log;

    return runHexoCommand(hexo, args);
  } catch (_) {
    log.error('Local hexo not found in %s', chalk.magenta(tildify(path)));
    log.error('Try running: \'npm install hexo --save\'');
    process.exit(2);
  }
}
~~~

runHexoCommand方法
主要是调用init方法进行初始化以及调用call方法去处理输入的命令
~~~js
function runHexoCommand(hexo, args) {
  //调用hexo模块的init方法,init内容在下面介绍
  return hexo.init().then(function() {
    var cmd = args._.shift();

    if (cmd) {
      var c = hexo.extend.console.get(cmd);
      if (!c) cmd = 'help';
    } else if (args.v || args.version) {
      cmd = 'version';
    } else if (args.consoleList) {
      return console.log(Object.keys(hexo.extend.console.list()).join('\n'));
    } else if (args.completion) {
      return completion(args);
    } else {
      cmd = 'help';
    }

    watchSignal(hexo);
    
    //调用hexo模块的call方法，具体内容在下面介绍
    return hexo.call(cmd, args).then(function() {
      return hexo.exit();
    }).catch(function(err) {
      return hexo.exit(err).then(function() {
        handleError(err);
      });
    });
  });
}
~~~

**hexo/lib/hexo/index.js**
关于hexo模块，着重看下构造函数、init、call方法

Hexo构造函数
~~~js
function Hexo(base, args) {
  //获取当前路径 E:\demo\hexo\source_analy
  base = base || process.cwd();
  args = args || {};

  //Hexo继承EventEmitter,使其拥有事件绑定和触发的能力。配合构造函数下面的代码require('util').inherits(Hexo, EventEmitter);
  EventEmitter.call(this);

  //设置目录名称
  this.base_dir = base + sep;
  this.public_dir = pathFn.join(base, 'public') + sep;
  this.source_dir = pathFn.join(base, 'source') + sep;
  this.plugin_dir = pathFn.join(base, 'node_modules') + sep;
  this.script_dir = pathFn.join(base, 'scripts') + sep;
  this.scaffold_dir = pathFn.join(base, 'scaffolds') + sep;
  this.theme_dir = pathFn.join(base, 'themes', defaultConfig.theme) + sep;
  this.theme_script_dir = pathFn.join(this.theme_dir, 'scripts') + sep;

  this.env = {
    args: args,
    debug: Boolean(args.debug),
    safe: Boolean(args.safe),
    silent: Boolean(args.silent),
    env: process.env.NODE_ENV || 'development',
    version: pkg.version,
    init: false
  };

  //全局配置文件_config.yml路径
  this.config_path = args.config ? pathFn.resolve(base, args.config)
                                 : pathFn.join(base, '_config.yml');
  
  //下面的模块都提供了register方法，在hexo的init方法中会将nodejs模块注册到下面对应的模块中去
  this.extend = {
    //注册控制台相关命令
    console: new extend.Console(),
    //注册项目部署操作
    deployer: new extend.Deployer(),
    filter: new extend.Filter(),
    generator: new extend.Generator(),
    helper: new extend.Helper(),
    migrator: new extend.Migrator(),
    processor: new extend.Processor(),
    renderer: new extend.Renderer(),
    //采用Nunjucks渲染标签
    tag: new extend.Tag()
  };

  //设置全局配置文件_config.yml
  this.config = _.clone(defaultConfig);

  this.log = createLogger(this.env);

  //提供render方法渲染数据或文件，具体内部还是调用this.extend.renderer注册的相关对象
  this.render = new Render(this);

  //提供format方法处理url请求地址，在生成静态文件(hexo/lib/plugins/console/generate.js)的时候会调用里面的方法
  this.route = new Router();

  //提供create、render、publish方法，主要用于文章的创建和渲染以及将草稿文章发布成正式文章,具体内部还是调用了this.extend.renderer、this.extend.filter、this.extend.tag注册的相关对象
  this.post = new Post(this);

  this.scaffold = new Scaffold(this);

  //默认db.json未加载
  this._dbLoaded = false;

  //默认静态文件未生成
  this._isGenerating = false;

  this.database = new Database({
    version: dbVersion,
    path: pathFn.join(base, 'db.json')
  });

  //初始化Schema模型并存储到database中
  registerModels(this);

  this.source = new Source(this);
  this.theme = new Theme(this);
  this.locals = new Locals(this);
  this._bindLocals();
}
~~~

**init方法**
~~~js
Hexo.prototype.init = function(){
  var self = this;

  this.log.debug('Hexo version: %s', chalk.magenta(this.version));
  this.log.debug('Working directory: %s', chalk.magenta(tildify(this.base_dir)));

  // Load internal plugins
  //注册Hexo控制台命令到this.extend.console模块中，例如我们用到的hexo clean & hexo g & hexo d ...
  require('../plugins/console')(this);
  //注册到this.extend.filter模块中,具体功能下面分析
  require('../plugins/filter')(this);
  require('../plugins/generator')(this);
  //注册到this.extend.helper模块中，提供了我们可以使用到的帮助标签，例如：link_to、image_tag、tagcloud等等，详情见：hexo/lib/plugins/helper/index.js
  require('../plugins/helper')(this);
  require('../plugins/processor')(this);
  //注册到this.extend.renderer模块中,提供了对html、css、js、json、swig、yml等语法的解析方法
  require('../plugins/renderer')(this);
  //注册到this.extend.tag模块中，提供对"{ % % }"语法的解析，详情见：hexo/lib/plugins/tag/index.js
  require('../plugins/tag')(this);

  // Load config
  return Promise.each([
    'update_package', // Update package.json
    'load_config', // Load config
    'load_plugins' // Load external plugins & scripts
  ], function(name){
    return require('./' + name)(self);
  }).then(function(){
    return self.execFilter('after_init', null, {context: self});
  }).then(function(){
    // Ready to go!
    self.emit('ready');
  });
};
~~~

**call方法**
~~~
Hexo.prototype.call = function(name, args, callback){
  if (!callback && typeof args === 'function'){
    callback = args;
    args = {};
  }

  var self = this;

  return new Promise(function(resolve, reject){
    //根据控制台输入的参数到Hexo.extend.console中获取到对应的js模块
    var c = self.extend.console.get(name);

    if (c){
      //调用对应参数的js模块
      c.call(self, args).then(resolve, reject);
    } else {
      reject(new Error('Console `' + name + '` has not been registered yet!'));
    }
  }).nodeify(callback);
};
~~~

hexo/lib/plugins/filter模块
~~~js
module.exports = function(ctx){
  var filter = ctx.extend.filter;
  //对文章中的摘要进行处理，即<!--more-->
  require('./after_post_render')(ctx);
  //处理代码高亮和将标题首字母转大写
  require('./before_post_render')(ctx);
  //保存database中的数据到db.json
  require('./before_exit')(ctx);
  //渲染文章内容
  require('./before_generate')(ctx);
  //模版本地化(i18n)
  require('./template_locals')(ctx);

  filter.register('new_post_path', require('./new_post_path'));
  filter.register('post_permalink', require('./post_permalink'));
};
~~~



<!--Hexo相关Node.js库

bluebird：github.com/petkaantonov/bluebird
bluebird是一个功能齐全的库,专注于创新的特性和性能

warehouse：github.com/tommy351/warehouse
Hexo使用的数据库

titlecase：首字母转大写

-->