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

    ```bash
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

    ```bash
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

    ```ini
    [mysqld]
    log-bin=mysql-bin
    server-id=1
    binlog-do-db=xxxDb   # 可选，只有启动bin-log的数据库才能完成replication
    ```

1. slave配置 : `vi my.cnf`

    ```ini
    [mysqld]
    server-id=2
    relay-log=relay-log
    replicate-do-db=db_name                  # 可选
    replicate-ignore-db=db_name              # 可选
    replicate-do-table=db_name.tbl_name      # 可选
    replicate-ignore-table=db_name.tbl_name  # 可选
    # 注意：master-xxx参数从5.5开始被移除了，从5.6开始如果还有该参数，会启动报错。这些参数只能通过 CHANGE MASTER TO 命令完成,比如：在命令行中执行 -- change master to master_host='192.168.101.86', master_user='s82', master_password='nalanala', master_log_file='mysql-bin.000159', master_log_pos=0;
    ```

1. 在master上创建用于Replication的用户。

   任何用户均可，需要有 REPLICATION SLAVE 权限。
   用户名和密码需要以明文的方式存储在 master.info 中，故最好单独创建一个这样的账户，赋予最小权限。

   ```sql
   CREATE USER 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
   GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.mydomain.com';
   SHOW GRANTS;
   ```

1. 使用 mysqldump 获取master快照备份，并在slave上恢复。

    ```bash
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

1. 如果同步出现问题，可以参考[这里](http://dev.mysql.com/doc/refman/5.0/en/replication-problems.html)进行排查。如果在
   slave 上执行`show slave status \G`，且结果中 Slave_SQL_Running 为 No 时，可以。

    1. master: `show master status`，并记下 File 和 Position的值。
    1. slave : `stop slave`
    1. slave : `RESET SLAVE`         -- ??? 请自行斟酌是否使用
    1. slave : `CHANGE MASTER TO ...`
    1. slave : `start slave`
