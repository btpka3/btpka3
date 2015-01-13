

# 安装
1. 创建所需执行的非root用户，比如： `nexus`。
1. 下载最新版本，并解压。比如：解压到 `/home/nexus`
1. 修改 `/etc/profile.d/xxx.sh` ，追加/修改以下环境变量

   ```sh
   export NEXUS_HOME=/home/nexus/nexus-2.11.1-01
   export PATH=${NEXUS_HOME}/bin:$PATH
   ```
1. 修改 `${NEXUS_HOME}/conf/nexus.properties`，按需修改以下配置项

   ```properties
   application-port=20010                # 默认值是 8081
   nexus-webapp-context-path=/           # 默认值是 /nexus
   ```
1. 将 nexus 作为 init.d 服务
  
    ```
    cp ${NEXUS_HOME}/bin/nexus /etc/init.d/
    vi /etc/init.d/nexus
    ```
    内容如下：

    ```sh
    # NEXUS_HOME=".."                   # 注释掉此行
    . /etc/profile.d/xxx.sh             # 在文件开头追加此行
    RUN_AS_USER=nexus                   # 修改此值为最开始创建的用户   
    ```
1. 现在可以通过 `service nexus start` 启动了，访问URL为 `http://localhost:20010/`
1. 为了使用自定义域名 `mvn.lizi.com` 访问，需要为Nginx增加以下配置项： 

    ```
    upstream nexus {
      server 127.0.0.1:20010;
    }

    server {
      listen *:80;
      server_name mvn.lizi.com;
      server_tokens off;
      root /notExisted;
      
      client_max_body_size 20m;
      ignore_invalid_headers off;

      access_log  /var/log/nginx/nexus_access.log;
      error_log   /var/log/nginx/nexus_error.log;

      location / { 
            proxy_pass                  http://nexus;
            proxy_connect_timeout       600;   # 增加超时时间，防止下载大的war包时504
            proxy_send_timeout          600;
            proxy_read_timeout          600;
            send_timeout                600;
      }
    }
    ```



