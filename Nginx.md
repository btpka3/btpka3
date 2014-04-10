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