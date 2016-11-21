# 安装
1. 参考[Jetty/Howto/High_Load](http://wiki.eclipse.org/Jetty/Howto/High_Load),修改系统参数
1. 从[官网](http://www.eclipse.org/jetty/) 下载，并上传的指定的服务器上。

1. 解压

    ```bash
    mkdir /usr/jetty
    tar -xzvf jetty-distribution-9.2.7.v20150116.tar.gz -C /usr/jetty
    ```

1. 设置 JETTY_HOME : `vi /etc/xxx.sh`

    ```bash
    export JETTY_HOME=/usr/jetty/jetty-distribution-9.2.7.v20150116
    ```

1. 修改 jetty 的全局性配置

    1. `vi $JETTY_HOME/etc/jetty.xml`, 修改92行左右，启用 **ForwardedRequestCustomizer**，该配置允许使用 HaProxy, Nginx等反向代理设置 `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto` 等 http 请求头
    1. `vi $JETTY_HOME/etc/jetty-logging.xml`, 修改19行左右，修改时区 `GMT` -> `GMT+8`. 
       这会使得 jetty 生成的日志备份文件 `yyyy_mm_dd.stderrout.log.HHmmssSSS"` 的后缀能与我们的时区相一致。

    1. `vi $JETTY_HOME/bin/jetty.sh` ，为方便非root用户可以执行该脚本，修改以下配置。

        ```bash
        # 修改 169 行左右, 修改 `for CONFIG in $ETC/default/${NAME}{,9} $HOME/.${NAME}rc; do` 为：
        for CONFIG in {/etc,~/etc}/default/${NAME}{,9} $HOME/.${NAME}rc; do 

        # 修改 447 行左右， 修改 `if [ -n "$JETTY_USER" ]`  为：
        if [ -n "$JETTY_USER" ] && [ `whoami` != "$JETTY_USER" ] 
        ```
    1. `vi $JETTY_HOME/bin/jetty.sh` ，防止Jenkins 通过SSH执行时，因stdout而超时。

        ```bash
        # 修改 459 行左右，修改 `exec ${RUN_CMD[*]} start-log-file="$JETTY_LOGS/start.log" &` 为：
        exec ${RUN_CMD[*]} start-log-file="$JETTY_LOGS/start.log" > /dev/null &

        # 修改 463 行左右，修改 `else\n "${RUN_CMD[@]}" &` 为：
        else
          "${RUN_CMD[@]}" > /dev/null &
        ```
1. 创建某个工程（这里是 my-app）特定的 `jetty.base`

    1. 创建目录

        ```bash
        mkdir -p /data/lizi-platform/my-app/jetty.base
        ```
    1. 创建一个空 start.ini 文件

        ```bash
        cd /data/app/my-app/jetty.base
        touch start.ini
        ```
    1. 通过命令创建所需的 start.d/xxx.ini 文件

        ```bash 
        java -jar ${JETTY_HOME}/start.jar --add-to-startd=server,deploy,http,logging,jsp,jstl,jaas,ssl
        mkdir work                        # 注意，该目录不会自动清空的。如果不再jetty.base目录下创建，会使用临时目录，重启一次，就创建一个临时目录

        # 确认启用的 jetty 模块
        java -jar ${JETTY_HOME}/start.jar --list-modules
        ```
    1. 修改 start.d 文件

        ```bash
        # 修改 http 端口等配置
        vi start.d/http.ini

        # 修改 ssl 配置（线上环境不需要，因为使用的都是正式证书。）
        # 开发、测试环境还需要从my-app的git仓库中 
        scp yourUserName@xxx.xxx.xxx.xxx:/path/to/lizi-platform/lizi-cas/src/main/config/lizi.jks  etc/
        vi start.d/ssl.ini
        ```
    1. 修改文件权限

        ```bash
        chown -R app:app /data/app/my-app/jetty.base     # lizi 用户是jetty启动时所用的系统用户身份
        ```

1. 创建某个工程（这里是 my-app）特定的配置文件 ： `vi /etc/default/my-app` 。

    ```bash
    #!/bin/bash

    if [[ "" = "${JAVA_HOME}" ]]
    then
        . /etc/profile.d/xxx.sh 
    fi

    today=`date +%Y%m%d%H%M%S`

    JETTY_BASE=/home/app/my-app/jetty.base
    JAVA_OPTIONS="-server \
        -Xms512m \
        -Xmx1024m \
        -XX:PermSize=32m \
        -XX:MaxPermSize=256m 
        -XX:ErrorFile=${JETTY_BASE}/logs/start.at.${today}.hs_err_pid.log \
        -XX:+UseConcMarkSweepGC \
        -XX:+HeapDumpOnOutOfMemoryError \
        -XX:HeapDumpPath=${JETTY_BASE}/logs/start.at.${today}.dump.hprof \
        -XX:+PrintGCDateStamps \
        -XX:+PrintGCDetails \
        -Xloggc:${JETTY_BASE}/logs/start.at.${today}.gc.log \
        -Duser.timezone=GMT+08 \
        -Dfile.encoding=UTF-8 \
        -Dspring.profiles.active=dev \
    "
    JETTY_RUN=$JETTY_BASE
    JETTY_USER=app          # app 用户是jetty启动时所用的系统用户身份
    ```
    注意：

    1. 该文件是shell脚本。
    1. 该路径只有root用户才可读取。非root用户需要到 `$HOME/etc/default/` 目录下读取。
    1. JVM参数中关于远程debug的配置，请修改端口号，防止冲突。如有必要，请移除远程debug的配置。

1. 创建某个工程（这里是 lizi-cas）特定的 init.d 脚本

    ```bash
    cp $JETTY_HOME/bin/jetty.sh /etc/init.d/my-app
    service my-app                                  # 之后就可以使用 service 命令了
    ```


# Jenkins相关配置

## deploy.sh

```
#!/bin/bash
APP=my-app
. /etc/default/$APP
                                                   
/etc/init.d/$APP stop

rm -fr $JETTY_BASE/work/*
rm -fr $JETTY_BASE/webapps/*
cp $JETTY_BASE/../upload/*.war $JETTY_BASE/webapps/ROOT.war

/etc/init.d/$APP start
```



# 关于HTTPS相关配置

1. nginx https 反向代理。浏览器与nginx之间是https，但nginx与tomcat/jetty之间是普通的http。nginx配置文件如下所示：

    ```groovy
    upstream lizi-platform.lizi-cas {
            server 127.0.0.1:30080;
    }

    server {
        listen          80;
        server_name     login-dev.lizi.com login-test.lizi.com;
        return          301     https://$host$request_uri;
    }
    server {
        listen          443;
        server_name     login-dev.lizi.com login-test.lizi.com;
        charset         utf-8;

        access_log      /home/www/logs/nginx/lizi-platform.lizi-cas.access.log main;
        error_log       /home/www/logs/nginx/lizi-platform.lizi-cas.error.log notice;

        ssl                     on;
        ssl_certificate         /home/zll/work/git-repo/lizi-platform/lizi-cas/src/main/config/lizi.pem.cer;
        ssl_certificate_key     /home/zll/work/git-repo/lizi-platform/lizi-cas/src/main/config/ssl/lizi.pem.clear.key;


        location / {
            proxy_pass          http://lizi-platform.lizi-cas;
            proxy_redirect      off;
            proxy_set_header    Host                $host;
            proxy_set_header    X-Real-IP           $remote_addr;
            proxy_set_header    X-Forwarded-For     $proxy_add_x_forwarded_for;
            proxy_set_header    X-Forwarded-Proto   $scheme;
        }
    }
    ```

1. 使用 jetty-maven-plugin 对外提供 https服务。因为 lizi-cas 使用 maven 的 war overlay方式开发，所以debug时，使用 jetty-maven-plugin 插件会很方便。

    1. 需要从jetty压缩包中copy所需的 etc/jetty*xml 到 lizi-cas 工程中，并略做修改，比如：修改 jetty.xml, 启用 ForwardedRequestCustomizer。

    1. 修改 pom.xml

        ```xml
        <plugin>
            <groupId>org.eclipse.jetty</groupId>
            <artifactId>jetty-maven-plugin</artifactId>
            <version>9.2.6.v20141205</version>
            <configuration>
                <systemProperties>
                    <systemProperty>
                        <name>jetty.port</name>
                        <value>30080</value>
                    </systemProperty>
                    <systemProperty>
                        <name>https.port</name>
                        <value>30081</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.base</name>
                        <value>${basedir}</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.keystore</name>
                        <value>src/main/config/lizi.jks</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.keystore.password</name>
                        <value>OBF:19iy19j019j219j419j619j8</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.keymanager.password</name>
                        <value>OBF:19iy19j019j219j419j619j8</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.truststore</name>
                        <value>src/main/config/lizi.jks</value>
                    </systemProperty>
                    <systemProperty>
                        <name>jetty.truststore.password</name>
                        <value>OBF:19iy19j019j219j419j619j8</value>
                    </systemProperty>
                </systemProperties>
                <jettyXml>${basedir}/src/main/config/jetty.xml,${basedir}/src/main/config/jetty-http.xml,${basedir}/src/main/config/jetty-ssl.xml,${basedir}/src/main/config/jetty-https.xml</jettyXml>
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>run</goal>
                    </goals>
                    <phase>prepare-package</phase>
                </execution>
            </executions>
        </plugin>
        ```

1. 运行 jetty-maven-plugin 插件时，连接其他 https 服务，并验证证书。修改 pom.xml，追加参数

    ```xml
    <plugin>
        <groupId>org.eclipse.jetty</groupId>
        <artifactId>jetty-maven-plugin</artifactId>
        <version>9.2.6.v20141205</version>
        <configuration>
            <systemProperties>
                <systemProperty>
                    <name>javax.net.ssl.trustStore</name>
                    <value>/path/to/lizi.jks</value>
                </systemProperty>
                <systemProperty>
                    <name>javax.net.ssl.trustStorePassword</name>
                    <value>123456</value>
                </systemProperty>
        </configuration>
    </plugin>
    ```

1. 通过 `grails run-app` 运行时，连接其他 https 服务，并验证证书。

    ```groovy
    // 方式一 ： 在命令行修改参数
    grails -Djavax.net.ssl.trustStore=/path/to/lizi.jks -Djavax.net.ssl.trustStorePassword=123456 run-app 

    // 方式二 ： 修改 BuildConfig.groovy
    System.setProperty("javax.net.ssl.trustStore", "${basedir}/test/lizi.jks")
    System.setProperty("javax.net.ssl.trustStorePassword", "123456")
    ```

1. 独立运行 jetty 时，连接其他 https 服务，并验证证书。`vi /etc/default/xxxAppName` :

    ```bash
    JAVA_OPTIONS="-server \
         -Djavax.net.ssl.trustStore=/home/lizi/lizi-platform/lizi-www/jetty.base/etc/lizi.jks \
         -Djavax.net.ssl.trustStorePassword=123456 \ 
    "
    ```
