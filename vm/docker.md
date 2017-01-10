
《[Docker 入门实战](http://yuedu.baidu.com/ebook/d817967416fc700abb68fca1?fr=aladdin&key=docker&f=read###)》

MacOS上，image的存储位置在 `~/Library/Containers/com.docker.docker/Data/`
《[阿里云开发者平台](https://dev.aliyun.com/search.html)》

daocloud.io

```
docker pull registry.mirrors.aliyuncs.com/library/java
```


《[docker使用阿里云Docker镜像库加速](http://blog.csdn.net/bwlab/article/details/50542261)》

# Docker Toolbox

Docker Toolbox 主要用于为老旧的Mac, Windows系统提供支持,并使其能运行docker。
但有了 "Docker for Mac" 之后,就不需要 Docker Toolbox 了。



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
        -e "MY_ENV_VAR=XXX" \
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
docker create <image>
docker start/stop/restart/kill <container>
                                        # 开启/停止/重启/Kill container
docker start -i <container>             # 启动一个container并进入交互模式

docker attach <container>               # attach一个运行中的container,
                                        # 只能看到正在运行的程序的输出,如果有输入的话,可以交互
docker exec -it <container> bash        # 在一个container 中执行一个命令, 常常用来bash操作


# ----------------------- 运行状态
docker ps                               # 默认显示正在运行中的container
docker stats                            # 对容器内存进行监控
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




# ----------------------- network
# 默认有 host和birdge 网络驱动,
docker network ls
docker network inspect bridge
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

docker volume ls            # 查看已有的数据卷

# FIXME 如何创建? 如何挂载?
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

参考 [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)

```
# 1. 创建空目录，并创建Dockerfile
mkdir test
cd test
touch Dockerfile
touch .dockerignore

# 2. 构建
docker build -t btpka3/my-img:1.0 .

# 3. 检查本地的images
docker images

# 4. 运行
docker run -d btpka3/my-img:1.0
```


## 示例：ElasticSearch

```
docker pull elasticsearch:2.4.1

docker run -itd \
        --name my-es \
        -p 9200:9200 \
        -p 9300:9300 \
        -v /Users/zll/tmp/es-data:/usr/share/elasticsearch/data \
        elasticsearch:2.4.1
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

    ```nginx
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

    ```nginx
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


### 如何设置共享目录?

* 命令行: 需要VM已经停止。

    ```
    VBoxManage sharedfolder add <machine name/id> --name <mount_name> \
        --hostpath <host_dir> --automount
    ```
* GUI: 通过 VirtualBox GUI程序设置共享目录。 Mac 下已经默认共享了 `/Users` 目录。
### 为何要用 docker-machine

* 想在 Mac OS和 Windows OS上使用docker。这是在上述操作系统上使用 docker engine 的唯一途径。
* 想管理其他主机上运行的docker服务。
* 《[Docker集群管理之Docker Machine](http://www.csdn.net/article/2015-08-11/2825438)》

```
docker-machine create --driver virtualbox default
                                    # 新建一个 machine

# 上述命令会下载 boot2docker.iso 并存放在
# ??? : ~/.boot2docker/
# ??? : ~/.docker/machine/cache/boot2docker.iso

docker-machine rm default           # 删除一个 machine

docker-machine env default          # 打印要使用指定 machine 做为当前环境所需的命令
eval $(docker-machine env node1)    # 使用指定 machine 做为当前环境
docker-machine ls                   # 列出所创建的 machine, 加星号的是当前使用的环境
docker-machine active               # 列出当前使用的是那一个 machine

sudo vi ~/Library/LaunchAgents/com.docker.machine.default.plist  # 设置开启启动


docker run busybox echo hello world # 测试当前环境
docker-machine ip default           # 查看指定 machine 的ip

docker-machine stop default         # 启动 machine
docker-machine start default        # 停止 machine
docker-machine restart default      # 重启 machine
docker-machine ssh default          # ssh 到远程主机上

# ssh 到远程主机上并设置加速器
docker-machine ssh default \
    "echo 'EXTRA_ARGS=\"--registry-mirror=https://pee6w651.mirror.aliyuncs.com\"' | sudo tee -a /var/lib/boot2docker/profile"
docker-machine config
```


## Docker Swarm

用以管理Docker集群. 将一群docker节点当做一个来操作。




```bash
# 使用阿里云的 docker 加速

docker-machine create -d virtualbox local       # 创建节点 local
eval "$(docker-machine env local)"              # 使用节点 local
docker run swarm create                         # 在 local 节点上运行 swarm, 并创建集群。
                                                # 最后会打印集群 token : feb57580075676ccd7d17d0c5452e6be

docker-machine create \
        -d virtualbox \
        --swarm \
        --swarm-master \
        --swarm-discovery token://feb57580075676ccd7d17d0c5452e6be \
        swarm-master

docker-machine create \
        -d virtualbox \
###        --engine-opt "--registry-mirror=https://pee6w651.mirror.aliyuncs.com" \
        --swarm \
        --swarm-discovery token://feb57580075676ccd7d17d0c5452e6be \
        swarm-agent-00

docker swarm init


---
在host主机中(MacOS)里有 :
vboxnet0 : 192.168.99.1/24


docker-machine create -d virtualbox consul0         # 192.168.99.200
docker-machine create -d virtualbox manager0        # 192.168.99.210
docker-machine create -d virtualbox manager1        # 192.168.99.211
docker-machine create -d virtualbox node0           # 192.168.99.220
docker-machine create -d virtualbox node1           # 192.168.99.221

# 为了方便, 一次ssh到vm上, 按照上述明确指明IP地址 (默认登录的用户是 docker, 而非root)
# docker start manager0
docker-machine ssh manager0
sudo ifconfig eth1 192.168.99.210 netmask 255.255.255.0

# @consul0: 创建 consul 发现服务
docker run -d -p 8500:8500 --name=consul progrium/consul -server -bootstrap

# @manager0: 创建 swarm 集群 (因为首先创建,所以是Primary管理节点)
docker run -d -p 4000:4000 swarm manage -H :4000 --replication \
    --advertise 192.168.99.210:4000 consul://192.168.99.200:8500
docker -H :4000 info        # Role: primary

# @manager1: 创建 swarm 集群 (因为首先创建,所以是Primary管理节点)
docker run -d -p 4000:4000 swarm manage -H :4000 --replication \
    --advertise 192.168.99.211:4000 consul://192.168.99.200:8500
docker -H :4000 info        # Role: replica

# @node0: 加入集群
docker run -d swarm join --advertise=192.168.99.220:2375 consul://192.168.99.200:8500

# @node1: 加入集群
docker run -d swarm join --advertise=192.168.99.221:2375 consul://192.168.99.200:8500

docker swarm join
docker swarm join-token
docker swarm update
docker swarm leave


```

## Docker Compose

适用于:

* 开发环境
* 自动测试环境
* 单主机上的部署


docker-compose.yml

```yaml
version: '2'
services:
    web:
        build: .
        ports:
            - "5000:5000"
        volumes:
            - .:/code
        depends_on:
            - redis
    redis:
        image: redis
```

参考

* 《[Docker集群管理之Docker Compose](http://www.csdn.net/article/1970-01-01/2825554)》


## DDC - Docker Datacenter
包含一些企业级的工具,包含 docker-engine, UCP, DTR。


### UCP - Universal Control Plane
提供一个Web界面来统一管理所有的节点。收费的。

```
# 创建节点1,并安装ucp
docker-machine create -d virtualbox \
  --virtualbox-memory "2500" \
  --virtualbox-disk-size "5000" node2

eval $(docker-machine env node1)

docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name ucp docker/ucp install -i \
  --swarm-port 3376
  --host-address $(docker-machine ip node1)

# 创建节点2, 并加入先前安装的ucp。 注意:没有License的情况下,无法加入的。
docker-machine create -d virtualbox \
  --virtualbox-memory "2500" \
  --virtualbox-disk-size "5000" node2
eval $(docker-machine env node2)
docker run --rm -it \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name ucp docker/ucp join -i \
  --host-address $(docker-machine ip node2)

# 最后提示访问的网址, 比如:
https://192.168.99.100:443
```

### DTR - Docker Trusted Registry
需要先安装 UCP。



## docker hub

[Configure automated builds on Docker Hub](https://docs.docker.com/docker-hub/builds/)

```bash
docker push
docker search
docker login
docker push
```
