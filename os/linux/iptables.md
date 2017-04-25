 


# 简介

`iptables`，`ip6tables`是一个管理 pacakge 过滤和 NAT 的工具。
用以建立、维护、检查 Linux Kernel 中 IPv4 和 IPv6 包过滤规则。

其配置文件为 "/etc/sysconfig/iptables"

* table

    Linux Kernel 中定义的的表。可包含多个 chain （预定义的、或自定义的）
    
    
    |table      |PREROUTING |INPUT  |FORWARD|OUTPUT |POSTROUTING| memo|
    |-----------|-----------|-------|-------|-------|-----------|----|
    |filter     |           | Y     | Y     | Y     |           ||
    |nat        | Y         |       |       | Y     | Y         ||
    |mangle     | Y         | Y     | Y     | Y     | Y         ||
    |raw        | Y         |       |       | Y     |           ||
    |security   |           | Y     | Y     | Y     |           ||
    
    * filter
    
        默认 table。即如果没有通过 `-t` 明确指定，则使用该 table。
        
    * nat
        
        当新建 connection 时会咨询该表。
        
    * mangle
    
        在 kernel 2.4.17 以及之前版本，该表只包含 PREROUTING、OUTPUT 这两个 chain。
    
    * raw
        
        该表主要配合 NOTRACK target 处理不进行跟踪的 connection。
        
    * security
    
        该表主要用于 Mandatory Access Control (MAC) 规则，比如 `SECMARK`，`CONNSECMARK` target
        MAC 又 Linux Security 模块实现（比如 SELinux）。该 `security` 在 `filter` 之后调用。
        允许在 filter 表中先启用任意的 Discretionary Access Control (DAC)，之后再启用 MAC 规则。
          
    
* chain 
    预定义的 chain 有 : `PREROUTING`、 `INPUT`、 `FORWARD`、 `OUTPUT`、 `POSTROUTING` 等
    
    
可以定义多个表，每个表中可以包含预定义的 chain 和用户自定义的 chain。
每个 chain 包含多个 rule (规则)。
每个 rule 指定了要对匹配的 package 进行如何处理。该处理称之为 'target'，
也可以跳转到同一个 table 中的其他 chain 进行处理。




* rule
    rule 用来描述匹配哪些 package，并进行哪些处理（target）

    chain 中的 rule 是按顺序进行处理的，找到匹配的 rule，
    就会按照该 rule 的 target 所指定的 下一个 rule 进行处理。

* target
   可以是 用户自定义 chain 的名称，
   可以是 `iptables-extensions` 中定义的 target。
   也可以是 `ACCEPT`, `DROP` 或 `RETURN` 这几个特殊值。

```bash
# man iptables
iptables --list [chain] --line-numbers      # 列出给定（或所有） chain 的规则详情（按 chain 分组显示）
iptables --list-rules [chain]               # 列出给定（或所有） chain 的规则详情（不分组）


iptables --apend chain rule-specification   # 在 chain 最开始加入指定规则
iptables --check chain rule-specification   # 检查给定 chain 是否匹配给定的规则
iptables --delete chain rule-specification  # 删除规则
iptables --delete chain rulenum             # 删除规则。rulenum 从 1 开始
iptables --insert chain [rulenum] rule-specification    # 插入规则
iptables --replace chain rulenum rule-specification     # 更新规则


iptables --flush [chain]                    # 清空给定（或全部） chain 中的 rule
iptables --zero [[chain [rulenum]]          # 清空给定（或全部） chain 、rule 的 package 或 byte 的计数器。
iptables --new-chain chain                  # 新增 chain
iptables --delete-chain chain               # 删除 chain
iptables --delete-chain [chain]             # 删除给定自定义（或全部） chain，前提该 chain 必须未被使用，且为空。
iptables --policy chain target              # 设置 policy。chain 必须是內建的，target 不能是內建或自定义的 chain
iptables --rename-chain old-chain new-chain # 重命名 chain


# 定义 rule 可使用参数

-4, --ipv4                  # IPv4
-6, --ipv6                  # IPv6

[!] -p, --protocol protocol # 指定协议，不是某协议。
                            # 协议名可以是 tcp, udp, udplite, icmp, icmpv6, esp, ah, sctp, mh, all
                            # 也可是数值型的协议号，具体可参考 /etc/protocols

[!] -s, --source address[/mask][,...] 
                            # 指定来源地址
                            # address可以是网络名，主机名，或者网络ip地址（需要指定 /mask)、或普通IP地址
                            
[!] -d, --destination address[/mask][,...]
                            # 指定目标地址

-m, --match match           # 启用一个 match

-j, --jump target           # 指定下一个处理动作

-g, --goto chain            # 使用一个自定义 chain 继续进行处理。
                            # 与 --jump 的区别是，当 --goto 的chain处理完毕后，还会回到该 chain 继续处理。（像方法调用）

[!] -i, --in-interface name     # 指定数据来源网卡接口
                                # 适用于进入 INPUT、 FORWARD、 PREROUTING 的数据

[!] -o, --out-interface name    # 指定数据目标网卡接口
                                # 适用于要进入 FORWARD、 OUTPUT、 POSTROUTING 的数据
    
[!] -f, --fragment          # 指明该规则仅仅匹配第二个及以后 IPv4 fragments of fragmented packets。

-c, --set-counters packets bytes    # 初始化规则匹配 package、byte 的计数器

# man iptables-extensions
```




 




```bahs
iptables [-t table] COMMAND chain CRETIRIA -j ACTION

# 查看定义规则的详细信息
iptables -L -n -v

# 拒绝来自 172.16.0.0/24 的请求 
iptables -t filter -A INPUT -s 172.16.0.0/16 -p udp --dport 53 -j DROP
```
# COMMAND




## 链管理命令

| `-P` |


* `-P`

# 通用匹配

|           |`-p tcp` |`-p udp` |`-p icmp`|memo|
|-----------|---------|---------|---------|---|
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

* `man iptables`
* `man iptables-extensions`
* [netfilter](http://netfilter.org/)
* [ iptables DNAT 与 SNAT 详解 ](http://jafy00.blog.51cto.com/2594646/651856)