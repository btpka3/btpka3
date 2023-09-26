# yum 安装

统一安装版本为：mysql-community-server-5.6.20

注意：从 [5.5.5](http://dev.mysql.com/doc/refman/5.5/en/innodb-default-se.html) 开始，默认的存储引擎已经改为 InnoDB。

[安装参考](http://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html)

## 查看是否已经安装

```bash
# 查询是否已经安装了mysql的相关RPM包
rpm -qa | grep -i mysql

# 查看相关安装后的文件
updatedb
locate mysql | less

# 如果需要卸载先前通过yum/rpm安装的，可以
rpm -e xxxx
```

## 使用 MySQL的yum源进行安装

```bash
# 为CentOS 5.x 获取MySQL的yum源
# wget http://repo.mysql.com/mysql-community-release-el5-5.noarch.rpm

# 为CentOS 6.x 获取并安装MySQL的yum源
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
rpm -ivh localinstall mysql-community-release-el6-5.noarch.rpm

# 确认是否已经启用了mysql的yum源
yum repolist enabled | grep mysql

# 查看可用的mysql版本列表
yum --showduplicates list mysql-community-server

# 安装 5.6.20 版 mysql
yum install mysql-community-server-5.6.20
```

## mysql 配置文件 /etc/my.cnf

参考 [option-files](http://dev.mysql.com/doc/refman/5.6/en/option-files.html)。
其中server可以配置的参数值参考[这里](http://dev.mysql.com/doc/refman/5.6/en/innodb-parameters.html)

```ini
[client]                                            # 应用于所有MySQL客户端
port                    = 3306
socket                  = ${datadir}/mysql.sock     # 除了mysqld、其他程序连接的socket
secure-auth             = OFF                       # 使用旧的密码HASH算法
default-character-set   = utf8mb4                   # 默认字符集

[mysqld]
port                    = 3306
user                    = mysql                     # 以哪一个用户启动mysql数据库
pid-file                = ${datadir}/mysql.pid      # PID 文件的位置
socket                  = ${datadir}/mysql.sock     # socket文件的位置
basedir                 = /usr                      # MySQL的安装目录
datadir                 = ${datadir}                # 默认数据目录
tmpdir                  = /tmp
default-storage-engine  = MyISAM                    # 默认存储引擎

default-authentication-plugin   = mysql_native_password
secure-auth             = OFF                       # 登录是使用老的认证协议，主要配合密码HASH长度。

max_connections         = 3072                      # 允许的最大连接数
symbolic-links          = 0                         # 禁用符号链接
skip-name-resolve       = ON                        # GRANT语句仅仅使用ip地址和 "localhost"
skip-external-locking                               #

server-id               = 90                        # 整数，通常为ip段最后一位
log-bin                 = mysql-bin                 # 二进制日志的文件路径和基础文件名（不含后缀）
expire_logs_days        = 0                         # 二进制日志flush多少天后删除


thread_cache_size       = 32                        # 应当缓存多少个线程以备重用
key_buffer_size         = 16M                       # 读MyISAM表的索引的buffer的大小
myisam_sort_buffer_size = 8M                        # 对MyISAM表的索引进行排序的buffer的大小
net_buffer_length       = 16K                       # client线程关于连接和结果buffer的大小
max_allowed_packet      = 4M                        # package的最大大小，必须是1024整倍数
sort_buffer_size        = 512K                      # 排序用的buffer size
read_buffer_size        = 256K                      # 对MyISAM表进行顺序读取时buffer的大小
read_rnd_buffer_size    = 512K                      # 对MyISAM表进行排序时buffer的大小，每个Client一个
query_cache_limit       = 8M                        # 查询结果大于该大小的，将不被缓存
query_cache_size        = 64M                       # 用以缓存查询结果的内存空间
query_cache_type        = 1                         # 是否缓存查询结果，不影响 query_cache_size 内存的开辟
sql_mode                = NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES

collation-server        = utf8mb4_unicode_ci        # 字符串排序规则
character-set-server    = utf8mb4                   # 服务器的默认字符集
character-set-client-handshake  = TRUE              # 是否使用客户端指定的字符集


log-error               = error.log                 # 错误日志文件
log-output              = FILE                      # 日志的输出目标
slow-query-log          = ON                        # 是否记录慢查询
slow-query-log-file     = slow-query.log            # 慢查询日志位置
log-queries-not-using-indexes   = ON                # 是否记录没有使用索引的查询

performance_schema      = ON                        # 启用 performance schema





[mysqldump]
quick                                               # 按条从服务器端获取数据，而非按表。
max_allowed_packet = 16M                            # 最大的buffer size


[mysqld_safe]
nice = 0

[mysql]
no-auto-rehash                                      # 禁用自动提示（命令行tab键），可提高速度
```

## 初始化数据目录

```bash
# 查看分区信息，根据大小制订合理的数据目录
df -h

# 初始化数据目录（默认是 /var/lib/mysql）
mysql_install_db --user=mysql --datadir=/data/mysql

# 上述命令默认会创建以下文件
ibdata1
ib_logfile0
ib_logfile1
mysql
performance_schema
```

## 安装后启动mysql

```bash
service mysqld start
```

## 创建用户

```sql
GRANT
ALL
ON naladb.* TO 'nalab2cdb'@'192.168.101.%' IDENTIFIED BY 'xxx';
GRANT ALL PRIVILEGES ON test.* TO
'root'@'localhost';
GRANT ALL PRIVILEGES ON test.* TO
'root'@'%';
```


# MacOS
```shell
brew install mysql-client
mysql \
  --host=mysql-server.default.svc.cluster.local \
  --database=smeta \
  --user=root \
  --execute='select * from smeta.uf_cluster_node'
```