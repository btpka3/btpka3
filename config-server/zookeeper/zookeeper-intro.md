# ZooKeeper简介

[ZooKeeper](http://zookeeper.apache.org/)是一个可以为分布式系统提供各种协作服务。
比如：Name Service, Configuration, Group Membership 。
ZooKeeper是一种类似于目录树结构的共享层级命名空间提供该功能的。但不同于目录树的是：每个节点都可以存放数据和创建子节点。
ZooKeeper通常以集群的方式对外提供服务，集群节点间通过选举出Leader，并经Leader完成所有节点间的数据同步。

- 《[服务发现：Zookeeper vs etcd vs Consul](http://blog.csdn.net/zdy0_2004/article/details/48463805)》
- [ZooKeeper Programmer's Guide](https://zookeeper.apache.org/doc/trunk/zookeeperProgrammers.pdf)
- [ZooKeeper Commands: The Four Letter Words](http://zookeeper.apache.org/doc/r3.3.1/zookeeperAdmin.html#sc_zkCommands)
- [ZooKeeper系列之六：ZooKeeper四字命令](http://blog.csdn.net/shenlan211314/article/details/6187029)
- [Apache Curator](http://curator.apache.org/)

# 简单尝试

```bash
wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
tar zxvf zookeeper-3.4.6.tar.gz
cd zookeeper-3.4.6

./bin/zkServer.sh start         # 启动ZooKeeper服务器
./bin/zkCli.sh                  # 连接到ZooKeeper服务器上
    help                        # 任何不支持的命令都显示完成的命令列表
    ls /                        # 查看根节点
    create /a "aaa"             # 创建节点 /a 并设置数据
    get /a
    create /a/b "bbb"           # 创建节点 /b并设置数据
    get /a
    get /b
    set /a "a00"                # 更新数据
    quit                        # 退出

./bin/zkServer.sh stop          # 启动ZooKeeper服务器
```

# 节点属性

在通过 `zkCli.sh get /path` 返回的信息，各个字段含义如下：

| attr           | desc                                                  |
|----------------|-------------------------------------------------------|
| zxid           | ZooKeeper Transaction Id, 有顺序的，全局唯一                   |
| cZxid          | 节点创建时的 zxid                                           |
| ctime          | 节点创建时的时间戳                                             |
| mZxid          | 节点最后一次更新时的 zxid                                       |
| mtime          | 节点最后一次更新时的时间戳                                         |
| pZxid          | 其子节点最后一次修改的 zxid                                      |
| cversion       | 其子节点的更新次数                                             |
| dataVersion    | 节点数据的更新次数                                             |
| aclVersion     | 节点ACL(授权信息)的更新次数                                      |
| ephemeralOwner | 如果该节点为ephemeral节点, ephemeralOwner值表示与该节点绑定的session id |
| dataLength     | 节点数据的字节数                                              |
| numChildren    | 子节点个数                                                 |

# zookeeper 四字母命令

```bash
echo conf | nc localhost 2181
echo cons | nc localhost 2181
echo wchs | nc localhost 2181
1 connections watching 15 paths
Total watches:15
```

| cmd  | desp                                          |
|------|-----------------------------------------------|
| conf | 输出相关服务配置的详细信息                                 |
| cons | 列出连接/会话等信息（接受 / 发送”的包数量、会话 id 、操作延迟、最后的操作执行等） |
| dump | 列出未经处理的会话和临时节点                                |
| envi | 输出关于服务环境的详细信息（区别于 conf 命令）                    |
| reqs | 列出未经处理的请求                                     |
| ruok | 测试服务是否处于正确状态。若正常应返回 "imok"                    |
| stat | 输出关于性能和连接的客户端的列表                              |
| wchs | 列出服务器 watch 的统计信息                             |
| wchc | 列出服务器 watch 的详细信息。按 session 分组显示              |
| wchp | 列出服务器 watch 的详细信息。按 path 分组显示                 |

# ZooKeeper Recipes

参考[这里](http://zookeeper.apache.org/doc/r3.4.6/recipes.html)

## Barriers

该单词可以翻译为"屏障"、"栅栏"。分布式系统可以使用Barriers来阻止在一些node上进行处理，直到满足特定条件条件，才能继续。

1. Client调用zk.exists() 方法检测Barriers节点，并watch
2. 如果Barriers节点不存在，client可以继续往下处理。
3. 否则：client监控zk上关于Barriers节点的消息
4. 如果监听事件被触发，则重复步骤1～3.

## Double Barriers

会使client在进入和结束计算任务时都会得到同步。

以下伪代码假设Barriers节点为b，client进程为p。

### 进入Barriers

1. 准备好字节点名称： n = b+"/"+p
2. 监测Barriers上的事件： exists(b+"/ready", true)
3. 创建子节点： create(n, EPHEMERAL)
4. 获取Barriers中所有节点： L=getChildren(b,false)
5. 如果Barriers中子节点数量L.size()少于阈值x，则等待Barriers上的事件
6. 否则：则设置Barriers就绪： create(b+"/ready", REGULAR)

### 离开Barriers

1. 获取Barriers中所有节点： L=getChildren(b,false)
2. 如果没有字子节点，则exit
3. 如果 p 是BarriersL中的唯一处理节点，delete(n) 并 exit
4. 如果 p 是BarriersL中最小的处理节点，则等待最高的处理进程
5. 否则：delete(n)，且等待最小的处理节点
6. goto 1.

## Queues

ZK支持创建序列节点。最终创建的节点格式为 `/path/to/queue/node/prefix-xxx`
后面的xxx是自增唯一的序列号。如果要实现有优先级的队列，可以定义为
`/path/to/queue/node/prefix-yy-xxx`，其中yy是优先级，值越小越优先。

从queue中取值的进程，只需要从最小节点中取值即可。

## Locks

### 进入同步

1. 已顺序和临时的方式创建节点： "/lock/node/lock-"
2. 从lockNode中获取所有子节点，无需监测lockNode。
3. 如果第一步创建的节点是最小节点，则说明当前client持有该锁，并结束。
4. client监测比第一步创建节点前面的节点的存在性。
5. 如果不存在，则goto 2；否则，等待监测消息后，goto 2。

### 离开同步

删除自己创建的节点即可。

注意事项：

* 每个节点只关注前一个加锁节点的存在行，故每次锁可用时，只会有一个client被唤醒。
* 没有论询或超时机制
* 此种实现机制，很容易检测所多少个等待加锁的连接，也方便调试。

## 共享锁

也可以称做读写锁。

* 读锁和写锁不能同时存在。
* 如果当前是读锁，可以允许再加多个读锁，但不允许加写锁。
* 如果当前是写锁，则禁止再加其他任何读锁、写锁。

### 获取读锁

1. create() : 创建序列的、临时的读锁节点 "lockNode/read-"，
2. getChildren()：获取锁目录节点下的所有子节点，无需监测。
3. 如果没有以 "write-" 作为前缀开始的、且序列号比第一步创建的节点的序列号还小的子节点，
   则该client获得读锁，并退出。
4. 否则，监测以 "write-" 作为前缀开始的，且序号比第一步创建的节点的序列号还小的前一个节点。
5. 如果不存在，goto 2.
6. 否则，等待消息并 goto 2.

### 获取写锁

1. create()： 创建序列的、临时的写锁节点 "lockNode/write-"
2. getChildren(): 获取锁目录节点下所有节点，无需监测。
3. 如果没有序号比第一步创建节点的序号还小的节点，则当前client获得写锁，退出。
4. 否则，监测比比第一步创建节点的序号还小的前一个节点。
5. 如果不存在，goto 2. 否则等待通知并goto 2.

## 两段式提交

## Leader选举

# Apache curator

ZooKeeper的API相对来说还是很低级API，如果要直接使用，并完成其文档中Recipes章节所列举的功能，还是比较麻烦的。

[Apache Curator](http://curator.apache.org/) 则是对ZooKeeper进行封装，并提供了高级API，并简化开发。
当然 Curator
也完善、扩展了ZooKeeper的Recipes，并指出其中一些并不实用——比如消息队列。完整列表参考[这里](hhttps://curator.apache.org/docs/recipes-shared-reentrant-lock)。


[spring-integration-zookeeper](https://docs.spring.io/spring-integration/reference/zookeeper.html)

# Exhibitor

[Netflix/exhibitor](https://github.com/Netflix/exhibitor)
为ZooKeeper提供了监控、备份/恢复和可视化功能。具体操作步骤请参考其[wiki](https://github.com/Netflix/exhibitor/wiki)。
