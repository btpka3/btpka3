# 常用插件
* Ant Plugin
* Credentials Plugin
* CVS Plugin
* External Monitor Job Type Plugin
* Javadoc Plugin
* Jenkins Parameterized Trigger plugin
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
* Mailer
* Maven Project Plugin
* PAM Authentication Plugin
* Publish Over SSH
* SSH Credentials Plugin
