
# 安装

```
yum install php-fpm php-bcmath php-mbstring php-gd php-xml php-mysql

mkdir /data0/php.session
chown nginx:nginx /data0/php.session  # 并确保该路径的拥有者 为 运行php进程的人

vi /etc/php-fpm.d/www.conf
user=nginx
group=nginx
php_value[session.save_path] = /data0/php.session
systemctl restart php-fpm

```

zentao.conf


```
server {
    listen *:80;
    server_name zentao.kingsilk.xyz;                                
    root        /data0/zentaopms/www;

    client_max_body_size 20m;
    ignore_invalid_headers off;

    access_log  logs/zentao.kingsilk.xyz.access.log main;
    error_log   logs/zentao.kingsilk.xyz.error.log;

    location / { 
        index  index.html index.htm index.php;
    }   
    location ~ \.php$ {
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }   

}
```



