


# 运行

```bash
docker network prune
docker-compose build
docker-compose up -d --build 
docker-compose down

# client
docker exec -it my-nat-client0 sh

route delete default gw 172.30.10.1 
route add default gw 172.30.10.101


docker exec -it my-nat-gw0 sh
iptables -t nat -A POSTROUTING -o eth0 -s 172.30.10.0/24 -j SNAT --to-source 172.30.20.101

# 如果配置错误了，通过类似下面的命令删除
# iptables -t nat -D POSTROUTING -o eth0 -s 172.30.10.0/24 -j SNAT --to-source 172.30.20.101
```


# 备注

iptables-save @ gw0

```bash
# Generated by iptables-save v1.6.1 on Mon Nov 19 17:05:13 2018
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [3:202]
:POSTROUTING ACCEPT [4:261]
:DOCKER_OUTPUT - [0:0]
:DOCKER_POSTROUTING - [0:0]
-A OUTPUT -d 127.0.0.11/32 -j DOCKER_OUTPUT
-A POSTROUTING -d 127.0.0.11/32 -j DOCKER_POSTROUTING
-A DOCKER_OUTPUT -d 127.0.0.11/32 -p tcp -m tcp --dport 53 -j DNAT --to-destination 127.0.0.11:45649
-A DOCKER_OUTPUT -d 127.0.0.11/32 -p udp -m udp --dport 53 -j DNAT --to-destination 127.0.0.11:45457
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p tcp -m tcp --sport 45649 -j SNAT --to-source :53
-A DOCKER_POSTROUTING -s 127.0.0.11/32 -p udp -m udp --sport 45457 -j SNAT --to-source :53
COMMIT
# Completed on Mon Nov 19 17:05:13 2018
# Generated by iptables-save v1.6.1 on Mon Nov 19 17:05:13 2018
*filter
:INPUT ACCEPT [8:694]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [8:608]
COMMIT
# Completed on Mon Nov 19 17:05:13 2018
# ```