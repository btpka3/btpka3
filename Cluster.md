* [spring-remoting-cluster ](http://code.google.com/p/spring-remoting-cluster/wiki/Usage)
* [Build server-cluster-aware Java applications](http://www.ibm.com/developerworks/java/library/j-zookeeper/)
* [Distributed lock manager](http://en.wikipedia.org/wiki/Distributed_lock_manager)
    * [zookeeper](http://zookeeper.apache.org/)

* 当集群节点过多时，为简化运维工作、使用配置服务器？
    * 使用Redis集中存储配置？
    * 需要有层次结构？每个node中的某项配置的值必须与其他节点的不一样？
    * 配置的值不能本地缓存？以便做到及时性？
    * 或者说，随应用程序一起的配置文件中只能有配置服务器的信息？