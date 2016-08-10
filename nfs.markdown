


# CentOS

```
yum list nfs*
yum install nfs-utils

man 5 exports
vi /etc/exports
/data1/samba/public 		*(rw,sync,no_root_squash)

exportfs -a
chmod -R ugo+rx /data

systemctl status rpcbind       
systemctl status nfs-server
```