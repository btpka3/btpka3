
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




# master-slave
[replication-howto](http://dev.mysql.com/doc/refman/5.1/en/replication-howto.html)

1. master配置

    `vi my.cnf`
    
    ```cnf
    [mysqld]
    log-bin=mysql-bin
    server-id=1
    ```

1. slave配置

    `vi my.cnf`

    ```cnf
    [mysqld]
    server-id=2
    ```

1. 在master上创建用于Replication的用户。

   任何用户均可，需要有  REPLICATION SLAVE  权限。
   用户名和密码需要以明文的方式存储在 master.info 中，故最好单独创建一个这样的账户，赋予最小权限。

   ```sql
   CREATE USER 'repl'@'%.mydomain.com' IDENTIFIED BY 'slavepass';
   GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.mydomain.com';
   SHOW GRANTS;
   ```

1. 查看Master状态

    ```sql
    FLUSH TABLES WITH READ LOCK;
    SHOW MASTER STATUS;
    +------------------+-----------+--------------+------------------+-------------------+
    | File             | Position  | Binlog_Do_DB | Binlog_Ignore_DB | Executed_Gtid_Set |
    +------------------+-----------+--------------+------------------+-------------------+
    | mysql-bin.000029 | 424473475 | naladb       |                  |                   |
    +------------------+-----------+--------------+------------------+-------------------+
    1 row in set (0.00 sec)
    ```

1. 获取master快照备份。

    1. 使用 mysqldump

        ```sh
        # 参数 `--master-data` 会自动追加一条  `CHANGE MASTER TO` 语句到结果中的。
        mysqldump --all-databases --master-data > dbdump.db
        ```
    2. 

1. 在slave上恢复快照备份???

1. 在slave上设置master信息，并启动

    ```sql
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

