

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

## centos 7 安装

```
yum install elasticsearch
systemctl enable elasticsearch
systemctl start elasticsearch
systemctl status elasticsearch
```

### 配置方式一 
通过环境变量进行配置。

1. 不要修改 `/etc/elasticsearch/elasticsearch.yml`（其初始内容为空）
1. 修改 `/etc/sysconfig/elasticsearch`            # 配置环境变量，含JAVA_HOME

### 配置方式二

通过配置文件进行配置

1.  检查 systemd 配置文件

    ```
    cat /usr/lib/systemd/system/elasticsearch.service
    ```

1. `vi /etc/elasticsearch/elasticsearch.yml`

    ```
    cluster.name : elasticsearch-lizi                  # 所有的集群名称要一致
    node.name : es3                                          # 节点名如果不设置，会自动随机生成
    path.data : /home/elasticsearch/data          # 根据实际情况修改, 默认是 /var/lib/elasticsearch
    path.logs : /home/elasticsearch/logs
    path.work : /home/elasticsearch/work
    ```

1. 修改 `vi /usr/share/elasticsearch/bin/elasticsearch` ,

    ```
    # 在最开始引入如下一行，主要为了引入环境变量 JAVA_HOME
    . /etc/profile.d/jujn.sh
    ```




## centos 6 安装

```
yum install elasticsearch
chkconfig --add elasticsearch
```

## 创建执行所需的系统用户

```
useradd elasticsearch
```


## 修改配置文件

### 修改 init.d 脚本

`vi /etc/init.d/elasticsearch`

```
# 在最开始追加一下语句,使其能找到JAVA_HOME等相关环境变量
. /etc/profile.d/xxx.sh
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






# ES安装目录文件说明
按照[这里](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/setup-repositories.html)安装之后，
其es的文件目录为：
* /etc/elasticsearch   -- 即为es的config目录，里面包括：elasticsearch.yml   logging.yml
* /usr/share/elasticsearch -- es的安装目录

这里和网上的资料不大一样！

# 插件安装
以大名鼎鼎的ik插件为例！
###  下载[ik插件ZIP资源](https://github.com/medcl/elasticsearch-analysis-ik)
右侧下方有一个按钮“Download ZIP"，点击下载源代码elasticsearch-analysis-ik-master.zip。

###  解压ZIP文件
解压文件elasticsearch-analysis-ik-master.zip，进入下载目录，执行命令：
```java
    unzip elasticsearch-analysis-ik-master.zip  
```

###  复制ik
将解压目录文件中config文件夹下的ik文件夹复制到ES的config文件夹（即：/etc/elasticsearch/）下。

###  打包
因为是源代码，此处需要使用maven打包，进入解压文件夹中，执行命令：
```java
    mvn clean package  
``` 
### 复制jar
* 在ES安装目录（/usr/share/elasticsearch）下新建文件夹plugins,以后的插件都放在这个文件夹下;
* 在plugins下新建ik的文件夹analysis-ik;
* 将上步打包生成的zip文件（位置：/target/releases/elasticsearch-analysis-ik-1.2.9.zip）复制到analysis-ik下并将其中的jar解压出来

### 修改elasticsearch.yml配置
在elasticsearch.yml的最后添加
```java
    index:  
      analysis:                     
        analyzer:        
          ik:  
              alias: [ik_analyzer]  
              type: org.elasticsearch.index.analysis.IkAnalyzerProvider  
          ik_max_word:  
              type: ik  
              use_smart: false  
          ik_smart:  
              type: ik  
              use_smart: true  
```
或者
```java
index.analysis.analyzer.ik.type : "ik"  
```

### 重启ES
```java
sudo service elasticsearch restart
sudo service elasticsearch status
```

### 验证
执行
```java
    curl -XPOST  "http://localhost:9200/${index}/_analyze?analyzer=ik&pretty=true&text=我是中国人"  
```
验证结果是否正确。
注意：必须先创建索引，才能验证。
		