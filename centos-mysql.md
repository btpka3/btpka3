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


