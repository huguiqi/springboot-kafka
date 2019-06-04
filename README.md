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
         

         
         
		
## 集成springboot
		
		
以下是springboot版本和kafka对应支持的版本：

![paste image](http://blog.huguiqi.com/1559638747484fxnv4uer.png?imageslim)


pom.xml:

		<dependency>
			<groupId>org.springframework.kafka</groupId>
			<artifactId>spring-kafka</artifactId>
			<version>2.2.4.RELEASE</version>
		</dependency>
        
由于我的spring-boot的版本是：

	2.1.3.RELEASE


查到spring-依赖的版本号：

![paste image](http://blog.huguiqi.com/1559640109584ssafa30k.png?imageslim)

所以就使用2.2.4


## springboot自动配置kafka


[spring-kafka文档](https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-messaging.html#boot-features-kafka)

https://docs.spring.io/spring-boot/docs/current/reference/html/boot-features-messaging.html#boot-features-kafka


(既可以为生产者也可以为消费者)配置文件中：

spring.kafka.bootstrap-servers=localhost:9092
spring.kafka.consumer.group-id=myGroup



发送消息，KafkaTemplate的实例是自动配置的：

    @Component
    public class MyBean {

        @Autowired
        private KafkaTemplate kafkaTemplate;

        @Autowired
        public MyBean(KafkaTemplate kafkaTemplate) {
            this.kafkaTemplate = kafkaTemplate;
        }

        // ...

    }



在本例子项目中，在启动入口时，加入kafka消息发送测试代码：



    package com.example.demo;

    import org.apache.kafka.clients.consumer.ConsumerRecord;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.boot.CommandLineRunner;
    import org.springframework.boot.SpringApplication;
    import org.springframework.boot.autoconfigure.SpringBootApplication;
    import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
    import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
    import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
    import org.springframework.context.ApplicationContext;
    import org.springframework.context.annotation.Bean;
    import org.springframework.kafka.annotation.KafkaListener;
    import org.springframework.kafka.core.KafkaTemplate;

    import java.util.Arrays;
    import java.util.concurrent.CountDownLatch;
    import java.util.concurrent.TimeUnit;

    @SpringBootApplication(exclude = {
            DataSourceAutoConfiguration.class,
            DataSourceTransactionManagerAutoConfiguration.class,
            HibernateJpaAutoConfiguration.class})
    public class Demo1Application {

        public static void main(String[] args) {
            SpringApplication.run(Demo1Application.class, args);
        }



        @Bean
        public CommandLineRunner commandLineRunner(ApplicationContext ctx) {
            return args -> {

                System.out.println("Let's inspect the beans provided by Spring Boot:");

                String[] beanNames = ctx.getBeanDefinitionNames();
                Arrays.sort(beanNames);
                for (String beanName : beanNames) {
                    System.out.println(beanName);
                }

                this.template.send("myTopic", "foo1");
                this.template.send("myTopic", "foo2");
                this.template.send("myTopic", "foo3");
                latch.await(60, TimeUnit.SECONDS);
                System.out.println("All received");
            };
        }


        @Autowired
        private KafkaTemplate<String, String> template;

        private final CountDownLatch latch = new CountDownLatch(3);


        @KafkaListener(topics = "myTopic")
        public void listen(ConsumerRecord<?, ?> cr) throws Exception {
            System.out.println(cr.toString());
            latch.countDown();//调用三次才唤醒
        }

    }




## Kafka Streams (流式处理)


    @Configuration
    @EnableKafkaStreams
    static class KafkaStreamsExampleConfiguration {

        @Bean
        public KStream<Integer, String> kStream(StreamsBuilder streamsBuilder) {
            KStream<Integer, String> stream = streamsBuilder.stream("ks1In");
            stream.map((k, v) -> new KeyValue<>(k, v.toUpperCase())).to("ks1Out",
                    Produced.with(Serdes.Integer(), new JsonSerde<>()));
            return stream;
        }

    }


将topic名为ks1In的流中的value转为大写字母,然后再转到新的topic，kslOut这个topic上去。


如果只是生产者的角色，则springboot项目中配置为：

	spring:
    	kafka:
        	producer: 
            	bootstrap-servers: broke1,broke2
    

如果是消费者，则springboot配置为：


    spring:
      kafka:
        consumer:
          enable-auto-commit: true
          group-id: applog
          auto-offset-reset: latest
          bootstrap-servers: broke1,broke2
      


* enable-auto-commit: true //指定消息被消费之后自动提交偏移量（即消息的编号，表示消费到了哪个位置，消费者每消费完一条消息就会向kafka服务器汇报自己消消费到的那个消息的编号，以便于下次继续消费）。
* group-id: applog //消费者组
* auto-offset-reset: latest //从最近的地方开始消费


你还可以配置kafka的序列化与反序列化：


    spring.kafka.consumer.value-deserializer=org.springframework.kafka.support.serializer.JsonDeserializer
    spring.kafka.consumer.properties.spring.json.value.default.type=com.example.Invoice
    spring.kafka.consumer.properties.spring.json.trusted.packages=com.example,org.acme
    
    
Similarly, you can disable the JsonSerializer default behavior of sending type information in headers:

    spring.kafka.producer.value-serializer=org.springframework.kafka.support.serializer.JsonSerializer
    spring.kafka.producer.properties.spring.json.add.type.headers=false


      
      
[项目源码](https://github.com/huguiqi/springboot-kafka.git)		




