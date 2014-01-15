## psql

```txt
postgres-# \? # 显示psql命令行帮助
postgres-# \q # 退出
postgres-# \c dbName # 切换DB
postgres-# \h CRATE DATABASE # 显示创建数据库的语法

postgres-# \l # 列出所有数据库
postgres-# SELECT DTNAME FORM PG_DATABASE; # 列出所有数据库

postgres-# \d+; # 列出所有表
postgres-# SELECT * FROM PG_TABLES; # 列出所有表

postgres-# \d+ tableName; # 显示表的详细信息
postgres-# SELECT * FROM INFORMATION_SCHEMA.TABLES; # 显示表的详细信息

postgres-# SELECT * FROM PG_USER; # 列出所有用户

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
如果不需要对largeObject进行权限控制，则可以将[lo_compat_privileges](http://www.postgresql.org/docs/9.0/interactive/runtime-config-compatible.html#GUC-LO-COMPAT-PRIVILEGES)设置为`on`（默认是`off`）