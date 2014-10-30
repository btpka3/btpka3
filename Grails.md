GORM Gotchas [part 1](http://spring.io/blog/2010/06/23/gorm-gotchas-part-1/)、[part 2](http://spring.io/blog/2010/07/02/gorm-gotchas-part-2/)、
[part 3](http://spring.io/blog/2010/07/28/gorm-gotchas-part-3/)

[参考这里](http://stackoverflow.com/questions/24309084/flush-mode-changed-in-grails-from-auto-to-manual)
grails 从 2.4 开始，默认是的flush mode 从 FlushMode.MANUAL 改为了 FlushMode.AUTO。
controller 中默认的事务是readonly，readonly事务的FlushMode是Manual。
修改 Config.groovy，设置 `grails.gorm.autoFlush = true` 可以在调用 save() 方法时，都 flush=true.

# GRAILS_OPTS

```
export GRAILS_OPTS="-server -Xms1G -Xmx2G -XX:PermSize=512m -XX:MaxPermSize=512m -XX:-UseConcMarkSweepGC"
```
# 常用命令

```sh

grails list-plugins
grails create-app my-test
cd my-test
# grails install-templates
# grails generate-all helloworld.Book
grails create-domain-class Book
grails run-app
```


# groovy-jdk vs. api vs. gapi
see [this](http://stackoverflow.com/a/6525784): 

1. api 是在所有Java文件上运行Javadoc之后的结果
1. gapi 是在所有Java文件和Groovy文件上运行groovydoc之后的结果。（最初只是groovy文件，但是现在则包含两者）
1. groovy-jdk 运行结果是对JDK进行增强的部分。


# 惯例优先原则（convention over configuration）
[参考](http://grails.org/doc/1.3.7/guide/2.%20Getting%20Started.html#2.6 Convention over Configuration)


# Grails命令的查找方式
参考：[4. The Command Line](http://grails.org/doc/1.3.7/guide/single.html#4. The Command Line)

Grails 使用[Gant](http://gant.codehaus.org/)作为构建工具，它是对Grails的[AntBuilder](http://groovy.codehaus.org/api/index.html?groovy/util/AntBuilder.html)进行了一个简单封装。

[Ant task列表](http://ant.apache.org/manual/tasklist.html)

Gant 脚本是一个Groovy文件，并调用预定义的一个AntBuilder和其他对象。其中两个主要的对象就是 includeTargets 和 includeTool。

# 配置文件
Grails读取配置文件是Groovy文件。使用的 [ConfigSlurper](http://groovy.codehaus.org/ConfigSlurper)、
 [API](http://groovy.codehaus.org/gapi/index.html?groovy/util/ConfigSlurper.html) 读取配置文件。

配置文件中也定义特定名称闭包，用以初始化特定的环境。

## log4j

[参考](http://grails.org/doc/1.3.7/guide/3.%20Configuration.html#3.1.2 Logging)、
[API](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/plugins/logging/Log4jConfig.html)

## dataSource
[GrailsDataSource](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/commons/GrailsDataSource.html)

## environments

## Dependency Resolution
[IvyDomainSpecificLanguageEvaluator](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/resolve/IvyDomainSpecificLanguageEvaluator.html)


# GORM
## Database Mapping 
[HibernateMappingBuilder](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/orm/hibernate/cfg/HibernateMappingBuilder.html)、
[Mapping](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/orm/hibernate/cfg/Mapping.html)

# Domain Classes
[HibernateCriteriaBuilder](http://grails.org/doc/1.3.7/api/index.html?grails/orm/HibernateCriteriaBuilder.html)、
[NamedCriteriaProxy](http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/orm/hibernate/cfg/NamedCriteriaProxy.html)


## Constraints
[validation(http://grails.org/doc/1.3.7/api/index.html?org/codehaus/groovy/grails/validation/package-summary.html)

##  生成递归的XML文件

```groovy

// A recursive XML demo
import groovy.xml.MarkupBuilder 

def builder = new MarkupBuilder();

// define recursive method with parameter
builder.metaClass.test = { n ->
    span {
        "l${n}" ("level" + n){
            if( n < 3 ){
                test n+1
            }
        }
    }
}

builder.div(style:"myStyle", "before text"){
    test 1
    mkp.yield "end text"
}

/*
<div style='myStyle'>before text
  <span>
    <l1>level1
      <span>
        <l2>level2
          <span>
            <l3>level3</l3>
          </span>
        </l2>
      </span>
    </l1>
  </span>end text
</div>
*/
```


# 输入sql语句
[see this](https://grails.org/FAQ#Q: How can I turn on logging for hibernate in order to see SQL statements, input parameters and output results?)

Config.groovy

```groovy
log4j {
    trace 'org.hibernate.SQL'
    trace 'org.hibernate.type'
}
```

DataSource.groovy
```groovy
dataSource {
   logSql = true
   ...
}
```

# Grails 1.3.7 升级至 2.4.0
* 修改 application.properties ，
   * 升级grails版本号

       ```properties
       app.grails.version=2.4.0
       ``` 
    * 将所有的插件依赖移至 BuildConfig.groovy 中

       ```groovy
       grails.project.dependency.resolution {
           plugins {
                compile ':tomcat:7.0.53'
           }
       }
       ```
    * 升级插件的版本号

* application.xml
    *移除bean 'grailsResourceLoader'、'grailsResourceHolder' 的定义及引用

* java

|a|b|
|---|---|
|org.codehaus.groovy.grails.commons.Holders |grails.util.Holders|
|org.codehaus.groovy.grails.commons.ConfigurationHolder|grails.util.Holders|
|org.codehaus.groovy.grails.plugins.springsecurity.SpringSecurityUtils|grails.plugin.springsecurity.SpringSecurityUtils|
|org.codehaus.groovy.grails.plugins.springsecurity.GrailsUser|grails.plugin.springsecurity.userdetails.GrailsUser|

* spring security core
 buildConfig.groovy

```groovy
# spring security core 升级至 2.0
# grails.plugins.springsecurity.* -> grails.plugin.springsecurity.*
```



# Maven

`grails create-pom me.test` 生成pom.xml 就可以使用GGTS以Maven工程的方式导入Grails工程。只不过刚开始容易造成找不到 GroovyObject 类。可以 工程上右键-> Groovy -> Add Groovy Library 解决。


以Maven形式创建Grails工程

```sh
mvn archetype:generate -DarchetypeGroupId=org.grails -DarchetypeArtifactId=grails-maven-archetype -DarchetypeVersion=2.4.3 -DgroupId=me.test -DartifactId=my-mvn
```

# 创建目录树

```txt
.
├── grails-app
│   ├── conf
│   │   └── spring
│   ├── controllers
│   ├── domain
│   ├── i18n
│   ├── services
│   ├── taglib
│   ├── utils
│   └── views
├── pom.xml
├── src
│   ├── groovy
│   └── java
├── target
│   └── eclipseclasses
└── test
    ├── integration
    └── unit
```

# 创建pom.xml

```xml
<?xml version="1.0" encoding="utf-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
	<modelVersion>4.0.0</modelVersion>

	<groupId>me.test</groupId>
	<artifactId>my-mvn-grails</artifactId>
	<packaging>grails-app</packaging>
	<version>0.1</version>

	<name>my-mvn-grails</name>
	<description>my-mvn-grails</description>

	<properties>
		<grails.version>2.3.11</grails.version>
		<h2.version>1.3.170</h2.version>
	</properties>

	<dependencies>
		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-async</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-rest</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-services</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-i18n</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-databinding</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-filters</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-gsp</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-log4j</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-servlets</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-url-mappings</artifactId>
			<version>${grails.version}</version>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-resources</artifactId>
			<version>${grails.version}</version>
			<scope>runtime</scope>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-test</artifactId>
			<version>${grails.version}</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-plugin-testing</artifactId>
			<version>${grails.version}</version>
			<scope>test</scope>
		</dependency>

		<dependency>
			<groupId>com.h2database</groupId>
			<artifactId>h2</artifactId>
			<version>${h2.version}</version>
			<scope>runtime</scope>
		</dependency>


		<dependency>
			<groupId>org.grails</groupId>
			<artifactId>grails-datastore-test-support</artifactId>
			<version>1.0-grails-2.3</version>
			<scope>test</scope>


		</dependency>


		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>scaffolding</artifactId>
			<version>2.0.3</version>
			<scope>compile</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>cache</artifactId>
			<version>1.1.7</version>
			<scope>compile</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>hibernate</artifactId>
			<version>3.6.10.16</version>
			<scope>runtime</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>database-migration</artifactId>
			<version>1.4.0</version>
			<scope>runtime</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>jquery</artifactId>
			<version>1.11.1</version>
			<scope>runtime</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>resources</artifactId>
			<version>1.2.8</version>
			<scope>runtime</scope>

			<type>zip</type>

		</dependency>

		<dependency>
			<groupId>org.grails.plugins</groupId>
			<artifactId>tomcat</artifactId>
			<version>7.0.54</version>
			<scope>provided</scope>

			<type>zip</type>

		</dependency>

	</dependencies>

	<build>
		<pluginManagement />

		<plugins>
			<!-- Disables the Maven surefire plugin for Grails applications, as we 
				have our own test runner -->
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-surefire-plugin</artifactId>
				<configuration>
					<skip>true</skip>
				</configuration>
				<executions>
					<execution>
						<id>surefire-it</id>
						<phase>integration-test</phase>
						<goals>
							<goal>test</goal>
						</goals>
						<configuration>
							<skip>false</skip>
						</configuration>
					</execution>
				</executions>
			</plugin>
			<plugin>
				<groupId>org.apache.maven.plugins</groupId>
				<artifactId>maven-clean-plugin</artifactId>
				<version>2.4.0</version>
				<configuration>
					<filesets>
						<fileset>
							<directory>plugins</directory>
							<includes>
								<include>**/*</include>
							</includes>
							<followSymlinks>false</followSymlinks>
						</fileset>
					</filesets>
				</configuration>
			</plugin>

			<plugin>
				<groupId>org.grails</groupId>
				<artifactId>grails-maven-plugin</artifactId>
				<version>2.4.2</version>
				<configuration>
					<grailsVersion>${grails.version}</grailsVersion>
				</configuration>
				<extensions>true</extensions>
			</plugin>
		</plugins>
	</build>

	<repositories>
		<repository>
			<id>grails</id>
			<name>grails</name>
			<url>http://repo.grails.org/grails/core</url>
		</repository>
		<repository>
			<id>grails-plugins</id>
			<name>grails-plugins</name>
			<url>http://repo.grails.org/grails/plugins</url>
		</repository>
	</repositories>

	<profiles>
		<profile>
			<id>tools</id>
			<activation>
				<property>
					<name>java.vendor</name>
					<value>Sun Microsystems Inc.</value>
				</property>
			</activation>
			<dependencies>
				<dependency>
					<groupId>com.sun</groupId>
					<artifactId>tools</artifactId>
					<version>${java.version}</version>
					<scope>system</scope>
					<systemPath>${java.home}/../lib/tools.jar</systemPath>
				</dependency>
			</dependencies>
		</profile>
	</profiles>
</project>

```


http://grails.github.io/grails-howtos/en/performanceTuning.html