
《[Docker 入门实战](http://yuedu.baidu.com/ebook/d817967416fc700abb68fca1?fr=aladdin&key=docker&f=read###)》

MacOS上，image的存储位置在 `~/Library/Containers/com.docker.docker/Data/`


## 常用命令

```
docker version                          # 查看版本号
docker info                             # 查看系统(docker)层面信息



# ----------------------- image
docker search <image>                   # 在docker index中搜索image
docker images                           # 查看本机images 
docker images -a                        # 查看所有images 
docker pull <image>                     # 从docker registry server 中下拉image 
docker push <image|repository>          # 推送一个image或repository到registry
docker push <image|repository>:TAG      # 同上,但指定一个tag
docker inspect <image|container>        # 查看image或container的底层信息
docker rmi <image...>                   # 删除一个或多个image

docker run <image> <command>            # 使用image创建container并执行相应命令，然后停止
# 比如:
#   进入交互模式, 开启tty, exit 后将终止
#   指定container名称,方便后续引用
#   设定环境变量
#   指定主机名
#   映射端口号
#   映射文件系统路径。默认为读写权限,可以后加 ":ro" 设置为只读。
docker run -i -t \
        --name yourNewContainerName \
        -e MY_ENV_VAR=XXX \
        -h yourNewHostName \
        -p <host_port:contain_port> \
        -v /host/path:/container/path:ro \
        <image> \ 
        /bin/bash 
# 也可以通过数据卷的方式,来复用之前容器中文件映射的配置。 
docker run -i -t \
        --volumes-from yourPreContainer \
        <image> \
        /bin/bash

# ----------------------- container
docker start/stop/restart/kill <container>   
                                        # 开启/停止/重启/Kill container
docker start -i <container>             # 启动一个container并进入交互模式

docker attach <container>               # attach一个运行中的container, 
                                        # 只能看到正在运行的程序的输出,如果有输入的话,可以交互
docker exec -it <container> bash        # 在一个container 中执行一个命令, 常常用来bash操作

docker ps                               # 默认显示正在运行中的container
docker ps -l                            # 显示最后一次创建的container，包括未运行的
docker ps -a                            # 显示所有的container，包括未运行的
docker logs <container>                 # 查看container的日志，也就是执行命令的一些输出
docker rm <container...>                # 删除一个或多个container 
docker rm `docker ps -a -q`             # 删除所有的container
docker ps -a -q | xargs docker rm       # 删除所有的container

docker cp <container>:/etc/nginx/nginx.conf /some/nginx.conf
                                        # 在container和本地文件系统之间copy文件


docker commit <container> [repo:tag]    # 将一个container固化为一个新的image，后面的repo:tag可选
docker build <path>                     # 寻找path路径下名为的Dockerfile的配置文件，使用此配置生成新的image
docker build -t repo[:tag]              # 同上，可以指定repo和可选的tag
docker build - < <dockerfile>           # 使用指定的dockerfile配置文件，docker以stdin方式获取内容
docker port <container> <container port>    # 查看本地哪个端口映射到container的指定端口




# ----------------------- running

```

## Mac



### 限制
1. 没有 docker0 bridge
1. 无法ping到容器，消息也无法从容器返回到host
1. 无法做到每个容器一个IP地址
 



### 容器要访问Host主机上的服务

```
# 为 lo0 绑定多个IP地址
sudo ifconfig lo0 alias 10.200.10.1/24

# 配置容器中的服务监听上述IP地址，或者 0.0.0.0

```

### host主机要访问容器内的服务
需要配置端口转发。

```
docker run -d -p 80:80 --name webserver nginx
```

## 网络

```
# 默认有三个网络
docker network ls 
docker network inspect bridge
```


## volume container

```
docker run -v /data --name my-data busybox true
```

## 安装

```
docker --version
docker-compose --version
docker-machine --version

# 下载镜像
docker pull elasticsearch:2.4.1
docker images

# 运行镜像
docker run docker/whalesay cowsay hi~

docker-machine ls
docker-machine ssh YOUR_VM_NAME
```

## 创建自定义 image

```
# 1. 创建空目录，并创建Dockerfile
# 2. 构建
docker build -t docker-whale .
docker images
docker run docker-whale
```

## 示例：ElasticSearch

```
docker pull elasticsearch:2.4.1
docker run elasticsearch:2.4.1
```


## demo

为了清楚docker整个操作流程, 该示例主要演示了经常使用的相关操作:

* 覆盖container中特定的文件
* 覆盖容器中特定的目录
* host与container之间端口映射

### 准备
各个文件的内容,请参考后面的 "附件: 文件内容"。

```
# 按照以下结构创建目录, 并准备好相应的文件
/tmp/docker-test
/tmp/docker-test/conf.d/default.conf
/tmp/docker-test/my-html/index.html
/tmp/docker-test/nginx.conf

```

### 运行

确保本机80, 8080 端口未被占用。

```
# 删除之前创建过的同名container(如果有的话)
docker stop my-tomcat
docker rm my-tomcat
docker stop my-nginx
docker rm my-nginx

# docker 运行 tomcat
docker run -itd \
        --name my-tomcat \
        -p 8080:8080 \
        tomcat

# docker 运行 nginx
docker run -itd \
        --name my-nginx \
        -p 80:80 \
        -v /tmp/docker-test/nginx.conf:/etc/nginx/nginx.conf:ro \
        -v /tmp/docker-test/conf.d:/etc/nginx/conf.d:ro \
        -v /tmp/docker-test/my-html:/usr/share/nginx/my-html \
        nginx
        
# 模拟修改docker内文件

docker exec -it my-nginx bash
echo aaa > /usr/share/nginx/my-html/aaa.txt
exit

```

### 验证

1. 本机浏览器访问 `http://localhost:8080/` 可以访问,并看到tomcat的主页
1. 本机浏览器访问 `http://localhost/` 可以访问:

    1. 并看到自定义的 nginx 主页: "hello docker"
    1. 通过相应工具可以看到有名称为 "X-DOCKER-TEST" http reponse header. 
1. 本机浏览器访问 `http://localhost/docs/` 可以访问 tomcat 的文档, 
    说明 nginx 反向代理 tomcat 成功。
1. 

### 附件: 文件内容
 
* index.html

    ```
    hello docker
    ```

* nginx.conf

    ```conf
    user  nginx;
    worker_processes  1;
    
    error_log  /var/log/nginx/error.log warn;
    pid        /var/run/nginx.pid;
    
    events {
        worker_connections  1024;
    }
    
    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;
    
        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';
    
        access_log  /var/log/nginx/access.log  main;
    
        sendfile        on;
        #tcp_nopush     on;
    
        keepalive_timeout  65;
    
        #gzip  on;
    
        include /etc/nginx/conf.d/*.conf;
        add_header              X-DOCKER-TEST   Hi~; # 追加内容
    }
    ```

* default.conf
    请修改下面中的ip地址为你自己的ip地址。

    ```conf
    server {
        listen       80;
        server_name  localhost;
    
        location / {
            root   /usr/share/nginx/my-html;       # 修改内容
            index  index.html index.htm;
        }
    
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
        
        location ~ /docs { 
            proxy_pass              http://192.168.0.40:8080;
            proxy_set_header        Host            $host;   # ???  $http_host;
            proxy_set_header        X-Real-IP       $remote_addr;
            proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header        X-Forwarded-Proto $scheme;
        }
    }
    ```

## docker-machine

### 为何要用 docker-machine

* 想在 Mac OS和 Windows OS上使用docker。这是在上述操作系统上使用 docker engine 的唯一途径。
* 想管理其他主机上运行的docker服务。


## Docker Swarm

## Docker Compose