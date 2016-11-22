http://sematext.com/spm/

# 安装
Zabbix分为普通发布版和长期支持版（LST），所以安装的时候应选择[2.2 LTS](http://www.zabbix.com/life_cycle_and_release_policy.php)版。

1. 安装Zabbix yum仓库

    ```bash
     # centos 5
    rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/5/x86_64/zabbix-release-2.2-1.el5.noarch.rpm

     # centos 6
    rpm -ivh http://repo.zabbix.com/zabbix/2.2/rhel/6/x86_64/zabbix-release-2.2-1.el6.noarch.rpm

    chkconfig --level 345 zabbix-server on
    ```

## 安装zabbix-server.


1. 创建MySQL数据库

    ```sql
    create database zabbix character set utf8 collate utf8_bin;
    grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';
    ```
1. 初始化MySQL数据库

    ```bash
    ll -d /usr/share/doc/zabbix-server-mysql-*
    cd /usr/share/doc/zabbix-server-mysql-2.2.7/create
    mysql -u root zabbix < schema.sql              # 也可以： mysql -u root zabbix; source schema.sql
    mysql -u root zabbix < images.sql
    mysql -u root zabbix < data.sql
    ```

1. 修改 /etc/zabbix/zabbix_server.conf

    ```groovy
    ListenPort=9010
    LogFile=/var/log/zabbix/zabbix_server.log
    DBHost=localhost
    DBName=zabbix
    DBUser=zabbix
    DBPassword=zabbix
    ```
1. 启动

   ```bash
   service zabbix-server restart
   ```
1. 通过查看日志，telnet 端口确认是否启动成功。



## 安装 zabbix web前端
zabbix 提供了两种前端：zabbix-web-mysql 和 zabbix-web-pgsql。但是，该预编译包均需要自定安装php和httpd。
但通常我们的环境中都使用的nginx，而不需要httpd。好在，仅仅安装zabbix web前端（php），只需拷贝文件即可。
参考[这里](https://www.zabbix.com/documentation/2.2/manual/installation/install#installing_zabbix_web_interface)。

1. 解压源码包中的php文件

    ```bash
    tar zxvf zabbix-2.2.7.tar.gz
    mkdir -p /data/software/zabbix/zabbix-2.2.7/frontends
    cp -R zabbix-2.2.7/frontends/php /data/software/zabbix/zabbix-2.2.7/frontends

    # 改变文件权限，这里的apache用户需要与 /etc/php-fpm.d/www.conf 中的user,group设定相同
    # 后续会通过浏览器在这里生成配置文件：zabbix.conf.php
    chown -R apache:apache /data/software/zabbix/zabbix-2.2.7/frontends/php/conf
    ```

    zabbix.conf.php 示例

    ```php
    <?php
    // Zabbix GUI configuration file
    global $DB;

    $DB['TYPE']     = 'MYSQL';
    $DB['SERVER']   = 'localhost';
    $DB['PORT']     = '0';
    $DB['DATABASE'] = 'zabbix';
    $DB['USER']     = 'root';
    $DB['PASSWORD'] = '';

    // SCHEMA is relevant only for IBM_DB2 database
    $DB['SCHEMA'] = '';

    $ZBX_SERVER      = 'localhost';
    $ZBX_SERVER_PORT = '9010';
    $ZBX_SERVER_NAME = '';

    $IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;
    ?>
    ```

1. 修改Nginx中的配置 /etc/nginx/conf.d/zabbix.conf

    ```groovy
    server {
        listen *:80;
        server_name zabbix.lizi.com;
        server_tokens off;
        root /data/software/zabbix/zabbix-2.2.7/frontends/php/;
        index  index.html index.htm  index.php;

        client_max_body_size 20m;
        ignore_invalid_headers off;

        access_log  /var/log/nginx/zabbix_access.log;
        error_log   /var/log/nginx/zabbix_error.log;
        location ~ \.php$ {
            root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  /data/software/zabbix/zabbix-2.2.7/frontends/php/$fastcgi_script_name;
            include        fastcgi_params;
        }
    }
    ```


1. 修改本地hosts之后，浏览器访问 `http://zabbix.lizi.com/`，根据实际状况一步一步进行。
配置完成后可以通过初始账户 Admin/zabbix 登录。



# 安装zabbix-agent.

    ```bash
    yum install zabbix-agent
    chkconfig --level 2345 zabbix-agent on
    service zabbix-agent start
    ```


    ```groovy
    Server=192.168.101.80                    # 允许访问该agent的IP地址列表，通常是zabbix server 的IP地址
    ListenPort=9011                          # 该agent的监听端口，server向agent查询数据用
    ServerActive=192.168.101.80:9010         # zabbix server 的ip地址和端口，agent向server发送存活信息
    Hostname=192.168.101.81                  # 需要与在zabbix server配置host时的host name相同
    ```

