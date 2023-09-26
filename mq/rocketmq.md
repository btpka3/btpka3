github:
- apache
  - [rocketmq](https://github.com/apache/rocketmq)
  - [rocketmq-docker](https://github.com/apache/rocketmq-docker)
  - [rocketmq-clients](https://github.com/apache/rocketmq-clients)
  - [rocketmq-dashboard](https://github.com/apache/rocketmq-dashboard)

doc
- [rocketmq](https://rocketmq.apache.org/)

# server

## 5.x

### 示例启动

```shell
export ROCKETMQ_HOME=$HOME/Downloads/rocketmq-all-5.1.0-bin-release
export NAMESRV_ADDR=localhost:9876
cd $ROCKETMQ_HOME

# 启动NameServer
./bin/mqnamesrv

# 启动Broker+Proxy
./bin/mqbroker -n localhost:9876 --enable-proxy
```

### nameServer
java 核心类：

- org.apache.rocketmq.namesrv.[NamesrvStartup](https://github.com/apache/rocketmq/blob/bd7db7ec62164882ce6db101bacd038308648e02/namesrv/src/main/java/org/apache/rocketmq/namesrv/NamesrvStartup.java#L43) # main函数主类
- org.apache.rocketmq.common.namesrv.[NamesrvConfig](https://github.com/apache/rocketmq/blob/bd7db7ec62164882ce6db101bacd038308648e02/common/src/main/java/org/apache/rocketmq/common/namesrv/NamesrvConfig.java#L19) # 配置项对应的java类
- org.apache.rocketmq.remoting.netty.[NettyServerConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/remoting/src/main/java/org/apache/rocketmq/remoting/netty/NettyServerConfig.java#L19)
    - listenPort : 10911
- org.apache.rocketmq.remoting.netty.[NettyClientConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/remoting/src/main/java/org/apache/rocketmq/remoting/netty/NettyClientConfig.java#L23)

配置文件由命令 mqnamesrv的参数 -c指定，格式是  properties 文件。
```properties
rocketmqHome=                 # RocketMQ主目录，默认用户主目录
namesrvAddr=                  # NameServer地址
kvConfigpath=                 # kv配置文件路径，包含顺序消息主题的配置信息
configStorePath=              # NameServer配置文件路径，建议使用-c指定NameServer配置文件路径
clusterTest=                  # 是否支持集群测试，默认: false
orderMessageEnable=           # 是否支持顺序消息，默认: false
```

### broker
java 核心类：
- org.apache.rocketmq.broker.[BrokerStartup](https://github.com/apache/rocketmq/blob/bd7db7ec62164882ce6db101bacd038308648e02/broker/src/main/java/org/apache/rocketmq/broker/BrokerStartup.java#L44)  # main函数主类
- org.apache.rocketmq.common.[BrokerConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/common/src/main/java/org/apache/rocketmq/common/BrokerConfig.java#L26)   # 配置项对应的java类
  - #aclEnable                              # 是否开启ACL权限控制
- org.apache.rocketmq.remoting.netty.[NettyServerConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/remoting/src/main/java/org/apache/rocketmq/remoting/netty/NettyServerConfig.java#L19)
  - listenPort : 10911
- org.apache.rocketmq.remoting.netty.[NettyClientConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/remoting/src/main/java/org/apache/rocketmq/remoting/netty/NettyClientConfig.java#L23)
- org.apache.rocketmq.store.config.[MessageStoreConfig](https://github.com/apache/rocketmq/blob/70480a1fa9aac397fa8c5dbcb352284ad118a891/store/src/main/java/org/apache/rocketmq/store/config/MessageStoreConfig.java#L195)
  - haListenPort: 10912

- org.apache.rocketmq.acl.plain.PlainAccessData  #
- org.apache.rocketmq.common.PlainAccessConfig

配置文件由命令 mqbroker的参数 -c指定，格式是  properties 文件。
默认是： conf/broker.conf

```properties

```

### proxy
java 核心类：
- org.apache.rocketmq.proxy.ProxyStartup # main函数主类
- org.apache.rocketmq.proxy.config.ProxyConfig # 配置文件对应的 java 类

配置文件由命令 mqproxy 的参数 -pc(--proxyConfigPath)指定，格式是  json 文件。
jvm 系统属性: com.rocketmq.proxy.configPath
默认配置文件: rmq-proxy.json
```json
{
  "rocketMQClusterName"  : "DefaultCluster",
  "grpcServerPort"       : 8081
}
```


### 其他
- $HOME/controller/controller.properties  # ControllerConfig#configStorePath
- $HOME/namesrv/kvConfig.json             # NamesrvConfig#kvConfigPath
- $HOME/namesrv/namesrv.properties        # NamesrvConfig#configStorePath


----------------------------------------------

# client

## java

## rocketmq-spring
github:
[rocketmq-spring](https://github.com/apache/rocketmq-spring)
  - maven: [org.apache.rocketmq:rocketmq-spring-boot-starter](https://search.maven.org/search?q=g:org.apache.rocketmq%20a:rocketmq-spring-boot-starter)
  - [wiki](https://github.com/apache/rocketmq-spring/wiki/Send-Message)
  - [rocketmq-spring-boot-samples](https://github.com/apache/rocketmq-spring/tree/master/rocketmq-spring-boot-samples)

核心java类：
- org.apache.rocketmq.spring.core.RocketMQTemplate
  - #send
  - #receive
- org.apache.rocketmq.spring.autoconfigure.RocketMQProperties
- org.apache.rocketmq.spring.core.RocketMQListener#onMessage
- org.apache.rocketmq.spring.autoconfigure.RocketMQAutoConfiguration

示例配置
```properties
rocketmq.producer.send-message-timeout=3000
rocketmq.producer.compress-message-body-threshold=4096
rocketmq.producer.max-message-size=4194304
rocketmq.producer.retry-times-when-send-async-failed=0
rocketmq.producer.retry-next-server=true
rocketmq.producer.retry-times-when-send-failed=2
```

## spring-cloud-starter-stream-rocketmq

github
- alibaba/spring-cloud-alibaba ：
    - [Spring Cloud Alibaba RocketMQ Binder](https://github.com/alibaba/spring-cloud-alibaba/wiki/RocketMQ-en)
        - maven: `com.alibaba.cloud:spring-cloud-stream-binder-rocketmq`
        - maven: `com.alibaba.cloud:spring-cloud-starter-stream-rocketmq`

核心java类
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitBinderConfigurationProperties  # prefix = "spring.cloud.stream.rabbit.binder"
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitBindingProperties
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitCommonProperties
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitConsumerProperties
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitExtendedBindingProperties      # prefix = "spring.cloud.stream.rabbit"
- org.springframework.cloud.stream.binder.rabbit.properties.RabbitProducerProperties


----------------------------------------------
# mqadmin


```shell

#podman run -rm apache/rocketmq:4.9.4

export ROCKETMQ_HOME=$HOME/Downloads/rocketmq-all-5.1.0-bin-release
export NAMESRV_ADDR=localhost:9876
export NAMESRV_ADDR=11.167.75.235:9876
cd $ROCKETMQ_HOME


# 显示完整命令列表
./bin/mqadmin

# ------------------------------ 集群
./bin/mqadmin clusterList



# 检查 topic 是否存在
./bin/mqadmin topicList -c
# 创建/更新 topic
./bin/mqadmin updateTopic -c DefaultCluster -p 6 -t yourNormalTopic
# 删除 topic
./bin/mqadmin deleteTopic -c DefaultCluster -t yourNormalTopic
./bin/mqadmin topicStatus -t mtee3_dispatch

# 根据msgId查询消息
./bin/mqadmin queryMsgByUniqueKey   -t mtee3_dispath -i AC1058F7004D6718465C5B024C7D001F
# 根据消息 Key 查询消息
./bin/mqadmin queryMsgByKey         -t mtee3_dispath -k 172.16.88.247_79_MTEE3_1692346077297_77  
# 根据offsetMsgId查询消息
./bin/mqadmin queryMsgById          --msgId AC1058F7004D6718465C5B024C7D001F 
```



# http api

```shell
ROCKETMQ_SERVER=http://11.167.75.235:8080
MSG_ID=AC1058F7004D6718465C5B024C7D001F
MQ_TOPIC=mtee3_dispatch
curl "${ROCKETMQ_SERVER}/message/viewMessage.query?msgId=${MSG_ID}&topic=${MQ_TOPIC}" \
  -H 'Accept: application/json, text/plain, */*' \
  --compressed \
  -s \
  --insecure | jq -M -r '.data.messageView.messageBody' > /tmp/a.txt
  

```
 