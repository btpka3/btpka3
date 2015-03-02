# 安装

1. 创建系统用户zookeeper，及所需的目录

    ```sh
    adduser -r -m  -d /data/software/zookeeper zookeeper 
    passwd -l zookeeper
    
    mkdir /data/store/zookeeper 
    chown -R zookeeper:zookeeper /data/store/zookeeper 
    
    mkdir /data/outputs/log/zookeeper
    chown -R zookeeper:zookeeper /data/outputs/log/zookeeper 
    ```
1. 从[Zookeeper官网](http://zookeeper.apache.org/)下载所需的安装包，或者查看文件共享：`\\10.1.10.212\share\java\zookeeper\`。放到 `/data/tmp/` 目录下，并解压：

    ```sh
    mkdir /data/tmp
    scp root@10.1.10.212:/data/share/java/zookeeper/zookeeper-3.4.6.tar.gz /data/tmp
    tar zxvf /data/tmp/zookeeper-3.4.6.tar.gz -C /data/software/zookeeper/
    chown -R zookeeper:zookeeper /data/software/zookeeper/zookeeper-3.4.6
    ```
1. 修改配置文件

    ```sh
    vi /data/software/zookeeper/zookeeper-3.4.6/conf/zoo.cfg
      dataDir=/data/store/zookeeper                  # zookeeper存储的目录
      clientPort=2181
      server.1=10.1.10.215:2888:3888
      server.2=10.1.10.216:2888:3888
      server.3=10.1.10.217:2888:3888
    
    vi /data/software/zookeeper/zookeeper-3.4.6/conf/log4j.properties
      zookeeper.log.dir=/data/outputs/log/zookeeper
    
    vi /data/software/zookeeper/zookeeper-3.4.6/bin/zkEnv.sh
      # 设置日志日志目录
      ZOO_LOG_DIR=/data/outputs/log/zookeeper
      # 新增：明确写明PID文件的路径。zookeeper用户必须对要求目录有写权限。
      ZOOPIDFILE=/data/store/zookeeper/zookeeper_server.pid    
    ```

1. 从[这里](https://github.com/globocom/zookeeper-centos-6/blob/master/redhat/zookeeper.init)下载Zookeeper的init.d脚本至 `/etc/init.d/zookeeper`，修改后并启用

    ```sh
    vi /etc/init.d/zookeeper
      ZK_HOME="/data/software/zookeeper/zookeeper-3.4.6"
      RUNNING_USER=zookeeper
      LOCK_FILE=/var/lock/subsys/zookeeper
      source /etc/profile.d/his.sh                                        # 根据实际情况修改该行。service命令只会保留LANG和TERM
    chmod u+x /etc/init.d/zookeeper
    chkconfig --add zookeeper
    chkconfig --list zookeeper
    chkconfig --level 345 zookeeper on
    ```
1. 启动

    ```sh
    service zookeeper start
    ```



https://github.com/Netflix/exhibitor/wiki/Building-Exhibitor
http://curator.apache.org/




-----------------------------------------------
TODO 合并


# 安装

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

1. 创建/修改zoo.cfg配置文件。注意：该配置文件不可使用行尾注释

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
    server.1=zk1.dev.lizi.com:2111:2112
    server.2=zk2.dev.lizi.com:2121:2122
    server.3=zk3.dev.lizi.com:2131:2132
    ```


1. 编辑 init.d 脚本

    ```sh
    vi /etc/init.d/zk
    ```
    内容如下：

    ```sh
    #!/bin/bash
    # chkconfig: 2345 60 60
    # description: xxx

    . /etc/profile.d/lizi.sh

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