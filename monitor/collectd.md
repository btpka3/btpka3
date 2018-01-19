
# 参考

- [Home](https://collectd.org/index.shtml)
- [collectd - alpine](https://wiki.alpinelinux.org/wiki/Collectd)
- [prom/collectd-exporter](https://hub.docker.com/r/prom/collectd-exporter/)
- [List of front-ends](https://collectd.org/wiki/index.php/List_of_front-ends)
- [javadoc for java plugin](https://collectd.org/documentation/javadoc/)
- [network plugin](https://collectd.org/wiki/index.php/Plugin:Network)
- [Binary protocol](https://collectd.org/wiki/index.php/Binary_protocol)
- [jcollectd](https://github.com/collectd/jcollectd)

# network 插件
可以将数据发送给别的实例，或者接收来自其他实例的数据。
至于使用哪一种，则要看如何配置。

## 作为客户端

```xml
# Client
<Plugin "network">
  Server "ff18::efc0:4a42"
</Plugin>
```
# 作为服务器端

```xml
# Server
<Plugin "network">
 Listen "ff18::efc0:4a42"
</Plugin>
```


# 运行

```bash
docker run --rm it alpine:3.6 sh
apk update
apk add collectd collectd-network
rc-service collectd stop

collectd --help 

# 测试文件
collectd -t

# 前台执行
collectd -f

# 默认配置文件
cat /etc/collectd/collectd.conf

# 类型定义
#   第一列为类型名，第二列为类型定义）
#   第二列的格式为  数据源名:类型:最小值:最大值
#       类型：
#           GAUGE，
#           DERIVE，
#           COUNTER
#           ABSOLUTE
/usr/share/collectd/types.db
```


