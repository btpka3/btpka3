[参考](http://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html)


```
# wget http://repo.mysql.com/mysql-community-release-el5-5.noarch.rpm
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
yum localinstall mysql-community-release-el6-5.noarch.rpm
yum repolist enabled | grep mysql
yum install mysql-community-server
service mysqld start
```


```sql
select  STR_TO_DATE('2014-07-15 12:13:14', '%Y-%m-%d %k:%i:%s')
```

# 修改最大连接数

```sh
vi /etc/mysql/my.cnf

root登录本地mysql
set global max_connections=1000;
```

# 用户 && 权限

```sh
create user 'btpka3'@'%' identified by '123456';
grant all on testdb.* to 'btpka3'@'%';
FLUSH PRIVILEGES;

```

# 字符集 utf8mb4

utf8mb4 是在 mysql 5.5.3 之后才支持的。MySql中utf8字符集允许的最大长度是3个字节。
但 emoji 表情符号等的UTF8编码则是4个字节，会出错：
```
java.sql.SQLException: Incorrect string value: '\xF0\x9F\x98\x98' for column 'content' at row 1
```



```sql
-- 检查服务器的版本
status
SHOW VARIABLES LIKE "%version%";

-- 检查服务器端支持的字符集
show variables like 'char%';

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

