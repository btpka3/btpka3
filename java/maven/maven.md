
# sonartype nexus

## Wget 下载最新快照

请看该 [API](https://repository.sonatype.org/nexus-restlet1x-plugin/default/docs/path__artifact_maven_redirect.html)


```bash
v="0.1.0-SNAPSHOT"

# 下载 pom 文件
wget -O "qh-common-domain-${v}.pom" "http://mvn.kingsilk.xyz/service/local/artifact/maven/redirect\
?r=public\
&g=net.kingsilk\
&a=qh-common-domain\
&v=$v\
&e=pom"

# 下载 jar 包
wget -O "qh-common-domain-${v}.jar" "http://mvn.kingsilk.xyz/service/local/artifact/maven/redirect\
?r=public\
&g=net.kingsilk\
&a=qh-common-domain\
&v=$v"
```



## 全局 exclude

- github : [maven-enforcer-plugin](https://github.com/apache/maven-enforcer/tree/enforcer-3.4.1/maven-enforcer-plugin)

```xml
<plugins>
  <plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-enforcer-plugin</artifactId>
    <version>3.0.0-M1</version>
    <executions>
      <execution>
        <goals>
          <goal>enforce</goal>
        </goals>
        <configuration>
          <rules>
            <bannedDependencies>
              <excludes>
                <exclude>log4j:log4j</exclude>
              </excludes>
            </bannedDependencies>
          </rules>
        </configuration>
      </execution>
    </executions>
  </plugin>
</plugins>
```

## 单个 artifact 的依赖树

- [ForArtifactDependencyGraphMojo.java](https://github.com/ferstl/depgraph-maven-plugin/blob/master/src/main/java/com/github/ferstl/depgraph/ForArtifactDependencyGraphMojo.java)

```shell
mvn com.github.ferstl:depgraph-maven-plugin:4.0.2:for-artifact \
  -DgroupId=org.springframework -DartifactId=spring-context -Dversion=6.0.12 \
  -DgraphFormat=text -DshowGroupIds=true -DshowVersions=true

```



## 下载站
http://jenv.mvnsearch.org/

《[开源中国 Maven 镜像库关闭访问](http://www.oschina.net/news/75946/maven-oschina-closed)》

国内替代品 http://maven.aliyun.com/r/#welcome

## 通过 sdkman 安装

[sdkman](https://sdkman.io/)

```bash
# 检查 sdkman 是否已经安装
sdk version
# 如果没有安装，则通过以下命令安装
curl -s "https://get.sdkman.io" | bash

sdk install maven 3.6.1
sdk list maven
# 安装多个版本的话，使用指定该版本
sdk use maven 3.6.1
```

## 安装2

```
sudo mkdir /usr/local/maven
sudo tar zxvf apache-maven-3.2.5-bin.tar.gz -C /usr/local/maven

vi /etc/profile.d/xxx.sh
export M2_HOME=/usr/local/maven/apache-maven-3.2.5
export PATH=$M2_HOME/bin:$PATH

mvn --version
```

## 向 Central 中心仓库发布

参考：
* 《[Guide to uploading artifacts to the Central Repository](http://maven.apache.org/guides/mini/guide-central-repository-upload.html)》
* 《[Working with PGP Signatures](http://central.sonatype.org/pages/working-with-pgp-signatures.html)》
* 《[OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html)》
* 《[发布Maven构件到中央仓库](http://my.oschina.net/songxinqiang/blog/313226)》

### gpg

```
gpg2 --version
gpg2 --gen-key              # 生成密钥对儿。比如真实姓名 btpka3, 电子邮箱 btpka3@163.com
gpg2 --list-keys            # 列出公钥
gpg2 --list-secret-keys     # 列出密钥

gpg2 -ab xxx.txt            # 对指定的文件进行签名
gpg2 --verify xxx.txt.asc   # 对指定文件的签名进行校验

                            # 查询发布过哪些公钥
gpg2 --keyserver hkp://pool.sks-keyservers.net --search-keys btpka3

                            # 发布公钥
gpg2 --keyserver hkp://pool.sks-keyservers.net --send-keys 1B2987CE0E7D4B2205F4323A3E1DC5C16350AE07

                            # 其他人员载入你的公钥
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 1B2987CE0E7D4B2205F4323A3E1DC5C16350AE07


gpg2 --edit-key A6BAB25C    # 编辑公钥
    1                       # 选择特定的公钥（如果有多个的话）
    expire                  # 重新设置过期时间
    save                    # 保存
                            # TODO 重新发布公钥
```


## wrapper

参考 [1](https://www.baeldung.com/maven-wrapper), [2](https://github.com/takari/maven-wrapper)

```bash
mvn -N io.takari:maven:wrapper -Dmaven=3.6.1
```


## version 使用变量

《[Maven CI Friendly Versions](https://maven.apache.org/maven-ci-friendly.html)》
从 Maven 3.5.0-beta-1 开始，可以使用 `${revision}`, `${sha1}`, `${changelist}` 作为 version 的占位符。
但同时还需要使用 [flatten-maven-plugin](https://www.mojohaus.org/flatten-maven-plugin/usage.html)，
否则，deploy 之后的 pom.xml 中 的version 仍然是占位符，别的工程就无法使用该pom了，使用的时候报错.

使用 flatten-maven-plugin 之后，就可以发布正确的 pom.xml。

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.codehaus.mojo</groupId>
      <artifactId>flatten-maven-plugin</artifactId>
      <version>1.1.0</version>
      <configuration>
        <updatePomFile>true</updatePomFile>
        <flattenMode>resolveCiFriendliesOnly</flattenMode>
      </configuration>
      <executions>
        <execution>
          <id>flatten</id>
          <phase>process-resources</phase>
          <goals>
            <goal>flatten</goal>
          </goals>
        </execution>
        <execution>
          <id>flatten.clean</id>
          <phase>clean</phase>
          <goals>
            <goal>clean</goal>
          </goals>
        </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```


## versions-maven-plugin
[Versions Maven Plugin](https://www.mojohaus.org/versions-maven-plugin/index.html)

引入

```xml
<plugin>
    <groupId>org.codehaus.mojo</groupId>
    <artifactId>versions-maven-plugin</artifactId>
    <version>2.11.0</version>
</plugin>
```


使用
```bash
mvn versions:display-dependency-updates
```

## maven-jdeps-plugin
[maven-jdeps-plugin](https://github.com/apache/maven-jdeps-plugin)
[Guide to Using Toolchains](https://maven.apache.org/guides/mini/guide-using-toolchains.html)

```bash
mvn org.apache.maven.plugins:maven-jdeps-plugin:3.1.2:jdkinternals
```

## maven-pmd-plugin
[maven-pmd-plugin](https://maven.apache.org/plugins/maven-pmd-plugin/)

# animal-sniffer-maven-plugin
（1）针对API提供方：用来 生成 API 签名（包含类，方法，字段）、
（2）针对API使用方：验证自己的代码是否仅仅使用了给定API签名内的接口，如果使用了给定签名以外的方法，将会报错。

- [Animal Sniffer](https://www.mojohaus.org/animal-sniffer/index.html)
- [Production Signatures](https://www.mojohaus.org/signatures/)
- [animal-sniffer-maven-plugin](https://www.mojohaus.org/animal-sniffer/animal-sniffer-maven-plugin/)
- [animal-sniffer-enforcer-rule](https://www.mojohaus.org/animal-sniffer/animal-sniffer-enforcer-rule/examples/checking-signatures.html)
- [java版本兼容_Maven：确保跨Java版本兼容性](https://blog.csdn.net/weixin_35745051/article/details/114689835)
- groupId : [org.codehaus.mojo.signature](https://search.maven.org/search?q=g:org.codehaus.mojo.signature)
- [SignatureBuilder.java](https://github.com/mojohaus/animal-sniffer/blob/master/animal-sniffer/src/main/java/org/codehaus/mojo/animal_sniffer/SignatureBuilder.java)




```bash
mvn org.codehaus.mojo:animal-sniffer-maven-plugin:1.23:build

# 需要先编译打包
mvn clean package
mvn animal-sniffer:check
```

Q1: SignatureBuilder 记录了啥？
参考 [Clazz](https://github.com/mojohaus/animal-sniffer/blob/4d7f0c1ba16d48beec368d59d15e954c00d122e2/animal-sniffer/src/main/java/org/codehaus/mojo/animal_sniffer/Clazz.java) 的格式:
- 类的全限定名
- 方法和常量的 签名
- 父 class 的类全限定名
- 父 interface 列表 的的类全限定名

保存的签名文件是 将 `Map<String, Clazz>` 通过 java.io.ObjectOutputStream 写入到文件。

Q2: SignatureBuilder 如何校验的？

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>animal-sniffer-maven-plugin</artifactId>
            <version>1.23</version>
            <configuration>
                <signature>
                    <groupId>org.codehaus.mojo.signature</groupId>
                    <artifactId>java15</artifactId>
                    <version>1.0</version>
                </signature>
            </configuration>
        </plugin>
    </plugins>
</build>
```

# maven-deploy-plugin

```shell
# -Dmaven.deploy.skip=true
# 发布 单个jar包到给定的 maven 仓库
# 注意：`-DrepositoryId` 的是 ${HOME}/.m2/settings.xml 中 `settings/servers/server` 下的id，
#      用来找到上传文件时的认证授权信息。
mvn deploy:deploy-file \
    -Durl=file://C:\m2-repo \
    -DrepositoryId=some.id \
    -Dfile=your-artifact-1.0.jar \
    [-DpomFile=your-pom.xml] \
    [-DgroupId=org.some.group] \
    [-DartifactId=your-artifact] \
    [-Dversion=1.0] \
    [-Dpackaging=jar] \
    [-Dclassifier=test] \
    [-DgeneratePom=true] \
    [-DgeneratePom.description="My Project Description"] \
    [-DrepositoryLayout=legacy] \
    [-DuniqueVersion=false]
```



# keytool-maven-plugin
[keytool-maven-plugin](https://www.mojohaus.org/keytool/keytool-maven-plugin/)
对jdk命令 keytool 的封装，用于管理秘钥。



## maven-toolchain-plugin
[maven-toolchain-plugin](https://maven.apache.org/plugins/maven-toolchains-plugin/)

## maven-dependency-plugin



```bash
# 清除本地缓存
mvn dependency:purge-local-repository  -DsnapshotsOnly=true

# 显示给定的jar是如何依赖进来的
mvn dependency:tree -Dincludes=org.springframework:spring

# 给定版本的jar包如何被仲裁/resolve 的？
mvn help:effective-pom -Dverbose=true -pl xxx
mvn help:effective-pom -Dverbose=true -Dartifact=commons-logging:commons-logging


```

## maven-install-plugin

[maven-install-plugin](https://maven.apache.org/plugins/maven-install-plugin/)

```bash
mvn install:install-file -Dfile=<path-to-file> -DgroupId=<group-id> -DartifactId=<artifact-id> -Dversion=<version> -Dpackaging=<packaging>
```




## 下载单个jar包

```
#  since 3.1
mvn dependency:get -Dtransitive=false -Dartifact=org.springframework:spring-instrument:3.2.3.RELEASE

# 下载sources jar包
mvn dependency:get -Dtransitive=false -Dartifact=org.springframework:spring-beans:4.1.8.RELEASE:jar:sources
```

## 下载源代码

```
mvn dependency:sources
mvn clean install dependency:sources -Dmaven.test.skip=true

# 部署，skip掉testcase的执行，但还运行 test-jar 等功能
mvn -Dmaven.test.skip.exec clean deploy
```

## 本地安装没有使用maven构建的jar包
```
mvn install:install-file -Dfile=your-artifact-1.0.jar \
                         -DpomFile=your-pom.xml       \
                         -Dsources=src.jar            \
                         -Djavadoc=apidocs.jar        \
                         -DgroupId=org.some.group     \
                         -DartifactId=your-artifact   \
                         -Dversion=1.0                \
                         -Dpackaging=jar              \
                         -Dclassifier=sources         \
                         -DgeneratePom=true           \
                         -DcreateChecksum=true


```

示例: 安装 neuroph-2.9

```

mvn install:install-file -Dfile=neuroph-adapters-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-adapters -Dpackaging=jar -Dversion=2.9
mvn install:install-file -Dfile=neuroph-contrib-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-contrib -Dpackaging=jar -Dversion=2.9
mvn install:install-file -Dfile=neuroph-core-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-core -Dpackaging=jar -Dversion=2.9
mvn install:install-file -Dfile=neuroph-imgrec-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-imgrec -Dpackaging=jar -Dversion=2.9
mvn install:install-file -Dfile=neuroph-ocr-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-ocr -Dpackaging=jar -Dversion=2.9
mvn install:install-file -Dfile=neuroph-samples-2.9.jar -DgroupId=org.neuroph -DartifactId=neuroph-samples -Dpackaging=jar -Dversion=2.9
```

## 多模块

[参考1](http://maven.apache.org/guides/mini/guide-multiple-modules.html)、
[参考2](http://blog.sonatype.com/people/2009/10/maven-tips-and-tricks-advanced-reactor-options/)

```
  -pl, --projects                ：只构建指定的模块列表，使用逗号分隔
  -rf, --resume-from             ：多模块构建时，跳过指定的模块
  -am, --also-make               ：在构建指定的模块时，也构建该模块所依赖的其他模块
  -amd, --also-make-dependents   ：在构建指定的模块时，也构建依赖于该模块的其他模块
```
示例：
```
# 安装leafModule1和它所依赖的模块（含父模块）
mvn -Dmaven.test.skip=true -am --projects subModule1/leafModule1 clean install
```
参考：[Guide multiple modules](http://maven.apache.org/guides/mini/guide-multiple-modules.html)
注意：使用以上参数时，当前路径应当是根模块的pom.xml所在的目录
注意：如果子模块B有一些自动生成代码的Maven插件依赖于子模块A，恐怕就不能一起编译了。而必须先install子模块A，才能在子模块B中自动生成代码、之后才可能重新一起编译、打包

## 经验
   * 在pom.xml中使用属性的存在性来激活profile。示例:

   ```xml
    <profile>
      <id>release</id>
      <activation>
        <property>
          <name>p_release</name>
        </property>
      </activation>
      <!-- ... -->
    </profile>
   ```
   之后就可以使用 `mvn -Dp_release ...` 来激活该profile了。



## 常用命令
查看那些profile生效
```bash
mvn help:active-profiles -N

# 打包所有模块，且忽略指定模块的构建错误
mvn -Dmaven.test.skip=true --resume-from xxx-maven-plugin package

# 只编译指定的模块及其依赖的模块
mvn -Dmaven.test.skip=true -am --projects my/module1,my/module2 compile
```




## 简化开发机配置
### settings.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<settings xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
          http://maven.apache.org/xsd/settings-1.0.0.xsd"
          xmlns="http://maven.apache.org/SETTINGS/1.0.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <localRepository>D:\maven\repository</localRepository>
  <servers>
    <server>
      <id>SOS-releases</id>
      <username>admin</username>
      <password>123456</password>
    </server>
    <server>
      <id>SOS-snapshots</id>
      <username>admin</username>
      <password>123456</password>
    </server>
  </servers>

      <mirrors>
    <mirror>
      <mirrorOf>central</mirrorOf>
      <name>mirror-central</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <id>mirror-central</id>
    </mirror>
  </mirrors>

  <profiles>
    <profile>
      <id>downloadSources</id>
      <properties>
        <downloadSources>true</downloadSources>
        <downloadJavadocs>false</downloadJavadocs>
      </properties>
      <repositories>
        <repository>
          <id>aliyun</id>
          <name>aliyun</name>
          <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
          <releases>
            <enabled>true</enabled>
          </releases>
          <snapshots>
              <enabled>false</enabled>
          </snapshots>
        </repository>
      </repositories>
      <pluginRepositories>
        <pluginRepository>
          <id>aliyun</id>
          <name>aliyun</name>
          <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
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
    <activeProfile>downloadSources</activeProfile>
  </activeProfiles>
</settings>
```
需要：

* 如果settings.xml 中的密码需要保密，请参考 [password encryption](http://maven.apache.org/guides/mini/guide-encryption.html)
* 局域网Maven仓库启启用分组，并且将所有仓库都纳入统一个组 `remote-repos` 中。
* `<server></server>` 配置是用以结合 pom.xml 中的 `<distributionManagement></distributionManagement>` 发布快照用的。

    ```xml
    <project>
        <distributionManagement>
            <repository>
                <id>SOS-releases</id>
                <url>http://mvn.test.me/content/repositories/releases/</url>
            </repository>
            <snapshotRepository>
                <id>SOS-snapshots</id>
                <url>http://mvn.test.me/content/repositories/snapshots/</url>
            </snapshotRepository>
        </distributionManagement>
    </project>
    ```



# 常用插件

* maven-compiler-plugin

指定编译级别。
```xml
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>2.3.2</version>
        <configuration>
          <source>1.6</source>
          <target>1.6</target>
        </configuration>
      </plugin>
```


* build-helper-maven-plugin

向Maven仓库部署非其他类型的artifact（比如：*.zip）。
```xml
 <build>
    <plugins>
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>build-helper-maven-plugin</artifactId>
        <version>1.8</version>
        <executions>
          <execution>
            <id>attach-artifacts</id>
            <phase>package</phase>
            <goals>
              <goal>attach-artifact</goal>
            </goals>
            <configuration>
              <artifacts>
                <artifact>
                  <file>target/${project.build.finalName}.zip</file>
                  <type>zip</type>
                </artifact>
              </artifacts>
            </configuration>
          </execution>
        </executions>
      </plugin>
    </plugins>
 </build>
```

* maven-jar-plugin

打包jar用，可以排除或加入特定的一些文件。
```xml
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-jar-plugin</artifactId>
        <configuration>
          <excludes>
            <exclude>config.properties</exclude>
          </excludes>
        </configuration>
      </plugin>
```

* exec-maven-plugin

    执行特定的Java程序。

    ```bash
    mvn exec:java  -Dexec.mainClass=me.test.TesseractExample
    ```

    配置示例
    ```xml
      <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>exec-maven-plugin</artifactId>
        <executions>
          <execution>
            <goals>
              <goal>java</goal>
            </goals>
          </execution>
        </executions>
        <configuration>
          <mainClass>com.alibaba.dubbo.container.Main</mainClass>
        </configuration>
      </plugin>
     ```

* maven-assembly-plugin

打包（*.tar.gz, *.zip 等格式）。
```xml
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-assembly-plugin</artifactId>
        <executions>
          <execution>
            <id>dubbo</id>
            <phase>package</phase>
            <goals>
              <goal>single</goal>
            </goals>
            <configuration>
              <appendAssemblyId>false</appendAssemblyId>
              <descriptors>
                <descriptor>${basedir}/src/main/assembly/daemon.xml</descriptor>
              </descriptors>
            </configuration>
          </execution>
        </executions>
      </plugin>
```

daemon.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<assembly xmlns="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/plugins/maven-assembly-plugin/assembly/1.1.2 http://maven.apache.org/xsd/assembly-1.1.2.xsd">
  <id>daemon</id>
  <formats>
    <format>zip</format>
  </formats>
  <dependencySets>
    <dependencySet>
      <unpack>false</unpack>
      <scope>runtime</scope>
      <outputDirectory>lib</outputDirectory>
    </dependencySet>
  </dependencySets>
  <fileSets>
    <fileSet>
      <directory>target/classes</directory> <!-- copy Maven filter 之后的 Resource -->
      <outputDirectory>conf</outputDirectory>
      <includes>
        <include>config.properties</include>
      </includes>
      <fileMode>0755</fileMode>
    </fileSet>
    <fileSet>
      <directory>.</directory>
      <outputDirectory>.</outputDirectory>
      <includes>
        <include>README*</include>
      </includes>
      <fileMode>0755</fileMode>
    </fileSet>
    <fileSet>
      <directory>target/bin</directory>
      <outputDirectory>bin</outputDirectory>
      <fileMode>0755</fileMode>
      <directoryMode>0755</directoryMode>
    </fileSet>
  </fileSets>
</assembly>
```

# plugins

# com.google.errorprone:error_prone_core
errorprone : [Installation](https://errorprone.info/docs/installation)

# Dependency-Check
[Dependency-Check](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/index.html) 主要用于检查 OWASP 中的风险依赖

```bash
mvn org.owasp:dependency-check-maven:5.0.0-M3:check
```



# NPE: NullPointerException


```bash
[ERROR] NullPointerException
java.lang.NullPointerException
    at java.util.Hashtable$Entry.setValue (Hashtable.java:1286)
    at org.apache.maven.model.interpolation.StringVisitorModelInterpolator$ModelVisitor.visit (StringVisitorModelInterpolator.java:1427)
    at org.apache.maven.model.interpolation.StringVisitorModelInterpolator$ModelVisitor.visit (StringVisitorModelInterpolator.java:1025)
    at org.apache.maven.model.interpolation.StringVisitorModelInterpolator$ModelVisitor.visit (StringVisitorModelInterpolator.java:168)
    at org.apache.maven.model.interpolation.StringVisitorModelInterpolator.interpolateModel (StringVisitorModelInterpolator.java:105)
    at org.apache.maven.model.building.DefaultModelBuilder.interpolateModel (DefaultModelBuilder.java:789)
    at org.apache.maven.model.building.DefaultModelBuilder.build (DefaultModelBuilder.java:393)
    at org.apache.maven.repository.internal.DefaultArtifactDescriptorReader.loadPom (DefaultArtifactDescriptorReader.java:292)
    at org.apache.maven.repository.internal.DefaultArtifactDescriptorReader.readArtifactDescriptor (DefaultArtifactDescriptorReader.java:171)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.resolveCachedArtifactDescriptor (DefaultDependencyCollector.java:541)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.getArtifactDescriptorResult (DefaultDependencyCollector.java:524)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:412)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.doRecurse (DefaultDependencyCollector.java:509)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:461)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.processDependency (DefaultDependencyCollector.java:365)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.process (DefaultDependencyCollector.java:352)
    at org.eclipse.aether.internal.impl.collect.DefaultDependencyCollector.collectDependencies (DefaultDependencyCollector.java:254)
    at org.eclipse.aether.internal.impl.DefaultRepositorySystem.collectDependencies (DefaultRepositorySystem.java:284)
    at org.apache.maven.project.DefaultProjectDependenciesResolver.resolve (DefaultProjectDependenciesResolver.java:169)
    at org.apache.maven.lifecycle.internal.LifecycleDependencyResolver.getDependencies (LifecycleDependencyResolver.java:243)
    at org.apache.maven.lifecycle.internal.LifecycleDependencyResolver.resolveProjectDependencies (LifecycleDependencyResolver.java:147)
    at org.apache.maven.lifecycle.internal.MojoExecutor.ensureDependenciesAreResolved (MojoExecutor.java:248)
    at org.apache.maven.lifecycle.internal.MojoExecutor.execute (MojoExecutor.java:202)
    at org.apache.maven.lifecycle.internal.MojoExecutor.execute (MojoExecutor.java:156)
    at org.apache.maven.lifecycle.internal.MojoExecutor.execute (MojoExecutor.java:148)
    at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject (LifecycleModuleBuilder.java:117)
    at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject (LifecycleModuleBuilder.java:81)
    at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build (SingleThreadedBuilder.java:56)
    at org.apache.maven.lifecycle.internal.LifecycleStarter.execute (LifecycleStarter.java:128)
    at org.apache.maven.DefaultMaven.doExecute (DefaultMaven.java:305)
    at org.apache.maven.DefaultMaven.doExecute (DefaultMaven.java:192)
    at org.apache.maven.DefaultMaven.execute (DefaultMaven.java:105)
    at org.apache.maven.cli.MavenCli.execute (MavenCli.java:956)
    at org.apache.maven.cli.MavenCli.doMain (MavenCli.java:288)
    at org.apache.maven.cli.MavenCli.main (MavenCli.java:192)
    at sun.reflect.NativeMethodAccessorImpl.invoke0 (Native Method)
    at sun.reflect.NativeMethodAccessorImpl.invoke (NativeMethodAccessorImpl.java:62)
    at sun.reflect.DelegatingMethodAccessorImpl.invoke (DelegatingMethodAccessorImpl.java:43)
    at java.lang.reflect.Method.invoke (Method.java:498)
    at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced (Launcher.java:282)
    at org.codehaus.plexus.classworlds.launcher.Launcher.launch (Launcher.java:225)
    at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode (Launcher.java:406)
    at org.codehaus.plexus.classworlds.launcher.Launcher.main (Launcher.java:347)
```





# scope

| scope  | compile | test compile | runtime | package | transitive deps | example            |
|--------|---------|--------------|---------|---------|-----------------|--------------------|
|compile | Y       | Y            | Y       | Y       | Y               | spring-core        |
|provided| Y       | Y            | X       | X       | X               | jdk, servlet-api   |
|runtime | X       | Y            | Y       | Y       |                 | jdbc driver        |
|system  | Y       | Y            | X       | X       | Y               |                    |



# MAVEN_OPTS

增加 maven jvm 内存：

-Xmx2048m -XX:MaxPermSize=1G
export MAVEN_OPTS="-Xms2048m -Xmx2048m"

```xml
<plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.11.0</version>
        <configuration>
          <fork>true</fork>
          <meminitial>128m</meminitial>
          <maxmem>512m</maxmem>
        </configuration>
      </plugin>
```


```shell
MAVEN_OPTS="-Xms512M -Xmx1024M -Xss2M -XX:MaxMetaspaceSize=1024M" mvn -Dmaven.test.skip=true clean package
```




# 原理


- org.apache.maven.execution.scope.internal.MojoExecutionScopeModule
- org.apache.maven.cli.MavenCli  # 主入口，通过 eclipse sisu /google guice 装配成兑现


===== mvn 创建 插件的 realm plugin>com.github.btpka3:hello-maven-plugin:1.0.0-SNAPSHOT
"main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.codehaus.plexus.classworlds.ClassWorld.newRealm(ClassWorld.java:71)
	  - locked <0x24c> (a org.codehaus.plexus.classworlds.ClassWorld)
	  at org.apache.maven.classrealm.DefaultClassRealmManager.newRealm(DefaultClassRealmManager.java:123)
	  at org.apache.maven.classrealm.DefaultClassRealmManager.createRealm(DefaultClassRealmManager.java:197)
	  at org.apache.maven.classrealm.DefaultClassRealmManager.createPluginRealm(DefaultClassRealmManager.java:269)              # ⭕️
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.createPluginRealm(DefaultMavenPluginManager.java:412)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.setupPluginRealm(DefaultMavenPluginManager.java:374)
	  - locked <0xddb> (a org.apache.maven.plugin.internal.DefaultMavenPluginManager)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.getPluginRealm(DefaultBuildPluginManager.java:234)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:105)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
	  at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
	  at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
	  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
	  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
	  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	  at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:566)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)

===== mvn 创建 找到插件对应的 Mojo 的实现类
"main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.eclipse.sisu.space.LoadedClass.<init>(LoadedClass.java:34)
	  at org.eclipse.sisu.plexus.ComponentDescriptorBeanModule.<init>(ComponentDescriptorBeanModule.java:72)
	  at org.codehaus.plexus.DefaultPlexusContainer.discoverComponents(DefaultPlexusContainer.java:449)
	  - locked <0x2655> (a java.util.IdentityHashMap)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.discoverPluginComponents(DefaultMavenPluginManager.java:436)    # ⭕️
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.createPluginRealm(DefaultMavenPluginManager.java:415)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.setupPluginRealm(DefaultMavenPluginManager.java:374)
	  - locked <0x262e> (a org.apache.maven.plugin.internal.DefaultMavenPluginManager)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.getPluginRealm(DefaultBuildPluginManager.java:234)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:105)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
	  at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
	  at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
	  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
	  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
	  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	  at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:566)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)


===== mvn 创建 mojo 对象
 "main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at com.github.btpka3.hello.maven.plugin.GreetingMojo.<init>(GreetingMojo.java:31)
	  at jdk.internal.reflect.NativeConstructorAccessorImpl.newInstance0(NativeConstructorAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeConstructorAccessorImpl.newInstance(NativeConstructorAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingConstructorAccessorImpl.newInstance(DelegatingConstructorAccessorImpl.java:45)
	  at java.lang.reflect.Constructor.newInstance(Constructor.java:490)
	  at com.google.inject.internal.DefaultConstructionProxyFactory$ReflectiveProxy.newInstance(DefaultConstructionProxyFactory.java:126)
	  at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:114)
	  at com.google.inject.internal.ConstructorInjector.access$000(ConstructorInjector.java:32)
	  at com.google.inject.internal.ConstructorInjector$1.call(ConstructorInjector.java:98)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:112)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:127)
	  at com.google.inject.internal.ProvisionListenerStackCallback.provision(ProvisionListenerStackCallback.java:66)
	  at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:93)
	  at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:306)
	  at com.google.inject.internal.InjectorImpl$1.get(InjectorImpl.java:1050)
	  at com.google.inject.internal.InjectorImpl.getInstance(InjectorImpl.java:1086)
	  at org.eclipse.sisu.space.AbstractDeferredClass.get(AbstractDeferredClass.java:48)
	  at com.google.inject.internal.ProviderInternalFactory.provision(ProviderInternalFactory.java:85)
	  at com.google.inject.internal.InternalFactoryToInitializableAdapter.provision(InternalFactoryToInitializableAdapter.java:57)
	  at com.google.inject.internal.ProviderInternalFactory$1.call(ProviderInternalFactory.java:66)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:112)
	  at com.google.inject.internal.ProvisionListenerStackCallback$Provision.provision(ProvisionListenerStackCallback.java:127)
	  at com.google.inject.internal.ProvisionListenerStackCallback.provision(ProvisionListenerStackCallback.java:66)
	  at com.google.inject.internal.ProviderInternalFactory.circularGet(ProviderInternalFactory.java:61)
	  at com.google.inject.internal.InternalFactoryToInitializableAdapter.get(InternalFactoryToInitializableAdapter.java:47)
	  at com.google.inject.internal.InjectorImpl$1.get(InjectorImpl.java:1050)
	  at org.eclipse.sisu.inject.Guice4$1.get(Guice4.java:162)
	  - locked <0x26b4> (a org.eclipse.sisu.inject.Guice4$1)
	  at org.eclipse.sisu.inject.LazyBeanEntry.getValue(LazyBeanEntry.java:81)
	  at org.eclipse.sisu.plexus.LazyPlexusBean.getValue(LazyPlexusBean.java:51)
	  at org.codehaus.plexus.DefaultPlexusContainer.lookup(DefaultPlexusContainer.java:263)
	  at org.codehaus.plexus.DefaultPlexusContainer.lookup(DefaultPlexusContainer.java:255)
	  at org.apache.maven.plugin.internal.DefaultMavenPluginManager.getConfiguredMojo(DefaultMavenPluginManager.java:520)
	  at org.apache.maven.plugin.DefaultBuildPluginManager.executeMojo(DefaultBuildPluginManager.java:124)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:210)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:156)
	  at org.apache.maven.lifecycle.internal.MojoExecutor.execute(MojoExecutor.java:148)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:117)
	  at org.apache.maven.lifecycle.internal.LifecycleModuleBuilder.buildProject(LifecycleModuleBuilder.java:81)
	  at org.apache.maven.lifecycle.internal.builder.singlethreaded.SingleThreadedBuilder.build(SingleThreadedBuilder.java:56)
	  at org.apache.maven.lifecycle.internal.LifecycleStarter.execute(LifecycleStarter.java:128)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:305)
	  at org.apache.maven.DefaultMaven.doExecute(DefaultMaven.java:192)
	  at org.apache.maven.DefaultMaven.execute(DefaultMaven.java:105)
	  at org.apache.maven.cli.MavenCli.execute(MavenCli.java:956)
	  at org.apache.maven.cli.MavenCli.doMain(MavenCli.java:288)
	  at org.apache.maven.cli.MavenCli.main(MavenCli.java:192)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at jdk.internal.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at jdk.internal.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:566)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launchEnhanced(Launcher.java:282)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.launch(Launcher.java:225)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.mainWithExitCode(Launcher.java:406)
	  at org.codehaus.plexus.classworlds.launcher.Launcher.main(Launcher.java:347)



# 源码
1. 给定的 pom.xml 如何解析成 对应的 org.apache.maven.model.Model ?

参考 `org.apache.maven.model.building.DefaultModelBuilder#readModel`,
`org.apache.maven.model.building.DefaultModelBuilder#buildRawModel`

2. 给定一个 Actifact ，是如何 resolve 的（下载 对应的 pom,jar 到本地 maven 仓库）

参考： `org.eclipse.aether.resolution.ArtifactRequest`, `org.eclipse.aether.RepositorySystem#resolveArtifact`



# IOC

- org.apache.maven.plugin.internal.DefaultMavenPluginManager#getConfiguredMojo
- org.codehaus.plexus.component.configurator.converters.composite.ObjectWithFieldsConverter#processConfiguration
- org.codehaus.plexus.component.configurator.ComponentConfigurator
- org.codehaus.plexus.component.configurator.converters.lookup.DefaultConverterLookup  # 参数类型转换
- org.codehaus.plexus.component.configurator.expression.ExpressionEvaluator  # evaluator.evaluate("${enforcer.failFast}") 获取对应的参数值
    - org.apache.maven.plugin.PluginParameterExpressionEvaluator#evaluate    # 里面列出可以支持的注入的 特殊属性
                                                                             # "localRepository"    : ArtifactRepository
                                                                             # "session"            : MavenSession
                                                                             # "reactorProjects"    : List<MavenProject>
                                                                             # "mojoExecution"      : MojoExecution
                                                                             # "project"            : MavenProject
                                                                             # "porject.*"          :
                                                                             # "pom.*"              :
                                                                             # "repositorySystemSession"    : RepositorySystemSession
                                                                             # "mojo"               : MojoExecution
                                                                             # "mojo.*"
                                                                             # "plugin"             : PluginDescriptor
                                                                             # "plugin.*"
                                                                             # "settings"           : Settings
                                                                             # "settings.*"
                                                                             # "basedir"
                                                                             # "basedir"
                                                                             # 从 properties 中取值

- org.codehaus.plexus.component.configurator.converters.ConfigurationConverter
- org.codehaus.plexus.component.configurator.converters.composite.ObjectWithFieldsConverter#fromExpression    # "${project}" 类似的POJO注入

