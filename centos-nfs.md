

[Setting Up An NFS Server And Client On CentOS 5.](www.howtoforge.com/setting-up-an-nfs-server-and-client-on-centos-5.5)

# 安装服务器

## 安装

```sh
[root@localhost ~]# yum list nfs*
[root@localhost ~]# yum install nfs-utils nfs-utils-lib

[root@h01 ~]# chkconfig --list nfs
[root@h01 ~]# chkconfig --level 345 nfs on
```
## 设置共享目录

```sh
[root@h01 ~]# man 5 exports
[root@h01 ~]# vi /etc/exports
/data/ttt/share/ 		000.000.000.000(rw,sync,no_root_squash)

[root@h01 ~]# exportfs -a
[root@h01 ~]# chmod –R ugo+rx /data

```

## 启动NFS服务

```sh
[root@h01 ~]# service rpcbind status			# 要先确保 rpcbind服务已经启动
[root@h01 ~]# service nfs start

```

# 客户端
## 安装

```sh
[root@h01 ~]# yum list nfs*
[root@h01 ~]# yum install nfs-utils nfs-utils-lib
```

## 启动rpcbind服务
```sh
[root@h01 ~]# service rpcbind start
```

## 验证

```sh
[root@h01 ~]# mount 000.000.000.000:/data/ttt/share     /data/srs/appData/appName/share-nfs/
[root@h01 ~]# echo hello > /data/ttt/appData/appName/share-nfs/hi.txt
[root@h01 ~]# rm –f /data/ttt/appData/appName/share-nfs/hi.txt

```




