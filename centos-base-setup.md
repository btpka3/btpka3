# 安装

## 分区
```sh
设备             大小（MB）   挂载点     类型            格式化
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
## 修改环境变量
```bash
root@h01 ~]# vi /etc/profile.d/custom.sh
export XXX=xxx
```
# 确认、修改 kernel 参数 
```bash
# 系统限制
# 确保能每个进程能打开足够多的文件
[root@h01 ~]# sysctl -A | grep fs\.file-max
fs.file-max = 383983
[root@h01 ~]# cat /proc/sys/fs/file-max
797839

# 查看指定进程使用的文件数量
ls -la /proc/<pid>/fd
lsof -p <pid of process>
lsof -p <pid> | wc -l
ulimit -n



# 如果值太小，需要修改，则修改以下文件
[root@h01 ~]# vi /etc/sysctl.conf
fs.file-max = 383983
[root@h01 ~]# sysctl -p

# 用户、进程级别的限制
[root@h01 ~]# vi /etc/security/limits.conf 
```
## Tools
### putty
1. 防止vi时使用小键盘造成乱码：Terminal->Features: 选中 Disable application keypad mode

## Locale && Language
```sh
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
# 格式：内网IP地址 主机名，可防止RMI连接 127.0.0.1出错
000.000.000.000 h01                     
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

7. 检查网络的启动级别和启动状态
```sh
network         0:关闭  1:关闭  2:启用  3:启用  4:启用  5:启用  6:关闭
[root@h01 ~]# service network status
配置设备：
lo em1
当前的活跃设备：
lo em1
```

8. 验证
```sh
[root@h01 ~]# ping -c 4 baidu.com
PING baidu.com (123.125.114.144) 56(84) bytes of data.
64 bytes from 123.125.114.144: icmp_seq=1 ttl=51 time=219 ms
64 bytes from 123.125.114.144: icmp_seq=4 ttl=51 time=223 ms
--- baidu.com ping statistics ---
4 packets transmitted, 2 received, 50% packet loss, time 4000ms
rtt min/avg/max/mdev = 219.364/221.428/223.493/2.117 ms
```
9. 起停命令
```sh
[root@h01 ~]# service network
用法：/etc/init.d/network {start|stop|status|restart|reload|force-reload}
```



## 安装较高版本GLibC
CentOS 6.3 默认自带的GLibC 是2.12版的，但是有的程序是使用2.14版本的。这里是更新GLibC的命令：
```sh
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


## vim
```sh
# 安装
[root@h01 ~]# yum install vim-X11 vim-common vim-enhanced vim-minimal

# 修改环境变量
[root@h01 ~]# vi /etc/profile.d/custom.sh
alias vi=vim

# 修改配置文件
[root@h01 ~]# vi ~/.vimrc
" comment here
set number
colors desert
syntax on
set ruler
set showcmd
set cursorline
set fileencodings=utf-8,gbk
```


# CentOS 基础设定

## 修改主机名，以及对主机名的本地解析
```sh
[root@localhost ~]# vi /etc/sysconfig/network
  HOSTNAME=dev-dubbo2
[root@localhost ~]# vi /etc/hosts
  10.1.10.214 dev-dubbo2
```

## 修改网络配置
暂略，此步骤一般已由网管完成。

## 修改语言
```sh
[root@localhost ~]# vi /etc/sysconfig/i18n
#LANG="zh_CN.UTF-8"
LANG="en_US.UTF-8"
```
## 修改系统变量
### kernel参数： 查看及修改每个进程可以打开的最大文件数

```sh
[root@localhost ~]# sysctl -A  | grep fs\.file-max
fs.file-max = 291212
[root@localhost ~]# cat /proc/sys/fs/file-max
291212
[root@localhost ~]# vi /etc/sysctl.conf
fs.file-max = 383983
```
### 修改用户限制

确认已经启用 pam_limits.so

```sh
[root@localhost ~]# vi /etc/pam.d/login
session required pam_limits.so
```

检查配置是否合理（比如用户最大进程数、可打开的最大文件数）
```sh
[root@localhost ~]# ulimit -a
```

如果值太小，则修改以下文件
```sh
[root@localhost ~]# vi /etc/security/limits.d/xxx.conf
root         soft    nofile         20000
root         hard    nofile         20000
root         soft    nproc          20000
root         hard    nproc          20000

*            soft    nofile         20000
*            hard    nofile         20000
*            soft    nproc          20000
*            hard    nproc          20000
```

FIXME : `/etc/security/limits.conf`

