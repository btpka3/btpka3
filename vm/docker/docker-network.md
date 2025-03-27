
### docker network

- [docker网络--多机通信--2--ipvlan笔记](https://blog.csdn.net/weixin_43501172/article/details/123819039)
- [Docker容器网络的七种武器](https://www.jianshu.com/p/bc3586d495d9)
- [podman-network-create](https://docs.podman.io/en/latest/markdown/podman-network-create.1.html)
- [Explore networking features](https://docs.docker.com/desktop/networking/)
- [I want to connect to a container from the Mac](https://github.com/containers/podman/issues/14554)


```bash
docker network create --attachable zll-net

docker network create \
    --gateway 192.168.1.1 \
    --subnet 192.168.1.0/24 \
    yourNetworkName


docker network ls
docker network inspect yourNetworkName
docker network rm yourNetworkName


# 测试：同时开两个命令行窗口，各自执行以下一条语句
docker run -it --rm --network=yourNetworkName --network-alias=node0 alpine:3.5 sh
docker run -it --rm --network=yourNetworkName --network-alias=node1 alpine:3.5 sh

# 分别在两个窗口中执行以下命令
cat /etc/resolv.conf
cat /etc/hosts
ip addr
ping zll-u
ping zll-x

# 注意：在创建 docker 容器的时候，可以不用 -p ，可以使用 `Dockerfile EXPOSE` + `docker run --publish`
# 从而无需关联 host 主机的端口

traceroute kingsilk.net  # 如果 宿主机是 Windows/MacOS, 则无法显示任何信息。

# swarm 模式下
```


### 内嵌的DNS服务器

在自定义网络中（含bridge类型）才可以使用

```bash
docker network ls
docker network create --driver bridge qh-net
docker run -it --rm --network=qh-net alpine:3.5

apk add --no-cache drill
drill kingsilk.net @127.0.0.11
```

## gateway


### ipvlan l2

```shell
# 注意：需要 rootful 才能使用 ipvlan
podman machine stop
podman machine set --rootful=true podman-machine-default
podman machine start

# 注意：这里的 enp0s2 是 `podman machine ssh podman-machine-default ip addr` 中 网络接口（虚拟机）
podman network create \
  --driver=ipvlan \
  --subnet=192.168.168.0/24 \
  --gateway=192.168.168.1 \
  -o mode=l2 \
  -o parent=enp0s2 \
  my_ipvlan_l2


podman run -it --rm --name box1 --cap-add=NET_ADMIN,NET_RAW --ip 192.168.168.6 --network my_ipvlan_l2 my-alpine sh
podman run -it --rm --name box2 --cap-add=NET_ADMIN,NET_RAW --ip 192.168.168.7 --network my_ipvlan_l2 my-alpine sh
```


## MacOS add route

[Adding a Static Route to macOS](https://support.justaddpower.com/kb/article/320-adding-a-static-route-to-macos/)

```shell
sudo route -n add -net A.B.C.D/E F.G.H.J

```
