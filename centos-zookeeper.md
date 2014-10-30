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