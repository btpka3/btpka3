# 安装



## 分区

```bash
            大小（MB）   挂载点     类型            格式化
LVM 卷组
  Vg_h01        476436
    Lv_root      51200      /          ext4            yes
    Lv_home     419236      /home      ext4            yes
    Lv_swap        6000                swap            yes
硬盘驱动器
  Sda
    Sda1            500     /boot      ext4            yes
    Sda2         476439     vg_h01     物理卷组LVM      yes
```



## 7788

```
yum install net-tools               # centos 7 最小化安装找不到 ifconfig 命令
yum install openssh-clients
yum install wget
yum install man
yum install telnet                  # Ctrl+] 之后，quit 可以结束telnet
yum install unzip
yum install gcc
yum groupinstall "Development Tools"
yum install mlocate                 # updatedb，locate 命令
yum install lsof                    # lsof 命令
yum install psmisc                  # pstree 命令

# 防止 /etc/resolv.conf 被覆盖，就禁用  NetworkManager
systemctl disable NetworkManager
systemctl stop NetworkManager
# systemctl enable NetworkManager-wait-online.service
```

## 修改主机名

```
hostname                           # 查看 hostname
hostname xxx.xxx.xxx               # 临时修改 hostname

vi /etc/hostname                   # 持久修改hostname，重启才生效
xxx.xxx.xxx

# ??? /etc/sysconfig/network

nmtui                              # 设置主机名
```


## 修改环境变量

```bash
root@h01 ~]# vi /etc/profile.d/custom.sh
export EDITOR=vim
export XXX=xxx
export VISUAL=vim                 # crontab -e 使用的编辑器

#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8
```



# EPEL

```bash
# for centos 7
rpm -ivh http://mirrors.zju.edu.cn/epel/7/x86_64/e/epel-release-7-5.noarch.rpm

# for centos 6
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
#rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# for centos 5
rpm -ivh http://dl.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
#rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-5.rpm

```

## Tools
### putty
1. 防止vi时使用小键盘造成乱码：Terminal->Features: 选中 Disable application keypad mode

## Locale && Language
```bash
locale # show current settings
# LC_COLLATE : 定义该环境的排序和比较规则
# LC_CTYPE : 用于字符分类和字符串处理(单字节？多字节？字符编码？)
# LC_MONETARY : 货币格式
# LC_NUMERIC : 非货币的数字显示格式
# LC_TIME : 时间和日期格式
# LC_MESSAGES : 提示信息的语言
# LANG : LC_* 的默认设置
# LC_ALL : 设置该值，相当于设置LC_*的值为指定值

export LANG=en_US.UTF-8  # 临时修改环境
vi /etc/sysconfig/i18n   # 永久修改环境
# 英文版系统：
#LANG="en_US.UTF-8"
#SYSFONT="latarcyrheb-sun16"
# 中文版系统：
#LANG="zh_CN.UTF-8"
#SYSFONT="latarcyrheb-sun16"
```

## IP Config

1.  检查DNS服务器 : `cat /etc/resolv.conf`

    ```bash
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

1.  检查是否启用网络和主机名 `cat /etc/sysconfig/network` :

    ```bash
    NETWORKING=yes
    HOSTNAME=h01
    ```



1. centos 7 通过命令修改 IP 地址

    ```
    ip addr                              # 查看IP地址
    ip link                              # 查看网络连接
    dhclient -v -r eth0                  # 释放DHCP获取的IP地址，重新获取

    yum install NetworkManager-tui
    nmtui edit enp0s3
    systemctl restart network.service
    ```

1.  通过 修改文件 设置IP地址

    1. centos 6 : 静态IP `vi /etc/sysconfig/network-scripts/ifcfg-eth0` :

        ```bash
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

    1. centos 7 静态IP `vi /etc/sysconfig/network-scripts/ifcfg-eth0`  。 多IP地址配置请参考 [这里](http://netidy.com/blog/add-multiple-ips-network-adapter-centos-7)


        ```
        HWADDR="AA:BB:CC:DD:EE:FF"
        TYPE="Ethernet"
        BOOTPROTO="static"
        DEFROUTE="yes"
        PEERDNS="yes"
        PEERROUTES="yes"
        IPV4_FAILURE_FATAL="no"
        IPV6INIT="yes"
        IPV6_AUTOCONF="yes"
        IPV6_DEFROUTE="yes"
        IPV6_PEERDNS="yes"
        IPV6_PEERROUTES="yes"
        IPV6_FAILURE_FATAL="no"
        NAME="enp2s0"
        UUID="4f8451cc-8bcd-4318-8411-da1dcb753a15"
        ONBOOT="yes"

        IPADDR=192.168.0.101     # 多个IP地址的话，可以配置 IPADDR0=xxx.xxx.xxx.xxx, 另起一行：IPADDR1=yyy.yyy.yyy.yyy
        GATEWAY=192.168.0.1
        NETMASK=255.255.0.0
        DNS1=192.168.7.1
        ```

    1. centos 6 动态IP `cat /etc/sysconfig/network-scripts/ifcfg-eth0`

        ```bash
        DEVICE="eth0"
        BOOTPROTO="dhcp"
        HWADDR="08:00:27:6E:BB:7E"
        NM_CONTROLLED="no"
        ONBOOT="yes"
        TYPE="Ethernet"
        UUID="6521ca0a-bb80-4c78-8683-1e9bf23d0d52"
        DNS1=8.8.8.8
        ```

    1. centos 7 动态IP

        ```
        HWADDR="AA:BB:CC:DD:EE:FF"
        TYPE="Ethernet"
        BOOTPROTO="dhcp"
        DEFROUTE="yes"
        PEERDNS="yes"
        PEERROUTES="yes"
        IPV4_FAILURE_FATAL="no"
        IPV6INIT="yes"
        IPV6_AUTOCONF="yes"
        IPV6_DEFROUTE="yes"
        IPV6_PEERDNS="yes"
        IPV6_PEERROUTES="yes"
        IPV6_FAILURE_FATAL="no"
        NAME="enp2s0"
        UUID="4f8451cc-8bcd-4318-8411-da1dcb753a15"
        ONBOOT="yes"
        ```

1.  修改对主机名的本地DNS解析 `vi /etc/hosts`

    ```bash
    # 追加以下一行
    # 格式：内网IP地址 主机名，可防止RMI连接 127.0.0.1出错
    000.000.000.000 h01
    ```

1.  检查网络的启动级别和启动状态

    ```bash
    [root@h01 ~]# chkconfig --list network
    network         0:off   1:off   2:on    3:on    4:on    5:on    6:off

    [root@h01~]# service network status
    Configured devices:
    lo eth0
    Currently active devices:
    lo eth0
    ```

1.  使用代理（若无请跳过）




    [参考](http://www.cyberciti.biz/faq/linux-unix-set-proxy-environment-variable/ "How To Use Proxy Server To Access Internet at Shell Prompt With http_proxy Variable")

    ```bash
    [root@h01 ~]# vi /etc/profile.d/custom.sh
    export http_proxy=http://10.1.18.123:808/
    export http_proxy=socks5://prod11.kingsilk.net:9999
    ```

1. 检查网络的启动级别和启动状态

    ```bash
    network         0:关闭  1:关闭  2:启用  3:启用  4:启用  5:启用  6:关闭
    [root@h01 ~]# service network status
    配置设备：
    lo em1
    当前的活跃设备：
    lo em1
    ```

1. 验证

    ```bash
    [root@h01 ~]# ping -c 4 baidu.com
    PING baidu.com (123.125.114.144) 56(84) bytes of data.
    64 bytes from 123.125.114.144: icmp_seq=1 ttl=51 time=219 ms
    64 bytes from 123.125.114.144: icmp_seq=4 ttl=51 time=223 ms
    --- baidu.com ping statistics ---
    4 packets transmitted, 2 received, 50% packet loss, time 4000ms
    rtt min/avg/max/mdev = 219.364/221.428/223.493/2.117 ms
    ```

1. 起停命令

    ```bash
    service network
    用法：/etc/init.d/network {start|stop|status|restart|reload|force-reload}

    systemctl status NetworkManager.service
    nmcli dev status
    ```

## 安装较高版本GLibC
CentOS 6.3 默认自带的GLibC 是2.12版的，但是有的程序是使用2.14版本的。这里是更新GLibC的命令：

```bash
cd ~
mkdir glibc-tmp
cd glibc-tmp
wget http://ftp.gnu.org/gnu/glibc/glibc-2.17.tar.xz
tar xvJf glibc-2.17.tar.xz
./glibc-2.17/configure -disable-sanity-checks
make
make install
```

## 常用命令
### 查看Linux 版本
```bash
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


# CentOS 基础设定

## 修改主机名，以及对主机名的本地解析
```bash
[root@localhost ~]# vi /etc/sysconfig/network
  HOSTNAME=dev-dubbo2
[root@localhost ~]# vi /etc/hosts
  10.1.10.214 dev-dubbo2
```

## 修改网络配置
暂略，此步骤一般已由网管完成。

## 修改语言
```bash
[root@localhost ~]# vi /etc/sysconfig/i18n
#LANG="zh_CN.UTF-8"
LANG="en_US.UTF-8"
```



# 防火墙
如果是本地局域网，可以考虑将防火墙关闭

```bash
sestatus             # 查看selinux
getenforce          # 查看selinux
setenforce 0       # 临时关闭 selinux
vi /etc/selinux/config   # SELINUX=enforcing  -> disabled : 关闭

service iptables stop
service ip6tables stop

chkconfig --level 2345 iptables off
chkconfig --level 2345 ip6tables off

chkconfig --list iptables
chkconfig --list ip6tables

# for centos 7
systemctl disable firewalld
systemctl stop firewalld
systemctl status firewalld
```

# 禁用 IPv6

```
# 临时 1
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1


# 临时2
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6

# 持久 vi /etc/sysctl.conf
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
```
