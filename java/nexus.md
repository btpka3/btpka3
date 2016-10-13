

# 安装
1. 创建所需执行的非root用户，比如： `nexus`。
1. 下载最新版本，并解压。比如：解压到 `/home/nexus`
1. 修改 `/etc/profile.d/xxx.sh` ，追加/修改以下环境变量

   ```sh
   export NEXUS_HOME=/home/nexus/nexus-2.11.1-01
   export PATH=${NEXUS_HOME}/bin:$PATH
   ```
1. 修改 `${NEXUS_HOME}/conf/nexus.properties`，按需修改以下配置项

   ```properties
   application-port=20010                # 默认值是 8081
   nexus-webapp-context-path=/           # 默认值是 /nexus
   ```
1. 将 nexus 作为 init.d 服务
  
    ```
    cp ${NEXUS_HOME}/bin/nexus /etc/init.d/
    vi /etc/init.d/nexus
    ```
    内容如下：

    ```sh
    # NEXUS_HOME=".."                   # 注释掉此行
    . /etc/profile.d/xxx.sh             # 在文件开头追加此行
    RUN_AS_USER=nexus                   # 修改此值为最开始创建的用户   
    ```
1. 现在可以通过 `service nexus start` 启动了，访问URL为 `http://localhost:20010/`
1. 为了使用自定义域名 `mvn.lizi.com` 访问，需要为Nginx增加以下配置项： 

    ```
    upstream nexus {
      server 127.0.0.1:20010;
    }

    server {
      listen *:80;
      server_name mvn.lizi.com;
      server_tokens off;
      root /notExisted;
      
      client_max_body_size 20m;
      ignore_invalid_headers off;

      access_log  /var/log/nginx/nexus_access.log;
      error_log   /var/log/nginx/nexus_error.log;

      location / { 
            proxy_pass                  http://nexus;
            proxy_set_header            Host            $host;   # ???  $http_host;
            proxy_set_header            X-Real-IP       $remote_addr;
            proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header            X-Forwarded-Proto $scheme;
            proxy_connect_timeout       600;   # 增加超时时间，防止下载大的war包时504
            proxy_send_timeout          600;
            proxy_read_timeout          600;
            send_timeout                600;
      }
    }
    ```
1. 之后通过URL `http://localhost:20010/` 登录，默认管理员 `admin`，密码 `admin123` 登录，并修改：

    ```
    Views/Repositories -> Repositories:
        把 "Apache Snapshots", Put out of service;
        Add, Proxy Repository, 追加 grails-plugins，配置参考下面的表格。
        修改 "Public Repositories", 下侧 Configuration, 把 grails-plugins 添加一下

    Administration -> server:
        Application server settings:
            Base Url : 修改为 "http://mvn.lizi.com/"
            选中  Force Base URL

     Administration -> Scheduled Tasks:
        Add, 
            name = download-indexes-central
            type = Download indexes, 
            Repository/Group = Central (Repo)
            执行时间为每天凌晨1点
        同样添加 grails-plugins 每天凌晨1点下载索引
        为组 Public Repositories 添加每天凌晨2点的 Repair Repositories Index 任务
    ```






# 常用仓库

|maven repo/mirror|index published?| url |description|
|-----------------|----------------|------|---|
|central        |yes|http://repo1.maven.org/maven2/                  |默认自带|
|ibiblio        |yes|http://mirrors.ibiblio.org/maven2/              ||
|oschina        |no |http://maven.oschina.net/content/groups/public/ ||
|grails-core    |no |http://repo.grails.org/grails/core/             |该库建议不要配置|
|grails-plugins |no |http://repo.grails.org/grails/plugins/          ||
|jboss          |yes|http://repository.jboss.com/maven2/             ||

配置完上述仓库之后，为了方便使用，需要上述仓库添加到 "Public Repositories" 组中，注意先后顺序（可以拖拽上下移动）。

为了方便客户端下载索引，还需要在 `Administration` -> `Scheduled Tasks` 中为所需的仓库/组 增加下载索引/发布索引的任务。




# settings.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">

    <!--
    <localRepository>E:/maven/repository</localRepository>
     -->

    <mirrors>
        <mirror>
            <id>mirror-all</id>
            <name>mirror-all</name>
            <mirrorOf>*</mirrorOf>
            <url>http://mvn.lizi.com/content/groups/public/</url>
        </mirror>
    </mirrors>

    <profiles>
        <profile>
            <id>profile-me</id>
            <properties>
                <downloadSources>true</downloadSources>
                <downloadJavadocs>false</downloadJavadocs>
            </properties>
            <pluginRepositories>
                <pluginRepository>
                    <id>osc-plugins</id>
                    <name>osc-plugins</name>
                    <url>http://mvn.lizi.com/content/groups/public/c</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>false</enabled>
                    </snapshots>
                </pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <activeProfiles>
        <activeProfile>profile-me</activeProfile>
    </activeProfiles>
</settings>
```