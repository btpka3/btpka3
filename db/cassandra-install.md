
GUI客户端工具 [DBeaver](http://dbeaver.jkiss.org/)

http://www.datastax.com/documentation/cassandra/2.1/cassandra/initialize/initializeSingleDS.html

# CentOS 安装

参考[这里](http://www.datastax.com/documentation/cassandra/2.0/cassandra/install/installRHEL_t.html)

## 前提条件

1. 已经安装了 JDK 1.7+
1. 已经安装了 Python 2.6+
1. 已经安装了 JNA 3.2.7+   （Java Native Access）

## 配置yum仓库

`vi /etc/yum.repos.d/datastax.repo`，内容如下：

```
[datastax]
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 0
```

## 安装

```
yum install dsc21 cassandra21
vi /etc/init.d/cassandra            # 在最开始追加以下配置文件
    . /etc/profile.d/lizi.sh        # 该sh脚本中包含JAVA_HOME等环境变量配置
```

RPM安装后的一些默认路径：

|path|description|
|---|---|
|/etc/cassandra/conf          |CAASSANDRA_CONF |
|/usr/share/cassandra         |CASSANDRA_HOME|
|/var/lib/cassandra/data      |CASSANDRA_DATA |
|/var/lib/cassandra/commitlog |CASSANDRA_COMMITLOG|

`vi /etc/cassandra/conf/cassandra.yaml`

```
listen_address: 192.168.101.80
```


## 启动 (默认配置)

```
service cassandra start
```

## 使用cql访问

cql介绍请参考[这里](http://cassandra.apache.org/doc/cql3/CQL.html)


## 修改默认认证方式
参考[这里](http://www.datastax.com/documentation/cassandra/2.1/cassandra/security/security_config_native_authenticate_t.html)。

1. `vi /etc/cassandra/conf/cassandra.yaml`

    ```yaml
    # 修改 authenticator ： AllowAllAuthenticator -> PasswordAuthenticator
    authenticator: PasswordAuthenticator
    ```
1. 增加 system_auth keyspace的复制因子（默认为1）
1. 重启 Cassandra 客户端。默认超级用户的为 cassandra/cassandra
1. 新建一个超级用户，设置复杂、难猜测的密码。

    ```bash
    cqlsh -u cassandra -p cassandra
    create user zhangll with password '123456' superuser;
    quit
    ```

1. 使用新的超级用户登录，并修改cassandra用户的密码

    ```bash
    cqlsh -u zhangll -p 123456
    alter user cassandra with password '(*(JHJ(*&*GHdf';
    -- ...
    ```

## 修改默认授权方式
参考[这里](http://www.datastax.com/documentation/cassandra/2.1/cassandra/security/secure_config_native_authorize_t.html)。

1. `vi /etc/cassandra/conf/cassandra.yaml`

    ```yaml
    # 修改 authorizer ：  AllowAllAuthorizer -> CassandraAuthorizer
    authorizer: CassandraAuthorizer

    # 修改 permissions_validity_in_ms 的值为一个合理值
    ```
1. 增加 system_auth keyspace的复制因子（默认为1）




