

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




# multiple layers

layerd 模式，不改改变 spring boot fat jar 包的目录格式
仍然是  `/`,  `BOOT-INF/classes`, `BOOT-INF/lib`  的目录结构。
仅仅增加了 `BOOT-INF/layers.idx`,
如果 includeLayerTools=true ，还 会增加 `BOOT-INF/lib/spring-boot-jarmode-layertools-3.2.2.jar`。


但是为了能复用 docker 的分层镜像能力，加快构建速度，故 按照配置 默认 将 完整 jar 包中的文件分成多个 逻辑上的layer，
并将分层信息写入到 BOOT-INF/layers.idx 中。
最后 通过  java -Djarmode=layertools -jar demo-0.0.1.jar extract

注意： includeLayerTools=true 时 fat jar 中会包含 `BOOT-INF/lib/spring-boot-jarmode-layertools-3.2.2.jar`

《[Reusing Docker Layers with Spring Boot](https://www.baeldung.com/docker-layers-spring-boot)》
《[Creating Docker Images with Spring Boot](https://www.baeldung.com/spring-boot-docker-images#layered-jars)》
  https://github.com/eugenp/tutorials/tree/master/docker-modules/docker-spring-boot

- 先 maven 打包
- 再 java -Djarmode=layertools -jar demo-0.0.1.jar extract  输出不同的 layer 目录，每个 layer 的根目录 都相当于 fat jar 内部的根目录
- Dockerfile:


```shell
# 查看 jar 的 layers
java -Djarmode=layertools -jar demo-0.0.1.jar list
# 解压
java -Djarmode=layertools -jar demo-0.0.1.jar extract


```

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
- org.springframework.boot.gradle.tasks.bundling.BootJar#copy  # bootJar task 的入口
- org.springframework.boot.gradle.tasks.bundling.BootArchiveSupport
- org.springframework.boot.gradle.tasks.bundling.BootZipCopyAction#execute
- org.gradle.api.file.FileCopyDetails               # 哪里生成的？
- org.springframework.boot.loader.tools.layer.CustomLayers#selectLayer
- org.springframework.boot.gradle.tasks.bundling.BootArchive
- org.springframework.boot.gradle.plugin.JavaPluginAction#configureBootJarTask  // ⭕️⭕️⭕️ 配置 bootJar

```shell
bootJar.classpath = [ "/**/build/classes/java/main", "/**/build/resources/main", "/**/*.jar" ]
bootJar.source = [ "/**/build/tmp/bootJar/MANIFEST.MF", "/**/build/classes/java/main/**", "/**/build/resources/main/**", "/**/*.jar" ]


# 如果要将 BOOT-INF/classes 下的 部分 类移到 root , 可以用以下方式配置
tasks.named("bootJar") {
    // ...
    filesMatching("**/MyLoader*", { details ->
        println "=======88888 filesMatching : " \
            + "\n\t details                        =" + details \
            + "\n\t details.getRelativeSourcePath()=" + details.getRelativeSourcePath() \
            + "\n\t details.getRelativePath()      =" + details.getRelativePath()

        // relativeSourcePath = com/github/btpka3/first/spring/loader/MyLoaderMain.class
        // relativePath       = BOOT-INF/classes/com/github/btpka3/first/spring/loader/MyLoaderMain.class
        details.setRelativePath(details.getRelativeSourcePath());
    })
}
# 然后命令行执行（注意：一定要clean，gradle 有检查，无需copy时，触发不到上述chek）
./gradlew clean bootJar ; unzip -l build/libs/first-spring-loader-0.0.1-SNAPSHOT.jar | grep MyLoader
```


# pom.xml
方式1： 做为parent
```xml
  <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>1.5.9.RELEASE</version>
  </parent
```

方式2： import bom
```xml
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-dependencies</artifactId>
            <version>1.0.0.RELEASE</version>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```



# version

| spring boot | spring framework |
|-------------|------------------|
|3.2.2        |6.1.3             |
|3.0.0        |6.0.2             |
|2.7.18       |5.3.31            |
|2.7.18       |5.3.31            |
|2.0.0.RELEASE|5.0.4.RELEASE     |
|1.5.9.RELEASE|4.3.13.RELEASE    |
|1.0.0.RELEASE|4.0.3.RELEASE     |




