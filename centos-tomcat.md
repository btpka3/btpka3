TODO

[init 脚本](/snippets/4)


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
                   pattern="%h %l %u %t &quot;%r&quot; %s %b" />
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



#HTTPS
生成自签名证书
<source>
CMD /> %JAVA_HOME%\bin\keytool -genkeypair -alias mykey -keyalg RSA -keysize 1024 -sigalg SHA1withRSA -dname "CN=your.domain.com, OU=R & D department, O=\"ABC Tech Co., Ltd\", L=Weihai, S=Shandong, C=CN" -validity 365 -keypass 123456 -keystore C:/.keystore -storepass 123456
</source>

注意： 为了能在 tomcat 下使用，-keypass 和 -storepass 必须一致。

修改tomcat的配置文件 server.xml ：
<source>
<Connector port="8443" protocol="HTTP/1.1" SSLEnabled="true"
               maxThreads="150" scheme="https" secure="true"
               clientAuth="false" sslProtocol="TLS" 
               keystoreFile="C:/.keystore"
               keystorePass="123456"/>
</source>

如果在tomcat内部还要使用JavaAPI连接到自己的网址上，为了防止出现以下错误：
<source>
SSLHandshakeException - unable to find valid certification path to requested target
</source>

可以在 %CATALINA_HOME%/bin/catalina.bat 中追加以下配置
<source>
set JAVA_OPTS=%JAVA_OPTS% -Djavax.net.ssl.trustStore="C:\.keystore" -Djavax.net.ssl.trustStorePassword="123456"
</source>

# 安装后、部署前可选操作
1. 删除 logs/*
1. 删除 work/*
1. 删除 conf/Catalina/localhost/host-manager.xml, conf/Catalina/localhost/manager.xml
1. 删除 webapps下自带的app。

# 最简单的 init 脚本

```sh
#!/bin/sh
# chkconfig: 2345 60 60

CATALINA_HOME=/home/lizi/nala-admin/apache-tomcat-6.0.41
TOMCAT_USER=lizi
export CATALINA_PID=$CATALINA_HOME/tomcat.pid、
export CATALINA_OPTS="-server -Xms=256m -Xmx=1024m -XX:PermSize=32m -XX:MaxPermSize=256m -Dfile.encoding=UTF-8"

if [[ "$USER" -eq "$TOMCAT_USER" ]]
then
   $CATALINA_HOME/bin/catalina.sh $@
else
    su -p -s /bin/sh ${TOMCAT_USER} -c "$CATALINA_HOME/bin/catalina.sh $*"
fi
```