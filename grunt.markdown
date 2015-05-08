同类工具参考 [F.I.S](http://fis.baidu.com/)


## 本地缓存

[npm_lazy](https://github.com/mixu/npm_lazy) 或者 [sinopia](https://github.com/rlidwka/sinopia)

### npm_lazy

* 全局安装 npm_lazy

    ```
    npm install -g npm_lazy
    useradd npm_lazy
    ```

* 按照需求修改 npm_lazy 配置文件

    ```
    vi /usr/local/nodejs/node-v0.12.1-linux-x64/lib/node_modules/npm_lazy/config.js
    ```
    
    常见修改内容有：
    
    ```
    logToConsole: false,
    logToFile: true,
    externalUrl: 'http://test-npm.xxx.com',
    port: 19030
    ```


* 为 centos7 增加 systemd 配置文件 

    ```
    vi /usr/lib/systemd/system/npm_lazy.service
    ```

    内容如下：

    ```
    [Unit]
    Description=npm_lazy
    After=network.target

    [Service]
    Type=simple
    Environment="PATH=/usr/local/nodejs/node-v0.12.1-linux-x64/bin:$PATH"
    ExecStart=/usr/local/nodejs/node-v0.12.1-linux-x64/bin/npm_lazy
    User=npm_lazy
    LimitNOFILE=65535
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
    ```

    启动，并设置使其开机自启动
    
    ```
    systemctl start npm_lazy
    systemctl status npm_lazy
    systemctl enable npm_lazy
    ```

* 在使用 npm 的机器上，配置使用该缓存

    * 通过命令
    
        ```
        npm config set registry http://test-npm.xxx.com/
        ```
    * 或者手动 `vi ~/.npmrc`  (也可以是项目根目录中的 .npmrc 文件)， 内容如下：
    
        ```
        registry=http://test-npm.xxx.com/
        ```
        
* 修改dns配置，或者hosts文件，使域名 `test-npm.xxx.com` 指向相应的IP地址

* 修噶 nginx 配置，增加反向代理

    ```
    upstream npm_lazy {
      server                        127.0.0.1:19030;
    }

    server {
      listen        80;
      server_name   test-npm.xxx.com; 
      server_tokens off; 
      #root          /NonExistPath;

      access_log    logs/test-npm_access.log;
      error_log     logs/test-npm_error.log;

      location / {
        gzip                    on;

        proxy_read_timeout      300;
        proxy_connect_timeout   300;
        proxy_redirect          off;

        proxy_set_header        Host                $http_host;
        proxy_set_header        X-Real-IP           $remote_addr;
        proxy_set_header        X-Forwarded-For     $proxy_add_x_forwarded_for;
        proxy_set_header        X-Forwarded-Proto   $scheme;
        proxy_set_header        X-Frame-Options     SAMEORIGIN;

        proxy_pass              http://npm_lazy;
      }
    }
    ```


## init


```
npm install -g grunt-cli
npm install -g grunt-init

npm init
npm install grunt --save-dev
npm install grunt-contrib-jshint --save-dev
npm install grunt-contrib-nodeunit --save-dev
npm install grunt-contrib-uglify --save-dev
npm install grunt-contrib-watch --save-dev
npm install grunt-contrib-requirejs --save-dev
npm install bootstrap --save
```

 


	
## grunt-contrib-watch

```
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```