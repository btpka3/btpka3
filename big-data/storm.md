

# 参考

由 Twitter 开源的分布式实时大数据处理框架，实时版的Hadoop。流处理。

- [apache storm](http://storm.apache.org)
  - [StormSql](https://storm.apache.org/releases/2.4.0/storm-sql-reference.html)
  - [Flux](https://storm.apache.org/releases/2.4.0/flux.html)
- [storm@docker](https://hub.docker.com/_/storm/)
- [storm@gtihub](https://github.com/apache/storm/)
- dockerhub
  - [storm](https://hub.docker.com/_/storm)
- github
  - [apache/storm](https://github.com/apache/storm)


# test

```bash
docker run -d -\
    -restart always \
    --name some-zookeeper
    zookeeper:3.4.10

docker run -d \
    --restart always \
    --name some-nimbus \
    --link some-zookeeper:zookeeper \
    storm:1.1.1 \
    storm nimbus

docker run -d \
    --restart always \
    --name supervisor \
    --link some-zookeeper:zookeeper \
    --link some-nimbus:nimbus \
    storm:1.1.1 \
    storm supervisor

docker run \
    -it \
    --rm \
    -v \
    --link some-nimbus:nimbus \
    $(pwd)/topology.jar:/topology.jar \
    storm:1.1.1 \
    storm jar /topology.jar org.apache.storm.starter.WordCountTopology topology
```
# 概念

## Topoloy
拓扑： 一个流数据处理的应用。topology类似于Hadoop中的MapReduce任务，不同之处，MapReduce负责有界的数据的计算，任务一定终止。
但是topology一旦运行，除非人为终止，负责持续运行下去。

## Nimbus
（Storm集群的master）： 支持主备集群。
主要作用：接受storm客户端提交的topology应用，并且分发代码给supervisor，在supervisor执行计算时，还可以进行故障检测。

## Supervisor
（Storm集群的slave服务）: 管理Worker（计算容器）的启动和销毁，接受nimbus分配的任务

## Worker
（JVM进程）： 独立计算容器，任务真实运行。


## Executors
（线程Thread）: Worker中一个线程资源，有一个到多个Executors
## Task
(任务)： Topology中的一个计算单元，支持并行Task
## Zookeeper
（分布式服务协调系统）： 负责Storm集群元数据及状态数据的存储，在Storm集群中nimbus和supervisor无状态服务，Storm集群是极其健壮。


# 组件

## Tuple
Tuple是Storm中的主要数据结构。
它是有序元素的列表。默认情况下，Tuple支持所有数据类型。
通常，它被建模为一组逗号分隔的值，并传递到Storm集群。

## Stream
流是元组的无序序列。

## Spouts
流的源。通常，Storm从原始数据源（如Twitter Streaming API，Apache Kafka队列，Kestrel队列等）接受输入数据。
否则，您可以编写spouts以从数据源读取数据。“ISpout”是实现spouts的核心接口，一些特定的接口是IRichSpout，BaseRichSpout，KafkaSpout等。

## Bolts
Bolts是逻辑处理单元。Spouts将数据传递到Bolts和Bolts过程，并产生新的输出流。
Bolts可以执行过滤，聚合，加入，与数据源和数据库交互的操作。Bolts接收数据并发射到一个或多个Bolts。
“IBolt”是实现Bolts的核心接口。一些常见的接口是IRichBolt，IBasicBolt等。

