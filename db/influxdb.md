

# 参考

- [InfluxDB Version 1.3 Documentation](https://docs.influxdata.com/influxdb/v1.3/)
- [influxdb-java](https://github.com/influxdata/influxdb-java)

# 名词解释

- database : 数据库
- measurement: 数据库中的表
- points : 表里面的一行数据
    - time : 时间戳,每条数据记录的时间，也是数据库自动生成的主索引
    - field: 数据,各种记录的值
    - tags: 标签,各种有索引的属性
- series: 表示这个表里面的所有的数据可以在图标上画成几条线（注：线条的个数由tags排列组合计算出来）

# 快速开始

```bash

mkdir -p /data0/store/soft/influxdb/data
mkdir -p /data0/store/soft/influxdb/conf

# 默认配置文件路径 /etc/influxdb/influxdb.conf
tee /data0/store/soft/influxdb/conf/influxdb.conf <<EOF
[meta]
  dir = "/var/lib/influxdb/meta"

[data]
  dir = "/var/lib/influxdb/data"
  engine = "tsm1"
wal-dir = "/var/lib/influxdb/wal"

[[collectd]]
  enabled = true
  bind-address = ":25826" # the bind address
  database = "collectd" # Name of the database that will be written to
  retention-policy = ""
  batch-size = 5000 # will flush if this many points get buffered
  batch-pending = 10 # number of batches that may be pending in memory
  batch-timeout = "10s"
  read-buffer = 0 # UDP read buffer size, 0 means to use OS default
  typesdb = "/usr/share/collectd/types.db"
  security-level = "none" # "none", "sign", or "encrypt"
  auth-file = "/etc/collectd/auth_file"
  parse-multivalue-plugin = "split"  # "split" or "join"
EOF


docker create                                               \
    --name my-influxdb                                      \
    -v /data0/store/soft/influxdb/data:/var/lib/influxdb    \
    -v /data0/store/soft/influxdb/conf:/etc/influxdb        \
    -p 8086:8086                                            \
    -p 8088:8088                                            \
    influxdb:1.4.2-alpine

docker start my-influxdb

```
# 常用命令

```sql
# 启动数据库
influxd help
influxd config -help
influxd run -help
influxd

# 连接到本地数据库
influx 

-- 创建数据库
create database "db_name"

-- 显示所有的数据库
show databases

-- 删除数据库
drop database "db_name"

-- 切换数据库
use db_name

-- 显示该数据库中所有的表
show measurements


SHOW RETENTION POLICIES
SHOW TAG KEYS FROM your_table
SHOW SERIES FROM your_table
SHOW FIELD KEYS FROM your_table

-- 创建表，直接在插入数据的时候指定表名
insert test,host=127.0.0.1,monitor_name=test count=1

-- 删除表
drop measurement "measurement_name"
```

# http api

```bash
curl -G 'http://localhost:8086/query?pretty=true' \
    --data-urlencode "db=_internal" \
    --data-urlencode 'q=select * from collectd'
```


# 注意
- 开源版不再支持集群


