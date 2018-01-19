# 集群配置
[参考](http://zookeeper.apache.org/doc/r3.4.6/zookeeperAdmin.html#sc_zkMulitServerSetup)，
下面是单主机配置多ZK集群。多主机的话，端口号就可以统一了。

1. 下载并解压，假设安装根目录目录为 $ZK_HOME

1. 集群规划

    |item                           |description       |
    |-------------------------------|------------------|
    |${ZK_HOME}/conf/zoo#.cfg       |zk节点#的配置文件|
    |${ZK_HOME}/data/#/data         |zk节点#的数据文件|
    |${ZK_HOME}/data/#/log          |zk节点#的数据日志目录|
    |${ZK_HOME}/data/#/logging      |zk节点#的log4j日志目录|
    |21#0                           |zk节点#端口：对Client提供服务的端口|
    |21#1                           |zk节点#端口：集群节点间进行数据同步的端口|
    |21#2                           |zk节点#端口：进行Master选举时的端口|

1. 在 ${ZK_HOME}/conf/ 目录下创建多个配置文件：zoo1.cfg、zoo2.cfg、zoo3.cfg

    ```ini
    clientPort=2110
    dataDir=${ZK_HOME}/data/1/data
    dataLogDir=${ZK_HOME}/data/1/log
    tickTime=2000
    initLimit=10
    syncLimit=5
    snapCount=100000
    maxClientCnxns=0
    autopurge.snapRetainCount=3
    autopurge.purgeInterval=1
    server.1=127.0.0.1:2111:2112
    server.2=127.0.0.1:2121:2122
    server.3=127.0.0.1:2131:2132
    ```
    注意：上面的clientPort、dataDir、dataLogDir要依次改一下。

1. 创建数据库目录、日志目录

    ```bash
    cd $ZK_HOME
    mkdir -p data/{1,2,3}/{data,log,logging}
    ```
1. 在数据目录下创建 myid 文件，该文件内容是server的Id。

    ```bash
    cd $ZK_HOME
    echo 1 > data/1/data/myid
    echo 2 > data/2/data/myid
    echo 3 > data/3/data/myid
    ```


1. 依次启动zk节点

    ```bash
    cd $ZK_HOME

    # 启动节点1
    export ZOO_LOG4J_PROP="DEBUG, CONSOLE, ROLLINGFILE"
    export ZOO_LOG_DIR="data/1/logging"
    ./bin/zkServer.sh start zoo1.cfg

    # 启动节点2
    export ZOO_LOG4J_PROP="DEBUG, CONSOLE, ROLLINGFILE"
    export ZOO_LOG_DIR="data/2/logging"
    ./bin/zkServer.sh start zoo2.cfg

    # 启动节点3
    export ZOO_LOG4J_PROP="DEBUG, CONSOLE, ROLLINGFILE"
    export ZOO_LOG_DIR="data/3/logging"
    ./bin/zkServer.sh start zoo3.cfg
    ```

1. 连接到集群上进行查看

    ```bash
    cd $ZK_HOME
    ./bin/zkCli.sh -server localhost:2110
    ./bin/zkCli.sh -server localhost:2120
    ./bin/zkCli.sh -server localhost:2130
    ```

1. 停止

    ```bash
    cd $ZK_HOME
    ./bin/zkServer.sh stop zoo1.cfg
    ./bin/zkServer.sh stop zoo2.cfg
    ./bin/zkServer.sh stop zoo3.cfg
    ```

