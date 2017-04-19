
# 常用命令

```bash
yum makecache

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

# 使用代理


* 通过修改配置文件： `\vi /etc/yum.conf`

    ```conf
    [main]
    proxy=socket5://172.17.0.1:9999 
    proxy_username=yum-user 
    proxy_password=qwerty
    ```
* 通过修改环境变量: 

    ```bash
    export http_proxy="http://mycache.mydomain.com:3128" 
    export https_proxy=$http_proxy
    export ftp_proxy=$http_proxy
    export no_proxy="127.0.0.1,localhost"
    ```

# 不使用依赖包安装


```bash
yum install yum-plugin-downloadonly

# 仅仅下载，而不安装
yum --downloadonly --downloaddir=/tmp/cache --enablerepo=remi --skip-broken install php-mysql

# 安装
yum --disablerepo=* --skip-broken install \*.rpm

```


# 光盘安装

```bash
# 挂载光驱
mkdir /media/cdrom 
mount /dev/cdrom /media/cdrom

#cd /etc/yum.repos.d 
#cp CentOS-Base.repo CentOS-Base.repo.bak
#vi CentOS-Media.repo  # 进行以下修改
#gpgcheck=0
#enabled=1 

# 禁用默认启用的几个仓库，并启用光盘源
yum --disalberepo=base,updates,extras\
--enablerepo=c7-media \
install firewalld
```