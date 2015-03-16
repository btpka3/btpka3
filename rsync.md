

```
yum install rsync
systemctl is-enabled rsyncd
systemctl status rsyncd

vi /etc/rsyncd.conf

rsync -avzP root@test11.jujncn.com:/home/git/repositories/ /data0/backup/git-repo

# 结合SSH
ssh root@test11.jujncn.com rsync -avzP root@test11.jujncn.com:/home/git/repositories/ /data0/backup/git-repo

```