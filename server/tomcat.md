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


# 目录结构定义

```txt
/data0/app/qh-agency/qh-agency-wap/
/data0/app/qh-agency/qh-agency-wap/bak/             // 备份目录
/data0/app/qh-agency/qh-agency-wap/deploy.sh        // 部署脚本
/data0/app/qh-agency/qh-agency-wap/scp.sh           // scp -> upload/
/data0/app/qh-agency/qh-agency-wap/start.sh         // systemctl, service
/data0/app/qh-agency/qh-agency-wap/upload/          
```



## deploy.sh

```bash
#!/bin/bash

APP=qh-agency-wap

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BAK_DIR=${DIR}/bak
UPLOAD_DIR=${DIR}/upload
JAR=${APP}*.jar                        # 注意，含有通配符 '*' 的哦
dataStr=$(date +%Y%m%d%H%M%S)

# 检查文件数量， 确保 upload 目录下只有一个最新的jar包
checkFileCount(){
    file=$1                                                      
    fileCount=`ls $file |wc -l`
    [[ $fileCount -eq 0 ]] && {
        echo "$file not found, abort." 1>&2
        exit 1
    }
    [[ $fileCount -gt 1 ]] && {
        echo "$file is more than one, will back up and remove them, please run again." 1>&2
        
        for f in $file
        do
           md5Str=$(md5sum ${f} | cut -f1 -d ' ')
           bakName="$(basename $f).${dataStr}.$md5Str"
           mv $f $DIR/bak/$bakName
        done

        mv -f $file $BAK_DIR/
        exit 1
    }   
}

checkFileCount "${UPLOAD_DIR}/${JAR}"

# 开启服务
systemctl restart qh-agency-wap

echo "qh-agency-wap发布成功"
```


## scp.sh

```bash
#!/bin/bash

PROJECT=qh-agency
APP=qh-agency-wap
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

dataStr=$(date +%Y%m%d%H%M%S)

for f in ${DIR}/upload/*.jar
do
    if [ -e ${f} ] ; then
        md5Str=$(md5sum ${f} | cut -f1 -d ' ')
        bakName="$(basename $f).${dataStr}.$md5Str"
        mv $f $DIR/bak/$bakName
    fi
done

scp root@test13.kingsilk.xyz:/root/upload/kingsilk/${PROJECT}/${APP}/${APP}*.jar ${DIR}/upload/
rm -rf ${DIR}/upload/*-sources.jar
```

## start.sh

```bash
#!/bin/bash
. /etc/profile.d/test13.sh

/usr/local/java/jdk1.8.0_45/bin/java \
    -jar /data0/app/qh-agency/qh-agency-wap/upload/*.jar \
    --spring.profiles.active=base,test13 \
    > /data0/app/qh-agency/qh-agency-wap/defalut.log
```

# tomcat

 
1.  安装

    ```
    su - app                   // 以 app 系统用户启动
    mkdir -p /data0/app/qh-agency/qh-agency-wap/
    cd /data0/app/qh-agency/qh-agency-wap/
    
    tar zxvf /path/to/apache-tomcat-x.x.x.tar.gz .
    chown -R app:app apache-tomcat-x.x.x
    cd apache-tomcat-x.x.x
    rm -fr  webapps/*                 # 删除自带应用
    rm -fr  work/*
    rm conf/Catalina/localhost/host-manager.xml
    rm conf/Catalina/localhost/manager.xml
    ```

1. `vi $CATALINA_HOME/conf/server.xml`

    1. 修改端口号(共4个)
    1. 加上默认字符集，为了防止页面乱码，在所有的 Connector 元素上追加  `URIEncoding="UTF-8"`

        ```xml
        <Connector port="30010" protocol="HTTP/1.1"
                   connectionTimeout="20000"
                   URIEncoding="UTF-8"
                   redirectPort="30081" />
        ```

    1. 为反向代理 启用 [RemoteIpValue](http://tomcat.apache.org/tomcat-6.0-doc/api/org/apache/catalina/valves/RemoteIpValve.html)

        ```xml
        <Engine ...>
            <Valve className="org.apache.catalina.valves.RemoteIpValve"
                remoteIpHeader="X-Forwarded-For"
                proxiesHeader="X-Forwarded-By"
                protocolHeader="X-Forwarded-Proto"
                trustedProxies="192\.168\..*"/>
        </Engine>
        ```

1. 其他修改，比如添加jar包，修改session集群等






# 服务启动脚本

* CentOS 6 : init.d 脚本。可以配合 service 命令


    1. 创建脚本
    
    ```bash
    su - root
    touch /etc/init.d/$APP_NAME 
    chomd +x /etc/init.d/$APP_NAME
    ```
    
    1. 修改脚本内容
    
    ```bash
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

    1. 开机自启动

    ```bash
    # 执行以下命令后，root用户就可以使用service命令启停了。并且，按照注释行 chkconfig 的配置设置默认启动级别
    chkconfig --add nala-admin
    
    # 确认默认启动级别
    chkconfig --list nala-admin
    
    # 重新设置启动级别（345级别默认启动）
    chkconfig --level 345 nala-admin on
    ```

* CentOS 7 : systemd 脚本。可以配合 systemctl 命令

    参考[这里](https://panovski.me/install-tomcat-8-on-centos-7/)。
    因为 systemd 的服务配置文件中不容易写环境变量，
    因此，新建 `vi ${CATALINA_HOME}/bin/setenv.sh` 来处理环境变量

    1. 创建 systemctl 配置文件
        
        ```bash
        touch /usr/lib/systemd/system/app-name.service
        ```

    1. 修改文件内容

        ```
        [Unit]
        Description=Apache Tomcat Web Application Container
        After=network.target
        
        [Service]
        Type=forking
        PIDFile=/data0/app/qh-wap/apache-tomcat-8.0.23/tomcat.pid
        
        User=qh
        ExecStartPre=
        ExecStart=/data0/app/qh-wap/apache-tomcat-8.0.23/bin/catalina.sh start
        ExecStop=/data0/app/qh-wap/apache-tomcat-8.0.23/bin/catalina.sh stop
        
        LimitFSIZE=infinity
        LimitCPU=infinity
        LimitAS=infinity
        LimitNOFILE=64000
        LimitRSS=infinity
        LimitNPROC=64000
        
        [Install]
        WantedBy=multi-user.target
        ```

     1. 开机自启动

        ```bash
        systemctl daemon-reload 
        systemctl restart qh-wap
        systemctl status qh-wap
        ```





# tomcat 配置 HTTPS
1. 生成自签名证书
    
    ```bash
    # 注意： 为了能在 tomcat 下使用，-keypass 和 -storepass 必须一致。
    keytool -genkeypair \
        -alias mykey \
        -keyalg RSA \
        -keysize 1024 \
        -sigalg SHA1withRSA \
        -dname "CN=your.domain.com, OU=R & D department, O=\"ABC Tech Co., Ltd\", L=Weihai, S=Shandong, C=CN" \
        -validity 365 \
        -keypass 123456 \
        -keystore /path/to/tomcat.jks \
        -storepass 123456
    ```

1. 修改tomcat的配置文件 server.xml ：
    
    ```xml
    <Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
                   maxThreads="150" scheme="https" secure="true"
                   clientAuth="false" sslProtocol="TLS"
                   keystoreFile="C:/.keystore"
                   keystorePass="123456"></Connector>
    ```

1. java client 端配置参数，防止证书校验异常：
    
    ```bash
    # for tomcat
    vi %CATALINA_HOME%/bin/catalina.sh
    set JAVA_OPTS=%JAVA_OPTS% -Djavax.net.ssl.trustStore="/path/to/tomcat.jks" -Djavax.net.ssl.trustStorePassword="123456"
    ```



-------

# 使用 Native connector

参考[这里](http://tomcat.apache.org/native-doc/)

```bash
# 安装依赖
yum install apr-devel openssl-devel gcc

# 下载 tomcat-native
wget http://mirror.bit.edu.cn/apache/tomcat/tomcat-connectors/native/1.1.31/source/tomcat-native-1.1.31-src.tar.gz
tar zxvf tomcat-native-1.1.31-src.tar.gz

# 编译
cd tomcat-native-1.1.31-src/jni/native

# 源码安装时，请指定prefix，否则将来多版本安装、删除时将很头疼。
# 下面的prefix是1.1.31的默认安装路径，当明确设置
./configure --with-apr=/usr/bin/apr-1-config \
            --with-ssl=yes \
            --prefix=/usr/local/apr
make

# 安装
make install

# 配置
vi /etc/init.d/lizi
export LD_LIBRARY_PATH=/usr/local/apr/lib:$LD_LIBRARY_PATH
```

# 使用 tomcat redis session

不再推荐使用，请使用 spring-boot、spring-session.

参考[tomcat-redis-session-manager](https://github.com/jcoleman/tomcat-redis-session-manager), 其下载页在[这里](https://github.com/jcoleman/tomcat-redis-session-manager/downloads)。

1. 下载Jar包

    按照其build.gradle的依赖，可以得知需要将以下jar包放到 $CATALINA_HOME/lib 下：

    ```txt
    tomcat-redis-session-manager-1.2-tomcat-7.jar
    jedis-2.0.0.jar
    commons-pool-1.5.5.jar
    ```

1. 修改tomcat配置文件 conf/context.xml
 
    ```xml
    <Valve className="com.radiadesign.catalina.session.RedisSessionHandlerValve" />
    <Manager className="com.radiadesign.catalina.session.RedisSessionManager"
             host="192.168.115.81"
             port="6379"
             database="0"
             maxInactiveInterval="1800" />
    ```
     



----------

# 虚拟主机
[参考](http://tomcat.apache.org/tomcat-7.0-doc/virtual-hosting-howto.html)

1. 创建虚拟主机所需的appBase目录（一般按照域名建立目录）

    ```bash
    mkdir /data/software/tomcat/default/ssolocal.eyar.com/
    ```
1. 修改server.xml，追加`<Host>`配置，name就是域名。

    ```bash
    vi /data/software/tomcat/default/conf/server.xml
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

    ```bash
    mkdir /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/
    vi /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/ROOT.xml
    ```
    ROOT.xml的内容参考如下示例：

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context antiResourceLocking="false" privileged="true" useHttpOnly="true"
                  docBase="/data/app/tcgroup-sso-web/tcgroup-sso-web">
    </Context>
    ```

1.  创建虚拟主机某个具体路径（比如：`http://ssolocal.eyar.com:8080/admin/` ）的app的配置文件。

    ```bash
    vi /data/software/tomcat/default/conf/Catalina/ssolocal.eyar.com/admin.xml
    ```
   内容参考如下示例：

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <Context antiResourceLocking="false" privileged="true" useHttpOnly="true"
                  docBase="/data/app/tcgroup-sso-home/tcgroup-sso-home">
    </Context>
    ```

