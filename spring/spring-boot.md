

* [reference guide](http://projects.spring.io/spring-boot/#quick-start)

## banner
默认打印 classpath下 banner.txt，可以修改文件位置和编码。
也可以是图片，图片的话会转为 [ASCII art](https://en.wikipedia.org/wiki/ASCII_art)。

一些在线的 ASCII art 工具：
* [Text to ASCII Art Generator (TAAG)](http://www.patorjk.com/software/taag/)
* [1](http://ascii.mastervb.net/text_to_ascii.php)
* [2](http://chris.com/ascii/)
* [5 Best Ascii Art Generators (Convert your Image to Text)](http://www.mytrickpages.com/2013/10/5-best-ascii-art-generators-convert-your-image-to-text.html)


# gradle 启动多个 profile

```
# build.gradle
bootRun {
    String activeProfile =  System.properties['spring.profiles.active']
    String confLoc = System.properties['spring.config.location']
    systemProperty "spring.profiles.active", activeProfile
    systemProperty "spring.config.location", "file:$confLoc"
}

./gradlew -Dspring.profiles.active=a,b bootRun

# idea intellij 的 Run/Debug 中编辑窗口如下配置：
Tasks:              bootRun
VM options:         -Dspring.profiles.active=a,b
Script parameters:
```


# jar

```shell
# 查看 jar 的 layers
java -Djarmode=layertools -jar demo-0.0.1.jar list
# 解压
java -Djarmode=layertools -jar demo-0.0.1.jar extract
```

# multiple layers

《[Reusing Docker Layers with Spring Boot](https://www.baeldung.com/docker-layers-spring-boot)》
《[Creating Docker Images with Spring Boot](https://www.baeldung.com/spring-boot-docker-images#layered-jars)》
  https://github.com/eugenp/tutorials/tree/master/docker-modules/docker-spring-boot

- 先 maven 打包
- 再 java -Djarmode=layertools -jar demo-0.0.1.jar extract  输出不同的 layer 目录，每个 layer 的根目录 都相当于 fat jar 内部的根目录
- Dockerfile:


# logging

- spring-boot-2.7.11.jar!/org/springframework/boot/logging/logback/defaults.xml
- spring-boot-2.7.11.jar!/org/springframework/boot/logging/logback/base.xml
- org.springframework.boot.logging.LoggingSystem
- org.springframework.boot.logging.LoggingSystem#get(java.lang.ClassLoader)
- org.springframework.boot.logging.LoggingSystemFactory  # 依次尝试使用 LogbackLoggingSystem.Factory, Log4J2LoggingSystem.Factory, JavaLoggingSystem.Factory
- org.springframework.boot.logging.AbstractLoggingSystem#getSpringConfigLocations # 拼接带 "-spring" 的log的配置文件名，比如: "logback-spring.xml"



# gradle plugin
- org.springframework.boot
    - [Spring Boot Gradle Plugin Reference Guide](https://docs.spring.io/spring-boot/docs/3.1.4/gradle-plugin/reference/htmlsingle/)
- io.spring.dependency-management

- org.springframework.boot.bom
    - [dependency-versions.html](https://docs.spring.io/spring-boot/docs/current/reference/html/dependency-versions.html#appendix.dependency-versions.properties)
    - [org.springframework.boot/spring-boot-dependencies/3.1.4/pom](https://repo1.maven.org/maven2/org/springframework/boot/spring-boot-dependencies/3.1.4/spring-boot-dependencies-3.1.4.pom)
    - [build.gradle](https://github.com/spring-projects/spring-boot/blob/v3.1.4/spring-boot-project/spring-boot-dependencies/build.gradle)
    - [BomPlugin.java](https://github.com/spring-projects/spring-boot/blob/9004966353e67765cbb369bed4ddc97817adf8ef/buildSrc/src/main/java/org/springframework/boot/build/bom/BomPlugin.java#L26)
    - [BomExtension.java](https://github.com/spring-projects/spring-boot/blob/9004966353e67765cbb369bed4ddc97817adf8ef/buildSrc/src/main/java/org/springframework/boot/build/bom/BomExtension.java)
    - [BomPluginIntegrationTests.java](https://github.com/spring-projects/spring-boot/blob/9004966353e67765cbb369bed4ddc97817adf8ef/buildSrc/src/test/java/org/springframework/boot/build/bom/BomPluginIntegrationTests.java)
    - [buildSrc/build.gradle](https://github.com/spring-projects/spring-boot/blob/9004966353e67765cbb369bed4ddc97817adf8ef/buildSrc/build.gradle#L71)
- org.springframework.boot.conventions
- org.springframework.boot.deployed
