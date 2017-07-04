
### docker network

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


## gateway


