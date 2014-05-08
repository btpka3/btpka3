# 安装

1. 创建系统用户redis，及所需的目录

    ```sh
    [root@localhost ~]# adduser -r -m  -d /data/software/redis redis 
    [root@localhost ~]# passwd -l redis
    
    [root@localhost ~]# mkdir /data/store/redis
    [root@localhost ~]# chown -R redis:redis /data/store/redis
    
    [root@localhost ~]# mkdir /data/outputs/log/redis
    [root@localhost ~]# chown -R redis:redis /data/outputs/log/redis

    ```
1. 从[Redis官网](http://redis.io/download)下载所需的安装包，或者查看文件共享：`\\10.1.10.212\share\java\redis\`。放到 `/data/tmp/` 目录下，并解压：

    ```sh
    [root@localhost ~]# mkdir /data/tmp
    [root@localhost ~]# scp root@10.1.10.212:/data/share/java/redis/redis-2.8.7.tar.gz /data/tmp
    [root@localhost ~]# tar zxvf /data/tmp/redis-2.8.7.tar.gz -C /data/software/redis/
    [root@localhost ~]# chown -R redis:redis /data/software/redis/
    ```
1. 编译

    ```sh
    [root@localhost ~]# su - redis
    [redis@localhost ~]$ cd /data/software/redis/redis-2.8.7/
    [redis@localhost redis-2.8.7]$ make
    ```
1. 修改配置文件

    ```sh
    [root@localhost ~]# /data/software/redis/redis-2.8.7/redis.conf
      daemonize yes
      pidfile /data/store/redis/redis.pid
      port 6379
      dir /data/store/redis/
    ```

1. 从[这里](/snippets/2)下载Redis的init.d脚本至 `/etc/init.d/redis`，修改后并启用

    ```sh
    [root@localhost ~] vi /etc/init.d/redis
      exec="/data/software/redis/redis-2.8.7/src/redis-server"
      pidfile="/data/store/redis/redis.pid"                                                                 # 应当与redis.conf中的配置保持一致
      REDIS_CONFIG="/data/software/redis/redis-2.8.7/redis.conf"
      REDIS_USR=redis
    [root@localhost ~]# chmod u+x /etc/init.d/redis
    [root@localhost ~]# chkconfig --add redis
    [root@localhost ~]# chkconfig --list redis
    [root@localhost ~]# chkconfig --level 345 redis on
    ```
1. 启动

    ```sh
    [root@localhost ~]# service redis start
    ```
