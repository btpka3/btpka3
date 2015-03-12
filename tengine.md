
由于官方的 Nginx 缺乏一些常用特性。比如：

1. 对于负载均衡，nginx 不支持 sticky session 方式。如果使用 ip hash, 也可能会负载不均衡。
1. 不支持对后台服务的health check。

因此，服务器上决定使用 [Tengine](http://tengine.taobao.org/) 来取代 Nginx 官方版。

## 安装

1. 安装依赖

    ```sh
    yum install openssl openssl-devel
    ```

1. 下载、编译并安装
    
    ```sh
    mkdir /usr/local/tengine
    
    cd /tmp
    wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
    tar zxvf tengine-2.1.0.tar.gz
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
    # 2. 在 "http {...}" 内加入 "include conf.d/*.conf;"
    # 3. 在最开始，设置 `user www`, 以非root 用户运行
    # 4. 修改 worker_process 为 CPU 核心数量
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
    systemctl statue tengine
    ```

### centos 6

1. 下载 init.d 脚本。从 [这里](http://wiki.nginx.org/InitScripts) 为 CentOS 下载 `Red Hat /etc/init.d/nginx`, 并保存到 `/etc/init.d/nginx`

1.  修改  `/etc/init.d/nginx` ,

    ```sh
    nginx="/usr/local/tengine-2.1.0/sbin/nginx"
    NGINX_CONF_FILE="/usr/local/tengine-2.1.0/conf/nginx.conf"
    ```	