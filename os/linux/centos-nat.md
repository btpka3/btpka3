
# 术语

* SNAT : 内网主机访问外网服务。
* DNAT : 局域网无静态IP地址，外网主机访问局域网网关特定端口，相当于直接访问内网中某个主机的特定服务。


# 背景
1. 阿里云传统网络中，内网主机无法直接访问外网。
2. 阿里云的NAT网关的费用不低，相当于单独一台 阿里云云主机 一年的费用。

# 目的
使用 VirtualBox 完成模拟环境的搭建，并学习、验证自建NAT。

## 模拟一 

### 环境准备

1. 使用 VirtualBox 最小化安装两个 CentOS 7 的虚拟机，分别命名为 "nat", "inner"

    ```txt
    www ━━━━━ nat ━━━━━ inner
    ```


1. 虚拟机 "nat" 启用前两个网卡，第一个NAT连接模式，第二个 internal 模式。
1. 虚拟机 "inner" 启用只启用第二个网卡，为 internal 模式。

    
    | VM    |               | nat       | inner     |
    |-------|---------------|-----------|-----------|
    |OS     |               |CentOS 7   |CentOS 7   |
    |NIC-1  |connect type   |NAT        |           |
    |NIC-1  |BOOTPROTO      |dhcp       |           |
    |NIC-1  |NAME           |enp0s3     |           |
    |NIC-1  |DEVICE         |enp0s3     |           |
    |NIC-1  |IPADDR         |?.?.?.?    |           |
    |NIC-1  |ZONE           |external   |           |
    |NIC-2  |connect type   |Internal   |Internal   |
    |NIC-2  |BOOTPROTO      |static     |static     |
    |NIC-2  |NAME           |enp0s8     |enp0s8     |
    |NIC-2  |DEVICE         |enp0s8     |enp0s8     |
    |NIC-2  |IPADDR         |172.17.0.1 |172.17.0.2 |
    |NIC-2  |NETMASK        |255.255.0.0|255.255.0.0|
    |NIC-2  |GATEWAY        |           |172.17.0.1 |
    |NIC-2  |ZONE           |internal   |           |
    
    PS: `NIC` 的含义为网卡。
    
    FIXME: 只要 nat 主机开启 ipv4 转发，NIC-1 在 external zone， NIC-2 在 internal zone，
        inner 就可以访问外网了？

1. 分别为两个虚拟机的第二个网卡配置静态类型的IP地址。
   文件路径为 `/etc/sysconfig/network-scripts/ifcfg-enp0s8`。
   参考内容如下：
   
    ```conf
    TYPE=Ethernet
    BOOTPROTO=static
    DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_PEERDNS=yes
    IPV6_PEERROUTES=yes
    IPV6_FAILURE_FATAL=no
    NAME=enp0s8
    UUID=64c0421d-31e0-4220-a54b-3cd604542951
    DEVICE=enp0s8
    ONBOOT=yes
    
    IPADDR=172.17.0.1
    #PREFIX1=16
    NETMASK=255.255.0.0
    ```

1. 重启网络

    ```bash
    systemctl restart network
    systemctl status network
    ```

1. 检验互通性

    ```bash
    # @ vm "nat" 
    ping www.baidu.com     # ping internet     (OK)
    ping 172.17.0.2        # ping vm "inner"   (OK)
    
    # @ vm "inner"
    ping www.baidu.com     # ping internet     (ERROR)
    ping 172.17.0.1        # ping vm "nat"     (OK)
    ```

### 进行配置

1. 开启 IP 转发

    ```bash
    sysctl net.ipv4.ip_forward          # 检查相关配置是否已经启用 ： 0 - 未启用，1 - 启用
    sysctl -w net.ipv4.ip_forward=1     # 临时修改，重启后失效
    
    vi /etc/sysctl.conf                 # 永久修改，重启后才生效
    net.ipv4.ip_forward=1
    ```
    
1. 安装 firewalld

    ```bash
    yum install firewalld  
    ```

1. 配置 firewalld

    ```bash
    firewall-cmd --list-all-zones
 
    firewall-cmd --zone=external --add-interface=enp0s3 --permanent
    firewall-cmd --zone=internal --add-interface=enp0s8 --permanent
    firewall-cmd --zone=internal --remove-interface=eth0  # 如果误加入，可以通过该命令移除
 
    firewall-cmd --complete-reload
    
    # 配置 masquerading  
    firewall-cmd --zone=external --add-masquerade --permanent
 
    # 开启 NAT
    firewall-cmd --permanent   \
       --direct                \
       --passthrough ipv4      \
       -t nat                  \
       -I POSTROUTING          \
       -o enp0s3               \
       -j MASQUERADE           \
       -s 172.17.0.1/16
    
    # 允许内网主机访问 网关主机的内网IP地址 访问相关服务
    firewall-cmd --permanent \
       --zone=internal \
       --add-service=ssh
    
     
    #firewall-cmd --permanent \
    #  --direct \
    #  --passthrough ipv4 \
    #  -I FORWARD \
    #  -i enp0s3 \
    #  -j ACCEPT

    firewall-cmd --reload
    # DONE.
 
    # NOTICE：以下为自测环境调查用命令, 请勿执行。
    firewall-cmd --permanent --direct --get-all-passthroughs
    firewall-cmd --permanent --direct --remove-passthrough ipv4  \
       -I FORWARD \
       -i enp0s3 \
       -j ACCEPT

    firewall-cmd --permanent --direct --remove-passthrough ipv4  \
       -t nat \
       -I POSTROUTING \
       -o enp0s3 \
       -j MASQUERADE \
       -s 172.17.0.0/16
    ```

### 在阿里云经典网络中记性测试

结论是 失败。 在阿里云主机 ECS1 上 traceroute ECS2，可以看到经过了3个路由器。
故猜测各个同个公司，同个地域中 多个 ECS 的网络拓扑如下： 

```txt
www ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓ 
                                                ┃
  ┏━━━ <net-10> ━━━ ROUTE-21 ━━━ <net-11> ━━━ ECS-1 (有公网IP)
  ┃
ROUTE-1 
  ┃
  ┗━━━ <net-20> ━━━ ROUTE-22 ━━━ <net-21> ━━━ ECS-2 (不能访问互联网)
```
因此，只有两台 ECS 云主机在同一个路由器下面的话，上面的实验才能成功。



## 模拟二


### 环境准备

1. 主机 nat , middle,  inner 共三个。

    ```txt
    www ━━━━━━━━━━━━━━━━━━━━━━┓ 
                              ┃
      ┏━━━━━━ <net-1> ━━━━━━ nat
      ┃
    middle (as router)
      ┃
      ┗━━━━━━ <net-2> ━━━━━━ inner
    ```

1. nat 与 middle 在同一个网络， middle 与 inner 在另一个网络，但 inner 直接无法ping 到 nat。
1. middle 角色为阿里云上的主机，我们自己无法对它进行任何配置。

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


### 模拟 2.1： VLAN

VLAN 模式貌似只能在同一个路由器下？跨路由器如何处理暂时不会。
VLAN 的网络设计为 172.20.0.0/16, 
虚拟机 nat 的ip地址为 172.20.0.1，
虚拟机 inner 的ip地址为 172.20.0.2。

1. 在虚拟机 nat 上启用 vlan （虚拟网卡）

    ```bash
    systemctl start NetworkManager   # 临时启用，以方便使用 nmtui
    nmtui
    # 新建 vlan 类型连接，比如名称为 "vlan1", device 为 "v1"
    
    systemctl stop NetworkManager
 
    # vi /etc/sysconfig/network-scripts/ifcfg-vlan1 
    # 设置 IP地址为 172.20.0.1
 
    systemctl restart network
    ```
    
    ifcfg-vlan1 的设置参考如下：

    ```properties
    VLAN=yes
    TYPE=Vlan
    DEVICE=v1
    PHYSDEV=enp0s8
    VLAN_ID=0
    REORDER_HDR=yes
    GVRP=no
    MVRP=no
    BOOTPROTO=static
    DEFROUTE=yes
    IPV4_FAILURE_FATAL=no
    IPV6INIT=yes
    IPV6_AUTOCONF=yes
    IPV6_DEFROUTE=yes
    IPV6_FAILURE_FATAL=no
    IPV6_ADDR_GEN_MODE=stable-privacy
    NAME=vlan1
    UUID=c373aaa6-ac13-4a69-876a-23b46f628c9d
    ONBOOT=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV6_PEERDNS=yes
    IPV6_PEERROUTES=yes
    
    IPADDR=172.20.0.1
    NETMASK=255.255.0.0
    ```
    
1. 在虚拟机 inner 上启用 vlan （虚拟网卡）

    ```bash
    systemctl start NetworkManager   # 临时启用，以方便使用 nmtui
    nmtui
    # 新建 vlan 类型连接，比如名称为 "vlan1", device 为 "v1"
 
    systemctl stop NetworkManager
 
    # vi /etc/sysconfig/network-scripts/ifcfg-vlan1 
    # 设置 IP地址为 172.20.0.2，设置网关为 172.20.0.1
 
    # vi /etc/sysconfig/network-scripts/ifcfg-enp0s8， 设置网关为
    systemctl restart network
    ```
    

    * 需要 middle 主机启用 net.ipv4.ip_forward。
    * nat 主机需要执行
    
        ```bash
        ip route add 172.18.0.0/16 via 172.17.0.2 dev enp0s8
        ```
1. 在 inner 主机上进行测试

    ```bash
    ping 172.20.0.1        # OK
    ping www.baidu.com     # OK
    ```

### 模拟 2.2

FAILED. inner 无法将网关设置为 nat 主机，因为不在一个网络里。

FIXME：后续尝试 VPN 方案。


# 参考
* [CentOS 7 as NAT Gateway for Private Network](http://blog.redbranch.net/2015/07/30/centos-7-as-nat-gateway-for-private-network/)
* [eploy Outbound NAT Gateway on CentOS 7](https://devops.profitbricks.com/tutorials/deploy-outbound-nat-gateway-on-centos-7/)





curl https://CLIENT_ID_qh-agency-wap:CLIENT_PWD_qh-agency-wap_123456@login.kingsilk.net/local/11300/rs/oauth/token \
    -d grant_type=client_credentials \
    -d scope=SERVER \
    --trace-ascii /dev/stdout -v 
    
    
    


