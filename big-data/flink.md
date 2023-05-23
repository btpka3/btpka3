
apache flink : 窗口函数支持较为完善， 支持 Exactly Once 消息投递方式，
支持 流处理、批处理。
Flink 可以运行在 YARN 上，与 HDFS 协同工作。

由 java,scala 混合编程实现、核心是 java 编写。

初期的Spark Streaming是通过将数据流转成批(micro-batches)，
即收集一段时间(time-window)内到达的所有数据，并在其上进行常规批处，
所以严格意义上，还不能算作流式处理。
但是Spark从版本开始推出基于 Continuous Processing Mode的 Structured Streaming，
支持按事件时间处理和端到端的一致性，但是在功能上还有一些缺陷，比如对端到端的exactly-once语义的支持。

弹性分布式数据集 RDD(Resilient Distributed Dattsets)

- [apache flink](https://flink.apache.org/)
- [流计算框架 Flink 与 Storm 的性能对比](https://blog.csdn.net/qq_41982570/article/details/123780773)
- [Apache 流框架“三剑客” Flink、Spark Streaming、Storm对比分析（一）](https://zhuanlan.zhihu.com/p/159036199)


```bash
docker run \
    -it \
    --name my-flink \
    -p 8081:8081 \
    flink:1.3.2-hadoop27-scala_2.11-alpine \
    local

```
