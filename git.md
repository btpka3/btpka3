# 配置

```sh
# 用户级的配置文件路径
~/.gitconfig 
# 配置用户身份
git config --global user.name "zhangliangliang"
git config --global user.email johndoe@example.com
git config --global core.editor vim
git config --global merge.tool vimdiff
git config --list
```

```sh
git add path/file              # 添加新文件
git reset HEAD path/file       # 取消添加
git commit  -m "commit msg"    # 提交修改
git push                       # 推送到远程
```


# 创建仓库

参考：http://gitref.org/

```sh
mkdir zll
cd zll
git init
echo hello > README
git add README
git commit -m "first commit"

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
```

#远程

```sh
# 如果使用ssh key，就不要使用https协议
git remote add origin git@10.1.18.153:zhangliangliang/test.git
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
git pull [remote-name]

# 提交到远程服务器
git push remote-name [branch-name]

## FIXME fetch, pull 是保存到工作空间？还是状态空间？

```

# Tag

```sh
# 显示所有tag
git tag
# 显示指定前缀的tag
git tag -l "v1.1*"
# 显示具体某个tag的详情
git show tag-name

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

```

# Branch

```sh
# 新建分支
git branch branch-name
# 切换分支
git checkout branch-name

# 新建并切换到该新分支(等价于上述两个命令)
git checkout -b new-branch-name

# 查看当前所有分支，以及工作空间所用的分支（前缀有*号）
git branch
# 查看分支最后一个提交对象
git branch -v
（分别叫做 stashing 和 commit amending）

# 合并分支(将branch2合并到branch1)
git checkout branch1
git merger branch2

# 如果有有合并冲突的文件，需要手动合并后，再使用以下命令就OK了
git add merged-by-hand-file
git commit

# 删除分支
git branch -d branch-name

```
