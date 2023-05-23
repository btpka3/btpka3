```
yum install rsync
systemctl is-enabled rsyncd
systemctl status rsyncd

vi /etc/rsyncd.conf

rsync -avzP root@test11.jujncn.com:/home/git/repositories/ /data0/backup/git-repo

# 结合SSH
ssh root@test11.jujncn.com rsync -avzP root@test11.jujncn.com:/home/git/repositories/ /data0/backup/git-repo

```

### rsync

```bash
# copy all files from src to dist
rsync -avzh /path/to/src/dir /path/to/dist/dir
rsync -avzh user@host:/path/to/src/dir /path/to/dist/dir

rsync -avzh --exclude-from=.rsyncignore . user@host:/path/to/dist/dir

rsync --progress user@host:/src/dir/ dest/dir
```
