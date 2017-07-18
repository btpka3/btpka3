[参考](https://wiki.postgresql.org/wiki/YUM_Installation)

[HA Streaming_replication](http://wiki.postgresql.org/wiki/Streaming_Replication)

## install

### centos 7

```
# 创建自定义的数据库初存储目录
mkdir /data0/pgsql/gitlab
chown -R postgres:postgres /data0/pgsql/gitlab/

# postgresql 默认使用指定的数据库存储目录
vi /usr/lib/systemd/system/postgresql-9.4.service
Environment=PGDATA=/data0/pgsql/gitlab

# 初始化数据库存储目录
/usr/pgsql-9.4/bin/postgresql94-setup initdb postgresql-9.4

systemctl daemon-reload
systemctl status postgresql-9.4
```


### 修改数据库配置文件

```
[root@s01 ~]# vi /var/lib/pgsql/9.1/data/pg_hba.conf
# 修改以下一行（可以方便pg_dump时不用输入密码——仅限本地执行）
local   all             all                                     peer  map=srsPgMap
# 追加以下一行（允许指定的IP段连接数据库）
host    all             all             192.168.0.1/24           md5

# 修改系统用户与数据库用户的映射关系（方便pg_dump时不用输入密码）
[root@s01 ~]# vi /var/lib/pgsql/9.1/data/pg_ident.conf
# MAPNAME       SYSTEM-USERNAME         PG-USERNAME
srsPgMap        postgres                postgres
srsPgMap        postgres                autotrading
srsPgMap        postgres                mocktrading

```



## psql

```
# 显示psql命令行帮助
postgres-# \?

# 退出
postgres-# \q

# 切换DB
postgres-# \c dbName
# 显示创建数据库的语法
postgres-# \h CRATE DATABASE
# 列出所有数据库及其拥有者和权限（具体哪个字母代表什么权限，请参考grant的语法说明文档）
postgres-# \l
# 列出所有数据库
postgres-# SELECT DTNAME FORM PG_DATABASE;

postgres-# \d+; # 列出所有表
postgres-# SELECT * FROM PG_TABLES; # 列出所有表

postgres-# \d+ tableName; # 显示表的详细信息
postgres-# SELECT * FROM INFORMATION_SCHEMA.TABLES; # 显示表的详细信息

postgres-# SELECT * FROM PG_USER; # 列出所有用户
postgres-# SELECT * FROM PG_SHADOW;

# 删除所有表
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

## LOB
### JDBC
[binary-data](http://jdbc.postgresql.org/documentation/80/binary-data.html)

```sql
CREATE TABLE imageslo (imgname text, imgoid oid);
```

* 插入

    ```java
    // All LargeObject API calls must be within a transaction block
    conn.setAutoCommit(false);

    // Get the Large Object Manager to perform operations with
    LargeObjectManager lobj = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();

    // Create a new large object
    int oid = lobj.create(LargeObjectManager.READ | LargeObjectManager.WRITE);

    // Open the large object for writing
    LargeObject obj = lobj.open(oid, LargeObjectManager.WRITE);

    // Now open the file
    File file = new File("myimage.gif");
    FileInputStream fis = new FileInputStream(file);

    // Copy the data from the file to the large object
    byte buf[] = new byte[2048];
    int s, tl = 0;
    while ((s = fis.read(buf, 0, 2048)) > 0) {
        obj.write(buf, 0, s);
        tl += s;
    }

    // Close the large object
    obj.close();

    // Now insert the row into imageslo
    PreparedStatement ps = conn.prepareStatement("INSERT INTO imageslo VALUES (?, ?)");
    ps.setString(1, file.getName());
    ps.setInt(2, oid);
    ps.executeUpdate();
    ps.close();
    fis.close();

    // Finally, commit the transaction.
    conn.commit();
    ```

* 读取

    ```java
    // All LargeObject API calls must be within a transaction block
    conn.setAutoCommit(false);

    // Get the Large Object Manager to perform operations with
    LargeObjectManager lobj = ((org.postgresql.PGConnection)conn).getLargeObjectAPI();

    PreparedStatement ps = conn.prepareStatement("SELECT imgoid FROM imageslo WHERE imgname = ?");
    ps.setString(1, "myimage.gif");
    ResultSet rs = ps.executeQuery();
    while (rs.next()) {
        // Open the large object for reading
        int oid = rs.getInt(1);
        LargeObject obj = lobj.open(oid, LargeObjectManager.READ);

        // Read the data
        byte buf[] = new byte[obj.size()];
        obj.read(buf, 0, obj.size());
        // Do something with the data read here

        // Close the object
        obj.close();
    }
    rs.close();
    ps.close();

    // Finally, commit the transaction.
    conn.commit();
    ```

### pg_largeobject、pg_largeobject_metadata 中的记录没有删除？
当使用oid字段存储blob时（比如使用JPA+@Lob自动创建相关的表时），发现仅仅删除用户表中的记录，pg_largeobject、pg_largeobject_metadata中的large object还是没有删除。官方文档给出的一个方法是使用[lo](http://www.postgresql.org/docs/9.1/static/lo.html)模块并使用trigger。
FIXME：trigger影响效率，且有时会失效？应该使用定时任务处理？

### Object Permissions
[9.0 release note](http://www.postgresql.org/docs/9.0/static/release-9-0.html#AEN101496)
[grant syntax](http://www.postgresql.org/docs/9.0/static/sql-grant.html)
```sql
GRANT { { SELECT | UPDATE } [,...] | ALL [ PRIVILEGES ] }
    ON LARGE OBJECT loid [, ...]
    TO { [ GROUP ] role_name | PUBLIC } [, ...] [ WITH GRANT OPTION ]
```

如果不需要对largeObject进行权限控制，则可以将[lo_compat_privileges](http://www.postgresql.org/docs/9.0/interactive/runtime-config-compatible.html#GUC-LO-COMPAT-PRIVILEGES)设置为`on`（默认是`off`）。该配置项位于postgre配置文件中，可以通过`show config_file`查看配置文件路径。



查询哪些用户有多少个largeObject
```sql
select t.lomowner as userOid, p.rolname, t.count
from (select lomowner as lomowner, count(*) as count from pg_largeobject_metadata group by lomowner ) t,
     pg_authid p
where t.lomowner = p.oid
--pg_authid的oid字段就是用户的oid
--pg_largeobject_metadata的oid就是largeObject的oid
```

整理largeObject
```sql
Vacuumlo –n –v dbName
Vacuum analyze verbose pg_largeobject;
Vacuum analyze verbose pg_largeobject_metadata;

```

```sql
DROP DATABASE IF EXISTS xxx
DROP TABLESPACE IF EXISTS xxx;;
DROP USER IF EXISTS xxx;

CREATE USER xxx PASSWORD 'password';
ALTER USER xxx WITH SUPERUSER;

mkdir /data/database/xxx
chown -R postgres:postgres /data/database/xxx
CREATE TABLESPACE xxx OWNER xxx LOCATION '/data/database/xxx';
CREATE DATABASE xxx WITH OWNER = xxx TABLESPACE = xxx ENCODING = 'UTF-8';

```

## ddl diff
http://apgdiff.com/how_to_use_it.php
