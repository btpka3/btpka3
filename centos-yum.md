

```sh
# 查看启用的yum仓库
yum repolist enabled

# 搜索
yum search xxx
yum --enablerepo=yyy xxx

# 查看详细信息
yum info xxx

# 列出依赖
yum deplist xxx

# 列出所有版本号
yum --showduplicates  list xxx

# 安装最新版本号
yum install mysql-community-server

# 安装特定版本号
yum install mysql-community-server-5.6.20

# 查询谁提供了指定的文件
yum provides /path/to/your/file
```

# 缺点
1. yum在安装时，会更新已安装的依赖。
1. yum在安装时，无法忽略某个特定依赖。

# 不使用依赖包安装


```sh
yum install yum-plugin-downloadonly

# 仅仅下载，而不安装
yum --downloadonly --downloaddir=/tmp/cache --enablerepo=remi --skip-broken install php-mysql

# 安装
yum --disablerepo=* --skip-broken install \*.rpm

```
