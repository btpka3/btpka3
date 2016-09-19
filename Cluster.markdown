http://storm.apache.org/

http://spark.apache.org/

* [spring-remoting-cluster ](http://code.google.com/p/spring-remoting-cluster/wiki/Usage)
* [Build server-cluster-aware Java applications](http://www.ibm.com/developerworks/java/library/j-zookeeper/)
* [Distributed lock manager](http://en.wikipedia.org/wiki/Distributed_lock_manager)
    * [zookeeper](http://zookeeper.apache.org/)

* 当集群节点过多时，为简化运维工作、使用配置服务器？
    * 使用Redis集中存储配置？
    * 需要有层次结构？每个node中的某项配置的值必须与其他节点的不一样？
    * 配置的值不能本地缓存？以便做到及时性？
    * 或者说，随应用程序一起的配置文件中只能有配置服务器的信息？


# ZooKeeper

ZooKeeper [recipes](http://zookeeper.apache.org/doc/r3.4.6/recipes.html).
ZK的API相对来说都比较低级，可以使用 [curator](http://curator.apache.org/) 的高级API进行编程。


# 架构

*  [墨迹天气服务器架构简介](http://download.csdn.net/detail/u010702509/8357037)

# 微服务

* 《[微服务实战（一）：微服务架构的优势与不足](http://kb.cnblogs.com/page/521880/)》
