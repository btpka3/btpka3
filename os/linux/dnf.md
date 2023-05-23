DNF是新一代的rpm软件包管理器。他首先出现在 Fedora 18 这个发行版中。而最近，它取代了yum，正式成为 Fedora 22 的包管理器。


```bash
yum install dnf
dnf --version
# 查看系统中可用的 DNF 软件库
dnf repolist
# 查看系统中可用和不可用的所有的 DNF 软件库
dnf repolist all
# 理出所有的 RPM 包
dnf list
# 列出所有安装了的 RPM 包
dnf list installed
# 列出所有可供安装的 RPM 包
dnf list available
# 搜索软件库中的 RPM 包
dnf search nano
# 查找某一文件的提供者
dnf provides /bin/bash
# 查看软件包详情
dnf info nano
# 安装软件包
dnf install nano
# 升级软件包
dnf update systemd
# 检查系统软件包的更新
dnf check-update
# 升级所有系统软件包
dnf update
dnf upgrade
# 删除软件包
dnf remove nano
dnf erase nano
# 删除无用孤立的软件包
dnf autoremove
# 删除缓存的无用软件包
dnf clean all
# 获取有关某条命令的使用帮助
dnf help clean
# 查看所有的 DNF 命令及其用途
dnf help
# 查看 DNF 命令的执行历史
dnf history
# 查看所有的软件包组
dnf grouplist
# 安装一个软件包组
dnf groupinstall 'Educational Software'
# 升级一个软件包组中的软件包
dnf groupupdate 'Educational Software'
# 删除一个软件包组
dnf groupremove 'Educational Software'
# 从特定的软件包库安装特定的软件
dnf -enablerepo=epel install phpmyadmin
# 更新软件包到最新的稳定发行版
dnf distro-sync
# 重新安装特定软件包
dnf reinstall nano
# 回滚某个特定软件的版本
dnf downgrade acpid

```

# DNF vs. YUM
- 在 DNF 中没有 –skip-broken 命令，并且没有替代命令供选择。
- 在 DNF 中没有判断哪个包提供了指定依赖的 resolvedep 命令
- 在 DNF 中没有用来列出某个软件依赖包的 deplist 命令
- 当你在 DNF 中排除了某个软件库，那么该操作将会影响到你之后所有的操作，不像在 YUM 下那样，你的排除操作只会咋升级和安装软件时才起作用。

