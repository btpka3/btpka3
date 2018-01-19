
# docker-machine

## 安装
（略）

## 快速开始 - 本地虚拟机

该演示适用于单台电脑上，通过 virtualbox 创建一个虚拟机（节点），并演示在 宿主主机（比如 MacOS）上远程操作 该虚拟机节点。


参考 [Get started with Docker Machine and a local VM](https://docs.docker.com/machine/get-started/)

```bash
# MacOS : 列出当前主机（MacOS）管理的节点
docker-machine ls

# MacOS : 通过 virtualbox 创建一个虚拟机/虚拟节点，以便进行后续的演示操作
docker-machine create --driver virtualbox default

# MacOS : 再次确认 default 节点已经创建
docker-machine ls

# MacOS : 检查 default 节点的相关环境变量。
docker-machine env default

# MacOS : 在当前主机(MacOS)的 bash 环境中启用相关环境变量，以便明确要操作的 docker 节点
eval "$(docker-machine env default)"
# MacOS : 确认当前 docker 命令要操作的目标节点。
env | grep DOCKER       

# default : 快速检查之前的配置，确认能否在目标 docker 节点（default 主机）上进行相应的操作。 
docker run busybox echo hello world

# MacOS : 检查 default 节点的IP地址
docker-machine ip default

# default : 在目标 docker 节点（default 主机）上启动一个 nginx 服务
docker run -d -p 8000:80 nginx

# MacOS : 在本地连接 default 的服务进行确认
curl $(docker-machine ip default):8000

# MacOS : 重启 default 节点
docker-machine stop             # 停止，如果没给出机器名称，则默认是 "default"
docker-machine start default    # 启动，重新启动后，default 主机的IP地址可能已经变更，
eval "$(docker-machine env default)"        # 故需要重新 : eval "$(docker-machine env default)"
curl $(docker-machine ip default):8000      # 因为服务器重启，所以原有的 docker 容器已经停

docker ps -a


# MacOS : 重置环境变量，以便 docker 命令操作自己电脑（MacOS）上的容器。
docker-machine env -u
eval $(docker-machine env -u)
docker ps -a

# MacOS : ssh 到 default 主机，并执行命令
docker-machine ssh default whoami  # docker 用户，而非 root，随镜像而不同
docker-machine --native-ssh ssh default <<EOF
whoami      # docker
sudo -i     # 切换到 root 用户
whoami      # root
exit 0      # exit sudo
exit 0      # exit ssh
EOF
```

## 创建远程节点

```bash
# 环境准备
# 1. 通过 virtualbox 手动安装一个 CentOS 7 虚拟机 vm-centos-1。
# 1. 创建 vm-centos-1 前，需要设定网卡为 桥接模式（能获取与 MacOS所在网络相同的独立 IP 地址）
# 1. 配置 通过 ssh key 登录到 vm-centos-1 上。
# 1. 会需要用到 netstat 命令，先安装上 `yun install -y net-tools`

# MacOS : 通过 SSH 添加其他远程主机作为 docker 节点。
# 以下命令会 ssh 到目标主机上 进行以下操作：
# 1. 检查 docker 是否已经启动，没有安装的话会自动安装 docker engine
# 1. 除了 docker 相关软件，更新其他已经安装的软件，比如：
#       `sudo -E yum -y update -x docker-*`
# 1. 为 docker daemon 生成证书
# 1. 重启 docker daemon 
# 1. 重新设定主机名，以便匹配 machine 名称。
docker-machine create                   \
    --driver generic                    \
    --generic-ip-address 192.168.0.156  \
    --generic-ssh-key ~/.ssh/id_rsa     \
    --generic-ssh-user root             \
    vm-centos-1
    
docker-machine rm vm-centos-1
docker-machine env vm-centos-1
eval "$(docker-machine env vm-centos-1)"

docker-machine status vm-centos-1
docker-machine provision vm-centos-1
docker-machine config vm-centos-1               # 配置或打印 vm-centos-1 相关配置
docker-machine regenerate-certs vm-centos-1     # 重新生成证书



docker run -d -p 8000:80 nginx
curl $(docker-machine ip vm-centos-1):8000
docker ls -a
```
