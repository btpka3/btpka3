
## df

```
df -lhT              # 查看分区的文件系统类型、大小、挂载点
sudo lsblk -o name,mountpoint,label,size,uuid
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


## mkfs.xfs

```
mkfs.xfs -f /dev/sdb1
mkfs.xfs -f /dev/sdb2
```

## fat32

```
mkfs.msdos -F 32 /dev/sdb1
fatlabel /dev/sdb1 YOUR_LABEL
```


## blkid

```
blkid

mkdir /data0 /data1                # 创建挂载点

vi /etc/fstab                            # 开机自动挂载
UUID=cd69195a-7846-4412-97c6-fe554fecbed6  /data0  xfs  defaults  0 0
UUID=c0271228-51f7-4139-a3db-120faf8bda7d  /data1  xfs  defaults  0 0
```
