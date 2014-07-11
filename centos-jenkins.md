# 安装
[参考](https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions)

1. 先[安装JDK](CentOs-JDK)

1. 新增 jenkins 的 yum 源

    ```sh
[root@localhost ~] wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
[root@localhost ~] rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
    ```
1. 安装

    ```sh
    [root@localhost ~] yum list "*jenkins*"                         # 查找可安装的jenkins版本
    [root@localhost ~] yum install jenkins                          # 安装
    ```
1. 按照规约修改jenkins的安装目录、存储目录
    ```sh
    [root@localhost ~] mkdir /data/software/jenkins/
    [root@localhost ~] mkdir /data/store/jenkins/
    [root@localhost ~] mv /usr/lib/jenkins/jenkins.war /data/software/jenkins/
    [root@localhost ~] usermod -m -d /data/store/jenkins jenkins               # 修改jenkins用户的主目录为 /data/store/jenkins
    ```

1. 配置

    ```sh
    [root@localhost ~] vi /etc/sysconfig/jenkins
      JENKINS_HOME="/data/store/jenkins"                               # 即jenkins用户的主目录
      JENKINS_PORT="19010"
      JENKINS_AJP_PORT="19011"
    [root@localhost ~] vi /etc/init.d/jenkins
      JENKINS_WAR="/data/software/jenkins/jenkins.war"
    ```


# 常用插件
* Ant Plugin
* Credentials Plugin
* CVS Plugin
* External Monitor Job Type Plugin
* Javadoc Plugin
* Parameterized Trigger plugin

   可以使一个job在运行前或运行后调用另外一个job。示例：

```sh
# job1. 更新SVN  

# job2. 打包并使用SSH部署：
mvn -f ../../job1/workspace/pom.xml clean package

# job3. 运行sonar：
mvn -f ../../job1/workspace/pom.xml -Dsonar.jdbc.username=xxx -Dsonar.jdbc.password=xxx clean compile sonar:sonar

# job4. 发布快照：
mvn -f ../../job1/workspace/pom.xml -Dmaven.test.skip=true -am --projects subModule1/subModule11,submodel2 clean deploy
```

* Jenkins Subversion Plug-in
* Jenkins Translation Assistance plugin
* LDAP Plugin  
  Jenkins 1.480  之后就包含在发布版本中了。下面示例如何使用使用域账户登录

```txt
1. Jenkins LDAP全局配置
   Jenkins -> Manage Jenkins -> Configure Global Security :
   * 选中“Enable security”
   * Access Control/Security Realm 部分，选择："LDAP"：
        Server             : ldap://10.1.10.2:389
        root DN            : DC=TCGROUP,DC=LOCAL
        User search filter : mail={0}
        Manager DN         : 域管理员的@eetop.com电子邮箱地址
        Manager Password   : 域管理员的域账户密码
        （其他字段留空即可）
    * Access Control/Authorization 部分
      选择 “Project-base Matrix Authorization Strategy”
      在下面就可以为所有project设置默认账户的权限了。（账户名就是 xxx@eetop.com)

2. Jenkins单个project/job的权限控制
   Jenkins -> 点击单个job名 -> 点击左侧 "Configure" -> 右侧最上面，
   选中“Enable project-based security”。之后就可以设置权限控制的矩阵表了。
   （账户名就是 xxx@eetop.com）
```

* Mailer
* Maven Project Plugin
* PAM Authentication Plugin
* Publish Over SSH
* SSH Credentials Plugin


[ref](https://gist.github.com/wataru420/1757063)



# 升级
RPM可以不用重装的。查看 /etc/init.d/jenkins 可以找到war包的路径。下载新的war包替换即可。