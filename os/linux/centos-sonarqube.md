
# maven 插件

```bash
mvn -U 
    -Dsonar.host.url=http://10.1.10.100:9000/
    -Dsonar.jdbc.url=jdbc:postgresql://10.1.10.105:1949/sonar
    -Dsonar.jdbc.username=sonar 
    -Dsonar.jdbc.password=sonar
    -Dsonar.exclusions=**/package-info.java,com/tc/his/api/model/*.java,com/tc/his/provider/dao/*.java
    clean compile sonar:sonar
```

# 安装
[参考1](http://docs.codehaus.org/display/SONAR/Installing)  
虽然 SonarQube自己提供了[yum源](http://sonar-pkg.sourceforge.net/)   ，但是由于其是搭建在 sourceforge.net 上的。但是由于某些原因，sourceforge.net 在国内访问很不稳定，所以，不推荐yum安装（除非翻墙）。

1. （可选）安装数据库（PostgreSQL、MySQL） 或使用既有的数据库。  
    SonarQube默认是有个嵌入式的H2数据库的，默认是H2数据库的数据存储位置是SonarQube安装目录的/data目录。

    ```sql
    -- PostgreSql
    CREATE USER sonar PASSWORD 'mypassword';
    CREATE DATABASE sonar WITH OWNER = sonar;
    ```
1. 从[官网](http://www.sonarqube.org/downloads/)下载所需的zip包。保存到 `/data/tmp` 目录下。
1. 解压

    ```bash
    [root@localhost ~] mkdir /data/software/sonarQube
    [root@localhost ~] unzip /data/tmp/sonar-3.7.4.zip -d /data/software/sonarQube/
    ```
1. 修改配置文件

    ```bash
    [root@localhost ~] vi /data/software/sonarQube/sonar-3.7.4/conf/sonar.properties
      sonar.web.port:                           19020
      sonar.jdbc.username:                  sonar
      sonar.jdbc.password:                   mypassword
      sonar.jdbc.url:                             jdbc:postgresql://10.1.10.105:1949/sonar
    ```
1. 追加init.d脚本

    ```bash
    [root@localhost ~] vi /etc/init.d/sonar 
      #!/bin/bash
      # chkconfig: 345 20 80
      /data/software/sonarQube/sonar-3.7.4/bin/linux-x86-64/sonar.sh "$@"
    [root@localhost ~] chmod u+x /etc/init.d/sonar
    [root@localhost ~] chkconfig --add sonar
    [root@localhost ~] chkconfig --list sonar
    [root@localhost ~] service sonar                               # 确认脚本是否成功
    [root@localhost ~] service sonar start
    ```
1. 启动。注意：需要先停止旧版本的SonarQube（如果有的话。）

    ```bash
    [root@localhost ~] service sonar start
    ```
1. 升级。
    1. 复制 OLD_SONARQUBE_HOME/extensions/plugins 到新的目录中
    1. （可选）备份sonar数据库。
    1. 访问 `http://10.1.10.212:19020/setup`， 并点击 ”upgrade“ 按钮。

# 安装插件
登录sonarQube后，顶部右侧 "Administrator" -> SYSTEM/Update Center -> Available Plugins 可以找找可用的插件。比如：

* Integration/LDAP
* Localization/Chinese # 汉语语言包

# 使用Maven插件进行分析

参考：[使用Maven进行分析](http://docs.codehaus.org/display/SONAR/Analyzing+with+Maven)、
[分析参数列表](http://docs.codehaus.org/display/SONAR/Analysis+Parameters)、
[使用企业数据库](http://mojo.codehaus.org/sonar-maven-plugin/examples/use-enterprise-database.html)、
[Sonar FAQ](http://docs.codehaus.org/display/SONAR/Frequently+Asked+Questions#FrequentlyAskedQuestions-Analysis)

执行以下mvn命令（无需在pom.xml中进行任何设定）：

```bash
# 第二行开始后的配置参数是SonarQube分析所需的参数
mvn -Dmave.test.skip=true -DsonarHostURL=http://10.1.10.212:19020 sonar:sonar \
-Dsonar.host.url=http://10.1.10.212:19020 \
-Dsonar.jdbc.url=jdbc:postgresql://10.1.10.105:1949/sonar \
-Dsonar.jdbc.username=sonar \
-Dsonar.jdbc.password=sonar \
-Dsonar.exclusions=**/package-info.java,**/model/*.java,**/dao/*.java
```
解释： 上述命令会：

1. 从Maven仓库查找最新的 `org.codehaus.mojo:sonar-maven-plugin:LATEST:sonar`  maven插件，
1. 该插件会查询sonarQube服务器的版本，使用与之匹配的 `org.codehaus.sonar:sonar:maven-plugin:XX:sonar` maven插件，
1. 第二个插件会再到sonarQube服务器上读取相应的设置、并进行分析。



# FIXME 可以进行代码Review？