## 参考

- [RocksDB](https://rocksdb.org/)
- [RocksJava Basics](https://github.com/facebook/rocksdb/wiki/RocksJava-Basics)
- [深入浅出带你走进 RocksDB](https://zhuanlan.zhihu.com/p/566742456)
- [Rocksdb简介](https://cloud.tencent.com/developer/article/2169307)

## VS

### rocksdb

- 基于 Google LevelDB研发的高性能kv持久化存储引擎
- 使用 Log-Structured Merge（LSM）trees做为基本的数据存储结构
- 增加了column family，有了列簇的概念，可把一些相关的key存储在一起
- 仅仅是一个内嵌的库(lib)，java版的jar包中包含了JNI实现部分。
- 分级存储，超出内存限制的内容将会放到 硬盘上。最后一级存储 90% 的内容
- 性能？
- 支持的数据类型少，key-value 都是 `byte[]` 类型。
- 支持TTL过期淘汰机制
- 增加了对 write ahead log（WAL）的管理机制，更方便管理WAL，WAL是binlog文件

### redis

- CS 结构，有网络开销
- 单个服务器时，容量受内存大小限制。
- 性能高。

## 数据库目录

```bash
zll@m [17:44:55] [/tmp/first-rocksdb.db]
-> % ll
total 280
-rw-r--r--  1 zll  wheel   982B Mar  1 17:33 000016.sst                 # 数据持久化文件
-rw-r--r--  1 zll  wheel    40B Mar  1 17:33 000017.log                 # 事务日志用于保存数据操作日志，可用于数据恢复
-rw-r--r--  1 zll  wheel    16B Mar  1 17:33 CURRENT                    # 记录当前正在使用的MANIFEST文件
-rw-r--r--  1 zll  wheel    36B Mar  1 17:30 IDENTITY
-rw-r--r--  1 zll  wheel     0B Mar  1 17:30 LOCK                       # rocksdb自带的文件锁，防止两个进程来打开数据库
-rw-r--r--  1 zll  wheel    27K Mar  1 17:33 LOG
-rw-r--r--  1 zll  wheel    23K Mar  1 17:30 LOG.old.1677663105660270
-rw-r--r--  1 zll  wheel    24K Mar  1 17:31 LOG.old.1677663167617744
-rw-r--r--  1 zll  wheel    24K Mar  1 17:32 LOG.old.1677663205279798
-rw-r--r--  1 zll  wheel   156B Mar  1 17:33 MANIFEST-000018            # 数据库中的 MANIFEST 文件记录数据库状态。
                                                                        # 压缩过程会添加新文件并从数据库中删除旧文件，
                                                                        # 并通过将它们记录在 MANIFEST 文件中使这些操作持久化
-rw-r--r--  1 zll  wheel   6.7K Mar  1 17:32 OPTIONS-000015
-rw-r--r--  1 zll  wheel   6.7K Mar  1 17:33 OPTIONS-000020
```
