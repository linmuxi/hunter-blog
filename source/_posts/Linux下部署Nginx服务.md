---
title: Linux下部署Nginx服务
date: 2016-02-01 11:21:12
tags: [Linux,Nginx]
categories: [技术]
---
这篇主要分享下如何在Linux下部署Nginx服务。
<!--more-->
Linux环境使用的Ubuntu15.10,使用的Root账户进行安装的。

安装说明：Nginx需要依赖pcre和zlib模块，请大家自行安装，没有安装也没有关系，下面会介绍到如何进行安装的。

1.下载Nginx
到[Nginx官网](http://nginx.org)下载Nginx软件，我下载的版本是1.9.10
![Ng版本](http://7xqlat.com1.z0.glb.clouddn.com/ng_version.png)

2.切换到root账户，输入命令：`sudo su`，接着根据提示输入当前账户密码回车

3.解压Nginx
输入命令：`tar -zxvf nginx-1.9.10.tar.gz`

3。进入nginx解压目录
输入命令：`cd nginx-1.9.10`

4.进行Nginx配置
输入命令：`./configure`
<br/>
<font color="red">注意：Ng是需要依赖PCRE模块和zlib模块的，如果没有安装，这里会配置失败。</font>

出现下面的信息，则表示缺少pcre模块:
![缺少pcre导致配置失败](http://7xqlat.com1.z0.glb.clouddn.com/ng_configure_error_1.png)

我们现在需要[下载](http://sourceforge.net/projects/pcre/files/pcre/)PCRE库,这里我下载的版本是8.38
![PCRE](http://7xqlat.com1.z0.glb.clouddn.com/pcre_version.png)

解压PCRE库,输入命令:`tar -jxvf pcre-8.38.tar.bz2`
进入到pcre解压目录,输入命令：`cd pcre-8.38`
进行PCRE配置，输入命令：`./configure`
进行PCRE编译，输入命令：`make`
进行PCRE安装，输入命令：`make install`
到这里PCRE就安装完成了。

出现下面的信息，则表示缺少zlib模块:
![缺少zlib导致配置失败](http://7xqlat.com1.z0.glb.clouddn.com/ng_configure_error_2.png)

我们现在需要[下载](http://sourceforge.net/projects/libpng/files/zlib/1.2.8/zlib-1.2.8.tar.gz)zlib库,这里我下载的版本是1.2.8
![PCRE](http://7xqlat.com1.z0.glb.clouddn.com/zlib_version.png)

解压zlib库,输入命令:`tar -zxvf zlib-1.2.8.tar.gz`
进入到zlib解压目录,输入命令：`cd zlib-1.2.8`
进行zlib配置，输入命令：`./configure`
进行zlib编译，输入命令：`make`
进行zlib安装，输入命令：`make install`
到这里zlib就安装完成了。

接着，我们重新切换到nginx解压目录，执行`./configure`,

出现下面截图就表示配置成功
![配置成功](http://7xqlat.com1.z0.glb.clouddn.com/ng_configure_success.png)

5.执行编译
输入命令：`make`

6.执行安装
输入命令：`make install`

到这里我们Ng就安装成功了
![Ng安装成功-查看版本](http://7xqlat.com1.z0.glb.clouddn.com/ng_install_success_01.png)

7.启动Ng
进入到Ng的安装目录,输入命令:`cd /usr/local/nginx/sbin`
启动Ng，输入命令：`./nginx`

8.重启Ng
输入命令：`./nginx -s reload`

9.验证配置文件是否正确
输入命令：`./nginx -t`

10.关闭ng
查询ng进程号,输入命令：`ps -ef | grep nginx`
正常停止： `kill -quit 进程号`
快速停止：`kill -term 进程号`
强制停止：`kill -9 进程号`

** 示例 **
我们利用Ng为两台应用服务器配置负载均衡,两台服务器的访问地址分别是：
http://192.168.100.101:8080
http://192.168.100.101:8081

第一步：进行nginx.conf文件配置。
1、在#gzip on下面新增
~~~nginx
upstream local_ng_01{
	server 192.168.100.101:8080;
	server 192.168.100.102:8080;
}
~~~
2、修改Server的配置
~~~nginx
server {
    listen       80;
    server_name  192.168.100.88;
	location / {
        root   html;
        index  index.html index.htm;
    	proxy_pass http://local_ng_01;
    }
}
~~~

这样我们在访问192.168.100.88的时候，请求会被均衡到101和102两台服务器上去了

完整nginx.conf配置：
~~~nginx
#user  nobody;
worker_processes  4;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  2048;
}

http {
    include       mime.types;
    default_type  application/octet-stream;

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  logs/access.log;
    client_header_timeout 3m;
    client_body_timeout 3m;
    send_timeout 3m;

    client_header_buffer_size 1k;

    sendfile        on;
    tcp_nopush     on;
    tcp_nodelay on;

    #keepalive_timeout  0;
    #keepalive_timeout  65;

    #gzip  on;

	upstream local_ng_01{
		server 192.168.100.101:8080;
		server 192.168.100.102:8080;
	}

    server {
        listen       80;
   		server_name  192.168.100.88;

        #charset koi8-r;

        #access_log  logs/host.access.log  main;

		location / {
	        root   html;
	        index  index.html index.htm;
	    	proxy_pass http://local_ng_01;
	    }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }

        # proxy the PHP scripts to Apache listening on 127.0.0.1:80
        #
        #location ~ \.php$ {
        #    proxy_pass   http://127.0.0.1;
        #}

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #    root           html;
        #    fastcgi_pass   127.0.0.1:9000;
        #    fastcgi_index  index.php;
        #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
        #    include        fastcgi_params;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #    deny  all;
        #}
    }


    # another virtual host using mix of IP-, name-, and port-based configuration
    #
    #server {
    #    listen       8000;
    #    listen       somename:8080;
    #    server_name  somename  alias  another.alias;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}


    # HTTPS server
    #
    #server {
    #    listen       443 ssl;
    #    server_name  localhost;

    #    ssl_certificate      cert.pem;
    #    ssl_certificate_key  cert.key;

    #    ssl_session_cache    shared:SSL:1m;
    #    ssl_session_timeout  5m;

    #    ssl_ciphers  HIGH:!aNULL:!MD5;
    #    ssl_prefer_server_ciphers  on;

    #    location / {
    #        root   html;
    #        index  index.html index.htm;
    #    }
    #}
}
~~~

最后，一开始我将Nginx是部署在Windows上的，测试的时候，性能反而比直接访问应用服务器还要慢，不明白为何还要弄个windows版本的ng出来，所以还是让ng静静的运行在linux上吧

<!-- 切换到root账户
sudo su

删除目录
rm -rf

删除文件
rm -f -->