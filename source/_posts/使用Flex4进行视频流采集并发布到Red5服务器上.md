---
title: 使用Flex4进行视频流采集并发布到Red5服务器上
date: 2016-02-01 15:52:49
tags: [Flex4,Red5]
categories: [技术]
---
这篇主要分享如何通过Flex4进行本地视频流采集并实时发布到Red5服务器上去。
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
            var con:NetConnection = new NetConnection();
            //Red5服务器流地址
            var rtmpURL:String = "rtmp://192.168.1.103/mystream";
            var netStream:NetStream;
            var video:Video = new Video();
            
            //以实时流形式发布视频流到red5上去
            private function netStatus(e:NetStatusEvent):void{
                if(e.info.code == 'NetConnection.Connect.Success'){
                    //通过netconnection构建netstream
                    netStream = new NetStream(con);
                    //附加视频和音频数据到netstream中
                    netStream.attachCamera(Camera.getCamera());
                    netStream.attachAudio(Microphone.getMicrophone());
                    //以记录方式发布名称为hunter的实时流到Red5流媒体服务器上
                    netStream.publish("hunter","live");
                    //发布之后red5下mystream/streams/下面就会生成hunter.flv文件
                }
            } 
            //打开本地摄像头
            private function openVideo(e:MouseEvent):void{
                //获取本地摄像头数据并附加在video对象上
                video.attachCamera(Camera.getCamera());
                video.width = 300;
                video.height = 200;
                //video附加在videoDisplay上显示
                vd.addChild(video);
            }
            
            private function publishRed5Server(e:MouseEvent):void{
            	//连接到Red5服务器上
                con.connect(rtmpURL);
                //监听连接状态
                con.addEventListener(NetStatusEvent.NET_STATUS,netStatus);
            }
            
            //进行录像
            private function recordVideo(e:MouseEvent):void{
                //先停止以前实时流模式，重启发布记录流模式
                netStream.close();
                netStream.publish("hunter","record");
            }
            
            private function stopPublish(e:MouseEvent):void{
                netStream.close();
            }
        ]]>
    </fx:Script>
    <s:Button x="11" y="10" label="打开视频" click="this.openVideo(event)" />
    <s:Button x="89" y="10" label="发布视频" click="this.publishRed5Server(event)"/>
    <s:Button x="167" y="10" label="录制视频" click="this.recordVideo(event)"/>
    <s:Button x="254" y="10" label="停止发布" click="this.stopPublish(event)" />
    <s:VideoDisplay id="vd" x="11" y="52" width="300" height="200" />
    <!--    
    <mx:UIComponent id="videoCan" x="10" y="258" width="300" height="200">
    </mx:UIComponent>
    -->
</s:Application>
~~~