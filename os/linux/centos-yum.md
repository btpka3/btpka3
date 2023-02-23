
# 常用命令

```bash
yum makecache

# 查看启用的yum仓库
yum repolist enabled

# 搜索
yum search xxx
yum search --showduplicates xxx
yum search --disablerepo="*" --enablerepo="epel" --showduplicates redis
yum --enablerepo=yyy xxx

# 查看详细信息
yum info xxx

# 列出依赖
yum deplist xxx

# 列出所有版本号
yum --showduplicates  list xxx

# 安装最新版本号
yum install mysql-community-server
yum install --disablerepo="*" --enablerepo="epel" redis

# 安装特定版本号
yum install mysql-community-server-5.6.20

# 查询谁提供了指定的文件
yum provides /path/to/your/file

# 卸载
yum remove package

# 查看 package 中有哪些文件
yum install -y yum-utils
repoquery -l package


# 查看本地配置了哪些仓库
yum repolist
```

# 缺点
1. yum在安装时，会更新已安装的依赖。
1. yum在安装时，无法忽略某个特定依赖。

# 使用代理


* 通过修改配置文件： `vi /etc/yum.conf`

    ```conf
    [main]
    proxy=socks5://172.17.0.1:9999
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

# 锁定版本

```bash
yum -y install yum-versionlock
# yum -y install yum-plugin-versionlock

yum versionlock add nginx
yum versionlock list
yum versionlock delete nginx
yum versionlock clear

yum check-update
yum check-update nginx
yum --showduplicates list nginx
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



# repo

## CentOS-Base.repo


文件内容： /etc/yum.repos.d/CentOS-Base.repo

```
# CentOS-Base.repo
#
# The mirror system uses the connecting IP address of the client and the
# update status of each mirror to pick mirrors that are updated to and
# geographically close to the client.  You should use this for CentOS updates
# unless you are manually picking other mirrors.
#
# If the mirrorlist= does not work for you, as a fall back you can try the
# remarked out baseurl= line instead.
#
#

[base]
name=CentOS-$releasever - Base - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/os/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/os/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/os/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#released updates
[updates]
name=CentOS-$releasever - Updates - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/updates/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/updates/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/updates/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that may be useful
[extras]
name=CentOS-$releasever - Extras - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/extras/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/extras/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/extras/$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-$releasever - Plus - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/centosplus/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/centosplus/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7

#contrib - packages by Centos Users
[contrib]
name=CentOS-$releasever - Contrib - mirrors.aliyun.com
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/$releasever/contrib/$basearch/
        http://mirrors.aliyuncs.com/centos/$releasever/contrib/$basearch/
        http://mirrors.cloud.aliyuncs.com/centos/$releasever/contrib/$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
```

## epel.repo

安装命令

```bash
yum -y install epel-release
```



文件内容 /etc/yum.repos.d/epel.repo


```
[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7

[epel-debuginfo]
name=Extra Packages for Enterprise Linux 7 - $basearch - Debug
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch/debug
metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-debug-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1

[epel-source]
name=Extra Packages for Enterprise Linux 7 - $basearch - Source
#baseurl=http://download.fedoraproject.org/pub/epel/7/SRPMS
metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-source-7&arch=$basearch
failovermethod=priority
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
gpgcheck=1
```
