---
title: 使用Flex4接受Red5服务器上的实时流数据
date: 2016-02-01 15:53:21
tags: [Flex4,Red5]
categories: [技术]
---
这篇主要分享如何使用Flex4从Red5服务器上接受实时流数据。
<!--more-->
关于Flex环境搭建和Red5服务器的部署和操作，不在本篇介绍范围内。

具体操作代码比较简单，关键点都有中文注释，Flex代码如下：
~~~
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" 
               xmlns:s="library://ns.adobe.com/flex/spark" 
               xmlns:mx="library://ns.adobe.com/flex/mx" minWidth="955" minHeight="600">
    <fx:Declarations>
        <!-- 将非可视元素（例如服务、值对象）放在此处 -->
    </fx:Declarations>
    <fx:Script>
        <![CDATA[
            
            var rtmpURL:String = "rtmp://192.168.1.103/mystream";
            var conn:NetConnection = new NetConnection();
            var netstream:NetStream;
            var video:Video;
            
            function connServer(e:MouseEvent):void{
                conn.connect(rtmpURL);
                conn.addEventListener(NetStatusEvent.NET_STATUS,netStatusHandler);
            }
            
            function netStatusHandler(e:NetStatusEvent):void{
                switch(e.info.code){
                    case "NetConnection.Connect.Success":{
                        connStream();
                    }
                    case "NetStream.Play.StreamNotFound":{
                        
                    }
                }
            }
            
            function connStream():void{
                netstream = new NetStream(conn);
                netstream.play("hunter");//如果是实时流这里文件后缀不要
                video = new Video(300,200);
                video.attachNetStream(netstream);
                vd.addChild(video);
            }
        ]]>
    </fx:Script>
    <s:Button label="查看视频" x="20" y="30" click="this.connServer(event)" />
    <!-- 
    <s:VideoPlayer x="21" y="59" id="vp"></s:VideoPlayer>
    -->
    <s:VideoDisplay x="21" y="59" id="vd">
    </s:VideoDisplay>
</s:Application>
~~~