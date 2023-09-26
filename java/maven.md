
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


## maven-dependency-plugin



```bash
# 清除本地缓存
mvn dependency:purge-local-repository  -DsnapshotsOnly=true

# 显示给定的jar是如何依赖进来的
mvn dependency:tree -Dincludes=org.springframework:spring

# 给定版本的jar包如何被仲裁的？
mvn help:effective-pom -Dverbose=true -pl xxx
mvn help:effective-pom -Dverbose=true -Dartifact=commons-logging:commons-logging
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
* maven-shade-plugin

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