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

## 
