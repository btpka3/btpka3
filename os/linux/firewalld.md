
# 简介
Firewalld 是 CentOS 7 默认自带的一套防火墙工具，
应当尽量使用 `firewall-cmd` 而非 `iptables` 来对防火墙进行管理。 

# firewalld 相关概念

* Zone 

    可以用来按特定环境区分，比如家庭网络，咖啡馆，服务器环境等。
   但服务器环境的网络因为基本不变动，zone 对服务器网络而言意义不大。

    firewalld 预定义了一些 zone，从 最不信任 到 最信任 的顺序列表如下：
    
    1. drop
    
        所有 incoming 请求都直接丢弃，不予回复。
        对于 outgoing 请求则相反含义，直接丢弃，不向外发送。
        
    1. block
        
        基本与 drop 相同，只不过针对 incoming 请求，不是不予回复，而是
        给予了 `icmp-host-prohibited` 或 `icmp6-adm-prohibited` 消息回复。
     
    1. public
        
        代表公开的，不被信任的网络。不信任网络中的其他主机，但可能按特定规则挑选信任什么。
       
    1. external
    
        当将启用 firewall 的主机作为 gateway (网关)时，代表外部的网络。
        默认已经开启了 masquerading ，因此你的内部网络仍然是私有，但可以访问。
        
    1. internal
        
        与 external 相反，代表防火墙内部的网络。
        内部网络中的主机均被信任，且可以额外提供一些网络服务。
    
    1. dmz
    
        demilitarized zone —— 隔离区。 这个区域的主机无法访问到网络中的其他主机。
        无法主动向外发送 outgoing 请求，只能接收特定的 incoming 请求。
    
    1. work
            
        适用于工作主机，网络中的大多数主机都是被信任的，可以提供更多一些服务。
        
    1. home
    
        家庭环境，暗含信任网络中的绝大部分主机，可以提供更多一些服务。
        
    1. trusted
    
        信任网络中的所有主机。
        
        
# 规则的性能

在 firewalld 中， 规则可以是 `permanent` 或 `immediate` 。 如果添加或修改规则，
默认会修改防火墙的行为。但重启后将恢复原有旧的规则。

大部分 firewall-cmd 命令都接受 `--permanent` 参数，这样的话，重启后仍然有效。


```bash
# 开机自启动
systemctl enable firewalld
# 启动防火墙
systemctl start firewalld.service

# 检查状态
firewall-cmd --state                    # "running"
firewall-cmd --get-default-zone         # "public"
firewall-cmd --set-default-zone=home

# 列出默认 zone 的状态详情
firewall-cmd --list-all
# 列出指定 zone 的状态详情
firewall-cmd --zone=home --list-all 
# 列出所有 zone 的状态详情
firewall-cmd --list-all-zones | less

# 创建自定义 zone
firewall-cmd --permanent --new-zone=publicweb
firewall-cmd --permanent --new-zone=publicweb -add-service=ssh
firewall-cmd --permanent --get-zones            # 新建的 zone 只能通过该命令看到
firewall-cmd --get-zones                        # 通过该命令看不到
firewall-cmd --reload                           # 只有 reload 之后，才能通过上述命令看到。


# 检查各个网卡分别在哪个 zone
firewall-cmd --get-active-zones

# 列出全部的zone （预定义的和自定义的）
firewall-cmd --get-zones

# 将指定的网卡接口迁移到指定的 zone 下。但是 `systemctl restart firewalld.service` 重启后会回复默认情况
firewall-cmd --zone=home --change-interface=eth0

# 永久修改 
vi /etc/sysconfig/network-scripts/ifcfg-eth0
ZONE=home

# 列出所有的服务
# TIP: 可以从 /usr/lib/firewalld/services/${serviceName}.xml 中查看详情
firewall-cmd --get-services
# 列出给定 zone 下可访问的服务
firewall-cmd --zone=public --list-services

# 为特定 zone 添加服务（基于服务）
firewall-cmd --zone=public --add-service=http               # （临时）
firewall-cmd --zone=public --add-service=http --permanent   # （永久）

# 为特定 zone 添加服务（基于端口）
firewall-cmd --zone=public --add-port=5000/tcp
firewall-cmd --zone=public --add-port=4990-4999/udp
firewall-cmd --zone=public --permanent --list-ports# 
firewall-cmd --zone=public --list-ports

cp /usr/lib/firewalld/services/xxx.xml /etc/firewalld/services/ 
vi /etc/firewalld/services/xxx.xml                          # 进行修改
firewall-cmd --reload
firewall-cmd --get-services                                 # 确认
```