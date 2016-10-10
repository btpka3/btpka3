



## sync-wiki.sh

先 clone

```
git clone git@git.oschina.net:btpka3/btpka3.wiki.git
cd btpka3.wiki
git remote add gitlab git@xxx.test.me:zhangll/btpka3.wiki.git
git push -f gitlab '*:*'
```

再设置同步脚本

```
#!/bin/bash
TIME="date +%Y-%m-%d.%H:%M:%S"

cd /home/zll/work/git-repo/oschina/btpka3.wiki
echo `$TIME` pull from gitlab
git pull --rebase gitlab master
[ $? = 0 ] || exit -1

echo `$TIME` pull from oschina
git pull --rebase origin master
[ $? = 0 ] || exit -1

echo `$TIME` push to oschina
git push origin master:master
[ $? = 0 ] || exit -1

echo `$TIME` push to oschina
git push -f gitlab master:master
[ $? = 0 ] || exit -1

echo `$TIME` Done.
```


## crontab -e

```
# m h  dom mon dow   command
0 */1  * * * /home/zll/work/git-repo/oschina/sync-wiki.sh 2>&1 >> /home/zll/work/git-repo/oschina/sync-wiki.log
```