


# 内存规划

## 总内存计算公式

```
total_possible_used_memory 
    = server_buffers + total_per_thread_buffers
    = server_buffers + per_thread_buffers * max_connections
    =   (     tmp_table_size                    # (16M)临时表在内存中的大小。影响 group by 性能
            + query_cache_size                  # (0)查询缓存大小
            + key_buffer_size                   # (8M)MyISAM : 索引缓存大小
            + innodb_buffer_pool_size           # (128M)InnoDB : 数据和索引缓存大小
            + innodb_additional_mem_pool_size   # (8M)InnoDB : 用于存储数据字典和内部结构的内存大小
            + innodb_log_buffer_size            # (8M)InnoDB : 用于把二进制日志写入磁盘的内存大小
        ) + ( 
              sort_buffer_size                  # (256K)排序时的缓存大小，影响 order by 性能
            + read_rnd_buffer_size              # (256K)无法完成内存排序时，会通过临时文件排序，设置读取排序后的row IDs的缓存大小，order by 性能
            + read_buffer_size                  # (128K)顺序读取表所有记录时的缓存大小
            + thread_stack                      # (256K)每个线程的堆栈大小
            + join_buffer_size                  # (256K)记录集关联时的缓存大小
            + binlog_cache_size                 # (32K)二进制日志缓存大小。如果启用bin-log，且有支持事务的存储引擎，才会allocate。
        ) * max_connections                     # 如果要看实际用到的最大内存，可以替换为 Max_used_connections 的值进行计算。

```

计算预计总内存SQL语句

```sql
select  (
            (     @@tmp_table_size
                + @@query_cache_size
                + @@key_buffer_size
                + @@innodb_buffer_pool_size
                + @@innodb_additional_mem_pool_size
                + @@innodb_log_buffer_size
            ) + ( 
                  @@sort_buffer_size
                + @@read_rnd_buffer_size
                + @@read_buffer_size
                + @@thread_stack
                + @@join_buffer_size
                + @@binlog_cache_size
            ) * @@max_connections
        ) / ( 1024 * 1024 * 1024 )
        AS total_possible_used_memory ;
```

在线[JS计算](http://www.mysqlcalculator.com/)

# my.cnf示例

下列示例中，`##` 开头的行是从 MySQL 5.6 之后才有的。

```ini
# 注1：选项中的减号(dash)、下划线(underscore)可以相互替换。
# 注2：系统变量和命令行选项均可在 命令行或配置文件中设定。
# 注3：数值型的可以使用 'K','M','G' 作为单位，不区分大小写。
# 注4：对于boolean型的选项，前缀 '--disable'，'--skip' 与后缀 '=0' 含义相同。
#     从MySQL 5.5.10起，除了0,1之外，'ON','TRUE','OFF','FALSE'都可被当作boolean值，不区分大小写。

[mysqld]
port = 3306                                 # 监听端口
datadir = /data0/mysql                      # 数据库目录
socket = /data0/mysql/mysql.sock            # socket文件
user = mysql                                # 以哪个OS用户的身份运行
symbolic-links = 0                          # 禁止符号链接
external-locking = 0                        # 禁止外部加锁
skip-name-resolve                           # 不对ip地址反向解析为主机名。对用户登录授权影响——只能使用IP地址
max_connections = 1000                      # 客户端的最大连接数。
default-storage-engine = InnoDB             # 修改默认存储引擎
max_allowed_packet = 32M                    # 客户端通讯时，允许的最大数据包大小
table_open_cache = 10240                    # 允许打开表的最大数量
sql-mode = NO_ENGINE_SUBSTITUTION
performance_schema = 1                      # 启用 performance_schema

sort_buffer_size = 2M                       # 排序时的缓存大小，影响 order by 性能
read_rnd_buffer_size = 2M                   # 无法完成内存排序时，会通过临时文件排序，设置读取排序后的row IDs的缓存大小，order by 性能
read_buffer_size = 2M                       # 顺序读取表所有记录时的缓存大小
thread_cache_size = 24                      # 
join_buffer_size = 4M                       # 记录集关联时的缓存大小

tmp_table_size = 32M                        # 临时表在内存中的大小。影响 group by 性能
thread_stack = 512K

# query cache
query_cache_type = 1                        # 启用 query cache
query_cache_size = 4G                       # 查询缓存大小
query_cache_limit = 4M                      # 查询结果超过该大小，将不被缓存

# binary log
log-bin = mysql-bin                         # 二进制日志的主文件名
binlog-do-db = naladb                       # 二进制日志只记录naladb数据库的更改
max_binlog_size = 1G                        # 二进制日志文件大小
binlog_cache_size = 32K                     # 二进制日志缓存大小。如果启用bin-log，且有支持事务的存储引擎，才会allocate。
expire_logs_days = 7                        # 旧的二进制日志超过7天就会被删除
server-id = 80                              # 服务器ID，用于主从复制

# character set
character-set-server = utf8mb4              # 服务器端存储时，使用的字符集
collation-server = utf8mb4_unicode_ci       # 服务器端排序时，使用的排序方法
character-set-client-handshake = TRUE       # 如果客户端有设置字符集信息，就客户端字符集信息

# log
general-log = 0                             # 不记录普通日志
log-error = /var/log/mysql/error.log        # 错误日志
slow-query-log = 1                          # 记录慢查询
slow_query_log_file = /var/run/mysqld/mysqld-slow.log   # 慢查询日志 
long_query_time = 3                         # 执行时间超过该时间的查询都是慢查询。单位：秒

# MyISAM
key_buffer_size = 2G                        # MyISAM : 索引缓存大小
myisam_sort_buffer_size = 128M              # MyISAM : 修改表、或创建索引时的缓存大小
myisam-recover-options = BACKUP

# InnoDB  
innodb_file_format = barracuda              
innodb_compression_level = 6                ##

innodb_buffer_pool_size = 5G                # InnoDB : 数据和索引缓存大小
innodb_buffer_pool_instances = 5            # 将 innodb_buffer_pool_size 划分的区域数，以提高并发，尽量使每个区域都至少1G
innodb_additional_mem_pool_size = 8M        # InnoDB : 用于存储数据字典和内部结构的内存大小

innodb_use_native_aio = 1                   # 仅对Linux系统有效，且默认就已经开启
innodb_file_per_table = 1                   # 新建或者alter table会使相关表的数据、索引从系统表空间中移除，并存储为一个单独的 *.idb 文件

innodb_log_file_size = 48M                  # InnoDB : 二进制日志单个文件的大小
innodb_log_files_in_group = 2               # InnoDB : 二进制日志文件数量
innodb_log_buffer_size = 8M                 # InnoDB : 用于把二进制日志写入磁盘的内存大小
innodb_doublewrite = 1                      # InnoDB : 将数据写入两次

innodb_flush_log_at_trx_commit = 1          # 完全兼容ACID。事务提交时，总是写入log_buffer，并且将其flush到硬盘上。
sync_binlog = 0                             # 是否使用特别的代码确保binlog同步到磁盘，否则依赖于OS


innodb_thread_concurrency = 24
innodb_write_io_threads = 24
innodb_read_io_threads = 24
innodb_io_capacity = 1000                   # 与磁盘性能(IOPS)有关系
innodb_adaptive_flushing = 1
innodb_flush_method = O_DIRECT              ##
innodb_lru_scan_depth=1024                  ##
```

# 配置文件调整

因为依靠配置文件记录修改差别，对于后续人员接手维护还是有点麻烦的：

* 配置文件中可以随意调整顺序，追加注释
* 配置文件中可能不少明确写明的选项，其值就是默认值
* 选项的下划线和减号可相互替换
* 数值选项的K,M,G等单位也不区分大小写
* boolean选项的表达方式有多种，也不区分大小写

因此，不方便差分。


下面就统一在使用不同配置文件时，通过 `mysqld --verbose --help` 的结果作为差分依据。
但是需要注意，该结果中，有部分选项其实是由同一个选项配置的。

如果不想重启服务器，除了要修改配置文件以外，还需要通过 `SET` 命令设置。  MySQL 运行时的变量值可以通过 `mysqladmin variables` 给出。



## 记录方法：

```
# 0. 确认读取的配置文件列表
mysqld --verbose --help | less
    # 第13、14行会给出读取顺序，5.5.40-0ubuntu0.12.04.1-log 的如下所示
    /etc/my.cnf /etc/mysql/my.cnf /usr/etc/my.cnf ~/.my.cnf
ll /etc/my.cnf /etc/mysql/my.cnf /usr/etc/my.cnf ~/.my.cnf 2>/dev/null

# 1. 导出默认程序自带的默认选项值
mysqld --no-defaults --verbose --help > my.default.cnf

# 2. 导出当前配置文件下的选项值
mysqld --verbose --help > my.cur.cnf

# 3. 差分结果并做笔记
diff my.default.cnf my.cur.cnf 
vi -d my.default.cnf my.cur.cnf
```

## 数据库环境
 
|          |test.86|prod.80|
|----------|----|----|
|CPU       |AMD Athlon(tm) II X2 245 Processor * 2 | Intel(R) Xeon(R) CPU E5-2620 v2 @ 2.10GHz * 24|
|RAM       |4G                                     |32G|
|DISK IOPS |135.78                                 |1521.04|
|OS        |Ubuntu 12.04.4 LTS                     |CentOS release 6.5 (Final)|
|MySQL     | 5.5.40-0ubuntu0.12.04.1-log for debian-linux-gnu on x86_64 ((Ubuntu))|mysqld  Ver 5.6.20 for Linux on x86_64 (MySQL Community Server (GPL))|


## 差别

|mysqld --verbose --help |default                             |test.86  |prod.80 |
|------------------------|------------------------------------|---------|---------|
|back-log                |80                                  |         |250|
|character-set-server    |latin1                              |utf8mb4  |utf8mb4|
|collation-server        |latin1_swedish_ci                   |utf8mb4_unicode_ci |utf8mb4_unicode_ci|
|datadir                 |/var/lib/mysql/                     |          |/data0/mysql/| 
|expire-logs-days        |0                                   |3 |7|
|general-log-file        |/var/lib/mysql/lizi80.log           ||/data0/mysql/lizi80.log|
|host-cache-size         |279                                 ||653|
|innodb-buffer-pool-instances|0                               ||5|
|innodb-buffer-pool-size |128M                                |512M |5G|
|innodb-file-format      |Antelope                            |barracuda|barracuda|
|innodb-flush-method     |(No default value)                  ||O_DIRECT|
|innodb-file-per-table   |FALSE                               |TRUE|TRUE    |
|innodb-io-capacity      |200                                 | |1000|
|innodb-log-file-size    |48M                                 | |48M|
|innodb-read-io-threads  |4                                   ||24|
|innodb-thread-concurrency|0                                  ||24|
|innodb-write-io-threads |4                                   ||24|
|join-buffer-size        |128K                                |512K|4M|
|key-buffer-size         |8M                                  |256M|2G|
|log-bin                 |(No default value)                  |mysql-bin|mysql-bin|
|log-error               |                                    |/var/log/mysql/error.log|/var/log/mysql/error.log|
|log-slow-queries        |/var/lib/mysql/${hostname}-slow.log |/var/log/mysql/mysql-slow.log||
|long-query-time         |10                                  |3|3|
|max-allowed-packet      |1M                                  |16M|32M|
|max-connections         |151                                 |500|1000|
|max-long-data-size      |1M                                  |16M|-|
|myisam-recover-options  |OFF                                 |BACKUP|BACKUP|
|myisam-sort-buffer-size |8M                                  |128M|128M|
|performance-schema      |FALSE                               |TRUE|TRUE|
|pid-file                |/var/lib/mysql/lizi80.pid           ||/data0/mysql/lizi80.pid|
|query-cache-limit       |1M                                  |4M|4M|
|query-cache-size        |0, 1M                               |16M|4G|
|query-cache-type        |OFF                                 ||ON|
|read-buffer-size        |128K                                |512K|2M|
|read-rnd-buffer-size    |256K                                |512K|2M|
|server-id               |0                                   |86|80|
|skip-name-resolve       |FALSE                               |TRUE|TRUE|
|slow-query-log          |FALSE                               |TRUE|TRUE|
|slow-query-log-file     |/var/lib/mysql/${hostname}-slow.log |/var/log/mysql/mysql-slow.log|/var/run/mysqld/mysqld-slow.log|
|socket                  |/var/lib/mysql/mysql.sock           ||/data0/mysql/mysql.sock| 
|sort-buffer-size        |256K                                |512K|2M|
|sql-mode                |                                    |NO_ENGINE_SUBSTITUTION             |NO_ENGINE_SUBSTITUTION |
|symbolic-links          |TRUE                                |FALSE|FALSE|
|table-definition-cache  |1400                                ||2000|
|table-cache             |400                                 |10240|-| 
|table-open-cache        |400, 2000                           |10240|10240| 
|thread-cache-size       |0, 9                                |8|24|
|thread-stack            |256K                                |512K|512K|
|tmp-table-size          |16M                                 ||32M|








