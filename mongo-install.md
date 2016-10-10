## 参考
* [NoSQL性能测试白皮书](http://www.infoq.com/cn/articles/nosql-performance-test)
* [MongoDB核心贡献者：不是MongoDB不行，而是你不懂！](http://www.csdn.net/article/2012-11-15/2811920-mongodb-quan-gong-lue)
* [MongoDB：逐渐变得无关紧要](http://www.csdn.net/article/2015-01-14/2823551)
* [再见 MongoDB，你好 PostgreSQL](http://www.oschina.net/translate/goodbye-mongodb-hello-postgresql?from=20150322)

# 安装

## ubuntu
see [here](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/)

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install -y mongodb-org   # 安装最新版

sudo apt-get install -y \
    mongodb-org=2.6.1 \
    mongodb-org-server=2.6.1 \
    mongodb-org-shell=2.6.1 \
    mongodb-org-mongos=2.6.1 \
    mongodb-org-tools=2.6.1          # 安装特定版本


# 之后更新时总会自动更新mongodb的版本，可以使用以下命令固定版本号
echo "mongodb-org hold"        | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold"  | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold"  | sudo dpkg --set-selections

# 防止开机自启动
echo manual | sudo tee /etc/init/mongod.override
# rm  /etc/init/mongod.override  # 允许开机自启动

# 启停
sudo service mongod start
sudo service mongod stop
```




## 连接到数据库

```
mongo
```

## CentOS
centos 安装参考[这里](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-red-hat-centos-or-fedora-linux/)

### 环境准备

```
echo never >/sys/kernel/mm/transparent_hugepage/enabled
echo never >/sys/kernel/mm/transparent_hugepage/defrag
```

### 安装 mongodb 3.0
使用yum 安装有点冲突问题，先使用 CentOS 7 的预编译的二进制包进行解压安装，参考[这里](http://docs.mongodb.org/manual/tutorial/install-mongodb-on-linux/)

1. 下载、解压

    ```
    mkdir -p /usr/local/mongo
    tar zxvf mongodb-linux-x86_64-rhel70-3.0.0.tgz -C /usr/local/mongo
    ```

1. 配置环境变量 `vi /etc/profile.d/xxx.sh` :

    ```
    export MONGO_HOME=/usr/local/mongo/mongodb-linux-x86_64-rhel70-3.0.0
    export PATH=$MONGO_HOME/bin:$PATH
    ```

1. 创建运行所需的用户

    ```
    useradd mongod
    ```

1. 创建 systemd 所需的 service 文件 ` vi /usr/lib/systemd/system/mongod.service`

    ```
    [Unit]
    Description=MongoDB Server
    After=network.target

    [Service]
    User=mongod
    Group=mongod
    Type=forking

    PIDFile=/data0/mongod/mongod.pid
    ExecStartPre=
    ExecStart=/usr/bin/mongod -f /etc/mongod.conf
    ExecReload=/bin/kill -s HUP $MAINPID
    ExecStop=/bin/kill -s QUIT $MAINPID
    WorkingDirectory=/data0/mongod
    Restart=always

    LimitFSIZE=infinity
    LimitCPU=infinity
    LimitAS=infinity
    LimitNOFILE=64000
    LimitRSS=infinity
    LimitNPROC=64000

    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
    ```

 

### 安装 mongodb 2.6

1. 新建 yum 的仓库配置文件

    ```sh
    vi /etc/yum.repos.d/mongodb.repo
    ```
    文件内容如下：

    ```conf
    [mongodb]
    name=MongoDB Repository
    baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/
    gpgcheck=0
    enabled=1
    ```

1. 查看可用版本

    ```sh
    yum --showduplicates list mongodb-org       # 查看可用的版本
    yum install mongodb-org-2.6.6               # 明确指定版本号并安装
    ```

1. 修改配置文件

    ```sh
    df -h                                      # 根据磁盘状况，规划数据存储目录，日志目录。
    mkdir -p /home/mongod/log                  # 创建日志目录
    mkdir -p /home/mongod/db                   # 创建数据目录
    chown -R mongod:mongod /home/mongod        # 修改属主
    chmod 700 /home/mongod                     # 修改权限

    vi /etc/mongod.conf                        # 修改配置文件
    ```
    修改以下配置项：

    ```conf
    logpath=/home/mongod/log/mongod.log        # 日志路径。（默认：/var/log/mongodb/mongod.log）
    dbpath=/home/mongod/db                     # 数据目录。（默认：/var/lib/mongo）
    #bind_ip=127.0.0.1                         # 注释掉该行，以便监听所有网卡
    httpinterface=true                         # 开启HTTP接口，端口为28017。注意：线上环境请不要开启（保持被注释的状态）。
    ```



1. 启动并检查

    ```sh
    chkconfig --list mongod
    service mongod restart
    service mongod status
    ```

# 单机配置

/etc/mongod.conf

```
net:
    port: 27017
    #bindIp: 127.0.0.1

processManagement:
    pidFilePath: /home/mongod/mongod.pid
    fork: true

storage:
    dbPath: /home/mongod/data
    directoryPerDB: true

systemLog:
    destination: file
    path : /home/mongod/log/mongodb.log
    logAppend: true

security:
    authorization: enabled
```

# 配置复制

1. 配置好每台服务器的hostname，并确保每个节点都可以用主机名ping到任意其他节点。比如：修改每个节点的上的 `/etc/hosts`

    ```
    192.168.101.81 s81
    192.168.101.82 s82
    192.168.101.83 s83
    192.168.101.85 s85
    ```
1. 在其中一台服务器上创建管理员用户。该服务器应当没有启用认证。使用命令 `mongo` 登录 mongo shell：

    ```js
    use admin
    db.createUser( {
        user: "siteUserAdmin",
        pwd: "<password>",
        roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
    });
    db.createUser( {
        user: "siteRootAdmin",
        pwd: "<password>",
        roles: [ { role: "root", db: "admin" } ]
    });
 
    db.auth("siteRootAdmin", "<password>");      // 认证
    db.getUsers();                               // 获取当前数据库中的用户

    // 对当前数据库中的用户 "siteRootAdmin"，授予不同数据库的不同权限
    db.grantRolesToUser(
      "siteRootAdmin",
      [
        { role: "read",      db: "db1" },
        { role: "readWrite", db: "db2" }
      ]
    );

    use test;                     // 为 test 数据库创建用户
    db.createUser( {
        user: "testUser",
        pwd: "testUser",
        roles: [ { role: "dbOwner", db: "test" } ]
    });
    ```


1. 停止所有的 mongod

    ```sh
    service mongod stop
    ```    

1. 创建一个 keyfile，用于 replica set。

    ```sh
    openssl rand -base64 741 > /home/mongod/mongodb-keyfile
    chown mongod:mongod /home/mongod/mongodb-keyfile
    chmod 600 /home/mongod/mongodb-keyfile
    ```
1. 将 keyfile 复制到规划的 replica set 中的其他服务器上

    ```sh
    scp -P 2222 /home/mongod/mongodb-keyfile root@192.168.101.85:/home/mongod/mongodb-keyfile
    ssh -p 2222 root@192.168.101.85 chown mongod:mongod /home/mongod/mongodb-keyfile
    ssh -p 2222 root@192.168.101.85 chmod 600 /home/mongod/mongodb-keyfile
    ```
1. 修改每一个 mongodb 的配置文件，设置 replica 参数

    ```sh
    vi /etc/mongod.conf
    ```
    修改以下配置项：

    ```conf
    replSet=rs_lizi
    keyFile=/home/mongod/mongodb-keyfile
    ```

1. 启动每一个 mongod 

    ```sh
    service mongod start
    ```

1. 使用 `mongo` 命令连接到最开始创建管理员的 mongod 节点上

    ```sql
    use admin
    db.auth("siteRootAdmin", "<password>");
    ```

1. 在 replica set 的每个节点上运行以下命令：

    ```js
    rs.initiate()
    ```

1. 检查：在 replica set 的每个节点上运行以下命令：

    ```js
    rs.conf()
    ```
    该命令会显示 replica set 配置对象的信息，会类似显示以下信息：

    ```js
    {
        "_id" : "rs_lizi",
        "version" : 1,
        "members" : [
            {
                "_id" : 0,
                "host" : "s85:27017"
            }
        ]
    }
    ```
1. 添加剩余的节点到 replica set 中 

    ```js
    rs.add("s85")
    ```
## 添加仲裁者（Arbiter）

1. 在上述所有对 `/etc/mongod.conf` 修改的基础上，再修改以下设置

    ```conf
    storage:
        smallFiles: true
        journal:
            enabled: false
    ```

1. 启动仲裁者节点

    ```sh
    service mongod start
    ```

1. 在主节点上执行命令，加入仲裁者节点

    ```js
    rs_lizi:PRIMARY> rs.addArb("s81")
    { "ok" : 1 }
    rs_lizi:PRIMARY> rs.conf()
        {
            "_id" : "rs_lizi",
        "version" : 6,
        "members" : [
            {
                "_id" : 0,
                "host" : "s82:27017"
            },
            {
                "_id" : 1,
                "host" : "s85:27017"
            },
            {
                "_id" : 2,
                "host" : "s81:27017",
                "arbiterOnly" : true               // 注意此行。
            }
        ]
    }
    ```




# backup

```
# 备份单个数据库， test1 是 dbOwner
mongodump   --host=192.168.0.12             \
            --port=27017                    \
            --username test1                \
            --password test1                \
            --db test                       \
            --out .
```