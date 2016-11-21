## 常用设置
在 vm 内,禁止 'Alt+tab' 在vm内切换窗口:

```
VirtualBox: File -> Preferences -> Input -> uncheck "Auto Capture Keyboard"
```


## 安装(host)
### ubuntu

* 安装Ubuntu仓库中的版本
    ```
    apt-cache search virtualbox
    sudo apt-get install virtualbox virtualbox-guest-additions-iso
    ```

* 安装官方渠道的最新版本
  
    ```
    # 将 'vivid' 替换为 'utopic', 'trusty', 'raring', 'quantal', 'precise', 
    # 'lucid', 'jessie', 'wheezy', 或者 'squeeze'
    deb http://download.virtualbox.org/virtualbox/debian vivid contrib
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install virtualbox-4.3
    echo "virtualbox-4.3 hold"        | sudo dpkg --set-selections
    sudo dpkg --get-selections virtualbox-4.3

    # /usr/share/virtualbox/VBoxGuestAdditions.iso
    ```

## 安装(guest)

### lubuntu
1. 在host上对virtualbox设置共享目录,建议不要选中 "自动挂载"
1. 安装必须的组件

    ```
    sudo apt-get install build-essential linux-headers-`uname -r` dkms
    ```
1. 安装 guest additions

    ```
    /media/zll/VBOXADDITIONS_4.3.28_100309/VBoxLinuxAdditions.run
    ```

1. 创建需要挂载的本地目录

    ```
    mkdir ~/c ~/c
    ```

1. 手动挂载

    ```
    sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) c ~/c
    sudo mount -t vboxsf -o uid=$UID,gid=$(id -g) d ~/d
    # 提示:如果共享目录设置的是自动挂载, 是挂载到了 /media/sf_c
    ```
1. 开机自动按自定义设置挂载

    1. 确保在 virtualbox 中设置的共享目录没有勾选 "自动挂载"
    1. `echo vboxsf >> /etc/moudules` 确保 kernel 提前加载所需模块
    1. `vi /etc/fstab`, 内容如下:

        ```
        c /home/zll/c     vboxsf  defaults,gid=zll,uid=zll,dmode=774,fmode=664,_netdev  0 0
        d /home/zll/d     vboxsf  defaults,gid=zll,uid=zll,dmode=774,fmode=664,_netdev  0 0
        ```


### win8 安装错误

```
VBoxManage.exe" setextradata "<Virtual machine name>" VBoxInternal/CPUM/CMPXCHG16B 1 
```
### centos 7

```
# 使用桥接方式
vi /etc/sysconfig/network-scripts/ifcfg-enp0s3 
DEVICE=eth0  
BOOTPROTO=dhcp  
ONBOOT=yes

systemctl restart network
yum install net-tools
ifconfig
```


[查看这里](https://www.virtualbox.org/wiki/Linux_Downloads)

## 网络连接
1.  网络地址转换（NAT）

    Guest系统访问网络资源均通过Host系统，只能单向访问。Host系统及其他外部系统均无法访问Guest系统。

2.  桥接网卡（Bridged Adapter） - 最常用

    可独立分配一个IP地址，局域网内所有主机均可与其互通。

3.  内部网络（Internal）

    Guest系统之间可以相互访问，但与外部隔绝。

4.  仅主机（Host Only）适配器

    ??? 前面几种功能在这里若合理配置均可实现。

## 共享本地硬盘

### centos guest

[参考](http://helpdeskgeek.com/virtualization/virtualbox-share-folder-host-guest/)

这里以Host系统为Windows，Guest系统为CentOS为例进行讲解：

1.  用虚拟光驱加载 VirtualBox 根目录下的 `VBoxGuestAdditions.iso`
1.  启动Guest系统，`设备` 菜单 -> 分配光驱 -> 选择第一步加载的虚拟光驱
1.  在Guest系统（CentOS）中加载cdrom，

    ```bash
    mount /dev/cdrom /media/cdrom
    # mount: block device /dev/sr0 is write-protected, mounting read-only
    cd /media/cdrom
    ./VBoxLinuxAdditions.run
    # ...  # NOTICE : 如果你没有安装CentOS的桌面系统，会提示 Installing the Window System drivers  [FAILED] 请无视。
    ```

1.  重启系统

    ```bash
    init 6
    ```
1.  Guest系统运行窗口： 

    ```
    `设备` 菜单 
        -> 共享文件夹 
        -> 点击`添加共享文件夹`图标 
        -> 设置`共享文件夹路径`（比如：`F:/`）
        -> 设置`共享文件名称`（比如: `F`） 
        -> 选中`固定分配` 
        -> 确定
    ```

1.  在Guest系统中运行以下命令加载

    ```bash
    mount -t vboxsf F /mnt/f    # 其中`F`是前一步设置的`共享文件名称`，`/mnt/f` 是挂载目录，若不存在请自行创建
    mount: block device /dev/sr0 is write-protected, mounting read-only
    cd /mnt/f
    ```

### windows guest

```
net use x: \\vboxsvr\sharename
```

##  搭建局域网

FIXME

## 调整磁盘大小

```
# 0. 列出所登记的虚拟硬盘
VBoxManage list hdds

# 1.1 复制并修改 uuid
cp /path/to/file1.vdi /path/to/file2.vdi 
VBoxManage internalcommands sethduuid /path/to/file2.vdi

# 1.2 克隆（作用同上）
VBoxManage clonehd /path/to/file1.vdi /path/to/file2.vdi --format VDI --variant Standard

# 2. 修改虚拟硬盘大小（100G）
VBoxManage modifyhd /path/to/file2.vdi --resize 102400
```


# U盘启动
## linux 
[参考](http://tecadmin.net/how-to-boot-from-usb-drive-in-virtualbox-on-linux/)

```
fdisk -l
umount /dev/sdb1
VBoxManage internalcommands createrawvmdk -rawdisk /dev/sdb -filename /opt/sdb.vmdk  # 注意：是整个U盘，而不是其中的一个分区。
```