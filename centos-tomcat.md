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


## scp.sh

```sh
#!/bin/bash

DIR=/data/app/my-app

#先备份
for f in ${DIR}/upload/*.war
do
   dataStr=$(date -d "`stat -c %y ${f}`" +%Y%m%d%H%M%S)
   backDir="${DIR}/bak/$(basename $f).${dataStr}.$RANDOM"
   mkdir $backDir
   mv $f $backDir
done

scp  root@192.168.0.100:/data/app/my-app/upload/*.war /data/app/my-app/upload/
```

## deploy.sh

```
DIR=/data/app/my-app
CATALINA_HOME=$DIR/apache-tomcat-7.0.54
WAR_NAME=ROOT
[[ $# -gt 0 ]] && {
    WAR_NAME="$1"
}

. /etc/profile.d/me.sh

/etc/init.d/my-app stop -force

rm -fr $CATALINA_HOME/work/*
rm -fr $CATALINA_HOME/webapps/*
cp $DIR/upload/my-app*.war $CATALINA_HOME/webapps/${WAR_NAME}.war

/etc/init.d/my-app start
```

## 安装

```
su - app                   // 以 app 系统用户启动
cd ~
mkdir my-app
cd my-app

tar zxvf /path/to/apache-tomcat-x.x.x.tar.gz .
cd apache-tomcat-x.x.x
rm -fr  webapps/*                 # 删除自带应用
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

 
## init.d 脚本

vi /etc/init.d/my-app

```
#!/bin/bash
# chkconfig: 2345 60 60
# description: xxx

. /etc/profile.d/me.sh

CATALINA_HOME=/home/app/my-app/apache-tomcat-6.0.41
TOMCAT_USER=app
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

启用

```
chkconfig --add my-app

# 确认默认启动级别
chkconfig --list my-app

# 重新设置启动级别（345级别默认启动）
chkconfig --level 345 my-app on
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


vi /etc/init.d/my-app
# 追加以下一句话
export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
```
## 使用 tomcat redis session
参考[tomcat-redis-session-manager](https://github.com/jcoleman/tomcat-redis-session-manager), 其下载页在[这里](https://github.com/jcoleman/tomcat-redis-session-manager/downloads)。

### 下载Jar包
按照其build.gradle的依赖，可以得知需要将以下jar包放到 $CATALINA_HOME/lib 下：

```
tomcat-redis-session-manager-1.2-tomcat-7.jar
jedis-2.0.0.jar
commons-pool-1.5.5.jar
```

### 修改tomcat配置文件 conf/context.xml

```xml

<Valve className="com.radiadesign.catalina.session.RedisSessionHandlerValve" />
<Manager className="com.radiadesign.catalina.session.RedisSessionManager"
         host="192.168.115.81"
         port="6379"
         database="0"
         maxInactiveInterval="1800" />
```


# 虚拟主机
[参考](http://tomcat.apache.org/tomcat-7.0-doc/virtual-hosting-howto.html)

1. 创建虚拟主机所需的appBase目录（一般按照域名建立目录）

    ``` sh
    [root@localhost ~]# mkdir /data/software/tomcat/default/ssolocal.eyar.com/
    ```
1. 修改server.xml，追加`<Host>`配置，name就是域名。

    ``` sh
    [root@localhost ~]# vi /data/software/tomcat/default/conf/server.xml
    ```
    在 `<Server><Service><Engine>` 下仿照下面追加配置

    ```xml
          <Host name="ssolocal.eyar.com" appBase="ssolocal.eyar.com">
             <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
                   prefix="ssolocal.eyar.com_access_log." suffix=".txt"
                   pattern="%h %l %u %t "%r" %s %b" ></Valve>
          </Host>
    ```
1.  创建虚拟主机根路径（`http://ssolocal.eyar.com:8080/` ）的默认app的配置文件。

    ``` sh
    [root@localhost ~]# mkdir /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/
    [root@localhost ~]# vi /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/ROOT.xml
    ```
    ROOT.xml的内容参考如下示例：

    ``` xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context antiResourceLocking="false" privileged="true" useHttpOnly="true" 
                  docBase="/data/app/tcgroup-sso-web/tcgroup-sso-web">
    </Context>
    ```
1.  创建虚拟主机某个具体路径（比如：`http://ssolocal.eyar.com:8080/admin/` ）的app的配置文件。

    ``` sh
    [root@localhost ~]# vi /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/admin.xml
    ```
   内容参考如下示例：

    ``` xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context antiResourceLocking="false" privileged="true" useHttpOnly="true" 
                  docBase="/data/app/tcgroup-sso-home/tcgroup-sso-home">
    </Context>
    ```



# HTTPS
生成自签名证书

```
CMD /> %JAVA_HOME%\bin\keytool -genkeypair -alias mykey -keyalg RSA -keysize 1024 -sigalg SHA1withRSA -dname "CN=your.domain.com, OU=R & D department, O=\"ABC Tech Co., Ltd\", L=Weihai, S=Shandong, C=CN" -validity 365 -keypass 123456 -keystore C:/.keystore -storepass 123456
```


注意： 为了能在 tomcat 下使用，-keypass 和 -storepass 必须一致。

修改tomcat的配置文件 server.xml ：

```
<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS" 
               keystoreFile="C:/.keystore"
               keystorePass="123456"></Connector>
```

如果在tomcat内部还要使用JavaAPI连接到自己的网址上，为了防止出现以下错误：

```
SSLHandshakeException - unable to find valid certification path to requested target
```

可以在 %CATALINA_HOME%/bin/catalina.bat 中追加以下配置

```
set JAVA_OPTS=%JAVA_OPTS% -Djavax.net.ssl.trustStore="C:\.keystore" -Djavax.net.ssl.trustStorePassword="123456"
```

# 安装后、部署前可选操作
1. 删除 logs/*
1. 删除 work/*
1. 删除 conf/Catalina/localhost/host-manager.xml, conf/Catalina/localhost/manager.xml
1. 删除 webapps下自带的app。

# 最简单的 init 脚本

```sh
#!/bin/sh
# chkconfig: 2345 60 60
# description: xxx

CATALINA_HOME=/home/lizi/nala-admin/apache-tomcat-6.0.41
TOMCAT_USER=lizi
export CATALINA_PID=$CATALINA_HOME/tomcat.pid、
export CATALINA_OPTS="-server -noverify -Xshare:off -Xms=256m -Xmx=1024m -XX:PermSize=32m -XX:MaxPermSize=256m -XX:+UseParallelGC -Dfile.encoding=UTF-8"

if [[ `whoami` = "$TOMCAT_USER" ]]
then
   $CATALINA_HOME/bin/catalina.sh $@
else
    su -p -s /bin/sh ${TOMCAT_USER} -c "$CATALINA_HOME/bin/catalina.sh $*"
fi
```