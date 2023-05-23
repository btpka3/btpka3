## 参考

- [docker swarm](https://docs.docker.com/engine/reference/commandline/swarm/)

## Docker Swarm

用以管理Docker集群. 将一群docker节点当做一个来操作。

所使用的端口

| Port         | Desp                                                                   |
|--------------|------------------------------------------------------------------------|
| 2375         | unencrypted docker socket, remote root passwordless access to the host |
| 2376         | tls encrypted socket                                                   |
| 2377/tcp     | cluster management communications(仅仅针对 swarm manager)                  |
| 5000         | docker registry service                                                |
| 7946/tcp/udp | communication among nodes                                              |
| 4789/udp     | overlay network traffic                                                |

```bash
# 先准备3台物理主机，或虚拟机，或云主机
# 为了学习，我个人通过 virtualbox 安装3个 centos7 的虚拟机,启动并获取各自的IP地址（最好静态配置）。
# MAC, IP 地址如下：
# manager1 : 08:00:27:1E:30:96   : 192.168.0.181
# worker1  : 08:00:27:4E:AB:43   : 192.168.0.191
# worker2  : 08:00:27:40:F7:E0   : 192.168.0.192
docker-machine create                   \
    --driver generic                    \
    --generic-ip-address 192.168.0.181  \
    --generic-ssh-key ~/.ssh/id_rsa     \
    --generic-ssh-user root             \
    manager1

docker-machine create                   \
    --driver generic                    \
    --generic-ip-address 192.168.0.191  \
    --generic-ssh-key ~/.ssh/id_rsa     \
    --generic-ssh-user root             \
    worker1

docker-machine create                   \
    --driver generic                    \
    --generic-ip-address 192.168.0.192  \
    --generic-ssh-key ~/.ssh/id_rsa     \
    --generic-ssh-user root             \
    worker2

# 为了便捷，你也可以使用以下密令创建基于 virtualbox的 ubuntu 的虚拟机
#docker-machine create --driver virtualbox manager1
#docker-machine create --driver virtualbox worker1
#docker-machine create --driver virtualbox worker2

# 在当前节点上创建一个集群
#docker-machine ssh manager1
eval $(docker-machine env manager1)
docker network create --driver overlay my-network
docker network inspect my-network   # Subnet=10.0.0.0/24, Gateway=10.0.0.1
docker-machine ssh manager1 ip addr
docker-machine ssh worker1  ip addr
docker-machine ssh worker2  ip addr


docker swarm init --advertise-addr 192.168.0.181
# 如果忘记刚刚命令显示的让 worker 加入的命令行提示，可以通过一下语句重新显示
docker swarm join-token worker
# 显示作为 manager 加入的命令行提示
docker swarm join-token manager

# 向当前集群中增加 worker1
eval $(docker-machine env worker1)
docker swarm join \
    --token SWMTKN-1-5ib1fc2dsxc89bta06qs3wgt7ei6b4l1xf38dvb07c4s9y108h-dd2tzlcqngcohxtpfa910mf91 \
    192.168.0.181:2377
docker network ls           # 会自动创建 my-network network。与 swarm manager 中的一致。

# 向当前集群中增加 worker2
eval $(docker-machine env worker2)
docker swarm join \
    --token SWMTKN-1-5ib1fc2dsxc89bta06qs3wgt7ei6b4l1xf38dvb07c4s9y108h-dd2tzlcqngcohxtpfa910mf91 \
    192.168.0.181:2377

# 检查集群情况
eval $(docker-machine env manager1)
docker info
docker node ls
docker node inspect worker1 --pretty

# 创建服务
# global 模式：每个节点上都会创建容器
# replicated 模式：可以指定要启动几份容器
# https://docs.docker.com/engine/swarm/ingress/
eval $(docker-machine env manager1)
# --publish mode=host,target=80,published=8080 \
docker service create       \
    --name my_web           \
    --replicas 2            \
    --network my-network    \
    --publish 8080:80       \
    nginx:1.13.1-alpine
docker service inspect my_web   # 可以看到 Ports.PublishMode 模式为 ingress 模式
docker service ls
docker service ps my_web        # 查看 各个docker 节点上启动的容器

# 假设仅仅在 worker1，worker2 两个节点上运行，没有在 manager1 节点上运行
#docker-machine ssh worker1 systemctl status firewalld
docker-machine ssh manager1 curl -v http://192.168.0.181:8080  # 不能是 localhost
docker-machine ssh worker1  curl -v http://192.168.0.191:8080
docker-machine ssh worker2  curl -v http://192.168.0.192:8080

# 查看 各个docker 节点上启动的容器, 并记住相应的 NAME
# 为了后续方便，并安装 curl 命令
eval $(docker-machine env manager1)
docker ps
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv apk update
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv apk add curl

eval $(docker-machine env worker1)
docker ps
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias apk update
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias apk add curl

eval $(docker-machine env worker2)
docker ps


# FIXME 在docker 节点上未能ping 通其他节点上的容器。
docker-machine ssh manager1 ping my_web.1.c47jky8j1an6hhtqd9a1yeias

# 可以在任意节点的 docker 容器内，ping 到其他 docker 节点上的容器。无需 link
eval $(docker-machine env manager1)
# 发现该容器有 10.0.0.2 和 10.0.0.4 两个 IP 地址
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv ip addr
# 结果为 10.0.0.2 FIMXE 创建服务时，--endpoint-mode 为 vip 模式？
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv ping -c 3 my_web
# 结果为 10.0.0.3
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv ping -c 3 my_web.1.c47jky8j1an6hhtqd9a1yeias
# 结果为 10.0.0.4
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv ping -c 3 my_web.2.hrxd2k5x8x6pwm75mywa24cuv


eval $(docker-machine env worker1)
# 发现该容器有 10.0.0.2 和 10.0.0.3 两个 IP 地址
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias ip addr
# 结果为 10.0.0.2
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias ping -c 3 my_web
# 结果为 10.0.0.3
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias ping -c 3 my_web.1.c47jky8j1an6hhtqd9a1yeias
# 结果为 10.0.0.4
docker exec my_web.1.c47jky8j1an6hhtqd9a1yeias ping -c 3 my_web.2.hrxd2k5x8x6pwm75mywa24cuv


# 验证1：经过 docker service create 时的 `--publish` 参数指定，
# 可以在 docker 节点的宿主机上通过 8080 端口访问 docker 容器提供的服务。
docker-machine ssh manager1 curl -v http://localhost:8080

# 验证2：在容器内部通过 80 端口访问服务
eval $(docker-machine env manager1)
docker exec my_web.2.hrxd2k5x8x6pwm75mywa24cuv curl -v http://localhost

# 检查网络情况
eval $(docker-machine env worker1)
docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
76098f600236        bridge              bridge              local
48a1a18e730d        docker_gwbridge     bridge              local
e23c93fb6091        host                host                local
obnxbvgbcso6        ingress             overlay             swarm
beiqsdhkffv1        my-network          overlay             swarm
48e987ac0a0b        none                null                local

* bridge : docker 安装后自带的一个默认网络。
    Subnet=172.17.0.0/16, Gateway=172.17.0.1

* docker_gwbridge : 创建、加入 swarm 集群后创建。用以在不同主机上的 swarm 节点之间进行通信。
    Subnet=172.18.0.0/16, Gateway=172.18.0.1
    当前 docker 节点下运行的容器的 IP地址,比如、
    xxxUserContainerId: 172.18.0.3/16
    container : ingress-sbox=172.18.0.2/16
* host : 配置为空
* ingress :
    Subnet=10.255.0.0/16, Gateway=10.255.0.1

    当前 docker 节点下运行的容器的 IP地址,比如
    xxxUserContainerId: 10.255.0.9/16
    container ingress-sbox=10.255.0.3/16

    所有连接在该网络的docker节点的IP地址(Peers)
        manager1, worker1, worker2 节点的IP地址

* my-network: 自定义的一个 overlay 的网络
    Subnet=10.0.0.0/24, Gateway=10.0.0.1

    当前 docker 节点下运行的容器的 IP地址,比如
    xxxUserContainerId: 10.0.0.4/24

    所有连接在该网络的docker节点的IP地址(Peers)
        worker1, worker2 节点的IP地址

# 到 docker 节点的容器内确认ip地址信息
eval $(docker-machine env worker1)
docker exec -it my_web.2.mz4hzcjzf59mqn1s8ssg57xzx ip addr
docker exec -it my_web.2.mz4hzcjzf59mqn1s8ssg57xzx netstat




# 更新服务
eval $(docker-machine env manager1)
docker service update --publish-add 80 my_web

```



