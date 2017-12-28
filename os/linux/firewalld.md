
# 简介
Firewalld 是 CentOS 7 默认自带的一套防火墙工具，
应当尽量使用 `firewall-cmd` 而非 `iptables` 来对防火墙进行管理。 

`firewalld` 不会从 `/etc/sysconfig/ip*tables` 读取配置文件。
想加载 `lokkit`、 `system-config-firewall` 设定文件，请使用
`firewall-offline-cmd` 命令和 `/etc/sysconfig/system-config-firewall` 文件。

```txt
system-config-firewall(GUI)  -> iptables(service)           -> iptables(command)  -> kernel(netfilter)
firwall-config(GUI)          -> firewalld(daemon & service) -> iptables(command)  -> kernel(netfilter)
firwall-cmd                  -> firewalld(daemon & service) -> iptables(command)  -> kernel(netfilter)
```

其配置文件为 `/etc/firewalld/` 目录下的 XML 文件。

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
        
        
# 常用命令

在 firewalld 中， 规则可以是 `permanent` 或 `immediate` 。 如果添加或修改规则，
默认会修改防火墙的行为。但重启后将恢复原有旧的规则。

大部分 firewall-cmd 命令都接受 `--permanent` 参数，这样的话，重启后仍然有效。


## 服务

```bash
# 开机自启动
systemctl enable firewalld
# 启动防火墙
systemctl start firewalld.service
```



## 状态相关

```bash
# 检查状态
firewall-cmd --state                # "running"
firewall-cmd --reload               # 重新加载防火墙规则，并保留 state 信息。注意非 permanent 配置会丢失
firewall-cmd --complete-reload      # 
firewall-cmd --runtime-to-permanent # 持久保存

firewall-cmd --get-log-denied       # 打印 log denied 设置
firewall-cmd --set-log-denied       # 在 INPUT、 FORWARD、 OUTPUT
                                    # 可选值：all、 unicast、 broadcast、 multicast、 off（默认）
```



## zone 相关

```bash
firewall-cmd --get-default-zone         # "public"
firewall-cmd --set-default-zone=home

# 查看 public zone 的默认配置
cat /etc/firewalld/zones/public.xml

vi /usr/lib/firewalld/services/es1.xml
<?xml version="1.0" encoding="utf-8"?>
<service>
  <short>elasticsearch 1</short>
  <description>ElasticSearch 1</description>
  <port protocol="tcp" port="9200-9299"/>
  <port protocol="tcp" port="9300-9399"/>
</service>

# 检查各个网卡分别在哪个 zone
firewall-cmd --get-active-zones

firewall-cmd [--permanent] \
    --get-zones         # 列出全部的zone （预定义的和自定义的）
    --get-services      # 列出所有的服务
                        # TIP: 可以从 /usr/lib/firewalld/services/${serviceName}.xml 中查看详情
    --get-icmptypes
    --get-zone-of-interface=interface
    --get-zone-of-source=source[/mask]|MAC|ipset:ipset
    --info-zone=zone   # 打印 zone 的信息

    --list-all-zones    # 列出所有 zone 的状态详情
    
firewall-cmd --permanent 
    --new-zone=zone
    --new-zone-from-file=filename [--name=zone]
    --delete-zone=zone
    --load-zone-defaults=zone
    
firewall-cmd --permanent -zone=zone
    --set-description=description
    --get-description
    --set-short=description
    --get-short
    --get-target
    --set-target=target

firewall-cmd [--permanent] [--zone=zone]
    --list-all
    --list-services
    --add-service=service [--timeout=timeval]
    --remove-service=service
    --query-service=service
    --list-ports
    --add-port=portid[-portid]/protocol [--timeout=timeval]
    --remove-port=portid[-portid]/protocol
    --query-port=portid[-portid]/protocol
    --list-protocols
    --add-protocol=protocol [--timeout=timeval]
    --remove-protcol=protocol
    --query-protocol=protocol
    
    # source 管理。 注意该功能依赖 NetworkManger 服务，如果该服务不可用，则只能使用 iptables
    --list-source-ports
    --add-source-port=portid[-portid]/protocol [--timeout=timeval]
    --remove-source-port=portid[-portid]/protocol
    --query-source-port=portid[-portid]/protocol
    --list-icmp-blocks
    --add-icmp-block=icmptype [--timeout=timeval]
    --remove-icmp-block=icmptype
    --query-icmp-block=icmptype
    --list-forward-ports
    --add-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[/mask]] [--timeout=timeval]
    --remove-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[/mask]]
    --query-forward-port=port=portid[-portid]:proto=protocol[:toport=portid[-portid]][:toaddr=address[/mask]]
    --add-masquerade [--timeout=timeval]
    --remove-masquerade
    --query-masquerade
    --list-rich-rules
    --add-rich-rule='rule' [--timeout=timeval]
    --remove-rich-rule='rule'
    --query-rich-rule='rule'
```

# interface
```bash
firewall-cmd [--permanent] [--zone=zone] 
     --list-interfaces
     --add-interface=interface
     --query-interface=interface
firewall-cmd [--zone=zone] 
    --change-interface=interface

firewall-cmd [--permanent]
    --remove-interface=interface

# 永久修改 
vi /etc/sysconfig/network-scripts/ifcfg-eth0
ZONE=home

```
# Bindings 和 source 相关

```bash
firewall-cmd [--permanent] [--zone=zone]
    --list-sources
    --add-source=source[/mask]|MAC|ipset:ipset
    --query-source=source[/mask]|MAC|ipset:ipset

firewall-cmd [--zone=zone]
    --change-source=source[/mask]|MAC|ipset:ipset

firewall-cmd [--permanent]
    --remove-source=source[/mask]|MAC|ipset:ipset
```

# IPSet 相关
```bash
firewall-cmd --permanent
    --new-ipset=ipset --type=ipset type [--option=ipset option[=value]]
    --new-ipset-from-file=filename [--name=ipset]
    --delete-ipset=ipset
    --load-ipset-defaults=ipset

firewall-cmd [--permanent]
    --info-ipset=ipset
    --get-ipsets

firewall-cmd --permanent --ipset=ipset 
    --set-description=description
    --get-description
    --set-short=description

firewall-cmd [--permanent] --ipset=ipset
    --add-entry=entry
    --remove-entry=entry
    --query-entry=entry
    --get-entries
    --add-entries-from-file=filename
    --remove-entries-from-file=filename
```

# Service 相关

```bash
firewall-cmd [--permanent]
    --info-service=service

firewall-cmd --permanent
    --new-service=service
    --new-service-from-file=filename [--name=service]
    --delete-service=service
    --load-service-defaults=service
    
firewall-cmd --permanent --service=service
    --set-description=description
    --get-description
    --set-short=description
    --get-short
    --add-port=portid[-portid]/protocol
    --remove-port=portid[-portid]/protocol
    --query-port=portid[-portid]/protocol
    --get-ports
    --add-protocol=protocol
    --remove-protocol=protocol
    --query-protocol=protocol
    --get-protocols
    --add-source-port=portid[-portid]/protocol
    --remove-source-port=portid[-portid]/protocol
    --query-source-port=portid[-portid]/protocol
    --get-source-ports
    --add-module=module
    --remove-module=module
    --query-module=module
    --get-modules
    --set-destination=ipv:address[/mask]
    --remove-destination=ipv
    --query-destination=ipv:address[/mask]
    --get-destinations
    
 

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


# Internet Control Message Protocol (ICMP) 相关

```bash
firewall-cmd [--permanent]
    --info-icmptype=icmptype

firewall-cmd --permanent
    --new-icmptype=icmptype
    --new-icmptype-from-file=filename [--name=icmptype]
    --delete-icmptype=icmptype
    --load-icmptype-defaults=icmptype

firewall-cmd --permanent --icmptype=icmptype 
    --set-description=description
    --get-description
    --set-short=description
    --get-short
    --add-destination=ipv
    --remove-destination=ipv
    --query-destination=ipv
    --get-destinations
```

# Direct 相关
```bash
firewall-cmd [--permanent] --direct

    # chains
    --get-all-chains                            # 只显示通过 --direct --add-chain 添加的配置
    --get-chains { ipv4 | ipv6 | eb } table
    --add-chain { ipv4 | ipv6 | eb } table chain
    --remove-chain { ipv4 | ipv6 | eb } table chain
    --query-chain { ipv4 | ipv6 | eb } table chain
    
    # rules
    --get-all-rules
    --get-rules { ipv4 | ipv6 | eb } table chain
    --add-rule { ipv4 | ipv6 | eb } table chain priority args
    --remove-rule { ipv4 | ipv6 | eb } table chain priority args
    --remove-rules { ipv4 | ipv6 | eb } table chain
    --query-rule { ipv4 | ipv6 | eb } table chain priority args

    # passthrough
    --get-all-passthroughs
    --get-passthroughs { ipv4 | ipv6 | eb }
    --add-passthrough { ipv4 | ipv6 | eb } args
    --remove-passthrough { ipv4 | ipv6 | eb } args
    --query-passthrough { ipv4 | ipv6 | eb } args
    

firewall-cmd --direct
    --passthrough { ipv4 | ipv6 | eb } args
    
    
    
    firewall-cmd --permanent   \
        --direct \
        --add-rule ipv4 \
        nat             \
        POSTROUTING     \
        -o enp0s3 \
        -j MASQUERADE \
        -s 172.17.0.1/16
        
    firewall-cmd --permanent   \
       --direct                \
       --passthrough ipv4      \
       -t nat                  \
       -I POSTROUTING          \
       -o enp0s3               \
       -j MASQUERADE           \
       -s 172.17.0.1/16
```


# Lockdown 相关


```bash
firewall-cmd 
    --lockdown-on
    --lockdown-off
    --query-lockdown
```

# Lockdown Whitelist 相关

白名单中的应用可以修改防火墙设置。



```bash
firewall-cmd [--permanent]
    --list-lockdown-whitelist-commands
    --add-lockdown-whitelist-command=command    
    --remove-lockdown-whitelist-command=command
    --query-lockdown-whitelist-command=command
    --list-lockdown-whitelist-contexts
    --add-lockdown-whitelist-context=context
    --remove-lockdown-whitelist-context=context
    --query-lockdown-whitelist-context=context
    --list-lockdown-whitelist-uids
    --add-lockdown-whitelist-uid=uid
    --remove-lockdown-whitelist-uid=uid
    --query-lockdown-whitelist-uid=uid
    --list-lockdown-whitelist-users
    --add-lockdown-whitelist-user=user
    --remove-lockdown-whitelist-user=user
    --query-lockdown-whitelist-user=user
```

# Panic 相关
```bash
firewall-cmd 
    --panic-on
    --panic-off
    --query-panic
```




## direct 选项

direct 可以提供直接控制防火墙的接口。需要对 iptables 有一些了解。

```bash
firewall-cmd [--permanent] --direct 

    # chain 相关
    --get-all-chains
    --get-chains { ipv4 | ipv6 | eb } table
    --add-chain { ipv4 | ipv6 | eb } table chain
    --remove-chain { ipv4 | ipv6 | eb } table chain
    --query-chain { ipv4 | ipv6 | eb } table chain

    # rule 相关
    --get-all-rules     # 只显示通过 `--direct --add-rule` 添加的 rule
    --get-rules { ipv4 | ipv6 | eb } table chain
    --query-rule { ipv4 | ipv6 | eb } table chain priority args
    --add-rule { ipv4 | ipv6 | eb } table chain priority args
    --remove-rule { ipv4 | ipv6 | eb } table chain priority args
    --remove-rules { ipv4 | ipv6 | eb } table chain
    
    # passthrough 相关
    --get-all-passthroughs
    --query-passthrough { ipv4 | ipv6 | eb } args
    --get-passthroughs { ipv4 | ipv6 | eb }
    --passthrough { ipv4 | ipv6 | eb } args     # 直接传递 iptables、 ip6tables、 ebtables 参数给相应的命令
                                                # 注意：该参数不会记录，因此，也无法使用 firewall-cmd 查询显示。
    --add-passthrough { ipv4 | ipv6 | eb } args
    --remove-passthrough { ipv4 | ipv6 | eb } args

```


# 常用

```bash
firewall-cmd --permanent --direct --get-all-passthroughs

    firewall-cmd --permanent   \
       --direct                \
       --passthrough ipv4      \
       -t nat                  \
       -I POSTROUTING          \
       -o enp0s3               \
       -j MASQUERADE           \
       -s 172.17.0.1/16
       
firewall-cmd --permanent --direct --passthrough ipv4  -I INPUT  -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
```


# 参考
* [firewalld](http://www.firewalld.org/)
* [How To Set Up a Firewall Using FirewallD on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)
* [CentOS 7 firewall](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Using_Firewalls.html)
* [FirewallD](http://fedoraproject.org/wiki/FirewallD)
* [RHEL7: How to get started with Firewalld.](https://www.certdepot.net/rhel7-get-started-firewalld/)

