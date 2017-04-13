# 背景
1. 阿里云传统网络中，内网主机无法直接访问外网。
2. 阿里云的NAT网关的费用不低，相当于单独一台 阿里云云主机 一年的费用。

# 目的
使用 VirtualBox 完成模拟环境的搭建，并学习、验证自建NAT。

# 模拟阿里云经典网络下的主机环境

1. 使用 VirtualBox 最小化安装两个 CentOS 7 的虚拟机，分别命名为 "nat", "inner"
1. 虚拟机 "nat" 启用前两个网卡，第一个NAT连接模式，第二个 internal 模式。
1. 虚拟机 "inner" 启用只启用第二个网卡，为 internal 模式。

    
    | VM    |               | nat       | inner     |memo |
    |-------|---------------|-----------|-----------|-----|
    |OS     |               |CentOS 7   |CentOS 7   ||
    |NIC-1  |connect type   |NAT        |None       |连接方式|
    |NIC-1  |BOOTPROTO      |dncp       |           ||
    |NIC-1  |NAME           |enp0s3     |           ||
    |NIC-1  |DEVICE         |enp0s3     |           ||
    |NIC-1  |ip addr(dhcp)  |10.0.2.15  |           ||
    |NIC-1  |ZONE           |external   |           ||
    |NIC-2  |connect type   |Internal   |Internal   |连接方式|
    |NIC-2  |BOOTPROTO      |static     |static     ||
    |NIC-2  |NAME           |enp0s8     |enp0s8     ||
    |NIC-2  |DEVICE         |enp0s8     |enp0s8     ||   
    |NIC-2  |IPADDR         |172.17.0.1 |172.17.0.2 ||
    |NIC-2  |NETMASK        |255.255.0.0|255.255.0.0||
    |NIC-2  |GATEWAY        |           |172.17.0.1 ||
    |NIC-2  |ZONE           |internal   |           ||
    
    PS: NIC  的含义为网卡。

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
    
    IPADDR1=172.17.0.1
    #PREFIX1=16
    NETMASK=255.255.0.0
    ```

1. 重启网络

    ```bash
    systecmtl restart network
    systecmtl status network
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

# NAT 网关配置

1. 开启 IP 转发

    ```bash
    sysctl net.ipv4.ip_forward          # 检查相关配置是否已经启用 ： 0 - 未启用，1 - 启用
    
    sysctl -w net.ipv4.ip_forward=1     # 临时修改，重启后失效
    
    vi /etc/sysctl.conf                 # 永久修改，重启后才生效
    net.ipv4.ip_forward=1
    ```
    
1. dd
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
    
     
    firewall-cmd --permanent \
       --direct \
       --passthrough ipv4 \
       -I FORWARD \
       -i enp0s3 \
       -j ACCEPT

    firewall-cmd --reload
 
    ```

# 参考
* [eploy Outbound NAT Gateway on CentOS 7](https://devops.profitbricks.com/tutorials/deploy-outbound-nat-gateway-on-centos-7/)
* [CentOS 7 as NAT Gateway for Private Network](http://blog.redbranch.net/2015/07/30/centos-7-as-nat-gateway-for-private-network/)


