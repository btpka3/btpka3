# 约定

* 一个grails应用单独配置一个tomcat。
* grails 应用需要以非root用户启动
* grials应用的根目录应为 /home/$APP_USER/$APP_NAME，其下应有以下目录/文件
    * 目录 upload : war包上传目录
    * 目录 apache-tomcat-x.x.x : tomcat的解压目录
    * deploy-${APP_NAME}.sh : war包上传后的部署脚本
* 最好准备一个 init.d 脚本，以便使用统一入口启停tomcat，文件路径应当为 /etc/init.d/$APP_NAME
    * 所有用户可以使用 `/etc/init.d/$APP_NAME xxx` 启停tomcat
    * root 用户还可以使用命令  `service $APP_NAME xxx` 启停tomcat

下面以应用为nala-admin、运行用户为lizi为例，说明一下配置过程。


# 下载 tomcat 

版本号： 6.0.41 。

```sh
su - lizi
mkdir nala-admin
mkdir upload
cd nala-admin

# 从80服务器上copy已经下载的tomcat
scp root@192.168.115.80:/root/share/apache-tomcat-6.0.41.tar.gz .
tar zxvf apache-tomcat-6.0.41.tar.gz .
```

# 配置

1. 删除自带的应用 

    ```sh
    rm -fr $CATALINA_HOME/webapps/*
    ```
1. `vi $CATALINA_HOME/conf/server.xml`

    1. 修改端口号(共4个)，端口号配置规则请参考[这里](ports)
    1. 加上默认字符集，防止页面乱码  `URIEncoding="UTF-8"`

        ```xml
        <Connector port="30010" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   URIEncoding="UTF-8"
                   redirectPort="30081" />
        ```

    1. 为反向代理 启用 RemoteIpValue

        ```xml
        <Server ...>
            <Valve className="org.apache.catalina.valves.RemoteIpValve"
                remoteIpHeader="X-Forwarded-For"
                proxiesHeader="X-Forwarded-By"
                protocolHeader="X-Forwarded-Proto"
                trustedProxies="192\.168\..*"/>
        </Server>
        ```

1. 其他修改，比如添加jar包，修改session集群等，希望大家在该wiki中详细说明






# 配置init.d脚本

脚本 /etc/init.d/$APP_NAME。该 init.d 脚本目的：

* 使用统一的入口启停tomcat（可以保证在启停时，环境变量，启动参数等一致）
* 可以设置是否开启自启动

## 创建脚本

```sh
su - root
touch /etc/init.d/nala-admin
chomd +x /etc/init.d/nala-admin
```

## 脚本内容

```sh
#!/bin/bash
# chkconfig: 2345 60 60
# description: xxx

. /etc/profile.d/lizi.sh

CATALINA_HOME=/home/lizi/nala-admin/apache-tomcat-6.0.41
TOMCAT_USER=lizi
export CATALINA_PID=$CATALINA_HOME/tomcat.pid
today=`date +%Y%m%d%H%M%S`
export CATALINA_OPTS="\
    -server \
    -Xms512m \
    -Xmx1024m \
    -XX:PermSize=32m \
    -XX:MaxPermSize=256m \
    -Xss256k \
    -XX:ErrorFile=${CATALINA_HOME}/logs/start.at.${today}.hs_err_pid.log \
    -XX:+UseConcMarkSweepGC \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=${CATALINA_HOME}/logs/start.at.${today}.dump.hprof \
    -XX:+PrintGCDateStamps \
    -XX:+PrintGCDetails \
    -Xloggc:${CATALINA_HOME}/logs/start.at.${today}.gc.log \
    -Duser.timezone=GMT+08 \
    -Dfile.encoding=UTF-8 \
"
export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH

if [[ `whoami` = "$TOMCAT_USER" ]]
then
   $CATALINA_HOME/bin/catalina.sh $@
else
    su -p -s /bin/sh ${TOMCAT_USER} -c "$CATALINA_HOME/bin/catalina.sh $*"
fi
```
说明：其中 LD_LIBRARY_PATH这一行的配置是为后续安装tomcat-native准备的。

## 后续处理

```sh
# 执行以下命令后，root用户就可以使用service命令启停了。并且，按照注释行 chkconfig 的配置设置默认启动级别
chkconfig --add nala-admin

# 确认默认启动级别
chkconfig --list nala-admin

# 重新设置启动级别（345级别默认启动）
chkconfig --level 345 nala-admin on

```

# systemd 脚本

参考[这里](https://panovski.me/install-tomcat-8-on-centos-7/)


```
# /usr/lib/systemd/system/app-name.service 

[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking
PIDFile=/data/app/app-name/apache-tomcat-xxx/tomcat.pid
Environment=CATALINA_PID=/data/app/app-anem/apache-tomcat-xxx/tomcat.pid
Environment=JAVA_HOME=/usr/java/default
Environment=CATALINA_HOME=/data/app/app-anem/apache-tomcat-xxx/
Environment=CATALINA_BASE=/data/app/app-anem/apache-tomcat-xxx/
Environment=CATALINA_OPTS= \
    -server \
    -Xms512m \
    -Xmx1024m \
    -XX:PermSize=32m \
    -XX:MaxPermSize=256m \
    -Xss256k \
    -XX:ErrorFile=${CATALINA_HOME}/logs/start.at.${today}.hs_err_pid.log \
    -XX:+UseConcMarkSweepGC \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=${CATALINA_HOME}/logs/start.at.${today}.dump.hprof \
    -XX:+PrintGCDateStamps \
    -XX:+PrintGCDetails \
    -Xloggc:${CATALINA_HOME}/logs/start.at.${today}.gc.log \
    -Duser.timezone=GMT+08 \
    -Dfile.encoding=UTF-8 \

User=qh
ExecStartPre=
ExecStart=/data/app/app-anem/apache-tomcat-xxx/bin/catalina.sh start
ExecStop=/data/app/app-anem/apache-tomcat-xxx/bin/catalina.sh stop

LimitFSIZE=infinity
LimitCPU=infinity
LimitAS=infinity
LimitNOFILE=64000
LimitRSS=infinity
LimitNPROC=64000

[Install]
WantedBy=multi-user.target
```


# 部署脚本

## 创建

```sh
su - lizi
cd nala-admin
touch deploy.sh
chmod u+x deploy.sh
```

## 脚本内容：

```sh
#!/bin/bash                                                                                      
DIR=/data/app/lizi
CATALINA_HOME=$DIR/apache-tomcat-7.0.54
WAR_NAME=ROOT
[[ $# -gt 0 ]] && {
    WAR_NAME="$1"
}

. /etc/profile.d/lizi.sh

/etc/init.d/lizi stop -force

rm -fr $CATALINA_HOME/work/*
rm -fr $CATALINA_HOME/webapps/*
cp $DIR/upload/lizi*.war $CATALINA_HOME/webapps/${WAR_NAME}.war

/etc/init.d/lizi start

```




# 使用 Native connector

参考[这里](http://tomcat.apache.org/native-doc/)

## 安装依赖

```sh
yum install apr-devel openssl-devel
```

## 下载 tomcat-native

```sh
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-connectors/native/1.1.31/source/tomcat-native-1.1.31-src.tar.gz
tar zxvf tomcat-native-1.1.31-src.tar.gz
```

## 配置、编译、安装

```sh
cd tomcat-native-1.1.31-src/jni/native

# 源码安装时，请指定prefix，否则将来多版本安装、删除时将很头疼。下面的prefix是1.1.31的默认安装路径，当明确设置
./configure --with-apr=/usr/bin/apr-1-config \
            --with-ssl=yes \
            --prefix=/usr/local/apr
make
make install
```

## 配置tomcat

```sh
vi /etc/init.d/lizi
# 追加以下一句话
export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
```

# 使用 tomcat redis session
参考[tomcat-redis-session-manager](https://github.com/jcoleman/tomcat-redis-session-manager), 其下载页在[这里](https://github.com/jcoleman/tomcat-redis-session-manager/downloads)。

## 下载Jar包
按照其build.gradle的依赖，可以得知需要将以下jar包放到 $CATALINA_HOME/lib 下：

```
tomcat-redis-session-manager-1.2-tomcat-7.jar
jedis-2.0.0.jar
commons-pool-1.5.5.jar
```

## 修改tomcat配置文件 conf/context.xml

```xml

<Valve className="com.radiadesign.catalina.session.RedisSessionHandlerValve" />
<Manager className="com.radiadesign.catalina.session.RedisSessionManager"
         host="192.168.115.81"
         port="6379"
         database="0"
         maxInactiveInterval="1800" />
```

# scp.sh

```sh
#!/bin/bash

DIR=/data/app/nala-time

#先备份
for f in ${DIR}/upload/*.war
do
   dataStr=$(date -d "`stat -c %y ${f}`" +%Y%m%d%H%M%S)
   backDir="${DIR}/bak/$(basename $f).${dataStr}.$RANDOM"
   mkdir $backDir
   mv $f $backDir
done

scp -P 2222 root@192.168.71.207:/data/app/nala-time/upload/*.war /data/app/nala-time/upload/
```