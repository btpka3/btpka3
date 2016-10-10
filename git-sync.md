## 目标

网上的 github、gitlab、git@Oschina 等托管服务都太慢，频繁编辑wiki会惹火。
但本地环境有自己搭建 gitlab， 希望无论在gitlab上编辑，还是在公网上编辑，都能合并到一起，两者内容一致

## 思路

1. 以公网上（git@OSChina）的为主，本地 clone 一份。
1. 之后，在本地 git 仓库新增一个 remote，该 remote 为局域网内 gitlab 搭建的 git 仓库。
1. 更新的时候，先从本地 gitlab 上拉取，再从 oschina 上拉取，
1. 最后 push 到 oschina 上，**强推** 到本地 gitlab 上。

以下是思路测试用的脚本。

```
cd /home/zll/work/git-repo/oschina
git clone git@git.oschina.net:btpka3/btpka3.wiki.git
cd btpka3.wiki
git remote add gitlab  git@git.test.me:zhangll/btpka3.wiki.git
git push -f gitlab master:master

git pull --rebase gitlab master
git pull --rebase origin master

git push origin master:master
git push -f gitlab master:master   
```

为了方便脚本自动执行，最好使用 SSH Key完成认证，而无需密码。需要修改 ssh 的配置 `vi ~/.ssh/config`

```
Host git.test.me
    IdentityFile ~/.ssh/id_rsa
Host git.oschina.net
    IdentityFile ~/.ssh/oschina/id_rsa
```

## sync-wiki.sh

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

## crontab 任务

```
# crontab -e
# m h  dom mon dow   command
0 */1  * * * /home/zll/work/git-repo/oschina/sync-wiki.sh 2>&1 >> /home/zll/work/git-repo/oschina/sync-wiki.log 
```
