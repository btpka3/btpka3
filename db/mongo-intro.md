
## 简介

[MongoDB](http://www.mongodb.org/) 是一个时下非常流行的非关系型数据库(NoSql)。如果官网的文档打开过慢，可以到[这里](http://docs.mongoing.com/manual-zh/faq/concurrency.html)看未翻译完的中文版参考手册。特点：

* schemaLess。无需预先定义存储结构。（但作为业务开发，还是需要的提前规划一下的）
* 使用Binary JSON （BSON）存储，对Web开发很方便
* 面向文档(Document)的，支持内嵌文档、LIST，MAP等
* 单个文档的更新总是原子的(atomic)
* 不支持事务。但给出了一个通过程序模拟[两段式提交](http://docs.mongodb.org/manual/tutorial/perform-two-phase-commits/)的事务实现
* 对单个collection(表)提供批处理功能
* 支持Replication，且可以设置至少复制到几个节点上才算成功。
* 支持Sharding
* 使用[读写锁](http://docs.mongodb.org/manual/faq/concurrency/)来进行并发控制——即，读和写不能同时进行，读可以同时有多个，写只能有一个。颗粒度有：
    * MongoDB实例级别的全局性锁。在 2.2 之前只有全局性锁。
    * 单个DB级别。在 2.2 版之后才有。（一个MongoDB实例有多个DB的额）

    PS: 尚未正式发布的 2.8 版本增强了默认存储引擎——MMAPv1，使其允许 [collection/表 级别](http://docs.mongodb.org/v2.8/release-notes/2.8/)的锁。并且新增了 WiredTiger 引擎，后者提供 document/行记录 级别的锁和压缩。 敬请期待吧！

## 客户端 
第三方提供的 GUI 客户端 [Robomongo](http://robomongo.org/)


## 常用命令

|command|description|
|------|-----|
|mongo      | 使用 mongo shell 连接 mongo 服务器|
|mongostat  | 显示 mongo 服务器的状态 |
|mongotop   | 显示 mongo 服务器的状态 |


## 基本使用

### 管理登录

```js

// 需要连接到主节点上，通过命令行提示符判断
mongo --host s82
use admin
// db.auth("siteUserAdmin", "password");
db.auth("siteRootAdmin", "password");
rs.conf()                               // 查看 Replica Set 的配置
rs.status()                             // 查看 Replica Set 的当前状态
```

### 普通登录 

```js
mongo --host s82                         // 连接到远程数据库，如果主机名不是标准的域名格式，必须使用 `--host`
use lizidb                               // 切换数据库，PS：此时该数据库可能并不存在
db.auth("lizidbAdmin", "password");      // 使用用户名、密码登录。否则后续操作将失败
db.getMongo().setSlaveOk()               // 如果当前节点是从节点，需要设置 slaveOk 之后，才能进行查询。
show collections                         // 列出所有的集合（表）
db.cart.find()                           // 列出 cart 集合（表）中所有的文档（记录）
```

### 编写独立的脚本
需要先参考 《[Write Scripts for the mongo Shell](http://docs.mongodb.org/manual/tutorial/write-scripts-for-the-mongo-shell/)》，再细看 [API](http://docs.mongodb.org/manual/reference/method/)。


1. 编写一个 `*.js` 文件 ： `vi mongo.js`

    ```js
    var db = connect("host:27017/dbName");
    db.auth("username","password");
    var colNames = db.getCollectionNames();
    printjson(colNames);
    ```
1. 执行该文件 `mongo mongo.js`


## 设计原则

* 所有集合都明确声明 String 类型的 id 字段 ： `String id`。GORM会自动将其赋值为 `new ObjectId().toString()`
* Embedded 类型，其class定义应当声明在Domain类内部，比如：

    ```groovy
    class Cart {                        // 整个文档大小（BSON）不可超过16M

        static embedded = ['addrList']  // 内嵌

        String id                       // Domain 类明确声明 String 型的 id，GORM 会自动赋值。
        List<Address> addrList          // Address 类型仅仅在 Cart 内部使用。

        static class Address {          // 则 Address 应该作为 Cart 的内部类进行声明
            // String id                // Address不是Domain类，只是普通 JavaBean，所以该id 只能手动赋值
                                        // 为避免其名字使人混淆，请大家不要在 Embbed 类中声明 `id` 字段
                                        // 而使用其他字段代替，比如 `int seq`
            int seq                     // 该字段的含义应当是在当前 cart 实例内唯一
            String province
            String city
            String zipCode
        }
    }
    ```
* Embedded 类型不是Domain类，其将没有 createCriteria() 等 GORM 方法。
* Embedded 类型不要声明 `id` 字段，因为其不是 domain 类，因此不会被自动赋值，需要手动赋值。为避免其名字使人混淆，请使用其他字段代替，比如 `int seq`。

# 约束 or 建议
* 单个Document的大小不能超过16M，如果超过，请考虑使用 GridFS
* 索引
    * 确保有足够内存装的下全部索引。否则性能低下
* 如果Replicaion
    * Replica set的大小需要是奇数个，或者引入 仲裁者 (arbiter)
    * Replica set成员需要保持数据最新，可以使用监控工具监控，写入时指定至少写入2份。
* 如果使用Sharding
    * 慎重选择sharding key，一旦使用，不可更改。
    * sharding key 不允许被更新
    * 对已有大数据量的collection进行sharding时，可以创建一个新的、空的 sharded 的 collection，然后再从应用级别导入。直接shard会有性能问题。
    * 除了shard key， 唯一索引无法保证唯一性，其唯一性需要应用自行控制。
    * 在批量导入时，最好先根据 sharding key 将数据预分组。



## 内建角色

参考[这里](http://docs.mongodb.org/manual/reference/built-in-roles/)

|Built-In Roles         |All db |
|-----------------------|-------|
|readAnyDatabase        |Yes    |
|readWriteAnyDatabase   |Yes    |
|userAdminAnyDatabase   |Yes    |
|dbAdminAnyDatabase     |Yes    |
|root                   |Yes    |
|read                   |       |
|readWrite              |       |
|dbAdmin                |       |
|dbOwner                |       |
|userAdmin              |       |
|clusterAdmin           |       |
|clusterManager         |       |
|clusterMonitor         |       |
|hostManager            |       |
|backup                 |       |
|restore                |       |

## 配置文件

MongoDB 2.6 开始，使用 YAML 语法书写配置文件，但仍然兼容 2.4 版的配置文件格式。 rpm包中的配置文件请参考[这里](https://github.com/mongodb/mongo/blob/master/rpm/mongod.conf)。


YAML版配置文件示例：

```yaml
# @see http://docs.mongodb.org/manual/reference/configuration-options
# setParameter @ses http://docs.mongodb.org/manual/reference/parameters/ 
# YAML format

systemLog:
    verbosity:
    quiet: false
    traceAllExceptions: true
    syslogFacility: user
    path: /var/log/mongodb/mongodb.log
    logAppend: true
    destination: file
    timeStampFormat: iso8601-local

processManagement:
    pidFilePath: /var/run/mongodb/mongod.pid
    fork: true
    windowsService:
        serviceName:
        displayName:
        description:
        serviceUser:
        servicePassword:

net:
    port: 27017
    bindIp: 127.0.0.1
    maxIncomingConnections: 1000000
    wireObjectCheck: true
    http:
        enabled: false
        JSONPEnabled: false
        RESTInterfaceEnabled: false
    unixDomainSocket:
        enabled: false
        pathPrefix: /tmp
    ipv6: false
    ssl:
        sslOnNormalPorts:                       # Deprecated
        mode: disabled
        PEMKeyFile:
        PEMKeyPassword:
        clusterFile:
        clusterPassword:
        CAFile:
        CRLFile:
        weakCertificateValidation:
        allowInvalidCertificates:
        FIPSMode:

setParameter:

security:
    keyFile:
    clusterAuthMode: keyFile
    authorization: disabled
    sasl:
        hostName:
        serviceName:
        saslauthdSocketPath:
    javascriptEnabled: true

operationProfiling:
    slowOpThresholdMs: 100
    mode: off

storage:
    dbPath: /var/lib/mongo
    directoryPerDB: false
    indexBuildRetry: true
    preallocDataFiles: true
    nsSize: 16
    quota:
        enforced: false
        maxFilesPerDB: 8
    smallFiles: false
    syncPeriodSecs: 60
    repairPath: 
    journal:
        enabled: true
        debugFlags: 
        commitIntervalMs: 100

replication:
    oplogSizeMB:
    replSetName:
    secondaryIndexPrefetch: all
    localPingThresholdMs: 15                    # mongos-only

sharding:
    clusterRole:
    archiveMovedChunks:
    autoSplit:                                  # mongos-only
    configDB:                                   # mongos-only
    chunkSize: 64                               # mongos-only

auditLog:
    destination: 
    format:
    path:
    filter:

snmp:
    subagent:
    master:
```

为了方便统一以YAML格式配置，现在将默认的配置项与 YAML配置项的对应关系列表如下：

```groovy
# default config entry      # YAML config entry
logpath                     systemLog.path
logappend                   systemLog.logAppend
fork                        processManagement.fork
#port                       net.port
dbpath                      storage.dbPath
pidfilepath                 processManagement.pidFilePath
bind_ip                     net.bindIp
#nojournal                  storage.journal.enabled
#cpu
#noauth                     security.authorization
#auth                       security.authorization
#verbose                    systemLog.verbosity
#objcheck                   net.wireObjectCheck
#quota=true                 storage.quota.enforced
#diaglog=0
#nohints=true
#httpinterface              net.http.enabled
#noscripting                security.javascriptEnabled
#notablescan                setParameter
#noprealloc                 storage.preallocDataFiles
#nssize                     storage.nsSize
#replSet                    replication.replSetName
#oplogSize                  replication.oplogSizeMB
#keyFile                    security.keyFile

```





## 参考文件
* 《[Replication Lag & The Facts of Life](http://blog.mongolab.com/2013/03/replication-lag-the-facts-of-life/)》
* 《[MongoDB Operations Best Practices guide](http://info.mongodb.com/rs/mongodb/images/MongoDB_Operations_Best_Practices.pdf)》 pdf
* 《[MongoDB与内存](http://huoding.com/2011/08/19/107)》
* 《[MongoDB. This is not the database you are looking for.](http://patrickmcfadin.com/2014/02/11/mongodb-this-is-not-the-database-you-are-looking-for/)》