# 参考
- [CNCF: Cloud Native Computing Fundation](https://www.cncf.io/)
* [installation](https://docs.docker.com/engine/installation/)
* [Start containers automatically](https://docs.docker.com/engine/admin/host_integration/)
* 《[Docker 入门实战](http://yuedu.baidu.com/ebook/d817967416fc700abb68fca1?fr=aladdin&key=docker&f=read###)》
* 《[阿里云开发者平台](https://dev.aliyun.com/search.html)》
* 《[docker使用阿里云Docker镜像库加速](http://blog.csdn.net/bwlab/article/details/50542261)》
* https://rancherdesktop.io/
- 《[Docker Desktop for Mac Commands for Getting Into The Local Docker VM](https://www.bretfisher.com/docker-for-mac-commands-for-getting-into-local-docker-vm/)》
    在 MacOS 运行 docker desktop 时，是用 [xhyve](https://github.com/mist64/xhyve)
    运行了一个 [Alpine Linux](https://alpinelinux.org/) 的虚拟机。

- [Distroless](https://github.com/GoogleContainerTools/distroless)  # 最小的静态镜像
- [dive](https://github.com/wagoodman/dive) # 分析镜像的工具
- https://github.com/bitnami/minideb
- 《[Optimizing builds with cache management](https://docs.docker.com/build/cache/)》

# macos

```shell
brew install --cask docker
#brew install docker docker-machine docker-compose

cat ~/.docker/daemon.json
cat ~/.docker/config.json
cat ~/.docker/features.json

# kill docker daemon
function kdo() {
    ps ax|grep -i docker|egrep -iv 'grep|com.docker.vmnetd'|awk '{print $1}'|xargs kill
}

```



MacOS上，image的存储位置在 `~/Library/Containers/com.docker.docker/Data/`



```sh
# https://github.com/docker/for-mac/issues/371
zll@m 0$ ls -lh ~/Library/Containers/com.docker.docker/Data/vms/0/Docker.qcow2
-rw-r--r--@ 1 zll  staff    13G Jun 20 17:27 /Users/zll/Library/Containers/com.docker.docker/Data/vms/0/Docker.qcow2

# 删除 不再运行的 容器
docker rm -v $(docker ps -a -q -f status=exited)

# 删除不再使用的，且文件很大的image
docker images |sort -h -k 7
```

# without sudo

see [here](https://askubuntu.com/questions/477551/how-can-i-use-docker-without-sudo)

```bash
# 创建 `docker` 用户组
sudo groupadd docker

# 将当前用户加入到 `docker` 用户组
#sudo gpasswd -a $USER docker
sudo usermod -aG docker $USER

# test (可能需要重新登录或重启服务器)
docker run hello-world
```

# warning

```bash
dockerd                  # 日志有如下警告
WARNING: Your kernel does not support cgroup swap limit.
WARNING: Yourkernel does not support swap limit capabilities.
Limitation discarded.

sudo vi /etc/default/grub
GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"
```

# HTTP/HTTPS 代理服务

```bash

# https://stackoverflow.com/questions/23111631/cannot-download-docker-images-behind-a-proxy
mkdir -p /etc/systemd/system/docker.service.d
cat > /etc/systemd/system/docker.service.d/http-proxy.conf <<EOF
[Service]
Environment="all_proxy=socks5://prod11.kingsilk.net:9999"
Environment="NO_PROXY=localhost,127.0.0.1,registry-internal.cn-hangzhou.aliyuncs.com,registry-vpc.cn-hangzhou.aliyuncs.com,prod11.kingsilk.net,prod12.kingsilk.ent,prod13.kingsilk.net,prod14.kingsilk.net"
EOF

systemctl daemon-reload
systemctl restart docker
docker run -it --rm alpine:3.5 sh -c "echo hi"
docker run -e DOCKER_HOST="unix:///var/run/docker.sock" -it --rm alpine:3.5 sh -c "echo hi"

# https://github.com/docker/for-mac/issues/770
docker run --restart always -d -v /var/run/docker.sock:/var/run/docker.sock -p 127.0.0.1:1234:1234 bobrik/socat TCP-LISTEN:1234,fork UNIX-CONNECT:/var/run/docker.sock
```

## 安装 docker 4 linux

* [Get Docker for CentOS](https://docs.docker.com/engine/installation/linux/centos/)

```bash
ll /etc/yum.repos.d/

yum remove docker \
        docker-common \
        container-selinux \
        docker-selinux \
        docker-engine

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum-config-manager --disable docker-ce-edge

yum makecache fast
yum list docker-ce.x86_64  --showduplicates |sort -r

yum install docker-ce
yum install docker-ce-<VERSION>
```

# 镜像存储目录

docker 默认会把镜像等保存在 /var/lib/docker 目录下，
而阿里云环境的系统盘只有20G。因此不适合直接使用系统盘

而 /etc/docker/daemon.json 的具体配置项需要参考
[dockerd 17.06](https://docs.docker.com/engine/reference/commandline/dockerd/)
[dockerd 17.03](https://docs.docker.com/v17.03/engine/reference/commandline/dockerd/)
命令：

版本早于 17.06-ce

```text
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --graph="/mnt"
```

版本晚于 17.06-ce

```text
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --data-root="/mnt"
```

# btrfs

```bash
sudo cat /proc/filesystems | grep btrfs
sudo apt-get install btrfs-tools
sudo cat /proc/filesystems | grep btrfs

# 创建容量为 10G 的文件
dd if=/dev/zero of=/data0/store/soft/myDocker.btrfs bs=10M count=1024
sudo losetup /dev/loop7 /data0/store/soft/myDocker.btrfs
sudo mkfs.btrfs -f /dev/loop7
sudo mount -t btrfs /dev/loop7 /data0/store/soft/docker

sudo tee /etc/docker/daemon.json <<-'EOF'
{
   "data-root": "/data0/store/soft/docker",
   "storage-driver": "btrfs",
   "registry-mirrors": ["https://cbnwh58y.mirror.aliyuncs.com"]
}
EOF

dockerd    # 检查控制台日志

sudo blkid
sudo vi /etc/fstab
/data0/store/soft/myDocker.btrfs /data0/store/soft/docker    auto  loop  0 0
```

# 使用 阿里云 的镜像进行加速

参考 [这里](https://cr.console.aliyun.com/#/accelerator)

```bash

after 17.06-ce

sudo mkdir -p /etc/docker

# 注意： Ubuntu下应该使用 btrfs
sudo tee /etc/docker/daemon.json <<-'EOF'
{
   "data-root": "/data0/store/soft/docker",
   "storage-driver": "devicemapper",
   "registry-mirrors": ["https://cbnwh58y.mirror.aliyuncs.com"]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker
```

# Docker Toolbox

Docker Toolbox 主要用于为老旧的Mac, Windows系统提供支持,并使其能运行docker。
但有了 "Docker for Mac" 之后,就不需要 Docker Toolbox 了。

## 常用命令

```
docker version                          # 查看版本号
docker info                             # 查看系统(docker)层面信息

# ----------------------- history
docker history --format "{{.ID}} {{.CreatedBy}} {{.Size}}" spring-docker-demo
c0d77f6af917 /bin/sh -c #(nop)  ENTRYPOINT ["java" "org.s… 0B
762598a32eb7 /bin/sh -c #(nop) COPY dir:a87b8823d5125bcc4… 7.42kB
80a00930350f /bin/sh -c #(nop) COPY dir:3875f37b8a0ed7494… 0B
0e138e074118 /bin/sh -c #(nop) COPY dir:db6f791338cb4f209… 2.35kB
e079ad66e67b /bin/sh -c #(nop) COPY dir:92a8a991992e9a488… 235kB
77a9401bd813 /bin/sh -c #(nop) COPY dir:f0bcb2a510eef53a7… 16.4MB
2eb37d403188 /bin/sh -c #(nop)  ENV JAVA_HOME=/opt/java/o… 0B

# ----------------------- image
docker search <image>                   # 在docker index中搜索image
docker manifest inspect docker.io/library/alpine:3.17.3   # 检查镜像是否存在于远程registry 中
docker images                           # 查看本机images
docker image list                       # 查看本机images
docker images -a                        # 查看所有images
docker image prune                      # 删除未使用的image
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
docker update --restart=no my-container

# ----------------------- 运行状态
docker ps                               # 默认显示正在运行中的container
docker stats                            # 对容器内存进行监控
docker stats --format "table {{.Container}}\t{{.Name}}\t{{.PIDs}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}\t{{.BlockIO}}"
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

## docker CLI

### docker system

管理Docker的命令

```bash

docker system df            # 显示docker 磁盘使用情况，支持详细信息选项
docker system events        # 从服务器获取Docker的实时事件信息，支持对事件进行过滤，指定时间戳，格式化等
docker system info          # 显示系统级别的信息，支持格式化
docker system prune         # 支持删除系统中没有使用的数据，包括：
                            #   - 处于停止状态的容器
                            #   - 所有没有被使用的数据卷
                            #   - 所有没有被使用的网络
                            #   - 所有标示为“dangling”状态的镜像
docker system prune --all --force
```

### docker plugin

管理Docker插件的命令，目前插件命令仅支持数据卷驱动，未来插件会提供容器集群网络，IP地址管理和分配，数据件驱动等功能

```bash
docker plugin create        # 从一个rootfs文件系统和配置文件中创建一个插件，
                            # 插件数据目录参数必须指明一个包含了 config.json 配置文件和 rootfs 文件系统的目录
docker plugin disable       # 禁用一个插件
docker plugin enable        # 启用一个插件
docker plugin inspect       # 查看插件中的详细信息
docker plugin install       # 安装一个插件，可以从镜像中心(registry)拉取插件，并进行安装
docker plugin ls            # 列出本地保存的所有插件
docker plugin push          # 将插件推送到镜像中心(registry)进行保存
docker plugin rm            # 删除插件
docker plugin set           # 修改插件的设置
docker plugin upgrade       # 升级已经存在的插件
```

### docker secret

集中式管理Docker 容器需要使用的敏感信息，包括密码，证书等,敏感信息不会保存在镜像中。
compose模版也可以不需要显式填写密码等敏感信息，只需要引用密码对象的名称。
实现的方式是通过把密码等敏感信息以文件的方式挂载到容器的/run/secrets/目录内，
使用该特性的镜像需要支持通过文件读取的方式来使用敏感信息的能力。

```bash
docker secret create        # 创建一个密码对象
docker secret inspect       # 查看一个密码对象的信息
docker secret ls            # 列出所有的密码对象
docker secret rm            # 删除一个或者多个密码对象
```

### docker stack

```bash
docker stack deploy         # 部署一个Compose模板到Docker集群中作为一个stack，相当于之前的 `docker-compose up`
docker stack ls             # 列出目前的所有stack
docker stack ps             # 展示一个stack中对应的容器，相当于之前的 `docker-compose ps`
docker stack rm             # 删除一个stack以及它包含的服务和容器
docker stack services       # 展示stack下面对应的服务
```

## Compose

用以定义和运行多个 docker 容器的应用。

参考：

1. 《[Docker 1.13 编排能力进化](https://yq.aliyun.com/articles/55973)》
1. 《[Docker 1.13 新特性 —— Docker系统相关](https://yq.aliyun.com/articles/71036)》
1. 《[Docker 1.13 新特性 —— Docker服务编排相关](https://yq.aliyun.com/articles/71039)》
1. 《[Docker 1.13 新特性 —— 网络相关](https://yq.aliyun.com/articles/70986)》

Docker Compose vs. Docker CLI

|                    | Docker Compose               | Docker 1.13+                                            |
|--------------------|------------------------------|---------------------------------------------------------|
| start service      | `docker-compose up -d`       | `docker stack deploy --compose-file=docker-compose.yml` |
| scale service      | `docker-compose scale xxx=n` | `docker service scale xxx=n`                            |
| stop service       | `docker-compose down`        | `docker stack rm`                                       |
| cross host machine | No                           | Yes                                                     |
| ignored directives | `deploy`                     | `build`                                                 |

总结：

* docker compose ：作为单机测试，演示环境使用，可以从源码build成容器；
* docker stack ： 适合 服务器部署使用，且只支持从镜像部署

### docker-compose.yml

语法参考 [这里](https://docs.docker.com/compose/compose-file/)

```bash
docker-compose build
```

### 清理

```bash

docker container prune

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

# 5. 创建最新版的链接
docker tag a69f3f5e1a31 btpka3/my-img:latest

# 6. 发布
docker login --username=yourhubusername --email=youremail@provider.com
docker push btpka3/my-img
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

## 安全

[一个回车键黑掉一台服务器——使用Docker时不要这么懒啊喂](http://www.jianshu.com/p/74aa4723111b)

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

# docker registry

《[About Registry](https://docs.docker.com/registry/introduction/)》
[containers/skopeo](https://github.com/containers/skopeo)

## 软件/镜像

- [Harbor](https://goharbor.io/)
- [_/registry](https://hub.docker.com/_/registry)

## 在线服务

- docker : [docker.io](https://hub.docker.com/)
- redhat : [quay.io](https://quay.io/search)
- fedora : [registry.fedoraproject.org](https://registry.fedoraproject.org/)
- k8s    : registry.k8s.io
- github : [ghcr.io](https://github.com/features/packages)
- google : [gcr.io](https://cloud.google.com/container-registry/)
- Microsoft : [mcr.microsoft.com](https://mcr.microsoft.com/)
- 阿里巴巴开源镜像站 : https://developer.aliyun.com/mirror
- registry.k8s.io

```shell
# docker.io
podman login --username=btpka3 docker.io
podman pull docker.io/library/alpine:3.17.3
# quay.io
podman pull quay.io/coreos/coreos-installer:release
# registry.fedoraproject.org
podman pull registry.fedoraproject.org/vim

# 两个仓库之间进行镜像copy
brew install skopeo
skopeo login quay.io
skopeo login registry.internal.company.com
skopeo copy docker://quay.io/buildah/stable docker://registry.internal.company.com/buildah
```
## mirror

|mirror domain                 |status  |mirror providr | desc|
|------------------------------|--------|------------|---------|
| <youId>.mirror.aliyuncs.com  |✅      |阿里云       ||
| hub-mirror.c.163.com         |✅      |网易         ||
| dockerproxy.com              |✅      |Docker Proxy||
| 05f073ad3c0010ea0f4bc00b7105ec20.mirror.swr.myhuaweicloud.com              |✅      |华为云|https://support.huaweicloud.com/usermanual-swr/swr_01_0045.html|


| mirror.baidubce.com          |🚫      |百度         |https://cloud.baidu.com/doc/CCE/s/Yjxppt74z|不稳定|
| docker.mirrors.ustc.edu.cn   |🚫      |中科大       |不可用|
| ccr.ccs.tencentyun.com       |🚫      |腾讯         |不可用|


- ✅ 阿里云
    - 加速域名: `<youId>.mirror.aliyuncs.com`
    - 示例值: `3ibg8tk1.mirror.aliyuncs.com`
    - 说明文档：阿里云: 容器镜像服务 ACR : 首页>容器镜像服务 ACR>镜像工具>官方镜像加速 : [官方镜像加速](https://help.aliyun.com/document_detail/60750.html)

- ✅ 网易
    - 加速域名: `hub-mirror.c.163.com`
- ✅ Docker Proxy
    - 加速域名: `dockerproxy.com`
- ✅ 华为云
    - 加速域名: `<xxx>.mirror.swr.myhuaweicloud.com`
    - 示例值: `05f073ad3c0010ea0f4bc00b7105ec20.mirror.swr.myhuaweicloud.com`
    - 说明文档： https://support.huaweicloud.com/usermanual-swr/swr_01_0045.html
- 🚫 百度
    - 加速域名: `mirror.baidubce.com`, 不稳定
    - 说明文档： https://cloud.baidu.com/doc/CCE/s/Yjxppt74z|不稳定
- 🚫 中科大
    - 加速域名: `docker.mirrors.ustc.edu.cn`, 不可用
- 🚫 腾讯云
    - 加速域名: `ccr.ccs.tencentyun.com`, 不可用





```shell
# 从 docker hub 拉取镜像的完整命令
podman pull docker.io/library/alpine:latest

# 验证使用镜像拉取
MIRROR=05f073ad3c0010ea0f4bc00b7105ec20.mirror.swr.myhuaweicloud.com
podman pull ${MIRROR}/library/alpine:latest
```

## curl
https://github.com/opencontainers/distribution-spec/blob/main/spec.md
https://docs.docker.com/registry/spec/auth/token/
https://stackoverflow.com/questions/57316115/get-manifest-of-a-public-docker-image-hosted-on-docker-hub-using-the-docker-regi

### docker.io
```shell
DOCKERHUB_USERNAME=
DOCKERHUB_PASSWORD=

TARGET_NS_REPO=library/alpine

# yes, you need a new token for each repository, maybe you can have multiple scopes though?
PARAMS="service=registry.docker.io&scope=repository:$TARGET_NS_REPO:pull"

TOKEN=$(curl  \
    "https://auth.docker.io/token?$PARAMS" \
    | jq -r '.token'
)

# TOKEN=$(curl --user "$DOCKERHUB_USERNAME:$DOCKERHUB_PASSWORD" \
#     "https://auth.docker.io/token?$PARAMS" \
#     | jq -r '.token'
# )

curl "https://registry-1.docker.io/v2/$TARGET_NS_REPO/tags/list" \
    -H "Authorization:Bearer $TOKEN" \
    | jq '.tags[:10]'

TAG="3.6"
curl "https://registry-1.docker.io/v2/$TARGET_NS_REPO/manifests/$TAG" \
    -H "Authorization:Bearer $TOKEN" \
    | jq '.fsLayers'
```

### 3ibg8tk1.mirror.aliyuncs.com

```shell
TARGET_NS_REPO=library/alpine
TAG="3.6"
curl "https://3ibg8tk1.mirror.aliyuncs.com/v2/$TARGET_NS_REPO/manifests/$TAG"
```
### registry.aliyuncs.com/google_containers

```shell
# 需要先 docker login
TARGET_NS_REPO=pause
TAG="3.9"
curl "https://registry.aliyuncs.com/v2/google_containers/$TARGET_NS_REPO/manifests/$TAG"


```

### registry.cn-hangzhou.aliyuncs.com/google_containers

```shell
docker manifest inspect registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.9
TARGET_NS_REPO=pause
TAG="3.9"
curl "https://registry.cn-hangzhou.aliyuncs.com/v2/google_containers/$TARGET_NS_REPO/manifests/$TAG"
```


# docker in docker

- [How To Run Docker in Docker Container [3 Easy Methods]](https://devopscube.com/run-docker-in-docker/)
- [_/docker](https://hub.docker.com/_/docker)
- [How to use Podman inside of a container](https://www.redhat.com/sysadmin/podman-inside-container)
- [quay.io/podman/stable](https://quay.io/repository/podman/stable)

DinD (Docker in Docker)

```shell
# 准备网络
docker network create       \
    -d bridge               \
    --gateway 192.168.1.1   \
    --subnet 192.168.1.0/24 \
    dockerNet

# 启动 daemon 实例
docker run --privileged -it --rm \
           --network dockerNet --network-alias docker \
           -e DOCKER_TLS_CERTDIR=/certs \
           -v some-docker-certs-ca:/certs/ca \
           -v some-docker-certs-client:/certs/client \
           docker:latest
# Connect to it from a second container
docker run -it --rm --network dockerNet \
	-e DOCKER_TLS_CERTDIR=/certs \
	-v some-docker-certs-client:/certs/client:ro \
	docker:latest sh

# 在第二个容器中执行以下命令
docker version
docker run -it --rm docker.io/library/alpine:3.17.3 date
docker run -it --rm --entrypoint /bin/sh docker.io/library/alpine:3.17.3 -l
docker run -it --rm --entrypoint /bin/sh docker.io/library/alpine:3.17.3 -c date
```

PinP(Podman in Podman)
[quay.io/podman/stable](https://quay.io/repository/podman/stable?tab=info)

```shell
#export PS1='\[\033[01;33m\]\u@\h\[\033[01;31m\] \W\$\[\033[00m\] '
podman run --security-opt label=disable --user podman \
  --device /dev/fuse quay.io/podman/stable \
  podman run alpine echo hello
```

## docker hub

[Configure automated builds on Docker Hub](https://docs.docker.com/docker-hub/builds/)

```bash
docker push
docker search
docker login
docker push
```

## 容器编排管理

* 自己管理 Docker Daemon
* Swarm
* kubernets
* Mesos

## 网络方案

* bridge : 默认(NAT模式）。此模式下会给container分配独立的network namespace、设置IP，并将容器链接到 docker0 虚拟网桥，再通过
  docker0 以及 iptables nat配置与宿主机通信。
* host : 此时host主机与container主机的IP不再隔离，container主机直接使用host主机的网络（比如动态IP分配）

```plain
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓      ┏━━━━━━━━━━━━━━━━━━━━━━━━━━┓  ┃
┃  ┃docker1                   ┃      ┃docker2                   ┃  ┃
┃  ┃eth0:172.17.0.1/16        ┃      ┃eth0:172.17.0.2/16        ┃  ┃
┃  ┗━━━━━━━━┳━━━━━━━━━━━━━━━━━┛      ┗━━━━━━━━━┳━━━━━━━━━━━━━━━━┛  ┃
┃           ┃                                  ┃                   ┃
┃      ┏━━━━┻━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┻━━━━━┓             ┃
┃      ┃  veth*                               veth*  ┃             ┃
┃      ┃           docker0:172.17.0.0/16             ┃             ┃
┃      ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛             ┃
┃                              host                                ┃
┃                       eth0:10.10.0.186/24                        ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

* overlay : 适用于多个容器间通信。
* none    : 完全移除网络
* ipvlan  : 允许配置 IPv4,IPv6地址
* macvlan : 给container分批 MAC 地址，适用于直接通信在 MAC 的物理网络的应用。

```shell

podman run --cap-add=NET_ADMIN,NET_RAW --name c1 --rm --network=host -it busybox:musl

podman run --cap-add=NET_ADMIN,NET_RAW --name c1 --rm --network=host -it alpine sh
apk add iputils
ping
```


## 如何管理容器的日志

* docker logs 采集
* syslog 采集
* ELK 采集
* 采集到阿里云日志服务

## 会选择什么操作系统作为容器的宿主机？

* Ubuntu
* CentOS
* CoreOS
* RedHat
* Windows

## 考虑如何管理Docker镜像

* 使用Docker Hub
* 搭建私有Docker Registry
* 使用阿里云Docker Registry服务
* 使用国内其他Docker Regsitry服务

## 容器技术相关的安全挑战?

* 考虑Docker容器中secret的管理
* 考虑Docker Engine相关的安全配置、证书，及定期更新
* 考虑容器镜像的安全和可信
* 考虑如何修复镜像中操作系统和应用的安全缺陷
* 考虑如何对运行期的Docker容器进行扫描
* 考虑对组织的不同成员授予Docker集群的不同操作权限

## centos

```
docker run -i -t  \
    --name my-centos \
    -d \
    centos \
    /bin/bash
docker exec -it my-centos bash
```

## ubuntu

```bash
docker rm my-ubuntu
docker run -i -t \
    --name my-ubuntu \
    -d \
    ubuntu:16.04 \
    /bin/bash
docker exec -it my-ubuntu bash
```

## 7788

* docker Can't set cookie dm_task_set_cookie failed

  see [here](https://github.com/moby/moby/issues/33603)
  and [Setting Semaphore Parameters](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Tuning_and_Optimizing_Red_Hat_Enterprise_Linux_for_Oracle_9i_and_10g_Databases/sect-Oracle_9i_and_10g_Tuning_Guide-Setting_Semaphores-Setting_Semaphore_Parameters.html)

    ```bash
    # 检查 device mapper 情况
    dmsetup ls

    # 检查 cookie 的使用情况，可以根据特征 grep,wc -l 一下，统计下数量
    ipcs
    dmsetup udevcookies
    ipcs -ls

    # 检查信号量相关设置
    cat /proc/sys/kernel/sem
    250 32000  32  128

    # （临时）修改 max number of arrays (128) 为更大的值
    echo 250 32000  32  1024 > /proc/sys/kernel/sem
    # （持久）
    echo "kernel.sem=250 32000 100 1024" >> /etc/sysctl.conf
    ```

# kernel 模块

容器与 kernel 交互是通过 系统调用的，并包含容器内的 kernel 、kernel module 代码。
这也是为何 容器被设计为轻量、以及 portable。

但是，如果 host 操作系统与 container 的相匹配。container 也是可以的。

- 以 `--privileged` 模式运行
- `-cap-add=ALL`
- mount host `/lib/modules` 到容器内。

在 windows 平台，docker toolbox 运行了一个 boot2docker， 可以 ssh 上去，并查看 `/lib/modules` 里的内容。



# image 备注

- [sickcodes/docker-osx](https://hub.docker.com/r/sickcodes/docker-osx)
- [_/microsoft-windows-servercore](https://hub.docker.com/_/microsoft-windows-servercore)
  https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/container-base-images

# java client

- [docker-java/docker-java](https://github.com/docker-java/docker-java)
    - `com.github.docker-java:docker-java-core`
    - `com.github.docker-java:docker-java-transport-*`
- [A Docker Guide for Java](https://www.baeldung.com/docker-java-api)

# Capability

docker
run : [Runtime privilege and Linux capabilities](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities)

默认开启的能力

| Capability       | Desc                                                                                                                          |
|------------------|-------------------------------------------------------------------------------------------------------------------------------|
| AUDIT_WRITE      | Write records to kernel auditing log.                                                                                         |
| CHOWN            | Make arbitrary changes to file UIDs and GIDs (see chown(2)).                                                                  |
| DAC_OVERRIDE     | Bypass file read, write, and execute permission checks.                                                                       |
| FOWNER           | Bypass permission checks on operations that normally require the file system UID of the process to match the UID of the file. |
| FSETID           | Don’t clear set-user-ID and set-group-ID permission bits when a file is modified.                                             |
| KILL             | Bypass permission checks for sending signals.                                                                                 |
| MKNOD            | Create special files using mknod(2).                                                                                          |
| NET_BIND_SERVICE | Bind a socket to internet domain privileged ports (port numbers less than 1024).                                              |
| NET_RAW          | Use RAW and PACKET sockets.                                                                                                   |
| SETFCAP          | Set file capabilities.                                                                                                        |
| SETGID           | Make arbitrary manipulations of process GIDs and supplementary GID list.                                                      |
| SETPCAP          | Modify process capabilities.                                                                                                  |
| SETUID           | Make arbitrary manipulations of process UIDs.                                                                                 |
| SYS_CHROOT       | Use chroot(2), change root directory.                                                                                         |

默认DROP掉的能力

| Capability         | Desc                                                                                                                      |
|--------------------|---------------------------------------------------------------------------------------------------------------------------|
| AUDIT_CONTROL      | Enable and disable kernel auditing; change auditing filter rules; retrieve auditing status and filtering rules.           |
| AUDIT_READ         | Allow reading the audit log via multicast netlink socket.                                                                 |
| BLOCK_SUSPEND      | Allow preventing system suspends.                                                                                         |
| BPF                | Allow creating BPF maps, loading BPF Type Format (BTF) data, retrieve JITed code of BPF programs, and more.               |
| CHECKPOINT_RESTORE | Allow checkpoint/restore related operations. Introduced in kernel 5.9.                                                    |
| DAC_READ_SEARCH    | Bypass file read permission checks and directory read and execute permission checks.                                      |
| IPC_LOCK           | Lock memory (mlock(2), mlockall(2), mmap(2), shmctl(2)).                                                                  |
| IPC_OWNER          | Bypass permission checks for operations on System V IPC objects.                                                          |
| LEASE              | Establish leases on arbitrary files (see fcntl(2)).                                                                       |
| LINUX_IMMUTABLE    | Set the FS_APPEND_FL and FS_IMMUTABLE_FL i-node flags.                                                                    |
| MAC_ADMIN          | Allow MAC configuration or state changes. Implemented for the Smack LSM.                                                  |
| MAC_OVERRIDE       | Override Mandatory Access Control (MAC). Implemented for the Smack Linux Security Module (LSM).                           |
| NET_ADMIN          | Perform various network-related operations.                                                                               |
| NET_BROADCAST      | Make socket broadcasts, and listen to multicasts.                                                                         |
| PERFMON            | Allow system performance and observability privileged operations using perf_events, i915_perf and other kernel subsystems |
| SYS_ADMIN          | Perform a range of system administration operations.                                                                      |
| SYS_BOOT           | Use reboot(2) and kexec_load(2), reboot and load a new kernel for later execution.                                        |
| SYS_MODULE         | Load and unload kernel modules.                                                                                           |
| SYS_NICE           | Raise process nice value (nice(2), setpriority(2)) and change the nice value for arbitrary processes.                     |
| SYS_PACCT          | Use acct(2), switch process accounting on or off.                                                                         |
| SYS_PTRACE         | Trace arbitrary processes using ptrace(2).                                                                                |
| SYS_RAWIO          | Perform I/O port operations (iopl(2) and ioperm(2)).                                                                      |
| SYS_RESOURCE       | Override resource Limits.                                                                                                 |
| SYS_TIME           | Set system clock (settimeofday(2), stime(2), adjtimex(2)); set real-time (hardware) clock.                                |
| SYS_TTY_CONFIG     | Use vhangup(2); employ various privileged ioctl(2) operations on virtual terminals.                                       |
| SYSLOG             | Perform privileged syslog(2) operations.                                                                                  |
| WAKE_ALARM         | Trigger something that will wake up the system.                                                                           |

# Q&A

## Ping returns, "operation not permitted.

A: 需要 `-cap-add NET_RAW`



# Engine API
[Docker Engine API (1.42)](https://docs.docker.com/engine/api/v1.42/)

```shell
podman run --rm -it alpine:latest sh
podman machine inspect
curl -v --unix-socket /Users/zll/.local/share/containers/podman/machine/qemu/podman.sock http:/v1.42/containers/json
```





# ~/.docker/config.json

- [Docker CLI configuration file (config.json) properties](https://docs.docker.com/engine/reference/commandline/cli/#docker-cli-configuration-file-configjson-properties)
- [Credential stores](https://docs.docker.com/engine/reference/commandline/login/#credential-stores)
- [pass](https://www.passwordstore.org/)

```shell
brew install pass
```


```json
{
  "credsStore": "osxkeychain"
}
```
