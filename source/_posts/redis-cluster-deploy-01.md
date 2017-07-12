---
title: Redis集群配置说明
date: 2017-03-07 11:41:27
tags: [redis]
categories: [技术]
keywords: redis
---

#### 环境说明 ####
redis版本：3.2.8
两台ubuntu，IP分别是：172.28.23.4、172.28.23.83，下面简称为ubuntuA、ubuntuB
分别在ubuntuA和ubuntuB上面运行3个redis实例

#### 环境准备 ####
1、下载解压redis
~~~shell
cd /opt
wget http://download.redis.io/releases/redis-3.2.8.tar.gz
tar -zxf redis-3.2.8.tar.gz
~~~

2、编译安装
~~~
cd redis-3.2.8
make && make install
~~~
安装完成后可以运行make test检查安装是否正确

3、ruby运行环境安装
因为后面我们需要使用到redis提供的redis-trib.rb来进行集群节点操作，该脚本是用ruby语言编写，所以需要先安装ruby运行环境
~~~
apt-get update
apt-get install ruby
gem install redis
~~~

<!--more-->

#### 实战操作 ####

1、创建redis节点目录
step1.在ubuntuA上redis根目录下创建redis_cluster目录
~~~
cd redis-3.2.8
mkdir redis_cluster
~~~

step2.在redis_cluster目录下分别创建8001、8002、8003目录，并将redis根目录下的redis.conf复制到这三个目录下
~~~
cd redis_cluster
mkdir 8001 8002 8003
cp ../redis.conf 8001
cp ../redis.conf 8002
cp ../redis.conf 8003
~~~

step3.分别修改这三个目录下redis.conf配置文件内容如下：
~~~
bind 127.0.0.1 172.28.23.4
protected-mode no
port 8001  # 8002 8003
appendonly yes
cluster-enabled yes
cluster-config-file nodes-8001.conf #nodes-8002.conf nodes-8003.conf 文件会自动生成，无需创建
cluster-node-timeout 15000 # 节点请求超时时间，默认15秒
~~~

step4.在ubuntuB上的操作同上面的步骤，只需修改为对应的9001 9002 9003即可

2、启动redis节点
在ubuntuA上面执行
~~~
cd /opt/redis-3.2.8/redis_cluster
redis-server 8001/redis.conf
redis-server 8002/redis.conf
redis-server 8003/redis.conf
~~~

在ubuntuB上面执行
~~~
cd /opt/redis-3.2.8/redis_cluster
redis-server 9001/redis.conf
redis-server 9002/redis.conf
redis-server 9003/redis.conf
~~~

3、检查redis节点启动情况
~~~
ps -ef |grep redis
~~~

4、搭建集群
目前我们已经在两台机器上运行了6个redis节点实例，接下来我们利用这些redis实例来创建集群。
通过利用redis提供的工具redis-trib.rb可以很轻松的完成集群的搭建
创建集群命令如下：
~~~

./redis-trib.rb create --replicas 1 172.28.23.4:8001 172.28.23.4:8002 172.28.23.4:8003 172.28.23.83:9001 172.28.23.83:9002 172.28.23.83:9003

~~~

运行如上命令之后，redis会响应如下内容：
![](http://7xqlat.com1.z0.glb.clouddn.com/redis-create-cluster-01.png)
redis会根据当前运行的redis实例自动分配master和slave节点，从图中可以看出，172.28.23.4:8001 172.28.23.83:9001 172.28.23.4:8002这三个实例为master节点，其余三个实例为对应的slave节点，还显示主从对应关系及具体hash槽分配情况
如果我们接受redis的分配，输入yes即可

5、检查集群节点运行状态
~~~
./redis-trib.rb check 172.28.23.4:8003
~~~

6、连接集群操作
~~~
redis-cli -h 172.28.23.4 -p 8003 -c
~~~
连接集群和连接普通redis实例不一样，一定要带参数-c；不然连接到实例之后进行操作会报错：(error)MOVED 5798 ip:port



#### 其他操作 ####
1、往集群中添加新的节点
~~~
./redis-trib.rb add-node 新节点IP:端口 已存在的节点IP:端口
~~~

2、往集群中添加slave节点
~~~
./redis-trib.rb add-node --slave 新节点IP:端口 已存在的节点IP:端口
~~~

3、从集群中移除节点
~~~
./redis-trib del-node 127.0.0.1:7000 `<node-id>`
~~~

#### 可能出现的问题 ####
Q1：运行redis-trib.rb脚本创建集群报错：
node 172.28.22.72:8001 is not empty. either the node already knows other nodes(check with cluster nodes) or contains some key in database 0
A1：三步走
1、redis-cli -h ip -p port
2、flushdb
3、删除aof、rdb、nodes.conf文件

Q2：输入yes之后，如果一直停留在waiting for the cluster to join。。
A2：表示slave无法连接到master，检查下ip设置是否正确。我遇到的是因为redis.conf中的bind 127.0.0.1 172.28.22.72 把127.0.0.1去掉，只绑定外网ip即可
