# kafka_client

## maven 依赖

pom.xml:

        <dependency>
			<groupId>org.apache.kafka</groupId>
			<artifactId>kafka-clients</artifactId>
			<version>2.1.0</version>
		</dependency>
		

## 安装kafka

[kafka官网](http://kafka.apache.org/)

### 快速开始

1. 下载kafka

目前最新版本是2.2.0

[下载地址](https://www.apache.org/dyn/closer.cgi?path=/kafka/2.2.0/kafka_2.12-2.2.0.tgz)


    > tar -xzf kafka_2.12-2.2.0.tgz
    > cd kafka_2.12-2.2.0

2. 启动zooKeeper服务器

因为kafka的运行需要zookeeper 作节点调度，所以kafka包里有zookeeper服务器的启动脚本,启动单节点的zookeeper实例:

    kafka_2.11-2.2.1> sh ./bin/zookeeper-server-start.sh config/zookeeper.properties
        /Users/sam/Public/bigData/kafka_2.11-2.2.1/bin/kafka-run-class.sh: line 306: /usr/libexec/java_home/bin/java: Not a directory
        /Users/sam/Public/bigData/kafka_2.11-2.2.1/bin/kafka-run-class.sh: line 306: exec: /usr/libexec/java_home/bin/java: cannot execute: Not a directory
        
启动zookeeper服务器报错，说`kafka-run-class.sh`里的java_home找不到，那么vi这个文件进去定位到306行，在226行前一行插入`JAVA_HOME`：

    # Which java to use
    225 JAVA_HOME='/Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home'
    226
    227 if [ -z "$JAVA_HOME" ]; then
    228   JAVA="java"
    229 else
    230   JAVA="$JAVA_HOME/bin/java"
    231 fi
        
        
保存，再次启动zookeeper:

    sh ./bin/zookeeper-server-start.sh config/zookeeper.properties
    
控制台中打印出：
    
    [2019-06-04 15:02:29,345] INFO binding to port 0.0.0.0/0.0.0.0:2181 (org.apache.zookeeper.server.NIOServerCnxnFactory)
    
表示启动成功。
    
    
3. 启动kafka服务器

执行：

        sh bin/kafka-server-start.sh config/server.properties
         
控制台打出：
         
         [2019-06-04 15:07:19,041] INFO Awaiting socket connections on s0.0.0.0:9092. (kafka.network.Acceptor)
         [2019-06-04 15:07:19,068] INFO [SocketServer brokerId=0] Created data-plane acceptor and processors for endpoint : EndPoint(null,9092,ListenerName(PLAINTEXT),PLAINTEXT) (kafka.network.SocketServer)
         
代表启动成功!!
         
4. 写一个生产者test，往kafka服务里写数据
         
看代码。。。。
         
         
5. 写一个消费者服务，从kafka服务里获取生产都的数据，并对数据进行消费
         
看代码
         

         
         
		
		






