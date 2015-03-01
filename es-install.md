

# yum 安装


yum/apt安装参考[这里](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html)。
并确保JDK版本， Java 8 update 20 or later, or Java 7 update 55 or later。

以下为yum安装。

## 导入 key

```
rpm --import https://packages.elasticsearch.org/GPG-KEY-elasticsearch
```

## 手动创建yum仓库配置文件

`vi /etc/yum.repos.d/elasticsearch.repo`  内容如下：

```
[elasticsearch-1.4]
name=Elasticsearch repository for 1.4.x packages
baseurl=http://packages.elasticsearch.org/elasticsearch/1.4/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1
```

## 安装

```
yum install elasticsearch
chkconfig --add elasticsearch
```

## 创建执行所需的系统用户

```
useradd es
```


## 修改配置文件

### 修改 init.d 脚本

`vi /etc/init.d/elasticsearc`

```
# 在最开始追加一下语句,使其能找到JAVA_HOME等相关环境变量
. /etc/profile.d/lizi.sh
```

### 修改 elasticsearch.yml 配置文件

`vi /etc/elasticsearch/elasticsearch.yml`

```
cluster.name : elasticsearch-lizi                  # 所有的集群名称要一致
node.name : es3                                    # 节点名如果不设置，会自动随机生成
path.data : /home/elasticsearch/data               # 根据实际情况修改, 默认是 /var/lib/elasticsearch
path.logs : /home/elasticsearch/logs
path.work : /home/elasticsearch/work
```

### 分别启动

```
service elasticsearch start
```


### 检查状态

```
curl 'localhost:9200/_cat/health?v'
curl 'localhost:9200/_cat/indices?v'
curl -XPUT 'localhost:9200/testIndex?pretty'  # 创建测试索引，之后再用上述两个命令检查状态 
```



# 7788

* 如果发现无法创建集群，请检查日志，确保publish_address正确。不正确就到elasticsearch.yml 中进行明确指定。
* 如果错误日志中出现 `Caused by: java.io.StreamCorruptedException: unexpected end of block data`，请检查JDK版本。





