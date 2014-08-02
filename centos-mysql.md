[参考](http://dev.mysql.com/doc/mysql-repo-excerpt/5.6/en/linux-installation-yum-repo.html)


```
wget http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm
yum localinstall mysql-community-release-el6-5.noarch.rpm
yum repolist enabled | grep mysql
yum install mysql-community-server
service mysqld start
```


```sql
select  STR_TO_DATE('2014-07-15 12:13:14', '%Y-%m-%d %k:%i:%s')
```