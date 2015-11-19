
由于官方的 Nginx 缺乏一些常用特性。比如：

1. 对于负载均衡，nginx 不支持 sticky session 方式。如果使用 ip hash, 也可能会负载不均衡。
1. 不支持对后台服务的health check。

因此，服务器上决定使用 [Tengine](http://tengine.taobao.org/) 来取代 Nginx 官方版。

## 安装

1. 安装依赖

    ```sh
    yum install openssl openssl-devel
    # 或者
    sudo apt-get install openssl libssl-dev
    sudo apt-get install build-essential
    sudo apt-get install linux-kernel-headers
    sudo apt-get install gcc libpcre3 libpcre3-dev zlib1g-dev 
    ```

1. 下载、编译并安装
    
    ```sh
    mkdir /usr/local/tengine
    
    cd /tmp
    wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
    tar zxvf tengine-2.1.0.tar.gz
    chown -R root:root tengine-2.1.0
    cd tengine-2.1.0
    ./configure --prefix=/usr/local/tengine/tengine-2.1.0 --user=nginx
    make
    make install
    ```


1. 修改配置

    ```sh
    cd /usr/local/tengine/tengine-2.1.0
    mkdir conf/conf.d
    vi conf/nginx.conf
    # 1. 启用 "log_format main ..."
    # 2. 在 "http {...}" 的 最后一行 加入 "include conf.d/*.conf;"
    # 3. 在最开始，设置 `user www`, 以非root 用户运行
    # 4. 修改 worker_process 为 CPU 核心数量      # cat /proc/cpuinfo|grep "model name"
    # 5. 在 "http {...}" 的 最后一行 加入 "add_header X-nodes test12;", 其中 test12 是主机名，请自行替换。

    useradd www
    chown -R www:www logs
    ```
1. 线上生产环境还要启用一下gzip，可以直接修改 nginx.conf
  
    ```conf
    gzip  on; 
    gzip_types  text/plain
                text/css
                text/js
                text/xml
                text/javascript
                application/javascript
                application/x-javascript
                application/json
                application/xml
                application/xml+rss;
    ```


### centos 7

1. 新建 systemd 所需的 service 文件： `vi /usr/lib/systemd/system/tengine.service` :

    ```
    [Unit]
    Description=Tengine Server
    After=network.target

    [Service]
    Type=forking
    ExecStartPre=/usr/local/tengine/tengine-2.1.0/sbin/nginx -t
    ExecStart=/usr/local/tengine/tengine-2.1.0/sbin/nginx
    ExecReload=/bin/kill -s HUP $MAINPID
    ExecStop=/bin/kill -s QUIT $MAINPID
    WorkingDirectory=/usr/local/tengine/tengine-2.1.0/
    PIDFile=/usr/local/tengine/tengine-2.1.0/logs/nginx.pid
    Restart=always
    User=root
    LimitNOFILE=65535
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
    ```

1.  启用、启动

    ```    
    systemctl enable tengine
    systemctl start tengine
    systemctl status tengine
    ```

### centos 6

1. 下载 init.d 脚本。从 [这里](http://wiki.nginx.org/InitScripts) 为 CentOS 下载 `Red Hat /etc/init.d/nginx`, 并保存到 `/etc/init.d/nginx`

1.  修改  `/etc/init.d/nginx` ,

    ```sh
    nginx="/usr/local/tengine-2.1.0/sbin/nginx"
    NGINX_CONF_FILE="/usr/local/tengine-2.1.0/conf/nginx.conf"
    ```	

### ubuntu

参考[这里](http://wiki.nginx.org/Upstart)

1. make

    ```
    sudo apt-get install libpcre3 libpcre3-dev
    sudo apt-get install openssl libssl-dev
    ```


1. `vi /etc/init/tengine.conf`

    ```
    # tengine

    description "tengine http daemon"
     
    start on (filesystem and net-device-up IFACE=lo)
    stop on runlevel [!2345]
     
    env DAEMON=/usr/local/tengine/tengine-2.1.0/sbin/nginx
    env PID=/usr/local/tengine/tengine-2.1.0/logs/nginx.pid
     
    expect fork
    respawn
    respawn limit 10 5
    #oom never
     
    pre-start script
            $DAEMON -t
            if [ $? -ne 0 ] 
                    then exit $?
            fi
    end script
     
    exec $DAEMON
    ```

1. 启动
 
    ```
    sudo service tengine status
    sudo service tengine start
    ```