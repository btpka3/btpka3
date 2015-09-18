# 安装

1. 创建系统用户zookeeper，及所需的目录

    ```sh
    adduser -r -m  -d /data/software/zookeeper zookeeper 
    passwd -l zookeeper
    ```
   
1. 下载并解压

    ```
    cd /data/software
    wget http://mirror.bit.edu.cn/apache/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz
    tar zxvf zookeeper-3.4.6.tar.gz
    cd zookeeper-3.4.6
    ```

1. 创建所需的目录结构

    ```sh
    cd $ZK_HOME
    mkdir server.1                        # ZK集群第一个节点的数据目录
    mkdir server.1/data                   # ZK的数据目录
    mkdir server.1/log                    # ZK的数据日志目录
    mkdir server.1/logging                # ZK的log4j的日志目录
    echo "1" > server.1/data/myid         # 创建数据目录中的myid文件，内容与当前节点的编号一致。
    ```

1. 创建/修改 $ZK_HOME/conf/zoo.cfg 配置文件。注意：该配置文件不可使用行尾注释

    ```cfg
    clientPort=2110
    dataDir=/data/software/zookeeper-3.4.6/server.3/data
    dataLogDir=/data/software/zookeeper-3.4.6/server.3/log
    tickTime=2000
    initLimit=10
    syncLimit=5
    snapCount=100000
    maxClientCnxns=0
    autopurge.snapRetainCount=3
    autopurge.purgeInterval=1
    server.1=zk1.test.me:2111:2112
    server.2=zk2.test.me:2121:2122
    server.3=zk3.test.me:2131:2132
    ```

1. `vi ${ZK_HOME}/conf/log4j.properties`

    ```properties
    zookeeper.log.dir=/data/software/zookeeper/zookeeper-3.4.6/server.1/logging
    zookeeper.tracelog.dir=/data/software/zookeeper/zookeeper-3.4.6/server.1/logging
    ```

1. `vi ${ZK_HOME}/bin/zkEnv.sh`

    ```
    # 设置日志日志目录
    ZOO_LOG_DIR=/data/outputs/log/zookeeper
    # 新增：明确写明PID文件的路径。zookeeper用户必须对要求目录有写权限。
    ZOOPIDFILE=/data/store/zookeeper/zookeeper_server.pid    
    ```

##  centos 6

1. `vi /etc/init.d/zk`

    ```sh
    #!/bin/bash
    # chkconfig: 2345 60 60
    # description: xxx

    . /etc/profile.d/xxx.sh

    export ZK_HOME=/data/software/zookeeper-3.4.6
    export ZOO_LOG4J_PROP="INFO, ROLLINGFILE"
    export ZOO_LOG_DIR="${ZK_HOME}/server.1/logging"
    RUNNING_USER=lizi

    today=`date +%Y%m%d%H%M%S`
    export SERVER_JVMFLAGS="\
        -server \
        -Xms64m \
        -Xmx1024m \
        -XX:PermSize=16m \
        -XX:MaxPermSize=64m \
        -Xss256k \
        -XX:ErrorFile=${ZOO_LOG_DIR}/start.at.${today}.hs_err_pid.log \
        -XX:+UseConcMarkSweepGC \
        -XX:+HeapDumpOnOutOfMemoryError \
        -XX:HeapDumpPath=${ZOO_LOG_DIR}/start.at.${today}.dump.hprof \
        -XX:+PrintGCDateStamps \
        -XX:+PrintGCDetails \
        -Xloggc:${ZOO_LOG_DIR}/start.at.${today}.gc.log \
        -Duser.timezone=GMT+08 \
        -Dfile.encoding=UTF-8 \
    "

    if [[ `whoami` = "$RUNNING_USER" ]]
    then
       $ZK_HOME/bin/zkServer.sh $@
    else
        su -p -s /bin/sh ${RUNNING_USER} -c "$ZK_HOME/bin/zkServer.sh $*"
    fi
    ```

1. 设置chkconfig

    ```
    chmod u+x /etc/init.d/zk
    chkconfig --add zk
    chkconfig --list zk
    chkconfig --level 345 zk on
    ```

1. 启动ZK集群

    ```sh
    # 到不同的ZK节点的服务上执行
    service zk start
    ```

1. 命令行连接ZK集群

    ```sh
    cd $ZK_HOME
    ./bin/zkCli.sh -server localhost:2110
    ```

##  centos 7
1. `vi /usr/local/zookeeper/zookeeper-3.4.6/bin/zkServer.sh`

    ```
    # 在最开始追加以下语句
    . /etc/profile.d/xxx.sh
    ```

1. `vi /usr/lib/systemd/system/zookeeper.service`

    ```
    [Unit]
    Description=Zookeeper Server
    After=network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/zookeeper/zookeeper-3.4.6/bin/zkServer.sh start
    ExecStop=/bin/kill -15 $MAINPID
    WorkingDirectory=/home/zookeeper
    PIDFile=/home/zookeeper/data/zookeeper_server.pid
    Restart=always
    User=zookeeper
    LimitNOFILE=65535

    [Install]
    WantedBy=multi-user.target
    ```

2. 启用并启动

    ```
    systemctl enable zookeeper
    systemctl start zookeeper
    systemctl status zookeeper
    ```