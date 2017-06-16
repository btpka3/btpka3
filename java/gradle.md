
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

# 禁用 daemon
./gradlew -Dorg.gradle.daemon=false build

# 远程调试 gradle 插件
./gradlew --stop
export GRADLE_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005"
./gradlew -Dorg.gradle.daemon=false build
```


## Project


```
## Script
groovy.lang.Script
org.gradle.groovy.scripts.BasicScript
    getProperty()
        // 先从当前 script binding 对象中获取
        // 再从当前 script 中获取
        // 最后从 DynamicObject——ProjectInternal 上获取
        //   -> ExtensibleDynamicObject#getProperty() 依次代理下面对象上的属性、方法: (其中 this == extensibleDynamicObject)
        //         1. this.extraPropertiesDynamicObject                = new ExtraPropertiesDynamicObjectAdapter(DefaultProject.class, this.convention.getExtraProperties());
        //                                                            -> "ext" 属性映射到 ExtraPropertiesExtension 实例
        //         2. this.beforeConvention                            = new BeanDynamicObject(buildScript)
        //         3. this.convention.getExtensionsAsDynamicObject()   = this.convention == new DefaultConvention(defaultProject.services.get(Instantiator.class))
        //                                                           new DefaultConvention.ExtensionsDynamicObject()#getProperty()
        //                                                                1.  先 查找插件提供的 extension 2. 再 查找插件提供的 convention 属性
                    // BuildScopeServiceRegistryFactory
                    // GradleScopeServices
                    //      #add(GradleInternal)
                    //      #addProvider(new TaskExecutionServices());
                    // DefaultServiceRegistry#getServiceProvider()
                    // BuildScopeServices
        //                                                                  DefaultTaskContainer
        //         4. this.parent                                      = ??? 

        //          this. dynamicDelegate =new BeanDynamicObject(defaultProject, DefaultProject.class)

        // this.afterConvention = defaultProject.taskContainer.getTasksAsDynamicObject()
        
    invokeMethod()
        // 再从当前 script 中获取
        // 最后从 DynamicObject——ProjectInternal 上获取
        
new ExtensibleDynamicObject(this,            Project.class, (Instantiator)this.services.get(Instantiator.class));
                            Object delegate, Class<?> publicType, Instantiator instantiator

this(delegate, (AbstractDynamicObject)createDynamicObject(delegate, publicType), (Convention)(new DefaultConvention(instantiator)));
public ExtensibleDynamicObject(Object delegate, AbstractDynamicObject dynamicDelegate, Convention convention) {
        this.dynamicDelegate = dynamicDelegate;
        this.convention = convention;
        this.extraPropertiesDynamicObject = new ExtraPropertiesDynamicObjectAdapter(delegate.getClass(), convention.getExtraProperties());
        this.updateDelegates();
    }


org.gradle.groovy.scripts.DefaultScript     
   定义了 mkdir， file，fileTree 等方法，
   但是这些方法都是代理了 fileOperations —— ProjectInternal 上的对应方法。

* org.gradle.api.internal.project.ProjectScript
    getScriptTarget() == ProjectInternal

* org.gradle.api.Project
* org.gradle.api.internal.project.ProjectFactory
* org.gradle.api.internal.project.DefaultProject

// DefaultScript#buildscript(Closure)
buildscript {

}

// DefaultProject#dependencies(Closure)
// -> DependencyHandler DefaultProject#getDependencies() 
// -> 对 DependencyHandler 应用 Closure
dependencies {  

    // DefaultDependencyHandler#invokeMethod()
    // -> DefaultDependencyHandler#configurationContainer.findByName(name)
    // -> DefaultDependencyHandler#doAdd(Configuration, dependencyNotation, Closure)
    compile ""  
}

// Project#task(Map<String, ?> args, String name, Closure configureClosure);
task myTar(type:Tar){
    baseName = "xxx"
    doLast {
    }
}


# 创建 task
task aaa(){
}

//  创建时，传递就options 为hashMap == [name:"aaaa"]
"main@1" prio=5 tid=0x1 nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.gradle.api.internal.tasks.DefaultTaskContainer.create(DefaultTaskContainer.java:71)
	  at org.gradle.api.internal.tasks.DefaultTaskContainer.create(DefaultTaskContainer.java:115)
	  at org.gradle.api.internal.project.DefaultProject.task(DefaultProject.java:999)
	  at sun.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:498)
	  at org.codehaus.groovy.reflection.CachedMethod.invoke(CachedMethod.java:93)
	  at groovy.lang.MetaMethod.doMethodInvoke(MetaMethod.java:325)
	  at org.gradle.internal.metaobject.BeanDynamicObject$MetaClassAdapter.invokeMethod(BeanDynamicObject.java:464)
	  at org.gradle.internal.metaobject.BeanDynamicObject.invokeMethod(BeanDynamicObject.java:176)
	  at org.gradle.internal.metaobject.CompositeDynamicObject.invokeMethod(CompositeDynamicObject.java:96)
	  at org.gradle.internal.metaobject.MixInClosurePropertiesAsMethodsDynamicObject.invokeMethod(MixInClosurePropertiesAsMethodsDynamicObject.java:30)
	  at org.gradle.groovy.scripts.BasicScript.invokeMethod(BasicScript.java:111)
	  at org.gradle.groovy.scripts.BasicScript.methodMissing(BasicScript.java:120)
	  at sun.reflect.GeneratedMethodAccessor19.invoke(Unknown Source:-1)
	  at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:498)
	  at org.codehaus.groovy.reflection.CachedMethod.invoke(CachedMethod.java:93)
	  at groovy.lang.MetaClassImpl.invokeMissingMethod(MetaClassImpl.java:941)
	  at groovy.lang.MetaClassImpl.invokePropertyOrMissing(MetaClassImpl.java:1264)
	  at groovy.lang.MetaClassImpl.invokeMethod(MetaClassImpl.java:1217)
	  at groovy.lang.MetaClassImpl.invokeMethod(MetaClassImpl.java:1024)
	  at org.codehaus.groovy.runtime.callsite.PogoMetaClassSite.callCurrent(PogoMetaClassSite.java:69)
	  at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCallCurrent(CallSiteArray.java:52)
	  at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callCurrent(AbstractCallSite.java:154)
	  at org.codehaus.groovy.runtime.callsite.AbstractCallSite.callCurrent(AbstractCallSite.java:174)
	  at build_5fzjd1yckxdq669oxhfdfdcqp.run(/Users/zll/work/git-repo/kingsilk/qh-agency/qh-agency-wap-front/build.gradle:62)
	  at org.gradle.groovy.scripts.internal.DefaultScriptRunnerFactory$ScriptRunnerImpl.run(DefaultScriptRunnerFactory.java:90)
	  at org.gradle.configuration.DefaultScriptPluginFactory$ScriptPluginImpl$2.run(DefaultScriptPluginFactory.java:176)
	  at org.gradle.configuration.ProjectScriptTarget.addConfiguration(ProjectScriptTarget.java:77)
	  at org.gradle.configuration.DefaultScriptPluginFactory$ScriptPluginImpl.apply(DefaultScriptPluginFactory.java:181)
	  at org.gradle.configuration.project.BuildScriptProcessor.execute(BuildScriptProcessor.java:39)
	  at org.gradle.configuration.project.BuildScriptProcessor.execute(BuildScriptProcessor.java:26)
	  at org.gradle.configuration.project.ConfigureActionsProjectEvaluator.evaluate(ConfigureActionsProjectEvaluator.java:34)
	  at org.gradle.configuration.project.LifecycleProjectEvaluator.doConfigure(LifecycleProjectEvaluator.java:70)
	  at org.gradle.configuration.project.LifecycleProjectEvaluator.access$000(LifecycleProjectEvaluator.java:33)
	  at org.gradle.configuration.project.LifecycleProjectEvaluator$1.execute(LifecycleProjectEvaluator.java:53)
	  at org.gradle.configuration.project.LifecycleProjectEvaluator$1.execute(LifecycleProjectEvaluator.java:50)
	  at org.gradle.internal.Transformers$4.transform(Transformers.java:169)
	  at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:106)
	  at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:61)
	  at org.gradle.configuration.project.LifecycleProjectEvaluator.evaluate(LifecycleProjectEvaluator.java:50)
	  at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:599)
	  at org.gradle.api.internal.project.DefaultProject.evaluate(DefaultProject.java:125)
	  at org.gradle.execution.TaskPathProjectEvaluator.configure(TaskPathProjectEvaluator.java:35)
	  at org.gradle.execution.TaskPathProjectEvaluator.configureHierarchy(TaskPathProjectEvaluator.java:62)
	  at org.gradle.configuration.DefaultBuildConfigurer.configure(DefaultBuildConfigurer.java:38)
	  at org.gradle.initialization.DefaultGradleLauncher$ConfigureBuildAction.execute(DefaultGradleLauncher.java:233)
	  at org.gradle.initialization.DefaultGradleLauncher$ConfigureBuildAction.execute(DefaultGradleLauncher.java:230)
	  at org.gradle.internal.Transformers$4.transform(Transformers.java:169)
	  at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:106)
	  at org.gradle.internal.progress.DefaultBuildOperationExecutor.run(DefaultBuildOperationExecutor.java:56)
	  at org.gradle.initialization.DefaultGradleLauncher.doBuildStages(DefaultGradleLauncher.java:160)
	  at org.gradle.initialization.DefaultGradleLauncher.doBuild(DefaultGradleLauncher.java:119)
	  at org.gradle.initialization.DefaultGradleLauncher.run(DefaultGradleLauncher.java:102)
	  at org.gradle.launcher.exec.GradleBuildController.run(GradleBuildController.java:71)
	  at org.gradle.tooling.internal.provider.ExecuteBuildActionRunner.run(ExecuteBuildActionRunner.java:28)
	  at org.gradle.launcher.exec.ChainingBuildActionRunner.run(ChainingBuildActionRunner.java:35)
	  at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:41)
	  at org.gradle.launcher.exec.InProcessBuildActionExecuter.execute(InProcessBuildActionExecuter.java:26)
	  at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:75)
	  at org.gradle.tooling.internal.provider.ContinuousBuildActionExecuter.execute(ContinuousBuildActionExecuter.java:49)
	  at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:49)
	  at org.gradle.tooling.internal.provider.ServicesSetupBuildActionExecuter.execute(ServicesSetupBuildActionExecuter.java:31)
	  at org.gradle.launcher.cli.RunBuildAction.run(RunBuildAction.java:51)
	  at org.gradle.internal.Actions$RunnableActionAdapter.execute(Actions.java:173)
	  at org.gradle.launcher.cli.CommandLineActionFactory$ParseAndBuildAction.execute(CommandLineActionFactory.java:244)
	  at org.gradle.launcher.cli.CommandLineActionFactory$ParseAndBuildAction.execute(CommandLineActionFactory.java:217)
	  at org.gradle.launcher.cli.JavaRuntimeValidationAction.execute(JavaRuntimeValidationAction.java:33)
	  at org.gradle.launcher.cli.JavaRuntimeValidationAction.execute(JavaRuntimeValidationAction.java:24)
	  at org.gradle.launcher.cli.ExceptionReportingAction.execute(ExceptionReportingAction.java:33)
	  at org.gradle.launcher.cli.ExceptionReportingAction.execute(ExceptionReportingAction.java:22)
	  at org.gradle.launcher.cli.CommandLineActionFactory$WithLogging.execute(CommandLineActionFactory.java:210)
	  at org.gradle.launcher.cli.CommandLineActionFactory$WithLogging.execute(CommandLineActionFactory.java:174)
	  at org.gradle.launcher.Main.doAction(Main.java:33)
	  at org.gradle.launcher.bootstrap.EntryPoint.run(EntryPoint.java:45)
	  at sun.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:498)
	  at org.gradle.launcher.bootstrap.ProcessBootstrap.runNoExit(ProcessBootstrap.java:60)
	  at org.gradle.launcher.bootstrap.ProcessBootstrap.run(ProcessBootstrap.java:37)
	  at org.gradle.launcher.GradleMain.main(GradleMain.java:23)
	  at sun.reflect.NativeMethodAccessorImpl.invoke0(NativeMethodAccessorImpl.java:-1)
	  at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
	  at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	  at java.lang.reflect.Method.invoke(Method.java:498)
	  at org.gradle.wrapper.BootstrapMainStarter.start(BootstrapMainStarter.java:30)
	  at org.gradle.wrapper.WrapperExecutor.execute(WrapperExecutor.java:129)
	  at org.gradle.wrapper.GradleWrapperMain.main(GradleWrapperMain.java:61)
```

## task dsl

通过 groovy 官方关于DSL的示例，根本没有找到直接将标识符当成字符串处理的的例子。

```txt
// 实际发现调用的是 TaskContainer#create() 方法，且下面的  aaaa 是以 字符串类型的 "aaaa" 作为参数传入的。
task aaaa(type:Tar){
  println "Hello"
}

通过在 
    `groovy.lang.Script`、
    `org.gradle.groovy.scripts.BasicScript`、
    `org.gradle.api.internal.plugins.DefaultConvention.ExtensionsDynamicObject`
的 
    `getProperty()`、 
    `invokeMethod()`
等方法上打条件断点，均未发现有以 "aaaa" 作为名称调用的。
而且从调用堆栈上看，该是从自动生成的Script类就直接调用 task 方法的。
思来想去，就只能是先 AST 修改调用方法了。比如上面的task方法可能被 AST 修改为：

task (type:Tar, "aaaa"){
    println "Hello"
}

根据猜猜，在 gradle 的github仓库里，通过源代码查找，终于证实了我的想法。
具体请参考：
org.gradle.groovy.scripts.internal.TaskDefinitionScriptTransformer
https://github.com/gradle/gradle/blob/v3.4.1/subprojects/core/src/main/java/org/gradle/groovy/scripts/internal/TaskDefinitionScriptTransformer.java

该类是由 BuildScriptTransformer 注册调用的。
```

## 使用手动编写的 pom.xml 的内容

```
apply plugin: 'maven-publish'


publishing {
    publications {
        mavenJava(MavenPublication) {
            artifacts.clear()
            
            // 方式1： 完全使用手写的 pom.xml
            pom.withXml(){
                asString().setLength(0)
                asString().append(file('pom.xml').text.replaceAll(~/\$\{aaa\}/, "123456"))
            }
//            // 修改
//            pom.withXml {
//                asNode().children().last() + {
//
//                    def d = delegate
//
//                    d.dependencyManagement {
//                        d.dependencies {
//                            parent.subprojects.sort { "$it.name" }.each { p ->
//                                if (p != project) {
//                                    d.dependency {
//                                        d.groupId(p.group)
//                                        d.artifactId(p.name)
//                                        d.version(p.version)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//                // 修改
//                pom.withXml {
//                    asNode().appendNode('description',
//                            'A demonstration of maven POM customization')
//                }
        }
    }
    repositories {
        maven {
            credentials {
                username "admin"
                password "admin123"
            }
            if (project.version.endsWith('-SNAPSHOT')) {
                url "http://mvn.kingsilk.xyz/content/repositories/snapshots/"
            } else {
                url "http://mvn.kingsilk.xyz/content/repositories/releases/"
            }
        }
    }
}
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

## npm

参考：[1](http://depressiverobot.com/2016/02/05/intellij-path.html)

```bash
# FIXME 发现 gradle 在 idea IntelliJ 中 不能找到 node， npm 等命令 

sudo launchctl config user path /usr/bin:/bin:/usr/sbin:/sbin

# 以下命令虽然可以，但需要重启，只能以当前环境变量为基准，之后一直不变，仍然不够灵活
sudo launchctl config user path $PATH

# 修改 
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
tasks.distTar.classifier = "prod"
tasks.distTar.compression = Compression.GZIP

tasks.distZip.dependsOn buildProd
tasks.distZip.classifier = "prod"

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
