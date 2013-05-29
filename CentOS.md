## IP Config
1. 检查DNS服务器
```sh
[root@h01 ~]# cat /etc/resolv.conf
# No nameservers found; try putting DNS servers into your
# ifcfg files in /etc/sysconfig/network-scripts like so:
#
# DNS1=xxx.xxx.xxx.xxx
# DNS2=xxx.xxx.xxx.xxx
# DOMAIN=lab.foo.com bar.foo.com
# nameserver xxx.xxx.xxx.xxx
nameserver 8.8.8.8
nameserver 8.8.4.4
```

2. 检查是否启用网络和主机名 
```sh
[root@h01 ~]# cat /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=h01
```

3. 设置IP地址
    * 静态IP

        注意：网卡的名称可能会变，一般是 eth0，但是这里是 em1
        ```sh
[root@h01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-em1
DEVICE="em1"                                # 设备名称
NM_CONTROLLED="no"                          # ? 若为yes，会报错
ONBOOT=yes                                  # 是否启动时就启用
TYPE=Ethernet                               # 网卡类型
BOOTPROTO=none                              # 分配IP地址的协议，这里是静态
IPADDR=000.000.000.000                      # 该网卡的IP地址
PREFIX=24                                   # 网络/子网掩码长度
GATEWAY=000.000.000.000                     # 网关
DNS1=000.000.000.000                        # 第一个DNS服务器的IP地址
DEFROUTE=yes                                # 将此设为默认路由
IPV4_FAILURE_FATAL=yes
IPV6INIT=no                                 # 不使用 IPv6
NAME="System em1"                           # 该配置的名称
UUID=1dad842d-1912-ef5a-a43a-bc238fb267e7   # 
HWADDR=BC:30:5B:E9:7F:D8                    # 硬件IP地址
USERCTL=no                                  # 非root用户不能修改配置
        ```
    * 动态IP
4. 修改对主机名的本地DNS解析
    ```sh
[root@h01 ~]# vi /etc/hosts             # 追加以下一行
000.000.000.000 h01                     # 内网IP地址 主机名
    ```
