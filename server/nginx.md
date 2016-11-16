# docker 安装

```
mkdkir -p ~/tmp/my-nginx/conf/conf.d


docker pull nginx:1.10.2
docker run -d --name my-nginx nginx:1.10.2
docker cp my-nginx:/etc/nginx/nginx.conf ~/tmp/my-nginx/conf/nginx.conf
docker cp my-nginx:/etc/nginx/conf.d ~/tmp/my-nginx/conf/
docker stop my-nginx
docker rm my-nginx 

docker run \
    --name my-nginx \
    -d \
    -p 80:80 \
    -p 443:443 \
    -v ~/tmp/my-nginx/conf/nginx.conf:/etc/nginx/nginx.conf:ro \
    -v ~/tmp/my-nginx/conf/conf.d:/etc/nginx/conf.d:ro \
    nginx:1.10.2

docker exec -it my-nginx bash
```


pam : see [here](http://www.doublecloud.org/2014/01/nginx-with-pam-authentication/)

# 参考

* 《[NGINX引入线程池 性能提升9倍](https://yq.aliyun.com/articles/26635?&utm_campaign=sys&utm_medium=market&utm_source=edm_email&msctype=email&mscmsgid=117816050400209379&)》

# 基础配置


```
worker_processes      auto;
worker_rlimit_nofile  100000; 



events {
    use                   epoll;
    worker_connections    2048;
    multi_accept          on;
}

http {
    server_tokens            off;
    sendfile                 on;
    tcp_nopush               on;
    tcp_nodelay              on;
    access_log               off;
    keepalive_timeout        30s;
    client_header_timeout    20s;
    client_body_timeout      20s;
    send_timeout             20s;
    reset_timedout_connection on;
    limit_conn_zone          $binary_remote_addr zone=addr:10m;
    limit_conn               addr 100;
    charset                  UTF-8;
    default_type             application/octet-stream;

    gzip                     on;
    gzip_disable             "msie6";
    # gzip_static            on;
    gzip_proxied             any;
    gzip_min_length          1000;
    gzip_comp_level          4;
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


    open_file_cache         max=10000 inactive=600s;
    open_file_cache_valid   30s;
    open_file_cache_min_uses 1;
    open_file_cache_errors  on;

    fastcgi_buffers          32      8k;
    client_body_buffer_size  1024k;
    client_max_body_size     10m;
}
```

# 编译的模块

[Nginx Modules](http://wiki.nginx.org/Modules)、
[Nginx 3rdPartyModules](http://wiki.nginx.org/3rdPartyModules)

```sh
[root@locahost ~]# /usr/sbin/nginx -h
[root@locahost ~]# /usr/sbin/nginx -V
nginx version: nginx/1.4.7
built by gcc 4.4.7 20120313 (Red Hat 4.4.7-3) (GCC) 
TLS SNI support enabled
configure arguments: 
    --prefix=/etc/nginx 
    --sbin-path=/usr/sbin/nginx 
    --conf-path=/etc/nginx/nginx.conf 
    --error-log-path=/var/log/nginx/error.log 
    --http-log-path=/var/log/nginx/access.log 
    --pid-path=/var/run/nginx.pid 
    --lock-path=/var/run/nginx.lock 
    --http-client-body-temp-path=/var/cache/nginx/client_temp 
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp 
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp 
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp 
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp 
    --user=nginx 
    --group=nginx 
    --with-http_ssl_module 
    --with-http_realip_module 
    --with-http_addition_module 
    --with-http_sub_module 
    --with-http_dav_module 
    --with-http_flv_module 
    --with-http_mp4_module 
    --with-http_gunzip_module 
    --with-http_gzip_static_module 
    --with-http_random_index_module 
    --with-http_secure_link_module 
    --with-http_stub_status_module 
    --with-mail --with-mail_ssl_module 
    --with-file-aio --with-ipv6 
    --with-cc-opt='-O2 -g -pipe -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic'

```



## stickiness 反向代理
[ngx_http_upstream_module](http://nginx.org/en/docs/http/ngx_http_upstream_module.html)  
3rd [nginx-upstream-jvm-route](https://code.google.com/p/nginx-upstream-jvm-route/)  
3rd [nginx-sticky-module](https://code.google.com/p/nginx-sticky-module)  


关于反向代理 Jetty 的 [X-Forwarded-For](http://eclipse.org/jetty/documentation/current/configuring-connectors.html#jetty-connectors-http-configuration) 的配置。



```conf
http {
    # ...
    upstream tomcat8080 {
        server                        10.1.10.104:8080 weight=1 max_fails=1 fail_timeout=1s;
        server                        10.1.18.74:8080  weight=1 max_fails=1 fail_timeout=1s;
    }

    server {
        listen                        80;
        server_name                   www.test.me;
        access_log                    /var/log/nginx/me.access.log     main;
        error_log                     /var/log/nginx/me.error.log      notice;
        root                          /var/www/;

        location / {
            proxy_next_upstream http_500 http_502 http_503 http_504 timeout error invalid_header;
            proxy_pass                http://tomcat8080;
            proxy_set_header  X-Real-IP  $remote_addr;
            index  index.html index.htm index.php;
    }
}
```

# OpenSSL heartbleed
[heartbleed](http://heartbleed.com/)、
[nginx and heartbleed](http://nginx.com/blog/nginx-and-the-heartbleed-vulnerability)

```
# nginx 使用的ssl的版本是？
ldd /path/to/nginx | grep ssl
strings /lib64/libssl.so.10 | grep "^OpenSSL "

# nginx 使用的是静态链接还是动态链接？
/path/to/nginx -V
```

### 被代理的服务器健康检测
[proxy_next_upstream](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)  
[fastcgi_next_upstream](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_next_upstream)  
[healthcheck_nginx_upstreams](https://github.com/cep21/healthcheck_nginx_upstreams)  
3rd [nginx_upstream_check_module](https://github.com/yaoweibin/nginx_upstream_check_module)


## https 反向代理

[1](http://www.cyberciti.biz/faq/howto-linux-unix-setup-nginx-ssl-proxy/)
[2](http://webapp.org.ua/sysadmin/setting-up-nginx-ssl-reverse-proxy-for-tomcat/)

```conf
server {
    location / {
         proxy_pass              http://tomcat_server;
         proxy_set_header        Host            $host;   # ???  $http_host;
         proxy_set_header        X-Real-IP       $remote_addr;
         proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
         proxy_set_header        X-Forwarded-Proto $scheme;
         add_header              Front-End-Https   on;
         proxy_redirect          off;
    }
}
```
[参考](http://wiki.nginx.org/Install)

# 安装
1. 新增nginx的yum仓库，`vi /etc/yum.repos.d/nginx.repo`

    ```sh
    [nginx]
    name=nginx repo
    baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
    gpgcheck=0
    enabled=1
    ```
2. 安装

    ```sh
    [root@locahost ~]# yum list nginx 
    [root@locahost ~]# yum install nginx
    [root@locahost ~]# chkconfig --list nginx
    [root@locahost ~]# chkconfig --level 345 nginx on
    ```
3. 创建所需的必要目录

    ```sh
    [root@locahost ~]# mkdir /data/outputs/log/nginx
    [root@locahost ~]# mkdir /data/store/nginx
    ```

## 正向代理

```conf
server {
    listen 192.168.0.10:80;

    #access_log      logs/proxy.access.log   main;
    #error_log       logs/proxy.error.log    notice;
    access_log      off;
    error_log       off;

    location / {
        resolver   180.76.76.76;

        set $flag 0;
        if ($http_host = fonts.googleapis.com) {
            set $flag 1;
        }
        if ($http_host = ajax.googleapis.com) {
            set $flag 2;
        }

        if ($flag = 0) {
            proxy_pass http://$http_host$uri$is_args$args;
        }
        if ($flag = 1) {
            proxy_pass http://fonts.useso.com$uri$is_args$args;
        }
        if ($flag = 2) {
            proxy_pass http://ajax.useso.com$uri$is_args$args;
        }
    }
}

server {
    listen 192.168.0.10:443;

    ssl                     on;
    ssl_certificate         conf.d/jujncn.com.pem.cer;
    ssl_certificate_key     conf.d/jujncn.com.pem.clear.key;

    #access_log      logs/proxy.access.log   main;
    #error_log       logs/proxy.error.log    notice;
    access_log      off;
    error_log       off;

    #return 301 http://$http_host$request_uri;

    location / {
        resolver   180.76.76.76;

        set $flag 0;
        if ($http_host = fonts.googleapis.com) {
            set $flag 1;
        }
        if ($http_host = ajax.googleapis.com) {
            set $flag 2;
        }

        if ($flag = 0) {
            proxy_pass http://$http_host$uri$is_args$args;
        }
        if ($flag = 1) {
            proxy_pass http://fonts.useso.com$uri$is_args$args;
        }
        if ($flag = 2) {
            proxy_pass http://ajax.useso.com$uri$is_args$args;
        }
    }
}
```

# 配置
1. 修改nginx的默认配置

    ```sh
    [root@locahost ~]# vi /etc/nginx/nginx.conf
          log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                                 '$status $body_bytes_sent "$http_referer" '
                             '"$http_user_agent" "$http_x_forwarded_for" $upstream_addr';           # 追加 $upstream_addr 以方便追踪转给了哪一个后台服务。
                                                                                                                                                                                          

    ```
1.  为sso配置。该示例与[tomcat 虚拟主机](centos-tomcat)的配置相呼应

    ```sh
    [root@locahost ~]# vi /etc/nginx/conf.d/sso.conf
    ```
    内容示例如下：
    ```xml
    upstream sso {
        server                          10.1.10.213:8080  weight=1 max_fails=1 fail_timeout=60s;
        server                          10.1.10.214:8080  weight=1 max_fails=1 fail_timeout=60s;
    }
    
    server {
        listen                          80; 
        server_name                     ssolocal.eyar.com;
        access_log                      /data/outputs/log/nginx/sso.access.log     main;
        error_log                       /data/outputs/log/nginx/sso.error.log      notice;
    
        location /admin {
            proxy_next_upstream         http_500 http_502 http_503 http_504 timeout error invalid_header;
            proxy_pass                  http://sso;
            proxy_set_header            Host ssolocal.eyar.com;           #如果tomcat使用虚拟主机的话，则需要加上该行。
        }   
    
        location / { 
            proxy_next_upstream         http_500 http_502 http_503 http_504 timeout error invalid_header;
            proxy_pass                  http://sso;
            proxy_set_header            Host ssolocal.eyar.com;                                                                                                                                                        
        }   
    
    }
    ```


# 强制HTTPS （TODO）

```conf
server {
    listen      80;
    server_name hisdev.eyar.com;
    return      301      https://$host$request_uri;  # 用户直接浏览器地址栏中输入http开头的URL将会自动跳转为HTTPS
}
server {
    listen      443 ssl;
    server_name hisdev.eyar.com;
    proxy_set_header            X-forward-ssl ;                              # 被反向代理的tomcat应用应根据此header设置生成的URL是https还是http。
}
```

# 配置https

```
server{
    listen *:80;
    listen *:443 ssl;

    server_name kingsilk.net;
    ssl_certificate     conf.d/kingsilk.net_213467004770525.pem;
    ssl_certificate_key conf.d/kingsilk.net_213467004770525.key;   
```

# Health Check
使用Nginx Plus + 提供的 [health_check](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#health_check) 指令

使用 [ngx_http_healthcheck_module ](http://wiki.nginx.org/HttpHealthcheckModule)

## 路径相关

### proxy_pass 带路径

```conf
location /aaa/bbb { 
    proxy_pass              http://qh-wap/xxx/yyy/;
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
}
```

效果：访问 `/aaa/bbb-111/222/333.html` 实际是代理访问了 `/xxx/yyy/-111/222/333.html`

### proxy_pass 不带路径

```conf
location /xxx/yyy { 
    proxy_pass              http://qh-wap;
    proxy_set_header        Host            $host;
    proxy_set_header        X-Real-IP       $remote_addr;
    proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header        X-Forwarded-Proto $scheme;
}
```
效果：访问 `/xxx/yyy-111/222/333.html` 实际是代理访问了 `/xxx/yyy-111/222/333.html`


### 移除某个路径前缀

```
location ~ ^/api(.*)$ {
    proxy_pass                  http://wap-zll$1;
}  
```
效果：访问 `/api/test/index` 实际是代理访问了 `/test/index`。
但是，注意：此时返回的HTML的URL路径普遍都有问题。


## 子域名跳转
 使得外部访问 http://www.test.me/ask/xxx 时都跳转到 http://ask.test.me/xxx 。
 但是内部app都只有一个，故内部访问 http://ask.test.me/xxx 时，还是在访问 http://www.test.me/ask/xxx 

```conf
upstream myTomcat {
    server                        localhost:10010 weight=1 max_fails=1 fail_timeout=1s;
}

server {
    listen 80 ;
    server_name www.test.me ask.test.me;
    root /404;
    access_log                    /var/log/nginx/test.me.access.log     main;
    error_log                     /var/log/nginx/test.me.error.log      notice;

    if ($http_host =  www.test.me) {
        rewrite ^/ask(.*)$ http://ask.test.me$1 permanent;
    }   

    location / { 

        if ($http_host =  ask.test.me) {
            rewrite ^(.*)$ /ask$1 break;
        }
        proxy_next_upstream http_500 http_502 http_503 http_504 timeout error invalid_header;
        proxy_pass                http://myTomcat;
        proxy_set_header  X-Real-IP  $remote_addr;
    }   
}
```




## 全部域名跳转

```
server {
  listen *:80;
  server_name wiki.kingsilk.xyz;
  rewrite ^(.*)$  http://git.kingsilk.xyz$1 permanent;                                                                  
}
```

## 主页跳转

```
server {
  location = / {
    add_header Cache-Control no-cache;
    return 302 $scheme://kingsilk.net/qh/mall/;
  } 
}
```


# PHP

```sh
# 如果需要，卸载之前安装的apache、php
yum remove httpd* php*

# 安装
yum install php-fpm php-bcmath php-mbstring php-gd php-xml php-mysql
sudo apt-get install php5 php5-xdebug
# 启动
service php-fpm start
# 修改nginx配置
location ~ \.php$ {
    root           html;
    fastcgi_pass   127.0.0.1:9000;
    fastcgi_index  index.php;
    fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
    include        fastcgi_params;
}

# 重启nginx
service nginx reload

# 测试
vi info.php
<?php  
phpinfo();  
?> 
```

修改/etc/php.ini

```ini
post_max_size = 16M
max_execution_time = 300
max_input_time = 300
date.timezone = Asia/Shanghai
```


# basic 认证

1. 安装 htpasswd

    ```
    # CentOS
    yum provides \*bin/htpasswd
    yum installl httpd-tools

    # Ubuntu
    apt-get install apache2-utils
    ```
2. 生成加密文件（Nginx是使用 crypt(3) 加密的、apache是md5加密）

    ```
    htpasswd -c -d /usr/local/tengine/tengine-2.1.0/conf/conf.d/test.me.htpasswd zhang3
    # 回车输入密码
    ```

3. 配置 nginx 使用 basic 认证

    ```
    auth_basic "Restricted Access";
    auth_basic_user_file ./conf.d/test.me.htpasswd;
    ```
# TCP 反向代理

参考：[ngx_stream_upstream_module](http://nginx.org/en/docs/stream/ngx_stream_upstream_module.html#upstream)

修改 nginx.conf

```
# 最后追加以下配置
stream {
    include /etc/nginx/conf.d/*.conf.stream;
}
```

创建 `/etc/nginx/conf.d/mq.conf.stream`

```
upstream mqtt_1883 {
    server mq:1883;
}   
upstream mqtts_8883 {
    server mq:8883;
}

# 完全 tcp 转发   
server {
    listen 11883;
    proxy_connect_timeout       20s;
    proxy_timeout               5m; 
    proxy_pass                  mqtt_1883;
}
server {
    listen 18883;
    proxy_connect_timeout       20s;
    proxy_timeout               5m; 
    proxy_pass                  mqtts_8883;
}

# 代为TSL
server {
    listen 19883 ssl;
    ssl_certificate             conf.d/mq/server.pem.cer;
    ssl_certificate_key         conf.d/mq/server.pem.key;
    ssl_session_cache           shared:SSL:10m;
    ssl_session_timeout         10m;
    #ssl_ciphers                HIGH:!aNULL:!MD5;
    #ssl_prefer_server_ciphers  on;
    proxy_connect_timeout       20s;
    proxy_timeout               5m; 
    proxy_pass                  mqtt_1883;
}
```

