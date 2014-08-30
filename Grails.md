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
//hibernate = "off"
hibernate.SQL="trace,stdout"
hibernate.type="trace,stdout"
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


