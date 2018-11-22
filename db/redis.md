# 参考

* [Running Redis in production ](http://shokunin.co/blog/2014/11/11/operational_redis.html)

# docker

```

docker pull redis:3.2.4

docker stop my-redis
docker rm my-redis
docker run -itd \
        --name my-redis \
        -p 6379:6379 \
        -v /Users/zll/tmp/my-redis/data/:/data \
        redis:3.2.4

docker start my-redis

docker exec -it my-redis bash

config get databases
info keyspace

```


# Cluster and Sentinel

每个 Redis 集群节点都要提供两个端口:

* 6379: 数据端口
* 16379: 集群端口,是数据端口号加上固定值 1000


Redis Cluster的作用: 将超过单机存储限制的数据分片存储在多台主机上。
Redis Sentinel的作用: 使用一主多从模式保证高可用性。

设计

|Host| Cluster Node, Sentinel Master Node| cluster slots | Sentinel slave node  |
|----|-----------------------------------|---------------|----------------------|
| 1  | A                                 |    0 -  999   | B1                   |
| 2  | B                                 | 1000 - 1999   | C1                   |
| 3  | C                                 | 2000 - 2999   | A1                   |

假如 host2 宕机了, 则由 A@host1, B1@host1, C@host3 共通构成一个完整的集群。

# 安装

1. 创建系统用户redis，及所需的目录

    ```bash
    cd ~/Downloads
    wget http://download.redis.io/releases/redis-3.0.3.tar.gz
    tar xzf redis-3.0.3.tar.gz
    cd redis-3.0.3
    make
    make PREFIX=/data0/soft/redis/redis-3.0.3 install

    [root@localhost ~]# adduser -r -m  -d /data/software/redis redis
    [root@localhost ~]# passwd -l redis

    [root@localhost ~]# mkdir /data/store/redis
    [root@localhost ~]# chown -R redis:redis /data/store/redis

    [root@localhost ~]# mkdir /data/outputs/log/redis
    [root@localhost ~]# chown -R redis:redis /data/outputs/log/redis

    ```
1. 从[Redis官网](http://redis.io/download)下载所需的安装包，或者查看文件共享：`\\10.1.10.212\share\java\redis\`。放到 `/data/tmp/` 目录下，并解压：

    ```bash
    [root@localhost ~]# mkdir /data/tmp
    [root@localhost ~]# scp root@10.1.10.212:/data/share/java/redis/redis-2.8.7.tar.gz /data/tmp
    [root@localhost ~]# tar zxvf /data/tmp/redis-2.8.7.tar.gz -C /data/software/redis/
    [root@localhost ~]# chown -R redis:redis /data/software/redis/
    ```
1. 编译

    ```bash
    [root@localhost ~]# su - redis
    [redis@localhost ~]$ cd /data/software/redis/redis-2.8.7/
    [redis@localhost redis-2.8.7]$ make
    ```
1. 修改配置文件

    ```bash
    [root@localhost ~]# /data/software/redis/redis-2.8.7/redis.conf
      daemonize yes
      pidfile /data/store/redis/redis.pid
      port 6379
      dir /data/store/redis/
    ```

1. 从[这里](init.d.redis)下载Redis的init.d脚本至 `/etc/init.d/redis`，修改后并启用

    ```bash
    [root@localhost ~] vi /etc/init.d/redis
      exec="/data/software/redis/redis-2.8.7/src/redis-server"
      pidfile="/data/store/redis/redis.pid"                                                                 # 应当与redis.conf中的配置保持一致
      REDIS_CONFIG="/data/software/redis/redis-2.8.7/redis.conf"
      REDIS_USER=redis
    [root@localhost ~]# chmod u+x /etc/init.d/redis
    [root@localhost ~]# chkconfig --add redis
    [root@localhost ~]# chkconfig --list redis
    [root@localhost ~]# chkconfig --level 345 redis on
    ```
1. 启动

    ```bash
    [root@localhost ~]# service redis start
    ```



---------------------------------------------------------------------------
TODO 上下合并


# 安装

1. 创建系统用户redis，及所需的目录

    ```bash
    adduser -r -m  -d /data/software/redis redis
    passwd -l redis

    mkdir /data/store/redis
    chown -R redis:redis /data/store/redis

    mkdir /data/outputs/log/redis
    chown -R redis:redis /data/outputs/log/redis

    ```
1. 从[Redis官网](http://redis.io/download)下载所需的安装包。放到 `/data/tmp/` 目录下，并解压：

    ```bash
    mkdir /data/tmp
    wget http://download.redis.io/releases/redis-2.8.14.tar.gz
    tar zxvf redis-2.8.14.tar.gz -C redis/
    chown -R redis:redis redis/
    ```
1. 编译

    ```bash
    su - redis
    cd /data/software/redis/redis-2.8.7/
    make
    ```
1. 修改系统设置

    ```bash
    vi /etc/sysctl.conf
    vm.overcommit_memory = 1

    sysctl vm.overcommit_memory=1
    ```


1. 修改配置文件 `/data/software/redis/redis-2.8.7/redis.conf`

    ```groovy
    daemonize yes
    pidfile /data/store/redis/redis.pid
    port 6379
    dir /data/store/redis/

    unixsocket /tmp/redis.sock
    unixsocketperm 770
    ```


## centos 6

1. 准备 init.d 脚本（可以搜索 redis rpm，找到rpm包后解压获取相应的init.d脚本，然后在再其基础上修改配置项）
    ```bash
    #!/bin/sh
    #
    # redis        init file for starting up the redis daemon
    #
    # chkconfig:   - 20 80
    # description: Starts and stops the redis daemon.

    # Source function library.
    . /etc/rc.d/init.d/functions

    name="redis-server"
    exec="/home/redis/redis-2.8.12/src/redis-server"
    pidfile="/home/redis/redis-2.8.12/redis.pid"
    REDIS_CONFIG="/home/redis/redis-2.8.12/redis.conf"
    REDIS_USER=redis

    [ -e /etc/sysconfig/redis ] && . /etc/sysconfig/redis

    lockfile=/var/lock/subsys/redis

    start() {
        [ -f $REDIS_CONFIG ] || exit 6
        [ -x $exec ] || exit 5
        echo -n $"Starting $name: "
        daemon --user ${REDIS_USER-redis} "$exec $REDIS_CONFIG  --daemonize yes --pidfile $pidfile"
        retval=$?
        echo
        [ $retval -eq 0 ] && touch $lockfile
        return $retval
    }

    stop() {
        echo -n $"Stopping $name: "
        killproc -p $pidfile $name
        retval=$?
        echo
        [ $retval -eq 0 ] && rm -f $lockfile
        return $retval
    }

    restart() {
        stop
        start
    }

    reload() {
        false
    }

    rh_status() {
        status -p $pidfile $name
    }

    rh_status_q() {
        rh_status >/dev/null 2>&1
    }


    case "$1" in
        start)
            rh_status_q && exit 0
            $1
            ;;
        stop)
            rh_status_q || exit 0
            $1
            ;;
        restart)
            $1
            ;;
        reload)
            rh_status_q || exit 7
            $1
            ;;
        force-reload)
            force_reload
            ;;
        status)
            rh_status
            ;;
        condrestart|try-restart)
            rh_status_q || exit 0
            restart
            ;;
        *)
            echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart}"
            exit 2
    esac
    exit $?
    ```
    并修改其中的配置项 `vi /etc/init.d/redis`

    ```bash
    exec="/data/software/redis/redis-2.8.14/src/redis-server"
    pidfile="/data/store/redis/redis.pid"                                                                 # 应当与redis.conf中的配置保持一致
    REDIS_CONFIG="/data/software/redis/redis-2.8.14/redis.conf"
    REDIS_USER=redis
    ```
    最后为 init.d 脚本修改权限

    ```bash
    chmod u+x /etc/init.d/redis
    chkconfig --add redis
    chkconfig --list redis
    chkconfig --level 345 redis on
    ```
1. 启动

    ```bash
    service redis start
    ```

## centos 7

1. `vi /usr/lib/systemd/system/redis.service`

    ```
    [Unit]
    Description=Redis Server
    After=network.target

    [Service]
    Type=forking
    ExecStart=/usr/local/bin/redis-server /home/redis/redis.conf
    ExecStop=/bin/kill -15 $MAINPID
    PIDFile=/home/redis/redis.pid
    Restart=always
    User=redis
    LimitNOFILE=65535

    [Install]
    WantedBy=multi-user.target
    ```

1. `systemctl enable redis`

1. `systemctl start redis`
