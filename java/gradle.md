
[gradle](http://gradle.org/)



```
wget https://downloads.gradle.org/distributions/gradle-2.11-bin.zip
sudo mkdir /usr/local/grale/
sudo unzip gradle-2.11-bin.zip -d /usr/local/grale/


sudo vi /etc/profile.d/zll.sh
export GRADLE_HOME=/usr/local/grale/gradle-2.11
export PATH=$GRADLE_HOME/bin:$PATH

# 启用 Gradle Daemon
vi ~/.gradle/gradle.properties
org.gradle.daemon=true


# 列出所有task
gradle tasks --all
```

## 上传到 maven 仓库

```
apply plugin: 'java'
apply plugin: 'maven'

repositories {
    maven {
          url "http://localhost:8081/nexus/content/groups/public"
    }
}

dependencies {
    testCompile "junit:junit:3.8.1"
    compile "org.jbundle.util:org.jbundle.util.jbackup:2.0.0"
    compile "net.sf.webtestfixtures:webtestfixtures:2.0.1.3"
}

uploadArchives {
    repositories {
       mavenDeployer {
            repository(url: "http://localhost:8081/nexus/content/repositories/releases") {
                authentication(userName: "admin", password: "admin123")
            }
            snapshotRepository(url: 'http://localhost:8081/nexus/content/repositories/snapshots') {
                authentication(userName: 'admin', password: 'admin123');  
            }
             //pom.version = "1.0-SNAPSHOT"
             //pom.artifactId = "simple-project"
             //pom.groupId = "com.example"
       }
    }
}
```

## 打包 source ，javadoc jar包

```groovy
task sourcesJar(type: Jar, dependsOn: classes) {
    classifier = 'sources'
    from sourceSets.main.allSource
}
task javadocJar(type: Jar, dependsOn: javadoc) {
    classifier = 'javadoc'
    from javadoc.destinationDir
}

artifacts {
    archives sourcesJar
    archives javadocJar
}
```

## 添加任务到 build
```groovy
task hello() {
}

rootProject.tasks.getByName('build').dependsOn hello
```

## tar

```groovy
/*
// INPUT
./build/a/a1.txt
./build/a/a2.txt
./build/b/b1.txt
./build/b/b2.txt
// OUTPUT
qh-agency-wap-front-1.1.0-SNAPSHOT-btpka3.tgz
/aaa/a1.txt
/bbb/a1.txt
*/
task myTar(type: Tar) {
    classifier = "btpka3"
    compression = Compression.GZIP
    archiveName = "${baseName}-${version}-${classifier}.${extension}"
    destinationDir = file("build/tmp")
    duplicatesStrategy = DuplicatesStrategy.WARN

    from("build/a") {
        exclude("a2.txt")
        into("aaa")

    }

    from("build/b") {
        exclude("b2.txt")
        into("bbb")
    }

    eachFile { FileCopyDetails fcd ->
        println "-----" + fcd.path
        //fcd.exclude()
    }
}
```

## upload 

```groovy
apply plugin: 'distribution'
distributions {
    //test12 {
    //    baseName = project.name
    //}
    main {  // prod
        baseName = project.name
    }
}

task buildProd() {
    group "build"

    doLast {
        ConfigurableFileTree ft = fileTree('src/main/dist')
        ft.exclude(".gitkeep")
        ft.visit { FileVisitDetails fvd ->
            delete fvd.file
        }
        project.exec {
            commandLine "${npm}", "run", "webpack", "--", "--env.env=prod", "--env.out=src/main/dist"
        }
    }
}
tasks.distTar.dependsOn buildProd
tasks.distTar.compression = Compression.GZIP

tasks.distZip.dependsOn buildProd

//
//task listDistributions() {
//
//    DefaultDistributionContainer c = project.extensions.getByName("distributions")
//    c.forEach { Distribution d ->
//        println """
//===================== listDistributions :  ${d}
//name        : ${d.name}
//baseName    : ${d.baseName}
//"""
//    }
//
//}
//
//task listArtifacts() {
//    Configuration c = project.configurations.getByName("archives")
//    c.getArtifacts().forEach { PublishArtifact a ->
//        println """
//===================== listArtifacts :  ${a}
//name        : ${a.name}
//type        : ${a.type}
//extension   : ${a.extension}
//classifier  : ${a.classifier}
//"""
//    }
//}
```

## exec

```groovy
def stdout = new ByteArrayOutputStream()
project.exec {
    standardOutput = stdout
    commandLine "echo","111","222"
}
println "-----------------------" + stdout
```

## download source


```groovy
apply plugin: 'eclipse'
apply plugin: 'idea'
idea {
    module {
        downloadJavadoc = false
        downloadSources = true
    }
}
eclipse {
    classpath {
        downloadSources = true
    }
}
// 注意：不要启用 `mavenLocal()` 仓库
```
## 程序使用版本号
[ref](http://stackoverflow.com/a/34786210/533317)

gradle.properties
```properties
group=net.kingsilk
version=0.1.0
sourceCompatibility=1.8
targetCompatibility=1.8
springBootVersion=1.5.2.RELEASE
```

build.gradle
```gradle
buildscript {
    ext {
    }
    repositories {
        maven { url "http://maven.aliyun.com/nexus/content/groups/public/" }
        mavenCentral()
    }
    dependencies {
        classpath("org.springframework.boot:spring-boot-gradle-plugin:${springBootVersion}")
        classpath("io.spring.gradle:dependency-management-plugin:1.0.0.RELEASE")
        classpath("org.eclipse.jgit:org.eclipse.jgit:4.5.0.201609210915-r")
    }
}


import org.codehaus.groovy.runtime.*
import org.eclipse.jgit.api.*

def getGitBranchCommit() {

    try {
        def git = Git.open(project.file(project.getRootProject().getProjectDir()));
        def repo = git.getRepository();
        def id = repo.resolve(repo.getFullBranch());
        return id.abbreviate(7).name()
    } catch (IOException ex) {
        return "UNKNOWN"
    }

}

processResources {
    filesMatching("**/version.properties") {
        expand(
                "prodVersion": version,
                "prodBuild": getGitBranchCommit(),
                "buildTimestamp": DateGroovyMethods.format(new Date(), 'yyyy-MM-dd HH:mm')
        )
    }
}
processResources.outputs.upToDateWhen { false }
```



## run main

build.gradle

```
################################### JavaExec
# gradle -PmainClass=Boo -Dexec.args="arg1 arg2 arg3" execute
task execute(type:JavaExec) {
   main = mainClass
   classpath = sourceSets.main.runtimeClasspath
   args System.getProperty("exec.args").split()
}

// gradle -DmainClass=me.test.Example -Dexec.args="arg1 arg2 arg3" execute
task execute(type:JavaExec) {
    main = System.getProperty('mainClass')
    classpath = sourceSets.main.runtimeClasspath
    args System.getProperty("exec.args").split()
}

################################### application plugin
# gradle run -Dexec.args="arg1 arg2 arg3"
mainClassName =  System.properties['mainClass']
run {    
    /* Can pass all the properties: */
    systemProperties System.getProperties()

    /* Need to split the space-delimited value in the exec.args */
    args System.getProperty("exec.args").split()    
}

################################### spring-boot plugin
// gradle bootRun -DmainClass=me.test.Example -Dexec.args="arg1 arg2 arg3"
springBoot {
    mainClass = System.properties['mainClass']
    args System.getProperty("exec.args").split() 
}
```

## init plugin

```
gradle init --type groovy-library
gradle wrapper --gradle-version 3.2.1
```

## init script
maven可以通过 settings.xml 进行全局配置，比如本地仓库的位置，mirror等。
那Gradle如何进行类似设置？——可以使用 [init script](https://docs.gradle.org/current/userguide/init_scripts.html)

创建文件 `~/.gradle/init.gradle`

```
allprojects {
    repositories {
        mavenLocal()
        maven {
            url "http://mvn.kingsilk.xyz/content/groups/public/"
        }
    }
}

```

# io.spring.gradle:dependency-management-plugin


https://spring.io/blog/2015/02/23/better-dependency-management-for-gradle

```
buildscript {
  repositories {
    jcenter()
  }
  dependencies {
    classpath "io.spring.gradle:dependency-management-plugin:0.5.1.RELEASE"
  }
}

apply plugin: "io.spring.dependency-management"

dependencyManagement {
  imports {
    mavenBom 'io.spring.platform:platform-bom:1.1.1.RELEASE'
  }
}
dependencies {
    compile 'org.springframework:spring-core'
}
```
