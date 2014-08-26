[参考](http://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html)


```
# wget http://repo.mysql.com/mysql-community-release-el5-5.noarch.rpm
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
rpm -ivh localinstall mysql-community-release-el6-5.noarch.rpm
yum repolist enabled | grep mysql
yum install mysql-community-server
service mysqld start

# 如果启动出错，说user.frm 执行无权限，则需要执行：
mysql_install_db --user=mysql --datadir=/data/mysql  # datadir 默认是 /var/lib/mysql
# 之后修改/etc/my.cnf

```


```sql
select  STR_TO_DATE('2014-07-15 12:13:14', '%Y-%m-%d %k:%i:%s')
```

# my.cnf 示例

```cnf
[client]
default-character-set = utf8mb4         # 除了mysqld、其他程序连接时使用的默认字符集
socket=/data/mysql/mysql.sock           # 除了mysqld、其他程序连接的socket
secure_auth=OFF                         # 使用旧的密码HASH算法

[mysql]
default-character-set = utf8mb4         # mysql程序在启动时的默认字符设定

[mysqld]
datadir=/data/mysql
socket=/data/mysql/mysql.sock
user=mysql
server-id=90
log_bin=/data/mysql/mysql-bin.log
symbolic-links=0
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
explicit_defaults_for_timestamp=true
old_passwords=1          # 密码hash值使用旧的格式（长度较短）
secure_auth=OFF          # 登录是使用老的认证协议，主要配合密码HASH长度。

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
```

# 重置、更新root的密码为最新格式
重置密码参考[这里](http://dev.mysql.com/doc/refman/5.5/en/resetting-permissions.html)、更新密码格式参考[这里](http://code.openark.org/blog/mysql/upgrading-passwords-from-old_passwords-to-new-passwords)

```txt
# 1. 停止mysql服务器
service mysqld stop
# 2. 编辑文本文件 /tmp/pwd.txt，并设置新密码

Set session old_passwords=1;  -- 1:使用新格式，使用较长的密码HASH
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('123456');
--UPDATE mysql.user SET Password=PASSWORD('123456') WHERE User='root';
FLUSH PRIVILEGES;

# 3. 将该文本作为初始化脚本启动mysqld
mysqld --init-file=/tmp/pwd.txt &

# 4. 删除 /tmp/pwd.txt
```





# 修改最大连接数

```sh
vi /etc/mysql/my.cnf

root登录本地mysql
set global max_connections=1000;
```

# mysql 重新更新root密码





# 用户 && 权限

```sh
create user 'btpka3'@'%' identified by '123456';
grant all on testdb.* to 'btpka3'@'%';
FLUSH PRIVILEGES;

```

# 字符集 utf8mb4

MySql中utf8字符集允许的最大长度是3个字节。
但 emoji 表情符号等的UTF8编码则是4个字节，会出错：
```
java.sql.SQLException: Incorrect string value: '\xF0\x9F\x98\x98' for column 'content' at row 1
```

[utf8mb4](http://dev.mysql.com/doc/refman/5.5/en/charset-unicode-utf8mb4.html) 是在 mysql 5.5.3 之后才支持的，每个字符允许的最大字节是4个字节。


查看编码

```sql
-- 检查服务器的版本 >=  5.5.3 
status
SHOW VARIABLES LIKE "%version%";

-- 检查服务器端支持的字符集
SHOW CHARACTER SET;

-- 检查服务器的字符集设置
show variables like 'char%';

-- 查看特定database/schema 的字符集设置
SELECT default_character_set_name FROM information_schema.SCHEMATA S
WHERE schema_name = "schemaname";

-- 查看特定表的字符集设置
SELECT CCSA.character_set_name FROM information_schema.`TABLES` T,
       information_schema.`COLLATION_CHARACTER_SET_APPLICABILITY` CCSA
WHERE CCSA.collation_name = T.table_collation
  AND T.table_schema = "schemaname"
  AND T.table_name = "tablename";

-- 查看特定列的字符集设置
SELECT character_set_name FROM information_schema.`COLUMNS` C
WHERE table_schema = "schemaname"
  AND table_name = "tablename"
  AND column_name = "columnname";


```

修改编码

```sql

-- utf8mb4_general_ci;
ALTER DATABASE <dbName> CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
ALTER TABLE account_detail CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 如果出现下面的1071错误，则是索引列太长了
-- ERROR 1071 (42000): Specified key was too long; max key length is 1000 bytes

-- 查看索引列表
show index from naladb.comment;
-- 查看索引定义DDL
mysqldump -d -u nalab2cdb -p mydb comment 
-- 重建索引（比如utf8mb4编码的varchar(255)是1020字节，用来建立索引会超过1000个字节）
alter table comment drop key FK38A5EE5F330F7244; 
alter table comment add key FK38A5EE5F330F7244 (user_id(250));
```


vi /etc/my.cnf

```cnf
[client]
default-character-set = utf8mb4

[mysql]
default-character-set = utf8mb4

[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
```

