# 参考
- [Fedora CoreOS](https://fedoraproject.org/coreos/)。
- [CoreOS Installer](https://coreos.github.io/coreos-installer/)
- [coreos/mkpasswd-container](https://github.com/coreos/mkpasswd-container)
- [cloud-init](https://cloudinit.readthedocs.io/) :
  注意：[coreos/coreos-cloudinit]()已经废弃，改为使用 Ignition 来替代。
  而 [Fedora Packages](https://packages.fedoraproject.org/pkgs/cloud-init/cloud-init/)是由
  [canonical/cloud-init](https://github.com/canonical/cloud-init) 提供。

* ~~ [coreos](https://coreos.com/os/docs/latest/) ~~ 已经由 Fedora CoreOS 替代
* [virtualbox](https://coreos.com/os/docs/latest/booting-on-virtualbox.html)
* [Installing CoreOS Container Linux to disk](https://coreos.com/os/docs/latest/installing-to-disk.html)
* [CoreOS With Nvidia CUDA GPU Drivers](http://tleyden.github.io/blog/2014/11/04/coreos-with-nvidia-cuda-gpu-drivers/)


# 命令
```shell
# mkpasswd
podman run -ti --rm quay.io/coreos/mkpasswd --method=yescrypt
```

# 安装-virtualbox
[Provisioning Fedora CoreOS on VirtualBox](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-virtualbox/)

```shell
# 准备 Ignition 配置文件
# 手动编写 yaml格式的 `demo.bu` 文件

CONF_DIR=/Users/zll/data0/work/git-repo/github/btpka3/btpka3/os/coreos
DATA_DIR=/Users/zll/data0/store/coreos-installer/data
STREAM="stable"
VM_NAME=my-fcos
IGN_PATH=${CONF_DIR}/demo.ign
alias butane='podman run --interactive --rm quay.io/coreos/butane:release'
alias coreos-installer="podman run --pull=always --privileged --rm \
    -v /dev:/dev -v ${DATA_DIR}:/data -w /data \
    quay.io/coreos/coreos-installer:release"

butane --pretty --strict < ${CONF_DIR}/demo.bu > ${CONF_DIR}/demo.ign
butane --pretty --strict < ${CONF_DIR}/remote.bu > ${CONF_DIR}/remote.ign


mkdir -p ${DATA_DIR}
cd $CONF_DIR
http-server     # npm install --global http-server

# 下载
cd ${DATA_DIR}
coreos-installer download -s "${STREAM}" -p virtualbox -f ova
ll
-rw-r--r--  1 zll  staff   826M May  4 15:26 fedora-coreos-38.20230414.3.0-virtualbox.x86_64.ova
-rw-r--r--  1 zll  staff   566B May  4 15:26 fedora-coreos-38.20230414.3.0-virtualbox.x86_64.ova.sig

# Importing the OVA
VBoxManage import --vsys 0 --vmname "$VM_NAME" ./fedora-coreos-38.20230414.3.0-virtualbox.x86_64.ova

# Setting the Ignition config
VBoxManage guestproperty set "$VM_NAME" /Ignition/Config "$(cat $IGN_PATH)"
# https://www.npmjs.com/package/http-server

# Configuring networking
VBoxManage modifyvm "$VM_NAME" --natpf1 "guestssh,tcp,,2222,,22"

# 默认用户是 core, 而
ssh dangqian.zll@localhost -p 2222

# 在虚拟机中执行以下命令
sudo rpm-ostree install \
  golang-k8s-cri-api-devel \
  golang-k8s-kubelet-devel \
  kubernetes-kubeadm \
  golang-k8s-system-validators-devel \
  golang-k8s-kubectl-devel \
  golang-k8s-cli-runtime-devel
reboot
```




# 安装2（废弃）
## 作为 VirtualBox 虚拟机安装

```bash
brew install gpg
brew install cdrtools

wget https://raw.githubusercontent.com/coreos/scripts/master/contrib/create-coreos-vdi
chmod +x create-coreos-vdi

./create-coreos-vdi -V stable


wget https://raw.github.com/coreos/scripts/master/contrib/create-basic-configdrive
chmod +x create-basic-configdrive

# 当前目录生成 my_vm01.iso，用以配置ssh key
./create-basic-configdrive -H my_vm01 -S ~/.ssh/id_rsa.pub



VBoxManage clonehd coreos_production_1298.7.0.vdi my_vm01.vdi
VBoxManage modifyhd my_vm01.vdi --resize 10240

# 使用 virtualbox 创建 64bit 的linux虚拟机，
# - 使用刚刚创建的vdi虚拟硬盘，
# - 启动时，挂载刚刚创建的 my_vm01.iso 文件（有了该 ISO 会使用我的SSH key 登录）
# - 网络模式设置为 桥接模式，以便能获取到与 宿主机同一个网络的IP地址。
#   启动后，ip地址会在虚拟机的登录窗口显示。

# 使用 ssh key 登录
ssh core@192.168.0.138

# 在 虚拟机内测试使用 docker
docker run -it --rm alpine:3.5 ip addr

```

## 安装到物理机上

1. 先运行 任何一种 Linux 的 LiveCD
1. 运行 [coreos-install 脚本](https://raw.githubusercontent.com/coreos/init/master/bin/coreos-install)

## FIXME

- 硬件驱动如何解决？比如显卡，网卡等?

    需要下载 coreos 源码，驱动的源码，给 kernel 打补丁，验证、编译生成新的 coreos 镜像。


# 记录

[vultr](https://www.vultr.com/) 上记录


## 查看版本

```bash


cat /etc/motd
Container Linux by CoreOS stable (1520.8.0)

cat /etc/os-release
NAME="Container Linux by CoreOS"
ID=coreos
VERSION=1520.8.0
VERSION_ID=1520.8.0
BUILD_ID=2017-10-26-0342
PRETTY_NAME="Container Linux by CoreOS 1520.8.0 (Ladybug)"
ANSI_COLOR="38;5;75"
HOME_URL="https://coreos.com/"
BUG_REPORT_URL="https://issues.coreos.com"
COREOS_BOARD="amd64-usr"

cat /etc/lsb-release
DISTRIB_ID="Container Linux by CoreOS"
DISTRIB_RELEASE=1520.8.0
DISTRIB_CODENAME="Ladybug"
DISTRIB_DESCRIPTION="Container Linux by CoreOS 1520.8.0 (Ladybug)"
```

## 查看分区与挂载

```bash
df -h
Filesystem       Size  Used Avail Use% Mounted on
devtmpfs         481M     0  481M   0% /dev
tmpfs            499M     0  499M   0% /dev/shm
tmpfs            499M  368K  498M   1% /run
tmpfs            499M     0  499M   0% /sys/fs/cgroup
/dev/vda9         22G  229M   21G   2% /
/dev/mapper/usr  985M  665M  269M  72% /usr
none             499M   67M  432M  14% /run/torcx/unpack
tmpfs            499M     0  499M   0% /tmp
/dev/vda1        128M   76M   53M  60% /boot
tmpfs            499M     0  499M   0% /media
/dev/vda6        108M   68K   99M   1% /usr/share/oem
tmpfs            100M     0  100M   0% /run/user/0

fdisk -l
Disk /dev/vda: 25 GiB, 26843545600 bytes, 52428800 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 850C8761-7A74-4DC2-8BDB-CB3FF43AB156

Device       Start      End  Sectors  Size Type
/dev/vda1     4096   266239   262144  128M EFI System
/dev/vda2   266240   270335     4096    2M BIOS boot
/dev/vda3   270336  2367487  2097152    1G unknown
/dev/vda4  2367488  4464639  2097152    1G unknown
/dev/vda6  4464640  4726783   262144  128M Linux filesystem
/dev/vda7  4726784  4857855   131072   64M unknown
/dev/vda9  4857856 52428766 47570911 22.7G unknown

Disk /dev/mapper/usr: 1016 MiB, 1065345024 bytes, 260094 sectors
Units: sectors of 1 * 4096 = 4096 bytes
Sector size (logical/physical): 4096 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes

mount -l
sysfs           on /sys                             type sysfs      (rw,nosuid,nodev,noexec,relatime,seclabel)
proc            on /proc                            type proc       (rw,nosuid,nodev,noexec,relatime)
devtmpfs        on /dev                             type devtmpfs   (rw,nosuid,seclabel,size=492376k,nr_inodes=123094,mode=755)
securityfs      on /sys/kernel/security             type securityfs (rw,nosuid,nodev,noexec,relatime)
tmpfs           on /dev/shm                         type tmpfs      (rw,nosuid,nodev,seclabel)
devpts          on /dev/pts                         type devpts     (rw,nosuid,noexec,relatime,seclabel,gid=5,mode=620,ptmxmode=000)
tmpfs           on /run                             type tmpfs      (rw,nosuid,nodev,seclabel,mode=755)
tmpfs           on /sys/fs/cgroup                   type tmpfs      (ro,nosuid,nodev,noexec,seclabel,mode=755)
cgroup          on /sys/fs/cgroup/systemd           type cgroup     (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
pstore          on /sys/fs/pstore                   type pstore     (rw,nosuid,nodev,noexec,relatime,seclabel)
cgroup          on /sys/fs/cgroup/net_cls,net_prio  type cgroup     (rw,nosuid,nodev,noexec,relatime,net_cls,net_prio)
cgroup          on /sys/fs/cgroup/memory            type cgroup     (rw,nosuid,nodev,noexec,relatime,memory)
cgroup          on /sys/fs/cgroup/freezer           type cgroup     (rw,nosuid,nodev,noexec,relatime,freezer)
cgroup          on /sys/fs/cgroup/blkio             type cgroup     (rw,nosuid,nodev,noexec,relatime,blkio)
cgroup          on /sys/fs/cgroup/perf_event        type cgroup     (rw,nosuid,nodev,noexec,relatime,perf_event)
cgroup          on /sys/fs/cgroup/devices           type cgroup     (rw,nosuid,nodev,noexec,relatime,devices)
cgroup          on /sys/fs/cgroup/cpu,cpuacct       type cgroup     (rw,nosuid,nodev,noexec,relatime,cpu,cpuacct)
cgroup          on /sys/fs/cgroup/cpuset            type cgroup     (rw,nosuid,nodev,noexec,relatime,cpuset)
cgroup          on /sys/fs/cgroup/hugetlb           type cgroup     (rw,nosuid,nodev,noexec,relatime,hugetlb)
cgroup          on /sys/fs/cgroup/pids              type cgroup     (rw,nosuid,nodev,noexec,relatime,pids)
/dev/vda9       on /                                type ext4       (rw,relatime,seclabel,data=ordered) [ROOT]
/dev/mapper/usr on /usr                             type ext4       (ro,relatime,seclabel,block_validity,delalloc,barrier,user_xattr,acl)
selinuxfs       on /sys/fs/selinux                  type selinuxfs  (rw,relatime)
none            on /run/torcx/unpack                type tmpfs      (ro,relatime,seclabel)
hugetlbfs       on /dev/hugepages                   type hugetlbfs  (rw,relatime,seclabel,pagesize=2M)
tmpfs           on /tmp                             type tmpfs      (rw,nosuid,nodev,seclabel)
systemd-1       on /boot                            type autofs     (rw,relatime,fd=29,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11674)
tmpfs           on /media                           type tmpfs      (rw,nosuid,nodev,noexec,relatime,seclabel)
systemd-1       on /proc/sys/fs/binfmt_misc         type autofs     (rw,relatime,fd=31,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=11713)
mqueue          on /dev/mqueue                      type mqueue     (rw,relatime,seclabel)
debugfs         on /sys/kernel/debug                type debugfs    (rw,relatime,seclabel)
/dev/vda6       on /usr/share/oem                   type ext4       (rw,nodev,relatime,seclabel,commit=600,data=ordered) [OEM]
/dev/vda1       on /boot                            type vfat       (rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,errors=remount-ro) [EFI-SYSTEM]
tmpfs           on /run/user/0                      type tmpfs      (rw,nosuid,nodev,relatime,seclabel,size=102020k,mode=700)
```

## 检查网络

```bash
ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 56:00:01:43:94:22 brd ff:ff:ff:ff:ff:ff
    inet 45.76.198.144/23 brd 45.76.199.255 scope global dynamic eth0
       valid_lft 48731sec preferred_lft 48731sec
    inet6 2001:19f0:7001:d13:5400:1ff:fe43:9422/64 scope global mngtmpaddr noprefixroute dynamic
       valid_lft 2591956sec preferred_lft 604756sec
    inet6 fe80::5400:1ff:fe43:9422/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 5a:01:01:43:94:22 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::5801:1ff:fe43:9422/64 scope link
       valid_lft forever preferred_lft forever
```


## 升级

```bash
cat /etc/coreos/update.conf
GROUP=stable
#REBOOT_STRATEGY=best-effort
#SERVER=https://example.update.core-os.net

# 如果修改了该文件，则需要 到每个节点上一一修改，并：
systemctl restart update-engine


update_engine_client -status
update_engine_client -check_for_update
# 手动触发升级
update_engine_client -update
```

# cloud-config
- [深入浅出CoreOS（二）：Cloud-Config和etcd ](http://www.dockone.io/article/1036)
- [Config Validator](https://coreos.com/validate/)
- [Using Cloud-Config](https://coreos.com/os/docs/latest/cloud-config.html)

cloud-config 会在 CoreOS 每次重启时执行。
