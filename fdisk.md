
## df

```
df -lhT              # 查看分区的文件系统类型、大小、挂载点
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


