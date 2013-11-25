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
### 被代理的服务器健康检测
[proxy_next_upstream](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)  
[fastcgi_next_upstream](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_next_upstream)  
3rd [nginx_upstream_check_module](https://github.com/yaoweibin/nginx_upstream_check_module)