http://www.infoq.com/cn/articles/nosql-performance-test

http://planetcassandra.org/mongodb-to-cassandra-migration/

http://www.csdn.net/article/2010-11-29/282698

http://patrickmcfadin.com/2014/02/11/mongodb-this-is-not-the-database-you-are-looking-for/

http://www.infoq.com/cn/articles/cassandra-mythology


http://www.iteye.com/magazines/83

# 主要概念
* cluster. 一组用于存储数据的节点。
* replication. 将数据副本拷贝到集群中其他节点的过程，用以保证可靠性和容错。
* Partitioner. 负责负载均衡，将数据均衡的分发到集群中的节点上。
* Data Center. 根据复制目的，集群内的一组一起配置的节点。



```sql
-- 重建 keyspace
DROP KEYSPACE IF EXISTS test;
CREATE KEYSPACE IF NOT EXISTS test
    WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }
    AND DURABLE_WRITES = true;
SELECT * FROM system.schema_keyspaces WHERE keyspace_name = 'test';
USE test;


```
https://github.com/datastax/java-driver
http://www.datastax.com/documentation/developer/java-driver/2.1/common/drivers/introduction/introArchOverview_c.html
http://docs.spring.io/spring-data/cassandra/docs/1.1.1.RELEASE/reference/html/