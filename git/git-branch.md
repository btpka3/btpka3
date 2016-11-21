# APP版本号规则
格式： major.minor.build
* major : 主版本号
* minor : 子版本号
* build : 补丁版本号。  
    major或minor变更后第一次发布时，该值为0。  
    major和minor均无变化时，若有新bug需要修正时，该值+1。
参考: [semver](http://semver.org/lang/zh-CN/)


# GIT分支管理规则


## Git tag 规则
tag名称：  v${major}.${minor}


## Git 分支规则
* 按照版本号定一个分支组
* 特殊分支——public。始终是最新版本的开发分支
* 每个分支组都包含2个分支
    * v${major}.${minor}-dev  : 开发分支。（不适用于最新版本）
    * v${major}.${minor}-test : 测试分支。（始终由开发分支push到测试分支、测试通过后在该测试分支节点上打tag）

如果某一阶段 要求开发分支稳定，则开发人员可先建立本地自定义分支（分支名任意），自测OK后，再合并到本地开发分支，再自测OK后，提交的远程，最后删除本地自定义分支。

假设当前最新版本为 2.2.0 ，尚在开发中，未发布生产环境，分支示意图：

```
-*(tag 2.1.0)--*(-> 2.2.0)(tag v2.2-test)--*--*--*--- master (即相当于 v2.2-dev 分支)
  \
    \--*--*(tag 2.1.1)--*(-> 2.1.2)(tag v2.1-test v2.1-prod)--*--*-- v2.1-dev

说明：一个星号代表一次 commit。
```
## git 操作步骤示例

```bash
# clone 仓库
git clone git@newcrm.nalashop.com:/home/git/web/nala-core

# 检出远程分支（一般都同名）
git checkout -b <local-branch-name> origin/<remote-branch-name>

# 切换（本地）分支（比如：public）
git checkout public

# 从远程更新该分支
git pull --all

# 花了N个小时做了某些修改，但是此时，可能其他人员已经向远程push新的代码了

# 修改后提交本地分支
git pull --all                       # 最好在本地commit前执行该语句，否则容易发生 平行四边形
git status
git add xxx
git commit -m "xxx"

# 提交到远程仓库
gitk
git pull --all                       # 如果在commit之后才 pull --all , 如果与远程存在冲突，在 git status 查看时，会有 需要merge 的文件
gitk                                 # 
git status                           # 查看是否需要merge的文件
# 1. git自动地 merge， 此时 git status 会显示没有需要 merge 的文件，自动生成 平行四边形
# 2. git无法自动 merge， 此时 git status 会显示有需要手动 merge 的文件 ： 下面是手动 merge 的步骤
    # 修改需要手动 merge 的文件
    git add xxx
    git commit -m "xx"               # commit之后，就会生成平行四边形

# 如果已生成 平行四边形，需要rebase。
    git rebase                       # 有 自动 rebase 和 手动 rebase 两种
        # 手动 rebase
        git branch -av               # 确认当前是在 rebase 创建的临时分支上
        # 修改需要 merge 的文件
        git add theMergedFile        # 告诉　git: 需要　merge 的文件已经修改完毕
        git rebase --continue        # 继续 rebase。 偶尔可能需要用到 git rebase --skip  ，后者是指本地虽然还有不同的文件，但是这些文件打算忽略。
        git branch -av               # 确认当前分支已经回到原有的分支（比如 public、master）
        gitk                         # 确认已经没有 平行四边形

# 推到远程
git push origin public:public

# 提交测试分支：从 pubic 分支提交到 2.2-test 分支（当前分支是public分支）
git pull
git push origin public:2.2-test

# 测试通过后，发布生产环境前，对该测试分支进行打标签
# 建议使用图形化工具gitk查看分支状态，但也可以使用 git log 命令，找到测试分支所指向的 commit。
gitk
# 打分支，并提交到远程仓库
git tag v2.2.0  c62426bd910xx6239021147497762029abde93xx    # 在指定的commit上打tag
git tag v2.2.0                                              # 在当前分支的当前commit上打tag
git push origin v2.2.0

# 检出tag
git tag -l
git checkout tags/2.2.0
``