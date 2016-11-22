

# server
## CentOS

```
yum list nfs*
yum install nfs-utils

man 5 exports
vi /etc/exports
/data1/samba/public 		*(rw,sync,no_root_squash)

exportfs -a
chmod -R ugo+rx /data

systemctl status rpcbind
systemctl status rpc-statd
systemctl status nfs-idmap
systemctl status nfs-server


less /etc/idmapd.conf
```

# client
## ubuntu

```
sudo apt-get install rpcbind nfs-common autofs

sudo mount 192.168.0.12:/data1/samba/public ./public/

vi /etc/auto.master
```


## Mac OS X

```
mkdir -p ~/work/nfs/12/public/
sudo mount -t nfs -o resvport 192.168.0.12:/data1/samba/public /Users/zll/work/nfs/12/public/


# 显示远程提供的共享目录

showmount -e 192.168.0.12          # IP 为 NFS共享服务器的IP地址

# 自动挂载
vi /etc/auto_master
/Users/zll/work/nfs/12/public/ -fstype=nfs4,resvport 192.168.0.12:/data1/samba/public

sudo launchctl list | grep -i auto
sudo launchctl list com.apple.automountd.plist
sudo launchctl list com.apple.autofsd.plist

sudo automount -vc
```