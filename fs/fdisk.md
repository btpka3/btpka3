## du

disk usage

```bash
# 先查看挂载情况
df -h
# 再通过 du 来统计目录使用情况
du -h -d 1 \
    --exclude=/dev \
    --exclude=/run \
    --exclude=/sys/fs/cgroup \
    --exclude=/proc \
    --exclude=/data0 \
    --exclude=/var/lib/docker/devicemapper \
    --exclude=/var/lib/docker/containers \
    /
```

## df

disk free

```bash
df -lhT              # 查看分区的文件系统类型、大小、挂载点
sudo lsblk -o name,mountpoint,label,size,uuid

df -i -h             # 查看 inode 使用状况

# 查找那个目录文件最多


/var
proc

#FILES=/usr/*
#FILES=/var/*
FILES="
/boot
/dev
/etc
/home
/lost+found
/media
/mnt
/opt
/proc
/root
/run
/srv
/sys
/tmp
/usr
"


for f in $FILES ; do
    echo $f `find $f -xdev -type f|wc -l`
done | sort -g -k2 | column -t


# 通过类似命令，一点点排除，最终发现 /var/lib/docker/devicemapper/mnt 目录下面有 602897 个文件

/dev         0
/lost+found  0
/media       0
/mnt         0
/opt         0
/srv         0
/tmp         3
/home        6
/root        23
/run         299
/boot        326
/etc         1851
/sys         11440
/usr         81147
/proc        148542

ls /var/lib/docker/devicemapper | wc -l

find /var/lib/docker/devicemapper -xdev -type f|wc -l

/var/lib/docker

find /var/lib/docker/devicemapper -xdev -type f|wc -l

```

## fdisk

```
fdisk -l                    # 列出所有硬盘
fdisk /dev/sdb              # 管理指定设备的分区表
p                           # 打印分区表
d 1                         # 删除指定的分区，如果不带参数，则会提示删除一个默认的并让确认
o                           # 创建一个dos格式的分区表
n                           # 创建一个分区
   p                        #   主分区
   1                        #   编号
   +500G                    #   分区大小
w                           # 写入磁盘
```

## mkfs 创建文件系统

```
# XFS
mkfs.xfs -f /dev/sdb1

# Fat32
mkfs.msdos -F 32 /dev/sdb1
fatlabel /dev/sdb1 YOUR_LABEL

# exFat
mkfs.exfat /dev/sdX1

# NTFS
mkfs.ntfs /dev/sdb1
```

## blkid

```
blkid

mkdir /data0 /data1                # 创建挂载点

vi /etc/fstab                            # 开机自动挂载
UUID=cd69195a-7846-4412-97c6-fe554fecbed6  /data0  xfs  defaults  0 0
UUID=c0271228-51f7-4139-a3db-120faf8bda7d  /data1  xfs  defaults  0 0
```

## LVM

参考 [这里](http://dreamfire.blog.51cto.com/418026/1084729/)

### 创建

```bash

# 创建分区的时候，可以修改一个分区的类型
fdisk /dev/sdb
t                           # 标记分区
1                           # 第一个分区
8e                          # 标记该分区为 LVM 分区  83-linux 分区

# 将两个分区转为物理卷 （添加 LVM 属性信息，并划分PE存储单元）
pvcreate /dev/sda1 /dev/sda2
pvs
pvdisplay

# 创建卷组，并加入指定的两个物理卷，默认 PE 大小为 4MB
# PE 是卷组的最小存储单元，可以通过 -s 参数修改
vgcreate vgdata /dev/sda1 /dev/sda2

# 在卷组 vgdata 切割出 500M 的 逻辑卷 lvdata1
lvcreate -L 500M -n lvdata1 vgdata
# 在逻辑卷 lvdata1 上创建 ext4 文件系统
mkfs.ext4 /dev/vgdata/lvdata1

# 挂载
mount /dev/vgdata/lvdata1 /data1

# 查询 UUID
blkid
# 并修改 fstab 以便开机自动挂载
vi fstab
```

### 缩小逻辑卷

```bash
# 取消挂载
umount /data1

# 检查还有多少剩余磁盘空间
e2fsck -f /dev/mapper/vgdata-lvdata1

# 设置减少后的尺寸为 700M
resize2fs /dev/mapper/vgdata-lvdata1 700M

# 禁烧逻辑卷的尺寸，也同样为 700M
lvreduce -L 700M /dev/vgdata/lvdata1

```

### 扩展逻辑卷

```bash
# 增加 500M 空间
lvextend –L +500M /dev/vgdata/lvdata1
lvs

# 同步文件系统
resize2fs /dev/vgdata/lvdata1
```

### 扩展卷组

```bash
# 扩展
vgextend vgdata /dev/sdb3
# 确认
pvs
```

### 数据转移

```bash
pvs
pvmove /dev/sda1 /dev/sda2
vgreduce vgdata dev/sda1
pvs
```

### 删除逻辑卷

```bash
#
umount /data1
vi /etc/fstab    # 去掉相应的自动挂载项
vgremove vgdata             # 删除卷组
pvremove /dev/hd2 /dev/hd3  # 删除逻辑卷
pvs
vgs
lvs
```

## 参考

[Win7 ISO -> U盘](http://serverfault.com/questions/6714/how-to-make-windows-7-usb-flash-install-media-from-linux)

## 数据回复

```
photorec
```

## exfat

```
# ubuntu
sudo apt-get install exfat-utils exfat-fuse

# centos
yum install exfat-utils fuse-exfat
```

# YUMI

[YUMI](http://www.pendrivelinux.com/yumi-multiboot-usb-creator/)

* [老毛桃](http://www.laomaotao.org/)
* [Ubuntu](http://cn.ubuntu.com/)
* [Lubuntu](http://lubuntu.net/)
* [CentOs](https://www.centos.org/)
* [OS X](http://www.apple.com/osx/)
* [Hackintosh](http://www.hackintosh.com/)
