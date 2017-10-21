


# 模拟环境准备

1. VirtualBox 最小化安装 CentOS7 虚拟机 nat, middle,  inner 共三个。
    1. 虚拟机 nat 启用两个网卡，第一个可以访问外网

    1. 虚拟机 middle 启用两个网卡，角色为路由器，连接位于两个网络下的虚拟机 nat，inner。
        middle 角色为阿里云上的主机，我们自己无法对它进行任何配置。

    1. 虚拟机 inner 启用一个网卡，只跟 middle 相连，不能直接访问公网，与 nat 主机不在一个网络

1. 计划网络拓扑如下：

    ```txt
    www ━━━━━━━━━━━━━━━━━━━━━━┓ 
                              ┃
      ┏━━━━━━ <net-1> ━━━━━━ nat
      ┃
    middle (as router)
      ┃
      ┗━━━━━━ <net-2> ━━━━━━ inner
    ```

1. 各个网卡配置脚本如下表所示：

    | VM        |               | nat       | inner     |middle     |
    |-----------|---------------|-----------|-----------|-----------|
    |OS         |               |CentOS 7   |CentOS 7   |CentOS 7   |
    |NIC-1      |connect type   |NAT        |None       |Internal   |
    |NIC-1      |BOOTPROTO      |dhcp       |           |static     |
    |NIC-1      |NAME           |enp0s3     |           |enp0s3     |
    |NIC-1      |DEVICE         |enp0s3     |           |enp0s3     |
    |NIC-1      |IPADDR         |?.?.?.?    |           |172.17.0.1 |
    |NIC-1      |NETMASK        |           |           |255.255.0.0|
    |NIC-1      |ZONE           |external   |           |           |
    |NIC-2      |connect type   |Internal   |Internal   |Internal   |
    |NIC-2      |BOOTPROTO      |static     |static     |static     |
    |NIC-2      |NAME           |enp0s8     |enp0s8     |enp0s8     |
    |NIC-2      |DEVICE         |enp0s8     |enp0s8     |enp0s8     |     
    |NIC-2      |IPADDR         |172.17.0.1 |172.18.0.2 |172.18.0.1 |
    |NIC-2      |NETMASK        |255.255.0.0|255.255.0.0|255.255.0.0|
    |NIC-2      |GATEWAY        |           |172.18.0.1 |           |
    |NIC-2      |ZONE           |internal   |           |           |
    |ping www   |               | Y         | N         | N         |
    |ping nat   |               | Y         | Y         | Y         |
    |ping inner |               | Y         | Y         | Y         |
    |ping middle|               | Y         | Y         | Y         |


1. 在虚拟机 nat 配置如下

    ```bash
    ip route add 172.18.0.0/16 via 172.17.0.2 dev enp0s8
    ```

1. 在虚拟机 inner 上进行以下配置

    ```bash
    # 不配置的话，openvpn client端启动后， inner ping 不到 172.17.0.2
    ip route add 172.17.0.0/16 via 172.18.0.1
    ```

# OpenVPN 服务器


## 墙

OpenVPN 的默认配合是会被墙的。因为会被嗅探到 握手信息。需要配置 上  obfsproxy, over SSH 或者 over stunnel。
see [this](https://vpnreviewer.com/vpn-protocols-that-work-in-china)


## 安装 OpenVPN


```bash
# 禁用 SELinux

yum install epel-release
yum install openvpn easy-rsa -y

cp /usr/share/doc/openvpn-2.4.1/sample/sample-config-files/server.conf /etc/openvpn
```

## 生成相关秘钥

```bash
mkdir -p /etc/openvpn/easy-rsa/keys
cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa
vi /etc/openvpn/easy-rsa/vars
# 1. 修改 KEY_NAME 为 "server". 值为后面要生成 server 端 key 的名称
# 2. 修改 KEY_CN 为对应的域名（可选）
# 3. 修改 KEY_ 开头的其他内容

cd /etc/openvpn/easy-rsa
source ./vars
./clean-all
./build-ca
./build-key-server server   # 该名称应当与前面设置的 KEY_NAME 名称一致。
./build-dh                  # 创建 Diffie-Hellman key 交换文件

cd /etc/openvpn/easy-rsa/keys
cp dh2048.pem ca.crt server.crt server.key /etc/openvpn

cd /etc/openvpn
openvpn --genkey --secret ta.key
```

## 配置服务器

1. 查看man手册

    ```bash
    # 命令行参数都可以出现在配置文件中，只是去掉了 "--" 前缀
    man openvpn
    vi /etc/openvpn/server.conf
    ```

1.  `/etc/openvpn/server.conf` 修改内容如下

    ```bash
    port 1194
    proto tcp                           # 启用tcp
    dev tun
    ca ca.crt
    cert server.crt
    key server.key
    dh dh2048.pem
    server 10.8.0.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    # 推送配置给 client 端，并让 client 端的所有请求都转发到 OpenVPN 服务器
    push "redirect-gateway def1 bypass-dhcp"
    keepalive 10 120
    tls-auth ta.key 0
    cipher AES-256-CBC
    user nobody
    group nobody
    persist-key
    persist-tun
    status openvpn-status.log           # 方便查看有多少个client在连接
    log         openvpn.log             # 开启日志，方便跟踪问题
    verb 3
    management 127.0.0.1 7505           # 启动管理 telnet localhost 7505 ; help; status 
    ```

## 启用 ip 转发

```bash
sysctl net.ipv4.ip_forward          # 检查相关配置是否已经启用 ： 0 - 未启用，1 - 启用
sysctl -w net.ipv4.ip_forward=1     # 临时修改，重启后失效

vi /etc/sysctl.conf                 # 永久修改，重启后才生效
net.ipv4.ip_forward=1
```

## 修改防火墙配置

如果使用的 iptables 服务

```bash
yum install iptables-services -y
systemctl mask firewalld
systemctl enable iptables
systemctl stop firewalld
systemctl start iptables
iptables --flush

# 其中 enp0s3 是有可以访问外网IP地址的网卡
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o enp0s3 -j MASQUERADE
```

如果使用的 firewalld 服务

```bash
firewall-cmd --permanent --direct --get-all-passthroughs
firewall-cmd --permanent --direct --get-all-rules

firewall-cmd --permanent --direct \
    --add-rule ipv4 nat POSTROUTING 1 \
    -s 10.8.0.0/24 \
    -o enp0s3 \ 
    -j MASQUERADE

#firewall-cmd --permanent   \
#   --direct                \
#   --passthrough ipv4      \
#   -t nat                  \
#   -A POSTROUTING          \
#   -o enp0s3               \
#   -j MASQUERADE           \
#   -s 10.8.0.0/24
firewall-cmd --complete-reload
```



### 启动并检查

```bash
systemctl -f enable openvpn@server.service
systemctl start openvpn@server.service

telnet localhost 1194       # 如果配置的是 UDP 协议，则 Connection refused
netstat -uapn | grep openvpn
nmap -sU localhost -p 1194  # 显示一下信息，则代表启动起来了
# PORT     STATE         SERVICE
# 1194/udp open|filtered openvpn

telnet localhost 7505       # help; status 

# 列出连接上的客户端
cat /etc/openvpn/openvpn-status.log
```


 


# OpenVPN 客户端（CentOS 7）

## 安装 OpenVPN
```bash
# 禁用 SELinux

yum install epel-release
yum install openvpn easy-rsa -y
```

## 从 OpenVPN 服务器上复制相关文件

```bash
cd /etc/openvpn
scp user@openvpn.server.ip:/etc/openvpn/easy-rsa/keys/ca.crt .
scp user@openvpn.server.ip:/etc/openvpn/easy-rsa/keys/client.crt .
scp user@openvpn.server.ip:/etc/openvpn/easy-rsa/keys/client.key .
scp user@openvpn.server.ip:/etc/openvpn/easy-rsa/keys/ta.key .
```

## 创建 client 端配置文件 

```bash
# vi /etc/openvpn/client.ovpn       # 路径可以随意
client
dev tun
proto tcp
remote 172.17.0.1 1194      # ip 地址为 OpenVPN 服务器的IP
remote-cert-tls server      # 验证服务器端证书

resolv-retry infinite
nobind

user nobody
group nobody

persist-key
persist-tun

verb 3

ca   ca.crt
cert client.crt
key  client.key
tls-auth ta.key 1
cipher AES-256-CBC          # 需要与服务器端配置保持一致
```


## 启动并验证

1. 启动前

    ```bash
    # 命令 `ip route` 结果如下 
    default via 172.18.0.1 dev enp0s8 
    169.254.0.0/16 dev enp0s8  scope link  metric 1002 
    172.17.0.0/16 via 172.18.0.1 dev enp0s8 
    172.18.0.0/16 dev enp0s8  proto kernel  scope link  src 172.18.0.2
    
    # ping
    ping 172.18.0.2             # inner,    OK
    ping 172.18.0.1             # middle,   OK
    ping 172.17.0.2             # middle,   OK
    ping 172.17.0.1             # nat,      OK
    ping www.baidu.com          # www,      FAILED
    ```

1. 启动
    
    ```bash
    openvpn --config /etc/openvpn/client.ovpn
    ```
1. 启动后

    ```bash
    # 命令 `ip route` 结果如下 
    0.0.0.0/1 via 10.8.0.5 dev tun0 
    default via 172.18.0.1 dev enp0s8 
    10.8.0.1 via 10.8.0.5 dev tun0 
    10.8.0.5 dev tun0  proto kernel  scope link  src 10.8.0.6 
    128.0.0.0/1 via 10.8.0.5 dev tun0 
    169.254.0.0/16 dev enp0s8  scope link  metric 1002 
    172.17.0.0/16 via 172.18.0.1 dev enp0s8 
    172.17.0.1 via 172.18.0.1 dev enp0s8 
    172.18.0.0/16 dev enp0s8  proto kernel  scope link  src 172.18.0.2
 
    # ping
    ping 172.18.0.2             # inner,    OK
    ping 172.18.0.1             # middle,   OK
    ping 172.17.0.2             # middle,   OK  # !!!
    ping 172.17.0.1             # nat,      OK
    ping www.baidu.com          # www,      OK
 
    # traceroute 检查路由路径
    ```

# FIXME

* openvpn client 端路由表中 `0.0.0.0/1` 即 `0.0.0.0/0.0.0.1` 是什么含义？
    按照 RFC 3330 (reserved networks) 和 RFC 1700 (assigned numbers)，
    0.0.0/8 (0.0.0.0 - 0.255.255.255) 的含义是 "this network"。
    该网络下的任何一个IP地址都不是一个合法的主机IP地址，但却是合法的 来源地址。

# 参考

* [openVpn](https://openvpn.net/)
* 《[How To Setup and Configure an OpenVPN Server on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-setup-and-configure-an-openvpn-server-on-centos-7)》

* [Docker 上的 IPsec VPN 服务器](https://github.com/hwdsl2/docker-ipsec-vpn-server/blob/master/README-zh.md)
