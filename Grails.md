# 惯例优先原则（convention over configuration）
[参考](http://grails.org/doc/1.3.7/guide/2.%20Getting%20Started.html#2.6 Convention over Configuration)


# Grails命令的查找方式
参考：[4. The Command Line](http://grails.org/doc/1.3.7/guide/single.html#4. The Command Line)

Grails 使用[Gant](http://gant.codehaus.org/)作为构建工具，它是对Grails的[AntBuilder](http://groovy.codehaus.org/api/index.html?groovy/util/AntBuilder.html)进行了一个简单封装。

[Ant task列表](http://ant.apache.org/manual/tasklist.html)

Gant 脚本是一个Groovy文件，并调用预定义的一个AntBuilder和其他对象。其中两个主要的对象就是 includeTargets 和 includeTool。