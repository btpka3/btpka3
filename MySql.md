
# 存储引擎

* MyISAM

    * 每张表被存为3个文件。*.frm —— 表格定义文件，*.MYD——数据文件，*.MY——索引文件
    * 查询快
    * 不支持事务
    * 不支持外键
    * 支持全文索引

* InnoDB

    * 从 5.5.5 开始是默认引擎。
    * 更新快
    * 支持事务
    * 支持外键
    * 不支持全文索引


## 查看

```sql

-- 查看所支持的引擎和默认值
show engines

-- 查看既有表和对应的引擎
select table_name, engine from INFORMATION_SCHEMA.TABLES where table_schema = 'myDb';
```


## 修改

持久修改默认引擎： `vi  /etc/my.cnf`，重启生效：

```cnf
[mysqld]
default-storage-engine=MyISAM
```
临时修改默认引擎，重启失效。

```sql
SET GLOBAL storage_engine='MyISAM';
SET SESSION storage_engine='MyISAM';
```

修改既有表的引擎

``` sql
ALTER TABLE t ENGINE = MYISAM;
```




# 备份与恢复
1. 要用bin-log。
1. 要定期全量备份，且记录该对应bin-log的File和Position。
1. 清除较旧的bin-log前，要确保全量备份已经包含该bin-log中的内容。
1. 恢复时，需要：
    1. 恢复全量备份
    1. 在增量从bin-log中从全量的位置开始，恢复到故障发前的position或日期，参考[这里](http://dev.mysql.com/doc/refman/5.6/en/point-in-time-recovery.html)。
1. 如果在master-slave模式上进行备份和回滚，对应bin-log的File和Position可以通过 `SHOW slave STATUS` 获取，备份前可以 `STOP SLAVE`（而不必像在master上那样必须先锁表）。



# master-slave
[replication-howto](http://dev.mysql.com/doc/refman/5.6/en/replication-howto.html)。replication可以做什么？

* 读写分离。所有更新都在master上进行，slave上只进行读取操作，减轻master的压力。
* 数据安全。全量备份数据时，可以在slave上进行，避免中断正在提供服务的master。
* 统计分析。对大量历史数据进行统计分析时，可以在slave上进行。
* 长距离数据分配。比如：可以在开发环境中通过slave访问到线上数据，而无需获得对master的访问权限。


## 查看Master状态

1. 在session1中获取一个读锁，这会阻塞写操作， InnoDB 表还会阻塞 COMMIT 操作。

    ```sql
    FLUSH TABLES WITH READ LOCK;
    ```

1. 在session2中查看MASTER的状态，并记录 `File` 和 `Position` 的值
 
    ```sh
    mysql -p -e "SHOW MASTER STATUS" > start_status.txt
    ```


    示例结果：

    ```sql
    SHOW MASTER STATUS;
    +------------------+-----------+--------------+------------------+-------------------+
    | File             | Position  | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
    +------------------+-----------+--------------+------------------+-------------------+
    | mysql-bin.000029 | 424473475 | naladb       |                  |                   |
    +------------------+-----------+--------------+------------------+-------------------+
    1 row in set (0.00 sec)
    ```

1. （可选）通过raw文件备份数据库

    ```sh
    tar cf /tmp/db.tar ./data
    # date ; tar cf mysql.tar ./mysql ; date 
    ```

1. 配合相应的时机，在session1中释放所有读锁

    ```sql
    UNLOCK TABLES;
    ```



## 对于在master中已经有数据的主从配置步骤

初始状态：master在运行，slave未运行。


1. master配置 : `vi my.cnf`，如果尚未配置，则修改后需要重启。
    
    ```cnf
    [mysqld]
    log-bin=mysql-bin
    server-id=1
    binlog-do-db=xxxDb   # 可选，只有启动bin-log的数据库才能完成replication
    ```

1. slave配置 : `vi my.cnf`

    ```cnf
    [mysqld]
    server-id=2
    relay-log=relay-log
    replicate-do-db=db_name                  # 可选 
    replicate-ignore-db=db_name              # 可选
    replicate-do-table=db_name.tbl_name      # 可选 
    replicate-ignore-table=db_name.tbl_name  # 可选
    # 注意：master-xxx参数从5.5开始被移除了，从5.6开始如果还有该参数，会启动报错。这些参数只能通过 CHANGE MASTER TO 命令完成。
    ```

1. 在master上创建用于Replication的用户。

   任何用户均可，需要有  REPLICATION SLAVE  权限。
   用户名和密码需要以明文的方式存储在 master.info 中，故最好单独创建一个这样的账户，赋予最小权限。

   ```sql
   CREATE USER 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
   GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.mydomain.com';
   SHOW GRANTS;
   ```

1. 使用 mysqldump 获取master快照备份，并在slave上恢复。

    ```sh
    # 在master上
    # 参数 `--master-data` 会自动追加一条  `CHANGE MASTER TO` 语句到结果中的。
    mysqldump --all-databases --master-data > dbdump.db

    # 在slave上
    mysql < dbdump.db
    ```

1. 使用 raw 文件（MyISAM）获取master快照备份，并在slave上恢复。
(InnoDB需要停止服务器，故不建议使用该方式)

    1. 确保以下变量在master和slave上一致。

    ```sql
    show variables where variable_name in ('ft_stopword_file', 'ft_min_word_len', 'ft_max_word_len');
    ```
    1. 参考前面的 "查看Master状态"，以获取master的状态并备份raw文件。
    1. 将备份文件加压到slave机器上
    1. 使用 `--skip-slave-start` 参数启动slave

1. 在slave上设置master信息，并启动

    ```sql
    RESET SLAVE  -- 可选
    CHANGE MASTER TO
        MASTER_HOST     = 'master_host_name',
        MASTER_USER     = 'replication_user_name',
        MASTER_PASSWORD = 'replication_password',
        MASTER_LOG_FILE = 'recorded_log_file_name',
        MASTER_LOG_POS  = recorded_log_position;
    START SLAVE;
    ```

1. 在slave上确认状态

    ```sql
    show slave status \G
    ```

1. 如果同步出现问题，可以参考[这里](http://dev.mysql.com/doc/refman/5.0/en/replication-problems.html)进行排查。如果在 slave 上执行`show slave status \G`，且结果中 Slave_SQL_Running 为 No 时，可以。

    1. master: `show master status`，并记下 File 和 Position的值。
    1. slave : `stop slave`
    1. slave : `RESET SLAVE`         -- ??? 请自行斟酌是否使用
    1. slave : `CHANGE MASTER TO ...`
    1. slave : `start slave`


# my.cnf

```cnf
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

# JDBC : stream resultset

MySQL的游标方式读取大数据量是有一些限制的：

1. 当前连接没处理完数据集，是不能执行其他查询操作的．
1. 必须把ResultSet#close()掉，否则必须会：　
    ```
    Streaming result set com.mysql.jdbc.RowDataDynamic@4447393f is still active. No statements may be issued when any streaming result sets are open and in use on a given connection. Ensure that you have called .close() on any active streaming result sets before attempting more queries.
    ```

FIXME: 仅仅MySQL会有这样的问题？