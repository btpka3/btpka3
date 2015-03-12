pam : see [here](http://www.doublecloud.org/2014/01/nginx-with-pam-authentication/)


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

# Health Check
使用Nginx Plus + 提供的 [health_check](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#health_check) 指令

使用 [ngx_http_healthcheck_module ](http://wiki.nginx.org/HttpHealthcheckModule)



# 子域名跳转
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


# PHP

```sh
# 如果需要，卸载之前安装的apache、php
yum remove httpd* php*

# 安装
yum install php-fpm php-bcmath php-mbstring php-gd php-xml php-mysql

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


