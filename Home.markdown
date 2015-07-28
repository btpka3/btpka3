# 简介
该工程主要用于自我总结用，由于[经历原因](introduction)，代码仍然放在 [github](https://github.com/btpka3/btpka3.github.com) 上，而 wiki 总结则放在了这里—— [git @ oschina](http://git.oschina.net/btpka3/btpka3/wikis/home) 上。

# 目录

该目录并没有列出全部的wiki页面，如需浏览全部，请点击 “[页面](pages)” 标签页。   

* 安全
    * [Security CSRF](security-csrf)
    * [Security Clickjacking](security-clickjacking)
    * [Security XSS](security-xss)
    * [JavaScript 允许重新定义 Array，因此JSON服务不要返回Array，而应当返回Object](http://haacked.com/archive/2008/11/20/anatomy-of-a-subtle-json-vulnerability.aspx/)
    

* Web 后端
    * Markdown
        * [简介](md-intro)
        * [示例](md-demo)
        * [同步wiki](md-sync)
    * Java
        * [JDK安装](java-jdk-install)
        * [Java调优总结](java-tuning)
        * [Java JSR 规范](java-jsr)
        * [Java servlet总结](java-servlet)
        * [Java tips](java-tips)
        * [Joda time 总结](joda-time)
    * [Groovy](groovy)
        * [groovy 反编译](groovy-decompile)
    * [Grails](grails)
        * [Spring DSL](grails-spring-dsl)
    * [Spring Framework](spring-framework)
    * [Spring Security](spring-security)
    * [CAS](cas-intro)
    * [Spring Boot](spring-boot)
* Web 前端
    * [CSS](css)
    * [font](font)
    * [JavaScript](js)
    * [jQuery](http://jquery.com/)
    * [AngularJs](angularjs )
    * [Node.js](nodejs)
    * [Grunt](grunt)
    * [Hybrid App](hybird-app)
    * [调试微信打开的 html5 页面](weixin-h5-debug)

* 开发工具
    * Git
        * [总结](git)
        * [分支管理](git-branch)
        * [WIKI同步](git-sync)
    * [Eclipse](eclipse)
    * [Idea Intellij](idea-intellij)
    * [Firefox](firefox)
    * [Gitlab](gitlab)
    * [Jenkins](jenkins)
    * [maven](maven)
    * [nexus](nexus)

* 测试
    * sysbench
        * [sysbench 进行 cpu 测试](sysbench-cpu)
        * [sysbench 进行磁盘测试](sysbench-fileio)
        * [sysbench 进行 MySql 压力测试](sysbench-mysql)
    * [Jmeter](jmeter)
    * [apache benchmark](ab) 

* 办公
    * [ThunderBird](thunderbird)
* 法律法规
    * [杭州住房公积金查询](http://www.hzgjj.gov.cn:8080/WebAccounts/pages/per/login.jsp)
    * [杭州社保、养老保险查询](http://www.zjhz.lss.gov.cn/html/wsbs/denglu.html)
    * [杭州市民邮箱](http://www.hangzhou.gov.cn/main/zwdt/ztzj/smyx/)， [登录](http://mail.hz.gov.cn/)
    * 《[中华人民共和国社会保险法](http://www.gov.cn/zxft/ft209/content_1748773.htm)》
    * [杭州市人力资源和社会保障网](http://www.zjhz.hrss.gov.cn/html/zcfg/zcfgk/zhl/index.html)
    * [2014杭州市区最低工资 ： 1650 元](http://www.zjhz.hrss.gov.cn/html/zcfg/zcfgk/in/zcfg5525648.html)
    * [2014杭州市区全社会在岗职工年平均工资 ： 51449 元](http://www.zjhz.hrss.gov.cn/html/zcfg/zcfgk/gzfu/71265.html)
    * [2014浙江省在岗职工年平均工资 : 48372 元](http://www.zjhz.hrss.gov.cn/html/zcfg/zcfgk/gzfu/71140.html)
    * [杭州市基本养老保障办法（杭政〔2013〕104号）](http://www.hangzhou.gov.cn/main/wjgg/ZFGB/201312/szfwj/T470036.shtml)
    * [杭州市基本养老保障办法主城区实施细则（杭政办〔2014〕4号）](http://www.hangzhou.gov.cn/main/wjgg/ZFGB/201402/szfwj/T475790.shtml)

* 服务器管理
    * [CentOS](centos-base-setup)
        * [limits](centos-limits)
        * [fdisk](fdisk)
    * [ntp](ntp)
    * [Ubuntu](ubuntu)
    * [Bash](bash)
    * [samba](samba)
    * [Vim](vim)
    * [Upstart](upstart)
    * [Tomcat](tomcat)
    * [jetty](jetty)
    * [Redis](redis)               TODO 合并
    * [RabbitMq](rabbitmq)
    * [ssh](ssh)
    * [https](https)
    * [nginx](nginx)
    * [Tengine](tengine)
    * [mysql](MySql) TODO 分解/合并
        * [MySql 安装](mysql-install)
        * [MySql 调优](mysql-tuning)
        * [MySql 主从复制](mysql-replication)
        * [MySql 读写分离](mysql-rw-splitting) FIXME 旭阳总结，未验证
    * ZooKeeper
        * [ZooKeeper简介](zk-intro)
        * [ZooKeeper安装](zk-install)   TODO 合并
        * [ZooKeeper单机集群配置示例](zk-cluster-demo)
    * ElasticSearch
        * [简介](es-intro)
        * [安装](es-install)
        * [示例](es-search)
        * [拼音/自动完成](es-pinyin)
    * MongoDB
        * [mongoDB 简介](mongo-intro)
        * [mongoDB 安装](mongo-install)
        * [mongoDB 使用总结](mongo)
        * [MongoDB java示例](mongo-java-demo)
        * [MongoDB Grails示例](https://github.com/btpka3/btpka3.github.com/tree/master/grails/my-mongo)
    * Cassandra  —— 暂时放弃使用
        * [Cassandra 简介](cassandra-intro)
        * [Cassandra 安装](cassandra-install)
        * [Cassandra cql](cassandra-cql)
        * [Cassandra cql示例](cassandra-cql-demo)
        * [java客户端示例，Spring-data-cassandra示例](https://github.com/btpka3/btpka3.github.com/tree/master/java/first-cassandra)
