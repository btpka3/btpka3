 

常用命令：
iptables, ip6tables

`firewalld` 不会从 `/etc/sysconfig/ip*tables` 读取配置文件。
想加载 `lokkit`、 `system-config-firewall` 设定文件，请使用
`firewall-offline-cmd` 命令和 `/etc/sysconfig/system-config-firewall` 文件。


```txt
system-config-firewall(GUI)  -> iptables(service)           -> iptables(command)  -> kernel(netfilter)
firwall-config(GUI)          -> firewalld(daemon & service) -> iptables(command)  -> kernel(netfilter)
firwall-cmd                  -> firewalld(daemon & service) -> iptables(command)  -> kernel(netfilter)
```

# 在内核空间的几个切入点
1. 内核空间中：从一个网络接口进来，到另一个网络接口去的
1. 数据包从内核流入用户空间的
1. 数据包从用户空间流出的
1. 进入/离开本机的外网接口
1. 进入/离开本机的内网接口

这五个位置也被称为五个钩子函数（hook functions）,也叫五个规则链。
1. PREROUTING (路由前)
1. INPUT (数据包流入口)
1. FORWARD (转发管卡)
1. OUTPUT(数据包出口)
1. POSTROUTING（路由后）


|       |PREROUTING |INPUT  |FORWARD|OUTPUT |POSTROUTING|
|-------|-----------|-------|-------|-------|-----------|
|filter |           | Y     | Y     | Y     |           |
|nat    | Y         |       |       | Y     | Y         |
|mangle | Y         | Y     | Y     | Y     | Y         |


```bahs
iptables [-t table] COMMAND chain CRETIRIA -j ACTION

# 查看定义规则的详细信息
iptables -L -n -v	

# 拒绝来自 172.16.0.0/24 的请求 
iptables -t filter -A INPUT -s 172.16.0.0/16 -p udp --dport 53 -j DROP
```
# COMMAND

* `-P`

# 通用匹配

|               |`-p tcp` |`-p udp` |`-p icmp`|memo|
|---------------|---------|---------|---------|---|
|`-s`       | Y       | Y       |         |指定目标端口|
|`-d`       | Y       | Y       |         |指定源端口|
|`-p`       | Y       |         |         |检查tcp的标志位：要坚持的、 必须为1的。比如 `--tcpflags syn,ack,fin,rst syn`|
|`-i eth0`  |         |         | Y       |echo-request : 请求回显(一般用8 来表示)，echo-reply: 响应的数据包(一般用0来表示) |
|`-o eth0`  |         |         | Y       |echo-request : 请求回显(一般用8 来表示)，echo-reply: 响应的数据包(一般用0来表示) |




# 扩展协议

|               |`-p tcp` |`-p udp` |`-p icmp`|memo|
|---------------|---------|---------|---------|---|
|`--dport 21-23`| Y       | Y       |         |指定目标端口|
|`--sport 80`   | Y       | Y       |         |指定源端口|
|`--tcp-flags`  | Y       |         |         |检查tcp的标志位：要坚持的、 必须为1的。比如 `--tcpflags syn,ack,fin,rst syn`|
|`--icmp-type`  |         |         | Y       |echo-request : 请求回显(一般用8 来表示)，echo-reply: 响应的数据包(一般用0来表示) |

# 参考

* [How To Set Up a Firewall Using FirewallD on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)
* [CentOS 7 firewall](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Security_Guide/sec-Using_Firewalls.html)


