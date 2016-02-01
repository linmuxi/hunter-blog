---
title: 'Tomcat配置SSL,支持HTTPS访问'
date: 2016-02-01 15:29:36
tags: [Tomcat,HTTPS,SSL]
categories: [技术]
---
这篇主要分享在Tomcat上配置SSL，开启HTTPS访问。
<!--more-->
第一步：通过keytools生成秘钥
输入命令：keytool -genkey -alias hunter -keyalg RSA
会在用户目录下面创建一个.keystore的文件

第二步：修改tomcat\config\server.xml文件
~~~
<Connector port="8443" protocol="org.apache.coyote.http11.Http11Protocol"
maxThreads="150" SSLEnabled="true" scheme="https" secure="true"
clientAuth="false" sslProtocol="TLS" keystorePass="这里是第一步配置的是keystore密码" />
~~~

到这里，就可以通过https://localhost:8443/ 进行访问了，当然也还是可以通过http://localhost:8080/ 进行访问,不过通过后者访问就不是基于https协议了。

通过下面的配置，能让http访问自动转换到https协议上去进行访问:
修改应用服务web.xml文件
~~~
<security-constraint>
    <web-resource-collection>
        <web-resource-name>securedapp</web-resource-name>
        <url-pattern>/*</url-pattern>
    </web-resource-collection>
    <user-data-constraint>
        <transport-guarantee>CONFIDENTIAL</transport-guarantee>
    </user-data-constraint>
</security-constraint>
~~~
将 URL 映射设为 /* ，这样整个应用都要求是 HTTPS 访问，而 transport-guarantee 标签设置为 CONFIDENTIAL 以便使应用支持 SSL。
如果你希望关闭 SSL ，只需要将 CONFIDENTIAL 改为 NONE 即可。

最后，让http访问自动转换到https协议，据说还有一种配置服务器响应strict-transport-security报文，还未测试，可以[参考](http://www.2cto.com/Article/201505/398588.html)说明

<!-- 
http自动跳转https访问的第二种方式：
服务器响应strict-transport-security报文 （未测试）
http://www.2cto.com/Article/201505/398588.html

思考：

第一种，可能是请求到了服务器之后，由服务器进行转换

第二种，可能是由浏览器来判断进行转换

如果成立，第二种性能要优于第一种？ -->


