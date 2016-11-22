参考：
* cassandra [documentation](http://www.datastax.com/documentation/cassandra/2.0/cassandra/gettingStartedCassandraIntro.html)
* cql : [3.1](http://www.datastax.com/documentation/cql/3.1/cql/cql_intro_c.html)
* [cassandra 2.1 新特性](http://www.datastax.com/documentation/developer/java-driver/2.1/java-driver/whatsNew2.html)
* Java driver : [home page](http://www.datastax.com/drivers/java/2.1/)、
 [Architectural overview](http://www.datastax.com/documentation/developer/java-driver/2.1/common/drivers/introduction/introArchOverview_c.html)、
[github](https://github.com/datastax/java-driver)
* [考虑 Apache Cassandra 数据库](http://www.ibm.com/developerworks/cn/opensource/os-apache-cassandra/)
* spring-data-cassandra : [1.1.1 reference](http://docs.spring.io/spring-data/cassandra/docs/1.1.1.RELEASE/reference/html/)
* [关于Cassandra的错误观点](http://www.infoq.com/cn/articles/cassandra-mythology)
* [MongoDB to Cassandra Migrations](http://planetcassandra.org/mongodb-to-cassandra-migration/)
* [HBase 在淘宝的应用和优化](http://www.iteye.com/magazines/83)
* [HBase vs Cassandra：我们迁移系统的原因](http://www.csdn.net/article/2010-11-29/282698)


[java客户端示例，Spring-data-cassandra示例](https://github.com/btpka3/btpka3.github.com/tree/master/java/first-cassandra)

# 2015-01-05 调查总结

Cassandra是 NoSQL 中一个后起之秀，比如

1. 针对写有优化，不会影响读取的速度
1. 无中心节点，节点之间平衡。

但经过调查之后发现：

1. Cassandra 2.1 版本有很有用的功能——能在collection上建立索引。但其提供的 cassandra-driver-core 2.1 版却不提供 `contains`, `contains key`等查询API，只能手写CQL。
1. spring-data-cassandra 虽然提供了cassandraTemplate, cqlTemplate，和POJO的映射，依赖于 cassandra-driver-core 2.0, 无法支持 cassandra 2.1。 且其 Repository 概念也仅仅提供了基础的功能，尚不支持自定义声名式的interface。
1. cassandra的Grails GORM插件，也是基于spring-data-cassandra。且基于其 1.0.0M1 版本和 Cassandra 2.0.11 一直没能搭建起一个可用的demo，报错 "InvalidQueryException: Unknown identifier version"。
1. 排序列只能是primary key中的 clustering collumn，因此对排序支持不好。排序严重依赖于主键设计，却又没有修改主键的方法，只能重新建表。



总的来说，cassandra 比 mongodb好，但不支持事务，其各种客户端类库，框架尚不完善，会增加很多开发工作量，影响开发效率，放弃使用。


# 相关组件

|groupId|artifactId|description|
|---|---|---|
|com.datastax.cassandra |cassandra-driver-core| cassandra java客户端核心组建|
|com.datastax.cassandra |cassandra-driver-mapping| cassandra 官方提供的与POJO的映射，且允许想MyBatis那样在接口上写简单的CQL|
|org.springframework.data|spring-data-cassandra|基于 cassandra-driver-core 提供POJO映射和简单的Repository，提供cqlTemplate和cassantraTemplate|
|org.grails.plugins|cassandra|基于cassandra-driver-core、spring-data-cassandra提供自动创建schema，和pojo映射|


# 概念
* cluster. 一组用于存储数据的节点。
* replication. 将数据副本拷贝到集群中其他节点的过程，用以保证可靠性和容错。
* Partitioner. 负责负载均衡，将数据均衡的分发到集群中的节点上。
* Data Center. 根据复制目的，集群内的一组一起配置的节点。

## keyspace
keysppace可以大致当作普通关系数据库中的schema的概念。主要用于控制 Replication。不同 Replication 策略的表应当放到不同的keyspace中。

Replication 策略可以是SimpleStrategy、 NetworkTopologyStrategy。两者均可用于评估Cassandra，但线上环境则应该使用后者。
如果要使用NetworkTopologyStrategy，需要修改默认使用的snitch——SimpleSnitch 为一个有网络感知的snitch，并在snitch的属性文件中定义一个或多个数据中心的名字，最后使用数据中心的名字作为keyspace的名字。

cassandra 内建一个 `system` keyspace，用于存储集群信息和表信息。

### 查看

```sql
use system;
-- 列出所有 keyspace
SELECT * FROM system.schema_keyspaces;

-- 查看集群信息
SELECT * FROM peers;
```

### 创建

```sql
CREATE KEYSPACE demodb
         WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', 'dc1' : 3 };
USE demodb;
```

### 更新

1. 执行更新cql

    ```sql
    -- 示例一
    ALTER KEYSPACE system_auth
            WITH REPLICATION = {'class' : 'NetworkTopologyStrategy', 'dc1' : 3, 'dc2' : 2};
    -- 示例二
    ALTER KEYSPACE eval_keyspace
            WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 3 };
    ```
2. 然后需要在每个受影响的节点上执行 `nodetool repair`
3. 需要一个节点执行成功之后，才能开始下一个节点。

## table
表可以有单主键或者组合主键。

###　创建

```sql
CREATE TABLE emp (
  empID int,
  deptID int,
  first_name varchar,
  last_name varchar,
  PRIMARY KEY (empID, deptID));
```

### 插入

```sql
INSERT INTO emp (empID, deptID, first_name, last_name)
  VALUES (104, 15, 'jane', 'smith');
```

### 查询

```sql
SELECT * FROM emp WHERE empID IN (130,104) ORDER BY deptID DESC;
```




# 限制
参考[这里](http://wiki.apache.org/cassandra/CassandraLimitations)

* CQL
    * 不支持 join。 比如SQL：`SELECT ... FROM t1, t2 where t1.user_id = t2.id and ...`
    * 不支持子查询。 比如SQL：`SELECT ... FROM t1 where t1.user_id IN (SELECT id FROM t2 where ....)`
    * 有限的支持聚合函数。
    * 排序由每个分区分别完成，并且是在创建表时就明确指定。
    * 不能使用任意的where语句。出现在where 条件中的列只能是 主键(包含partition key、clustering columns)，索引列，且大部分只能通过and 连接，不能通过 or 连接。
        * Partition key 支持 "=" 操作符
        * partition key 的最后一列支持 "IN" 操作符
        * Clustering columns 支持 "=", ">", ">=", "<", "<=" 操作符。
        * 索引列支持 "=" 操作符。
* 存储引擎
    * 集群中的每个分区的所在的服务器的磁盘必须能够容纳下所有数据。
    * 一个字段的值不能超过2GB。
    * 集合类型的字段的值不恩那个大于64KB。
    * 一个表的行数*列数不能大于20亿（2 billion）。



# 不支持
* 事务
* 不支持聚合函数
* 操作符只支持 "=", "<", ">", "<=", ">="。其他均不支持，比如："is null", "=null", 'is not null', "!=", '<>'



# 索引
Cassandra从2.1版本起，支持在Collection上创建索引。

## 何时使用索引？
Cassandra内建的索引适用于：许多记录包含被索引的值。如果一列的唯一的值越多，就需要越多的开销来查询和维护索引。

以下情形请不要使用索引：

* 在[基数](http://en.wikipedia.org/wiki/Cardinality_%28SQL_statements%29)较高（唯一值很多）的列上不要建立索引。因为你会查询大量数据，却得到很小的结果集。
* 如果表中有 counter 类型的列，则该表上不要建立索引。
* 在经常更新或删除的列上不要建立索引。cassandra 在索引中存储的墓碑(tombstone)最多允许100K，超过该值，再使用该索引时将出错。
* 如果没有使用更精确的查询来缩小范围，使用索引来查询话，集群中的机器越多，查询越慢。
