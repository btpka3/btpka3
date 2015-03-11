
由于官方的 Nginx 缺乏一些常用特性。比如：

1. 对于负载均衡，nginx 不支持 sticky session 方式。如果使用 ip hash, 也可能会负载不均衡。
1. 不支持对后台服务的health check。

因此，服务器上决定使用 [Tengine](http://tengine.taobao.org/) 来取代 Nginx 官方版。

# 安装

```sh
yum install openssl openssl-devel

mkdir /tmp/99
cd /tmp/99
wget http://tengine.taobao.org/download/tengine-2.1.0.tar.gz
tar zxvf tengine-2.1.0.tar.gz
cd tengine-2.1.0
./configure --prefix=/usr/local/tengine-2.1.0 --user=nginx
make
make install

```

# 修改配置

```sh
cd /usr/local/tengine-2.1.0
mkdir conf.d
vi conf/nginx.conf
# 1. 启用 "log_format main ..."
# 2. 在 "http {...}" 内加入 "include ../conf.d/*.conf;"
```

# 准备 init.d 脚本
从 [这里](http://wiki.nginx.org/InitScripts) 为 CentOS 下载 `Red Hat /etc/init.d/nginx`, 并修改其中两行

```sh
nginx="/usr/local/tengine-2.1.0/sbin/nginx"
NGINX_CONF_FILE="/usr/local/tengine-2.1.0/conf/nginx.conf"
```