

## 简介
Geode自身功能比较多，首先它是一个基于JVM的NoSQL分布式数据处理平台，
同时集中间件、缓存、消息队列、事件处理引擎、NoSQL数据库于一身的分布式内存数据处理平台。
可用来进行完成分布式缓存、数据持久化、，分布式事物、动态扩展等功能


## 试运行

```bash
docker run -it apachegeode/geode

docker create                                       \
    --name my-geode                                 \
    -it                                             \
    --restart unless-stopped                        \
    -p 8080:8080                                    \
    -p 10334:10334                                  \
    -p 40404:40404                                  \
    -p 1099:1099                                    \
    -p 7070:7070                                    \
    -v /data0/store/geode:/data:rw                  \
    apachegeode/geode                               

docker start my-geode
docker exec -it my-geode sh
gfsh
start locator
start server
create region --name=regionA --type=REPLICATE_PERSISTENT
```

## 参考

- [geode](http://geode.apache.org/)
- [geode @docker hub](https://hub.docker.com/r/apachegeode/geode/)
- [geode@github](https://github.com/apache/geode)
- [Geode in 5 minutes](https://cwiki.apache.org/confluence/display/GEODE/Index#Index-Geodein5minutes)
- [大中型企业的天网：Apache Geode](http://www.infoq.com/cn/articles/introduction-of-apache-geode)
- [Greenplum Database](https://greenplum.org/)

