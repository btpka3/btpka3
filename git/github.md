* [Git中文手册](http://git-scm.com/book/zh)、
* [git Refspec](http://git-scm.com/book/zh/Git-%E5%86%85%E9%83%A8%E5%8E%9F%E7%90%86-The-Refspec)、
* [Git Commit-ish/Tree-ish ](http://stackoverflow.com/questions/4044368/what-does-tree-ish-mean-in-git/18605496#18605496)
* git工作量统计： [查看](http://btpka3.github.io/js/node/git-stat/stat/)， [源码](https://github.com/btpka3/btpka3.github.com/blob/master/js/node/git-stat/)

# 记住密码
使用ssh协议，可以使用ssh key来免密码登录。但是如果使用 http/https 协议来clone，则可以参考 [这里](https://help.github.com/articles/caching-your-github-password-in-git/)

```
# Mac
git credential-osxkeychain
brew install git
git config --global credential.helper osxkeychain

git credential-osxkeychain erase

# Windows
git config --global credential.helper wincred

# Linux
git config --global credential.helper 'cache --timeout=3600'   # 保存在内存中
# 保存在磁盘上, 默认查找 ~/.git-credentials  $XDG_CONFIG_HOME/git/credentials
git config credential.helper 'store --file=<path>'
```
# 配置

```bash
# 用户级的配置文件路径
~/.gitconfig
# 配置用户身份
git config --global user.name "zhangll"
git config --global user.email zhangll@lizi.com
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --global push.default simple           # 在 "git push" 时，会推到当前分支跟踪的远程分支（可能名称不同）
git config --global core.filemode false           # 忽略文件仅文件权限的变更（比如 old mode 100755  new mode 100644）
git config --global color.ui auto                 # git命令下会使用红色、绿色等来突出显示。
git config --global branch.autosetuprebase always # 在 "git pull" 时，总会自动rebase
git config --global credential.helper cache       # 在 clone `https` 类型的URL时，可减少用户名密码输入次数
git config --global core.quotepath false          # 在提交中文名称的文件时，不转义为 \350\256\256\346\200\273\347\273\223.xlsx
git config --list
```

```bash
git add path/file              # 添加新文件
git reset HEAD path/file       # 取消添加
git commit  -m "commit msg"    # 提交修改
git push                       # 推送到远程
```




# 创建仓库

参考：http://gitref.org/

```bash
# 远程服务器创建
mkdir lizi-tmp
cd lizi-tmp
git --bare init

# 本地创建
mkdir zll
cd zll
git init
echo hello > README
git add README
git commit -m "first commit"

# 将本地设置为跟踪远程服务器
git remote add origin git@newcrm.nalashop.com:~/web/lizi-tmp
git push --set-upstream origin master

# 删除
git rm README
git mv file_from file_to
git log

# 在提交前，将已标记为要提交的文件移除。
git reset HEAD xxxFile

# 取消修改
git checkout -- benchmarks.rb

# 修改最后一次提交
git commit --amend

# 查看当前工作区的状态
git status
# .gitignore 中可以忽略特定的文件
git diff

# 查看远程仓库的URL
git config --get remote.origin.url
```


# 远程

```bash
# 如果使用ssh key，就不要使用https协议
git remote add origin git@10.1.18.153:zhangliangliang/test.git
git remote set-url origin git@new-host:new-url
git remote show
git remote rm origin
git push -u origin master

# 重命名
git remote rename origin xx

# 从远程仓库上获取最新内容（不合并本地已经修改的内容）
# 注意：分支号前面的加号可选
# 如果 :local-branch-name 省略，则默认与remote-branch-name 相同
git fetch remote-name  +remote-branch-name:local-branchName

# 从远程仓库上获取最新内容（合并本地已经修改的内容）
git pull --rebase

# 提交到远程服务器
git push remote-name [branch-name]

## FIXME fetch, pull 是保存到工作空间？还是状态空间？

```

# Tag

```bash
# 显示本地所有tag
git tag
# 显示指定前缀的tag
git tag -l "v1.1*"
# 显示具体某个tag的详情
git show tag-name
# 显示远程所有的分支和标签
git ls-remote

# 新建轻量级tag（不要使用 -a -s -m 选项）
git tag v1.4-lw
# 新建tag(默认是对当前状态进行tag)
git tag -a new-tag-name -m some-message [commit-hash]
# 新建签名的tag(不要使用 -a 选项）
git tag -s tag-name -m some-message
# 验证签名tag：会使用GPG进行验证，需要预先下载签名者的公钥
git tag -v tag-name

# 提交指定的tag到远程
git push remote-name tag-name
# 提交所有的tag到远程
git push remote-name --tags

# 删除本地tag
git tag -d tag-name
# 删除远程tag
git push origin :refs/tags/tag-name

# 检出tag
git checkout tags/tag-name
```

# Branch

```bash
# 新建分支
git branch branch-name
# 检出远程分支
git checkout -b local-branch-name origin/remote-branch-name
# 切换本地分支
git checkout branch-name

# 新建并切换到该新分支(等价于上述两个命令)
git checkout -b new-branch-name

# 查看本地所有分支，以及工作空间所用的分支（前缀有*号）
git branch
# 查看远程分支
git branch -r
# 查看所有分支（本地和远程）
git branch -av
git show-branch
# 查看当前分支是track远程的哪个分支
git remote show origin

# 查看分支最后一个提交对象
git branch -v
（分别叫做 stashing 和 commit amending）

# 合并分支(将branch2合并到branch1)
git checkout branch1
git merge branch2

# 如果有有合并冲突的文件，需要手动合并后，再使用以下命令就OK了
git add merged-by-hand-file
git commit

# 删除分支
git branch -d branch-name

```

# 远程分支

```bash
# 新建远程分支
git push origin test:master         // 提交本地test分支作为远程的master分支

# 合并远程分支
git checkout remoteBranch1                 # ??? git checkout origin/branch1
git push origin remoteBranch1:remoteBranch2


# 删除远程分支
git push origin :remoteBranch2


```



# 取消本地所有修改

```bash
# 取消对文件的修改
git reset --hard HEAD

# 删除本地未索引的文件
git clean -fdx

git status
```

# 删除最后几次commit
```bash
# 查看提交的log，并找到想要回滚到的commit的
git log
git reset --hard <sha1-commit-id>
```

# rebase
假如有新修改提交到本地了。在push前进行pull的时候，
git自动合并并创建了一个新的commit，其注释为 "Merge branch 'xxx' of git@xxxx/path/to/xxx.git into xxx"。此时，大家应当立即运行

```bash
gitk  # 此时有比较复杂的路线图
git rebase
gitk  # 此时就变成单线路了

# rebase之后，会将本地的多个提交合并成一个提交，原来的多个提交的历史记录可以通过以下命令找到
git reflog
git cherry-pick 12944d8
```



# 单个文件
## 查看日志

```bash
git log path/to/file
```

## diff

```bash
git diff <sha1-commit-id1> <sha1-commit-id2> path/to/file
```


## 检出特定版本

```bash
git checkout <sha1-commit-id> path/to/file
```
## 无本地copy情况下，从远程仓库检出最新的指定文件

```bash
git ls-remote git@git.test.me:/path/to/git/repo
git archive --remote=git@git.test.me:/path/to/git/repo refs/heads/test path/to/file  --format zip -o /tmp/a.zip
cd /tmp/
unzip /tmp/a.zip
cp path/to/file /path/to/dest
```

## 无本地copy情况下，从远程仓库检出指定版本的指定文件

```bash
# 先通过SSH登录到远程仓库，看一下test分支上指定文件的最近3条日志，找到所需的commit SHA1.
ssh git@git.test.me "cd /path/to/git/repo && git log -n 3 test -- path/to/file"
git archive --remote=git@git.test.me:/path/to/git/repo d787416b0aec88747075ef0f5909bc4f863aa26e path/to/file  --format zip -o /tmp/a.zip
cd /tmp/
unzip /tmp/a.zip
cp path/to/file /path/to/dest
```


# .gitignore

```
/target-eclipse/classes
/web-app/WEB-INF/classes
/target/
/out/
/test/
/overlays/
/db/
.classpath
.settings/
.project
.idea/
.DS_Store
*.iml
*.ipr
*.iws
*.swp
*.log
```

注意：如果要忽略特定的目录中的文件，但还想在远程仓库中保持该目录，则：

```
emptyDir/*
!emptyDir/.gitkeep
```




# 撤销提交
## 编辑最后一次本地提交
也即，本地已经commit，但是没push到远程

```bash
git reset --soft HEAD~1             # 先reset，会copy HEAD为.git/ORIG_HEAD
doSomeEdit
git add .
git commit -c ORIG_HEAD             # 使用原来的commit消息，并提交
```


## 本地已经commit，也已经push到远程，但其他开发人员尚未拉取
```bash
git push -f                         # 本地修改之后，强制提交
```

## 本地已经commit，也已经push到远程，但其他开发人员已经拉取，且进行了多次提交

```bash
git rever <commit-id>               # 该方法通过在最新commit之后新建一个commit来达到回滚的效果。
```

# 统计

```
# 一定时期内的代码提交次数
git log --after=2015-01-01 --before=2016-03-01 --pretty='%ae' | sort | uniq -c | sort -k1 -n -r


# 统计代码修改量
git log --after=2015-01-01 --before=2016-03-01 --pretty='%an' | sort -u
git log --author="btpka3" --pretty=tformat: --numstat \
    | gawk '{ add += $1 ; subs += $2 ; loc += $1 - $2 } \
    END { printf "added lines: %s removed lines : %s total lines: %s\n",add,subs,loc }' -

# gitstats
gitstats -c project_name=qh-app \
    -c commit_begin=`git log --date-order --date=iso --before=2015-01-01 -n 1 --pretty='%H'` \
    -c commit_end=`git log --date-order --date=iso --before=2016-03-01  -n 1 --pretty='%H'`  \
    qh-app \
    stat/qh-app
```


# sync


## repo

```
git clone http://git.oschina.net/btpka3/btpka3.wiki.git
cd btpka3.wiki
git remote add gitlab git@git.kingsilk.xyz:btpka3/btpka3.wiki.git
git config --list
```
## crontab
```
0 */1  *   *   *   /home/zll/work/git-repo/oschina/sync-wiki.sh 2>&1 >>  /home/zll/work/git-repo/oschina/sync-wiki.log
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



# search

- [Understanding GitHub Code Search syntax](https://docs.github.com/en/search-github/github-code-search/understanding-github-code-search-syntax)
- [languages.yml](https://github.com/github-linguist/linguist/blob/master/lib/linguist/languages.yml) 支持搜索的编程语言列表

```plain
org:github                              # 按照组织搜索
repo:spring-cloud/spring-cloud-config   # 搜索指定的代码仓库
user:zhang3                             # 再给定的个人账号下搜索

language:java                           # 搜索指定的语言

path:Event.java                         # 按照文件路径搜索,
                                        # 支持正则表达式， 比如搜索所有 README.md 文件:  path:/(^|\/)README\.md$/
                                        # 支持 glob 通配符，
                                        # - `?`  : 匹配任意单个字符
                                        # - `*`  : 匹配任意长度字符，但不匹配 '/' 字符。 比如: path:*.txt
                                        # - `**` : 匹配任意级别目录。 比如: path:/src/**/*.js
                                        # 如果要路径或文件中包含特殊字符（比如 '?','*'），需要使用双引号引用起来。 比如: path:"file?"

symbol:WithContext                      # 部分编程语言可以搜索某个方法。
                                        # symbol:Maint.deleteRows   : 比如 搜索 struct `Maint` 的 方法 `deleteRows`
                                        # symbol:Maint::deleteRows  : 使用go 语言的话，用该方式
                                        # symbol:/^String::to_.*/   : 支持正则

content:README.md                       # 搜索内容中包含 "README.md" 的文件

is:archived                             # 限定对仓库的属性进行过滤
                                        # is:archived
                                        # is:fork
                                        # is:verdored
                                        # is:vgenerated
```
