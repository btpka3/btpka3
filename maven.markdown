
## 下载站
http://jenv.mvnsearch.org/

## 安装

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
gpg2 --gen-key              # 生成密钥对儿
gpg2 --list-keys            # 列出公钥
gpg2 --list-secret-keys     # 列出密钥

gpg2 -ab xxx.txt            # 对指定的文件进行签名
gpg2 --verify xxx.txt.asc   # 对指定文件的签名进行校验

                            # 发布公钥
gpg2 --keyserver hkp://pool.sks-keyservers.net --send-keys C6EED57A      

                            # 其他人员载入你的公钥
gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys C6EED57A


gpg2 --edit-key A6BAB25C    # 编辑公钥
    1                       # 选择特定的公钥（如果有多个的话）
    expire                  # 重新设置过期时间
    save                    # 保存
                            # TODO 重新发布公钥
```






## 下载单个jar包

```
#  since 3.1
mvn dependency:get -Dtransitive=false -Dartifact=org.springframework:spring-instrument:3.2.3.RELEASE
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
                         [-DpomFile=your-pom.xml] \
                         [-Dsources=src.jar] \
                         [-Djavadoc=apidocs.jar] \
                         [-DgroupId=org.some.group] \
                         [-DartifactId=your-artifact] \
                         [-Dversion=1.0] \
                         [-Dpackaging=jar] \
                         [-Dclassifier=sources] \
                         [-DgeneratePom=true] \
                         [-DcreateChecksum=true]


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
```sh
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
      <mirrorOf>*</mirrorOf>
      <name>remote-repos</name>
      <url>http://10.1.18.74:8097/artifactory/remote-repos</url>
      <id>remote-repos</id>
    </mirror>
  </mirrors>

  <profiles>
    <profile>
      <id>downloadSources</id>
      <properties>
        <downloadSources>true</downloadSources>
        <downloadJavadocs>true</downloadJavadocs>
      </properties>
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

