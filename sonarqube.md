

# 触发运行



## 集成 Idea Intellij

Idea 中安装 [SonarLint](http://www.sonarlint.org/intellij/index.html) 插件, 但仅限开发语言——Java，Js，PHP（不包括 Groovy）








## SonarQube Scanner
参考 《[Analyzing Source Code](http://docs.sonarqube.org/display/SONAR/Analyzing+Source+Code)》

```
sudo mkdir /usr/local/sonarqube
sudo unzip sonar-scanner-2.6.1.zip -d /usr/local/sonarqube/

sudo vi /etc/profile.d/xxx.sh
export SONAR_QUBE_SCANNER_HOME=/usr/local/sonarqube/sonar-scanner-2.6.1/
export PATH=$SONAR_QUBE_SCANNER_HOME/bin:$PATH

cd $PROJECT_ROOT
vi sonar-project.properties
sonar-scanner
```
sonar-project.properties 文件示例
```
sonar.host.url=http://test12.kingsilk.xyz:9000
sonar.projectKey=net.kingsilk:qh-wap-front
sonar.projectName=qh-wap-front
sonar.projectVersion=2.1.0
sonar.sources=\
  src/controllers,\
  src/directives,\
  src/filters,\
  src/services,\
  src/views,\
  src/index.js,\
  src/config.js
sonar.sourceEncoding=UTF-8
#sonar.exclusions=\
#  grails-app/controllers/xyz/kingsilk/qh/wap/controller/Test*.groovy
```
