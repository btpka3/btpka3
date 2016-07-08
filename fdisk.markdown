
## df


```
df -lhT              # 查看分区的文件系统类型、大小、挂载点
sudo lsblk -o name,mountpoint,label,size,uuid

df -i -h             # 查看 inode 使用状况
```



## fdisk

```
fdisk -l                   # 列出所有硬盘
fdisk /dev/sdb             # 管理指定设备的分区表
p                          # 打印分区表
d 1                        # 删除指定的分区，如果不带参数，则会提示删除一个默认的并让确认
o                          # 创建一个dos格式的分区表
n                          # 创建一个分区
   p                       #   主分区
   1                       #   编号
   +500G                   #   分区大小
w                          # 写入磁盘
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
