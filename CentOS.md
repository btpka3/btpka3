## IP Config
1.  检查DNS服务器
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

2.  检查是否启用网络和主机名 
```sh
[root@h01 ~]# cat /etc/sysconfig/network
NETWORKING=yes
HOSTNAME=h01
```

3.  设置IP地址
    * 静态IP

        ```sh
[root@h01 ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"                               # 设备名称
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

        ```sh
[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE="eth0"
BOOTPROTO="dhcp"
HWADDR="08:00:27:6E:BB:7E"
NM_CONTROLLED="no"
ONBOOT="yes"
TYPE="Ethernet"
UUID="6521ca0a-bb80-4c78-8683-1e9bf23d0d52"
DNS1=8.8.8.8
        ```

4.  修改对主机名的本地DNS解析
    ```sh
[root@h01 ~]# vi /etc/hosts             # 追加以下一行
000.000.000.000 h01                     # 内网IP地址 主机名
    ```
5.  检查网络的启动级别和启动状态
```sh
[root@h01 ~]# chkconfig --list network
network         0:off   1:off   2:on    3:on    4:on    5:on    6:off
[root@h01~]# service network status
Configured devices:
lo eth0
Currently active devices:
lo eth0

```
6.  使用代理（若无请跳过） 

    [参考](http://www.cyberciti.biz/faq/linux-unix-set-proxy-environment-variable/ "How To Use Proxy Server To Access Internet at Shell Prompt With http_proxy Variable")
    ```sh
[root@h01 ~]# vi /etc/profile.d/custom.sh
# ...
 export http_proxy=http://10.1.18.123:808/
    ```

## 常用命令
### 查看Linux 版本
```sh
[root@localhost ~]# cat /etc/issue            # 安装时的默认发行版本信息，不会再发生改变
CentOS release 6.3 (Final)
Kernel \r on an \m

[root@localhost ~]# cat /etc/redhat-release   # 安装时的默认发行版本信息，不会再发生改变
CentOS release 6.3 (Final)

[root@localhost ~]# cat /proc/version
Linux version 2.6.32-279.el6.x86_64 (mockbuild@c6b9.bsys.dev.centos.org) (gcc version 4.4.6 20120305 (Red Hat 4.4.6-4) (GCC) ) #1 SMP Fri Jun 22 12:19:21 UTC 2012
[root@localhost ~]# uname -a
Linux localhost.localdomain 2.6.32-279.el6.x86_64 #1 SMP Fri Jun 22 12:19:21 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux

```

