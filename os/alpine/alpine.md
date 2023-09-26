[apline linux](https://www.alpinelinux.org/) 使用
的是 [OpenRC](https://docs.alpinelinux.org/user-handbook/0.1a/Working/openrc.html)
作为 init service。

# repo
[Repositories](https://wiki.alpinelinux.org/wiki/Repositories)

```shell
echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community/" >> /etc/apk/repositories
echo "@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing/"     >> /etc/apk/repositories
```
# docker

```shell
docker pull docker.io/library/alpine:3.18
docker run --rm -it docker.io/library/alpine:3.18 cat /etc/os-release
```



# 支持 alpine 的包

可自行到 [这里](https://pkgs.alpinelinux.org/packages) 搜索。

arm64已经与aarch64合并，因为aarch64和arm64指的是同一件事。

- busybox
- podman


- jdk : aliababa
  dragonwell : [alibabadragonwell/dragonwell:dragonwell-17.0.3.0.3.7_jdk-17.0.3-ga-alpine](https://hub.docker.com/layers/alibabadragonwell/dragonwell/dragonwell-17.0.3.0.3.7_jdk-17.0.3-ga-alpine/images/sha256-80c216958a8589e59bd769e8ed45b0268577bdb4896ca2c28e1a21f1e4438174?context=explore)
- eclipse-temurin:8-jdk-alpine
    - [eclipse-temurin:8-jdk-alpine](https://hub.docker.com/layers/library/eclipse-temurin/8-jdk-alpine/images/sha256-88faa301308c48dc55f3e94e518827bc22ee6b45d23377c85ad844fc673d9b6c?context=explore)
    - [eclipse-temurin:11-jdk-alpine](https://hub.docker.com/layers/library/eclipse-temurin/11-jdk-alpine/images/sha256-b574575375b043cc24e26907b9a7ad3b51ee42614abcb34a5cc51196948ae5b5?context=explore)
    - [eclipse-temurin:17-jdk-alpine](https://hub.docker.com/layers/library/eclipse-temurin/17-jdk-alpine/images/sha256-4f6f61ededa179586bd6679bb23c448bad317ca352ee253b6359650923e86c9a?context=explore)
    
- maven:
      [maven:3.9.2-eclipse-temurin-11-alpine](https://hub.docker.com/layers/library/maven/3.9.2-eclipse-temurin-11-alpine/images/sha256-76573f73fa5c642bab4b4faad08ee949900e8f98e8dd1195b679326d1fffb521?context=explore)

      ```shell
      podman run -it --rm --name my-maven-project \
           -v "$(pwd)":/data \
           -v "${HOME}/.m2/repository":/usr/share/maven/ref/repository \
           -v "${HOME}/.m2/settings.xml":/usr/share/maven/ref/settings.xml \
           -w /data \
           maven:3.9.2-eclipse-temurin-11-alpine \
           mvn \
               -Dautoconfig.skip=true \
               -Denforcer.skip=true \
               -Dmaven.test.skip \
               clean install \
               -am \
               -pl sar
      ```
    


| package           | x86_64 | aarch64 |
|-------------------|--------|---------|
| busybox           | Y      | Y       |
| podman            | Y      | Y       |
| nginx             | Y      | Y       |
| redis             | Y      | Y       |
| tengine           | -      | -       |
| dragonwell        | -      | -       |
| GraalVM           |        |         |
| mysql             | Y      | Y       |
| mariadb           | Y      | Y       |
| postgresql        | -      | -       |
| mongodb           | -      | -       |
| cloud-init        | Y      | Y       |
| podman            | Y      | Y       |
| aliyun/aliyun-cli | -      | -       |
| ceph-dev          | Y      | Y       |
| s3fs-fuse         | Y      | Y       |

# alpine/busybox

```bash
podman run --rm -it alpine:latest sh

# 检查 alpine 版本
cat /etc/os-release
cat /etc/issue
cat /etc/alpine-release

# 检查 kernel 版本
uname -r
cat /proc/version

# docker run -it --rm --network=customBridge alpine:3.5
# 参考： https://serverfault.com/questions/104125/busybox-how-to-list-process-priority
ps -o pid,ppid,pgid,nice,user,group,tty,vsz,etime,time,comm,args

# 判断bash 是否存在，如不不存在则安装
command -v bash >/dev/null || apk add --no-cache bash


# 添加用户
deluser --remove-home admin
addgroup -g 1100 admin
adduser -u 1100 -G admin -D admin



apk add --no-cache shadow # 提供 usermod 命令
apk add --no-cache openrc # 提供 rc-update 命令


# 参考： https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management#Overview
apk update          # 更新索引到本地
apk search -v xxx   # 搜索指定的 package
apk add xxx         # 下载并安装指定的 package
apk del xxx         # 卸载指定的 package
apk info            # 列出所有已经安装的 package
apk info xxx        # 查看指定 package 的信息
apk info -L xxx     # 查看指定 package 的所有的文件列表
apk info installkernel
apk -v cache clean  # 清楚缓存
apk info --who-owns /etc/ssh/sshd_config
apk info --who-owns /lib/modules/4.14.69-0-vanilla//kernel/net/netfilter/nft_nat.ko


# 常用工具
apk add --no-cache drill       # 替代 nslookup/dig
drill kingsilk.net @223.5.5.5
drill kingsilk.net @127.0.0.11
drill kingsilk.net @8.8.8.8

# 仓库：
cat > /etc/apk/repositories <<EOF
https://dl-cdn.alpinelinux.org/alpine/v3.17/main
https://dl-cdn.alpinelinux.org/alpine/v3.17/community
https://dl-cdn.alpinelinux.org/alpine/edge/testing
EOF


# 启动服务
apk add openrc
touch /run/openrc/softlevel
rc-service --list
rc-status --list
rc-status --servicelist

rc-update add etcd
rc-service etcd status

rc-service hostname start
rc-service networking start
rc-service etcd start
rc-service etcd stop

# TimeZone 时区
apk add alpine-conf
setup-timezone -z Asia/Shanghai
```

## 参考

- [Building a modified kernel for Alpine Linux](https://strfry.org/blog/building-alpine-kernel.html)


# virtual box

see : https://linuxhint.com/install-alpine-linux-virtualbox/
https://wiki.alpinelinux.org/wiki/VirtualBox_shared_folders

How to mount a VirtualBox shared folder when the Guest OS boots
https://gist.github.com/kentwait/ea49b270f4f7480541409c5ded093ec9

How to add and delete Static Routes on macOS (persistently)
https://www.analysisman.com/2020/11/macos-staticroutes.html

```shell
# virtual box 中插入光盘 alpine 的标准版 ISO 后启动
# 输入 `root` 完成登录

# 开始安装，并根据提示进行各种设置，最后 移除ISO，并重启
# 安装建议：键盘布局: us, 启用 openssh, 允许root密码ssh, dhcp 分配网址
setup-alpine

tail -f /etc/apk/repositories
# 默认只开启了main 的repo, 修改该文件，并开启 community repo 
vi /etc/apk/repositories
apk update


apk add virtualbox-guest-additions virtualbox-guest-additions-x11 linux-virt
rc-update add virtualbox-drm-client defroot
poweroff
reboot


# 共享目录
# 在 VirtualBox GUI 上 通过 Settings/Shared Folders 添加要共享目录， 
# 假设 Folder Name = zll ， Folder Path = /Users/zll
# 然后在 alpine 中执行 :
mkdir -p /Users/zll  # 只是简化一下，确保 虚拟机中、host 中的路径都一致
modprobe -a vboxsf 
addgroup admin vboxsf
# 检查 vboxsf 支持的选项
mount.vboxsf
mount.vboxsf -o uid=1000,gid=1000 zll /Users/zll   # `zll` 是 VitualBox GUI 中的 Folder Name。
# 或者使用下面的命令。FIXME: 为何 umask 等选项一旦加上，就变成root用户挂载了？
mount -t vboxsf -o uid=1000,gid=1000 zll /Users/zll
ls -l /Users/zll
umount /Users/zll


# 如果想重启自动挂载，则：
vi /etc/fstab 
zll     /Users/zll  vboxsf  uid=1000,gid=1000   0    0
mount -av

# ssh
ak add openssh
vi /etc/ssh/sshd_config # 确保有以下配置
PermitRootLogin yes
PermitEmptyPasswords yes

# 重启 ssh
/etc/init.d/sshd restart

# 在 VirtualBox GUI 上 通过 Settings/Network, 选择 【Brided Adapter】
# 在 alipine 虚拟机中检查ip地址
ip addr

# 在宿主机中 ssh
ssh root@30.196.224.194

# 查看所有网卡
ifconfig -a
ip link show

# 额外配置一个静态IP，方便SSH
vi /etc/network/interfaces
# 可以在已经有 `iface eth0 inet dhcp` 的基础上给 eth0 再增加一个静态IP
iface eth0 inet static
    address 199.199.199.199
    network 255.255.255.0


/etc/init.d/networking restart
apk add networkmanager-cli


# 临时添加路由
#sudo route -n add -net 192.168.56.0 -netmask 255.255.248.0 192.168.56.1 -ifp vmenet0
sudo route -n add -net 192.168.56.0/21  192.168.56.1 #-ifp vmenet0
netstat -nr

# 持久添加路由
# networksetup -setadditionalroutes <networkservice> [ <dest> <mask> <gateway> ]*
sudo networksetup -setadditionalroutes "USB 10/100/1000 LAN" 192.168.56.0 255.255.248.0 192.168.56.1

# VM 访问 internet
# 方式1： 简单： virtualbox 直接再给 VM 添加一个 nat 模式的 network adapter
# 方式2： TODO： VM 仅仅给配置一个 Host-only Adapter 的情况下，通过 启用ip路由，和SNAT配置。

#sudo route -n add -host 199.199.199.199 -interface en0

192.168.56.1
192.168.56.0/21 

# 启用图形界面
#setup-xorg-base

apk add vim curl sudo doas



######################################################################## podman
# @see 《Setting up Alpine Linux with Podman》
# https://virtualzone.de/posts/alpine-podman/

# 添加用户 admin
adduser admin
# 将用户 admin 添加到 用户组 wheel 中
adduser admin wheel
# 修改配置，允许 wheel 用户组的的成员可以使用 doas
vim /etc/doas.d/doas.conf # 增加以下一行
permit persist :wheel

# 设置 rc_cgroup_mode=unified 以便启用 cgroups v2 
vim /etc/rc.conf
# 启用 cgroups 服务
rc-update add cgroups && rc-service cgroups start

# 检查 /sys/fs/cgroup 的文件系统
stat -f -c %T /sys/fs/cgroup

# 安装 podman
apk add podman

# 允许用户以 rootless 模式使用 podman
modprobe tun
echo tun >>/etc/modules
echo <USER>:100000:65536 >/etc/subuid     # 请替换 <USER> 为你的用户，比如 : admin
echo <USER>:100000:65536 >/etc/subgid     # 请替换 <USER> 为你的用户，比如 : admin

# 启用 iptables 模块
modprobe ip_tables
echo "ip_tables" >> /etc/modules


podman run --rm -it docker.io/alpine:latest echo aaa
#podman run --rm hello-world

# 可选：允许 ports < 1024 
sudo echo "net.ipv4.ip_unprivileged_port_start=80" >> /etc/sysctl.conf

mkdir -p /home/admin/.config/containers/


cp /etc/containers/storage.conf /home/admin/.config/containers/storage.conf

# 修改: 放弃：virtualbox 共享目录 不支持 作为 docker 存储
vi /home/admin/.config/containers/storage.conf
graphroot = "/Users/zll/.local/share/containers/storage"

Error: a network file system with user namespaces is not supported.  Please use a mount_program: backing file system is unsupported for this graph driver
```


# dmidecode