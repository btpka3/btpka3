# 参考
- [Fedora CoreOS](https://fedoraproject.org/coreos/)。
- [CoreOS Installer](https://coreos.github.io/coreos-installer/)
- [coreos/mkpasswd-container](https://github.com/coreos/mkpasswd-container)
- [cloud-init](https://cloudinit.readthedocs.io/) :
  注意：[coreos/coreos-cloudinit](https://github.com/coreos/coreos-cloudinit) 已经废弃，
  改为[canonical/cloud-init](https://github.com/canonical/cloud-init) 提供。
  而 [Fedora Packages](https://packages.fedoraproject.org/pkgs/cloud-init/cloud-init/)是由
    
- 安装[kuboard](https://kuboard.cn/install/install-k8s-dashboard.html#%E5%AE%89%E8%A3%85)  

* packages repo: [packages.fedoraproject.org](https://packages.fedoraproject.org/)
   - [cloud-init](https://packages.fedoraproject.org/pkgs/cloud-init/cloud-init/) 提供 cloud-init 命令
   - [moby-engine](https://packages.fedoraproject.org/pkgs/moby-engine/moby-engine/) 提供开源版本的 docker 命令
      注意：docker官网的安装命令 [Install Docker Engine](https://docs.docker.com/engine/install/)  
- [containerd](https://github.com/containerd/containerd) 开源版本的 container runtime
    - [getting-started.md](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)
    - [https://containerd.io/](https://containerd.io/)
    - 配置文件：`/etc/containerd/config.toml`
- [cri-dockerd](https://github.com/Mirantis/cri-dockerd) 安装 docker ce 时需要。
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
#alias butane='docker run --interactive --rm quay.io/coreos/butane:release'
#alias coreos-installer="podman run --pull=always --privileged --rm \
#    -v /dev:/dev -v ${DATA_DIR}:/data -w /data \
#    quay.io/coreos/coreos-installer:release"

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

# 默认用户是 core
ssh dangqian.zll@xxx.xxx.xxx.xxx -p 2222

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


# 自动更新的例子


```shell
# 登录后发现有广播提示，提示操作系统有更新，需要登录的shell都退出以便继续。
-> % ssh dangqian.zll@192.168.56.3
Fedora CoreOS 38.20230430.3.1
Tracker: https://github.com/coreos/fedora-coreos-tracker
Discuss: https://discussion.fedoraproject.org/tag/coreos

Last login: Fri Jul 21 12:48:52 2023 from 192.168.56.1
[dangqian.zll@localhost ~]$ 
Broadcast message from Zincati at Fri 2023-07-21 14:42:37 UTC:
New update 38.20230625.3.0 is available and has been deployed.
If permitted by the update strategy, Zincati will reboot into this update when
all interactive users have logged out, or in 10 minutes, whichever comes
earlier. Please log out of all active sessions in order to let the auto-update
process continue.

# 检查当前的操作系统版本
[dangqian.zll@localhost ~]$ cat /etc/os-release
NAME="Fedora Linux"
VERSION="38.20230430.3.1 (CoreOS)"
ID=fedora
VERSION_ID=38
VERSION_CODENAME=""
PLATFORM_ID="platform:f38"
PRETTY_NAME="Fedora CoreOS 38.20230430.3.1"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:38"
HOME_URL="https://getfedora.org/coreos/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora-coreos/"
SUPPORT_URL="https://github.com/coreos/fedora-coreos-tracker/"
BUG_REPORT_URL="https://github.com/coreos/fedora-coreos-tracker/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=38
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=38
SUPPORT_END=2024-05-14
VARIANT="CoreOS"
VARIANT_ID=coreos
OSTREE_VERSION='38.20230430.3.1'

# 检查当前rmp-ostree 的状态
[dangqian.zll@localhost yum.repos.d]$ rpm-ostree status
State: busy
AutomaticUpdatesDriver: Zincati
  DriverState: active; found update on remote: 38.20230625.3.0
Transaction: deploy --lock-finalization --skip-branch-check revision=e841d77aadb875bb801ac845a0d9b8a70b4224bdeb15e7d6c5bff1da932c0301 --disallow-downgrade 
  Initiator: caller :1.29
Deployments:
● fedora:fedora/x86_64/coreos/stable
                  Version: 38.20230430.3.1 (2023-05-15T21:32:02Z)
               BaseCommit: e7109bec01fdc47125e43fca01b9817d2371557a019bbcfc6a45527c93a23f98
             GPGSignature: Valid signature by 6A51BBABBA3D5467B6171221809A8D7CEB10B464
          LayeredPackages: cloud-init vim

  fedora:fedora/x86_64/coreos/stable
                  Version: 38.20230414.3.0 (2023-05-01T21:23:54Z)
               BaseCommit: 8453aa86d93a2eefc9ef948ad1c8d40f8603f4d37f202e4624df2a9fb2beb12b
             GPGSignature: Valid signature by 6A51BBABBA3D5467B6171221809A8D7CEB10B464
          LayeredPackages: cloud-init vim

# 退出ssh，以便其自动重启并安装更新

# 重启后重新 ssh：
# 重新检查 操作系统版本
[dangqian.zll@localhost ~]$ cat /etc/os-release
NAME="Fedora Linux"
VERSION="38.20230625.3.0 (CoreOS)"
ID=fedora
VERSION_ID=38
VERSION_CODENAME=""
PLATFORM_ID="platform:f38"
PRETTY_NAME="Fedora CoreOS 38.20230625.3.0"
ANSI_COLOR="0;38;2;60;110;180"
LOGO=fedora-logo-icon
CPE_NAME="cpe:/o:fedoraproject:fedora:38"
HOME_URL="https://getfedora.org/coreos/"
DOCUMENTATION_URL="https://docs.fedoraproject.org/en-US/fedora-coreos/"
SUPPORT_URL="https://github.com/coreos/fedora-coreos-tracker/"
BUG_REPORT_URL="https://github.com/coreos/fedora-coreos-tracker/"
REDHAT_BUGZILLA_PRODUCT="Fedora"
REDHAT_BUGZILLA_PRODUCT_VERSION=38
REDHAT_SUPPORT_PRODUCT="Fedora"
REDHAT_SUPPORT_PRODUCT_VERSION=38
SUPPORT_END=2024-05-14
VARIANT="CoreOS"
VARIANT_ID=coreos
OSTREE_VERSION='38.20230625.3.0'
# 重新检查 rpm-ostree 最新状态

[dangqian.zll@localhost ~]$ rpm-ostree status
State: idle
AutomaticUpdatesDriver: Zincati
  DriverState: active; periodically polling for updates (last checked Tue 2023-07-25 02:12:04 UTC)
Deployments:
● fedora:fedora/x86_64/coreos/stable
                  Version: 38.20230625.3.0 (2023-07-11T11:57:53Z)
               BaseCommit: e841d77aadb875bb801ac845a0d9b8a70b4224bdeb15e7d6c5bff1da932c0301
             GPGSignature: Valid signature by 6A51BBABBA3D5467B6171221809A8D7CEB10B464
          LayeredPackages: cloud-init vim

  fedora:fedora/x86_64/coreos/stable
                  Version: 38.20230430.3.1 (2023-05-15T21:32:02Z)
               BaseCommit: e7109bec01fdc47125e43fca01b9817d2371557a019bbcfc6a45527c93a23f98
             GPGSignature: Valid signature by 6A51BBABBA3D5467B6171221809A8D7CEB10B464
          LayeredPackages: cloud-init vim
```

# 是否还能使用 dnf ？
不能。因为相关文件系统是ReadOnly FileSystem

```plain

[dangqian.zll@localhost ~]$ sudo dnf install kubelet
Fedora 38 - x86_64                                                                                                                                                                                                    5.4 MB/s |  83 MB     00:15    
Fedora 38 openh264 (From Cisco) - x86_64                                                                                                                                                                              410  B/s | 2.5 kB     00:06    
Fedora Modular 38 - x86_64                                                                                                                                                                                            1.0 MB/s | 2.8 MB     00:02    
Fedora 38 - x86_64 - Updates                                                                                                                                                                                          2.6 MB/s |  29 MB     00:11    
Fedora Modular 38 - x86_64 - Updates                                                                                                                                                                                  673 kB/s | 2.1 MB     00:03    
Kubernetes                                                                                                                                                                                                             66 kB/s | 177 kB     00:02    
Fedora 38 - x86_64 - Updates Archive                                                                                                                                                                                  890 kB/s |  45 MB     00:51    
Dependencies resolved.
======================================================================================================================================================================================================================================================
 Package                                                              Architecture                                         Version                                                     Repository                                                Size
======================================================================================================================================================================================================================================================
Installing:
 kubelet                                                              x86_64                                               1.27.4-0                                                    kubernetes                                                20 M
Installing dependencies:
 conntrack-tools                                                      x86_64                                               1.4.7-1.fc38                                                updates                                                  228 k
 libnetfilter_cthelper                                                x86_64                                               1.0.0-23.fc38                                               fedora                                                    22 k
 libnetfilter_cttimeout                                               x86_64                                               1.0.0-21.fc38                                               fedora                                                    23 k
 libnetfilter_queue                                                   x86_64                                               1.0.5-4.fc38                                                fedora                                                    28 k

Transaction Summary
======================================================================================================================================================================================================================================================
Install  5 Packages

Total download size: 20 M
Installed size: 102 M
Is this ok [y/N]: y
Downloading Packages:
(1/5): libnetfilter_cthelper-1.0.0-23.fc38.x86_64.rpm                                                                                                                                                                  22 kB/s |  22 kB     00:01    
(2/5): libnetfilter_cttimeout-1.0.0-21.fc38.x86_64.rpm                                                                                                                                                                 22 kB/s |  23 kB     00:01    
(3/5): libnetfilter_queue-1.0.5-4.fc38.x86_64.rpm                                                                                                                                                                      27 kB/s |  28 kB     00:01    
(4/5): conntrack-tools-1.4.7-1.fc38.x86_64.rpm                                                                                                                                                                        428 kB/s | 228 kB     00:00    
(5/5): 49e46174a716325c333a575df9c990b0e237616e7c78537580d7e14204eca1d0-kubelet-1.27.4-0.x86_64.rpm                                                                                                                   6.4 MB/s |  20 MB     00:03    
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                                 3.7 MB/s |  20 MB     00:05     
Fedora 38 - x86_64                                                                                                                                                                                                    1.6 MB/s | 1.6 kB     00:00    
Importing GPG key 0xEB10B464:
 Userid     : "Fedora (38) <fedora-38-primary@fedoraproject.org>"
 Fingerprint: 6A51 BBAB BA3D 5467 B617 1221 809A 8D7C EB10 B464
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Is this ok [y/N]: y
error: can't create transaction lock on /usr/share/rpm/.rpm.lock (Read-only file system)
Fedora 38 - x86_64 - Updates                                                                                                                                                                                          1.6 MB/s | 1.6 kB     00:00    
Importing GPG key 0xEB10B464:
 Userid     : "Fedora (38) <fedora-38-primary@fedoraproject.org>"
 Fingerprint: 6A51 BBAB BA3D 5467 B617 1221 809A 8D7C EB10 B464
 From       : /etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Is this ok [y/N]: y
error: can't create transaction lock on /usr/share/rpm/.rpm.lock (Read-only file system)
Kubernetes                                                                                                                                                                                                            1.0 kB/s | 975  B     00:00    
Importing GPG key 0x3E1BA8D5:
 Userid     : "Google Cloud Packages RPM Signing Key <gc-team@google.com>"
 Fingerprint: 3749 E1BA 95A8 6CE0 5454 6ED2 F09C 394C 3E1B A8D5
 From       : https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
Is this ok [y/N]: y
error: can't create transaction lock on /usr/share/rpm/.rpm.lock (Read-only file system)
Key import failed (code 2). Failing package is: libnetfilter_cthelper-1.0.0-23.fc38.x86_64
 GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Public key for libnetfilter_cttimeout-1.0.0-21.fc38.x86_64.rpm is not installed. Failing package is: libnetfilter_cttimeout-1.0.0-21.fc38.x86_64
 GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Public key for libnetfilter_queue-1.0.5-4.fc38.x86_64.rpm is not installed. Failing package is: libnetfilter_queue-1.0.5-4.fc38.x86_64
 GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Key import failed (code 2). Failing package is: conntrack-tools-1.4.7-1.fc38.x86_64
 GPG Keys are configured as: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-fedora-38-x86_64
Key import failed (code 2). Failing package is: kubelet-1.27.4-0.x86_64
 GPG Keys are configured as: https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
The downloaded packages were saved in cache until the next successful transaction.
You can remove cached packages by executing 'dnf clean packages'.
Error: GPG check FAILED
[dangqian.zll@localhost ~]$ 
```


# k8s
https://dev.to/carminezacc/creating-a-kubernetes-cluster-with-fedora-coreos-36-j17 

- [Install Kubernetes v1.25.4 on Fedora CoreOS 37 with ignition, ansible and kubeadm](https://pvamos.github.io/fcos-k8s/)
- kubernetes: [入门/生产环境](https://kubernetes.io/zh-cn/docs/setup/production-environment/)
- [kubeadm init](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init/)
    - [结合一份配置文件来使用 kubeadm init](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init/#config-file)
- [kubeadm init phase](https://kubernetes.io/zh-cn/docs/reference/setup-tools/kubeadm/kubeadm-init-phase/)
- [kubeadm 配置 (v1beta3)](https://kubernetes.io/zh-cn/docs/reference/config-api/kubeadm-config.v1beta3/)


```shell
# 先确保 docker 正常work
docker images 
docker run hello-world

sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# 设置主机名
sudo hostnamectl set-hostname my-k8s-master
sudo hostnamectl set-hostname my-k8s-worker1
hostnamectl status


# 设置规定IP地址
nmcli -t -f STATE general
# 获取 网口的 UUID

ifconfig
ip addr
nmcli con show -a
nmcli con show cf82ce0a-3467-3385-9248-1767678b6116 |grep ipv4
sudo nmcli connection modify <network_uuid_or_name> IPv4.address <new_static_IP>/24
sudo nmcli connection modify cf82ce0a-3467-3385-9248-1767678b6116 IPv4.address 192.168.56.3/24
sudo nmcli connection modify cf82ce0a-3467-3385-9248-1767678b6116 IPv4.gateway 192.168.56.1
sudo nmcli connection modify cf82ce0a-3467-3385-9248-1767678b6116 IPv4.dns 8.8.8.8
# auto - 自动通过 dhcp 获取， manual - 静态IP
sudo nmcli connection modify cf82ce0a-3467-3385-9248-1767678b6116 IPv4.method manual
sudo nmcli connection down   cf82ce0a-3467-3385-9248-1767678b6116
sudo nmcli connection up     cf82ce0a-3467-3385-9248-1767678b6116
route -n


sudo rpm-ostree install python3 libselinux-python3 ansible nmap telnet iproute-tc
sudo rpm-ostree install kubelet kubeadm kubectl 
kubelet --version
kubeadm version
kubectl version

# 此时 kubelet 会一直尝试重启，但因 `/var/lib/kubelet/config.yaml` 不存在而启动失败
sudo systemctl enable --now kubelet
journalctl -xeu kubelet
journalctl -f -u kubelet


docker --version
containerd --version
kubelet --version
runc --version
crictl info
uname -a
cat /etc/containerd/config.toml
netstat -pnlt | grep 6443

# ori-codkerd : https://github.com/Mirantis/cri-dockerd
# 安装 docker-ce 时需要安装 ori-codkerd
wget https://github.com/Mirantis/cri-dockerd/releases/download/v0.3.4/cri-dockerd-0.3.4-3.fc36.x86_64.rpm
rpm -ivh cri-dockerd-0.3.4-3.fc36.x86_64.rpm 
systemctl enable cri-docker
systemctl start cri-docker
systemctl status cri-docker
ll -l /var/run/cri-dockerd.sock


# 打印默认的 kubeadm init 参数
kubeadm config print init-defaults 


# containerd : /var/run/containerd/containerd.sock
# cri-docker : /var/run/cri-dockerd.sock

# 检查
sudo kubeadm init phase preflight --kubernetes-version 1.27.4  --cri-socket  unix:///var/run/cri-dockerd.sock

# 检查要使用到的镜像
# Azure 中国 提供了 gcr.io 及 k8s.gcr.io 容器仓库的镜像代理服务。
# 镜像地址：docker pull gcr.azk8s.cn/google_containers/<imagename>:<version>
kubeadm config images list
# 拉取镜像
sudo kubeadm config images pull \
  --kubernetes-version 1.27.4
sudo kubeadm config images pull \
  --image-repository=registry.aliyuncs.com/google_containers \
  --kubernetes-version 1.27.4

cat /etc/containerd/config.toml
version = 2

[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    systemd_cgroup = true
    sandbox_image="registry.k8s.io/pause:3.9"
    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/usr/libexec/cni/"
      conf_dir = "/etc/cni/net.d"
  [plugins."io.containerd.internal.v1.opt"]
    path = "/var/lib/containerd/opt"

# reset
kubectl drain my-fedora2 --delete-emptydir-data --force --ignore-daemonsets  # 这里的 my-fedora2 是 node名字

kubeadm reset -f
rm -f $HOME/.kube/config


#sudo kubeadm init --image-repository registry.aliyuncs.com/google_containers
sudo kubeadm init \
    --apiserver-advertise-address=192.168.56.5 \
    --service-cidr=10.96.0.0/12  \
    --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl get node



```
## 网络插件

```shell
```



kubeadm init 示例日志
```shell
[dangqian.zll@localhost ~]$ sudo kubeadm init
[init] Using Kubernetes version: v1.27.4
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W0725 13:12:50.480698    4672 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local localhost.localdomain] and IPs [10.96.0.1 10.0.2.15]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost localhost.localdomain] and IPs [10.0.2.15 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost localhost.localdomain] and IPs [10.0.2.15 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[kubelet-check] Initial timeout of 40s passed.
[apiclient] All control plane components are healthy after 103.023689 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node localhost.localdomain as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node localhost.localdomain as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: iq0dmy.6hn6wxc0ma21n7j7
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.2.15:6443 --token iq0dmy.6hn6wxc0ma21n7j7 \
	--discovery-token-ca-cert-hash sha256:19cfb8ed771e5c78bb75d13dd349e36011356d57f7f1f4c30cbb5d21c43f775c 
```


# k8s 问题
 
## Q1: sandbox image of the container runtime is inconsistent with that used by kubeadm

```shell
W0725 13:12:50.480698    4672 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image
```

解决方式：

/etc/containerd/config.toml 中增加  sandbox_image 设置
```yaml
#...
[plugins]
  [plugins."io.containerd.grpc.v1.cri"]
    sandbox_image="registry.k8s.io/pause:3.9"
#...
```
修改后需要 `sudo systemctl restart containerd`

其他参考 
- [重载沙箱（pause）镜像](https://kubernetes.io/zh-cn/docs/setup/production-environment/container-runtimes/#override-pause-image-containerd)
- [问题“The connection to the server....:6443 was refused - did you specify the right host or port?”的处理！](https://blog.csdn.net/sinat_28371057/article/details/109895159)



## Q2: Unimplemented : unknown service runtime.v1.RuntimeService"

```plain
[ERROR CRI]: container runtime is not running: output: time="2023-07-26T18:46:21Z" level=fatal msg="validate service connection: CRI v1 runtime API is not implemented for endpoint \"unix:///var/run/containerd/containerd.sock\": rpc error: code = Unimplemented desc = unknown service runtime.v1.RuntimeService"
```

解决方法
```shell
vi /etc/containerd/config.toml
# 注释掉这一行:
# disabled_plugins = ["cri"]

systemctl restart containerd
```


## Q3
`kubeadm init phase preflight --config kubeadm.yaml` 时报错

```plain
I0727 06:41:20.162482    8725 initconfiguration.go:255] loading configuration from "kubeadm.yaml"
invalid configuration for GroupVersionKind /, Kind=: kind and apiVersion is mandatory information that must be specified
```
原因1： kubeadm.yaml 中 `---` 要处于第一行，其前面不要有空白行，注释行