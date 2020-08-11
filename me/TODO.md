
# TODO
* NW.js, electron, DirectUI, SkinUI
* mobile app with ~~ionic and angular~~ cordova and angular material
* 图片仓库（cdn）
* 另外一个 iconfont
* 提供 手机号／电子邮箱　注册账户的一览
* 恶意使用指定的手机号去注册第三方的网站账户
* 利用 Bower 创建前端资源CDN管理程序
* OAuth sample
* Spring Security # Domain Object Security (ACLs) sample
* Spring Security + CAS for Ajax login status test
* Front-end : push-message?
* Front-end : model.isModified?
* Front-end : Date-Range-Widget?
* Front-end : web view, prePrint view, print view: can Css Theme only?
* Comted sample
* Spring Integration
* Spring [LDAP](http://docs.spring.io/spring-ldap/docs/current/reference/)
   * Jenkins (LDAP + Auth)
   * Maven Nexus (LDAP + Auth)
   * SonarQube (LDAP + Auth)
   * VisualSVN (LDAP + Auth)
* Scriptable browser plugin
* Linux login + LDAP
* [Git](http://git-scm.com/book/zh)
* Web App managed HttpSession stored in Redis
* trie implementation in Java & JS
* Spring Security vs. Apache Shiro
* OSGI
* design REST url template for HIS
* design patten summary
* avoid JVM memory leak
* SQL preformance
* <del>AOP: singleton or prototype advice</del>
   Srping `<aop:advisor/>`不支持设置scope，只能是Singleton。
* Jsp Tag : output page scope var with custom var name.
* Jetty Cluster
* DDD: CQRS
* MySql cluster
* servlet 3.0 aysnc
* Spring 4 WebSocket
* Spring Remoting HttpInvoker
* grails quartz plugin - study, add enable singleJob
* Central configuration
* Apache Mahout 推荐引擎
* [HMM - Hidden Markov model](http://en.wikipedia.org/wiki/Hidden_Markov_model)
* [HBuilder](http://www.dcloud.io/)
* [Clouda+](http://clouda.baidu.com/portal)
* 自建融合支付
* 自建融合短信网关（云片网，阿里大于）
* OAuth0 中国版
* socks5 代理服务器+浏览器插件
* 微信、QQ报名 
* 短信验证码安全监测
* 手机号注册过哪些网站？
* let's encrypt -dns challenge + aliyun dns api
* nginx traffic monitor SPA 
* study
    - [Apache Flink](https://flink.apache.org/)
    - [JStorm](http://www.jstorm.io/index_cn.html)
    - [Apache Storm](http://storm.apache.org/)
    - [Apache Spark](http://spark.apache.org/)
    - [Apache RocketMQ](http://rocketmq.apache.org/)
    - [Apache Kafka](http://kafka.apache.org/)
    - hbase
    - 实时计算
    - 流式处理
    - [DalmatinerDB](https://dalmatiner.io/)
    - [Druid](http://druid.io/)
    - [greenplum](https://pivotal.io/pivotal-greenplum)
    - [Hazelcast](https://hazelcast.org/)
    - reactive
        - [project reactor](https://projectreactor.io)
        - [vert.x](http://vertx.io/)
        - [akka](https://akka.io/)  
        - RxJava
        - Reactor vs vert.x
        - [Reacting to Spring Framework 5.0](https://content.pivotal.io/blog/reacting-to-spring-framework-5-0)
    - [Cloudopt](https://next.cloudopt.net/#/)
    - [jooq](http://www.jooq.org/)
    - [jBPM](https://www.jbpm.org/)
    - https://decisions.com/company
    - 时序数据库、监控相关
        - [Micrometer](https://micrometer.io/docs)
        - ~~[Spring Metrics](https://docs.spring.io/spring-metrics/docs/current/public/prometheus)~~
        - [influxdb](https://github.com/influxdata/influxdb)
        - [prometheus](https://github.com/prometheus/prometheus)
        - [RRDtool](http://oss.oetiker.ch/rrdtool/)
        - [Graphite](http://graphite.readthedocs.org/en/latest/)
        - [OpenTSDB](http://opentsdb.net/)
        - [Kdb+](http://kx.com/)
        - [Druid](http://druid.io/)
        - [KairosDB](http://kairosdb.github.io/)
        - [Spatedb](https://github.com/t0nyren/spatedb)
        - [Gorilla]()
        - [HiTSDB](https://help.aliyun.com/product/54825.html)
    - cache
        - [Infinispan](http://infinispan.org/)
    
* spring-cloud-zookeeper 中针对 config 对 zookeeper 进行前后端配置。
  并按照 spring-boot 加载的顺序进行合并展示。






# 构想：Maven 依赖检查平台

2019年3月份的 [全民扫雷](https://yida.alibaba-inc.com/s/qmsz) 中，大家爆了关于 maven 依赖的雷：

- "Jar包依赖版本基线及废旧依赖清理" by 敦行
- "IC依赖冲突太多" by 神天

这些雷受到了N多开发同学的认同。也有不少同学提出了自己的解决方案，比如：
 
- "[BP-基于BOM的Maven项目依赖管理及包冲突解决](https://www.atatech.org/articles/134745)" by 敦行

其他参考：
- Maven 类库管理平台： [依赖关系查询](http://mvnmp.alibaba.net/search_log_history.htm)
- Maven 类库管理平台： [新增依赖规则](http://mvnmp.alibaba.net/edit_mvn_rule.htm)
- [Maven 插件 maven-enforcer-plugin 使用小结](https://www.atatech.org/articles/121763)


# 目的

- 注册、认证二方包、三方包，维护相关信息（介绍、使用文档，传递依赖说明）
- POM 检查、依赖检查 
- 提供制定检查规范，并提供扫描检查、报告功能
- 为 二方包 升级简化流程


# 设计思路

## 用户/组织管理
以个人/组织（group）的方式 管理平台用户。

## 项目/项目组管理

以项目、项目组（与 aone 应用无关，独立概念）进行 资源、功能管控：

## 二方包、三方包管理

### 注册、认领、信息维护

注册、认证二方包、三方包，维护相关信息：
- Owner 的认领与转交
- Aone 信息
- Git 仓库信息
- 二方包使用文档信息
- 外部文档链接
- 传递依赖 的相关信息 维护
    - 为什么要用某个该依赖。
    - 什么时候要用某个传递依赖（尤其是 scope 是 provide 的传递依赖）。


### 版本信息维护

- 发布时间
- 变更内容
- 相关问题


### issue 管理

记录发现的漏洞、bug，用户反馈的问题、已结相关对应方案。

如果是 bug、漏洞，可以关联到不同的版本上。

三方包的信息，需要平台来管理。

### 打标

打标是用来 后续 maven 插件根据标签进行依赖管理。

标签 应当 要有自己的 打标标准 和说明文档的。

标签分类：
 
- 平台预设的标签。比如 `Deprecated`, `disabled`, `recommended`, `jdk1.6`, `antx` 等 
- 自定义标签。


二方包、三方包 Owner 自己按照版本进行打标，全局可见。
非 Owner 打标，仅在相应的应用、应用组中可见。

在二方包/三方包的界面展示标签的时候， 要能区分显示：
- 区分显示 平台预设标签 和 自定义标签（按照颜色）
- 区分显示 Owner/平台 打的标签 和 应用/应用组内 打的标签

### 多维度评分

通过多维度评分，可谓二方包的使用者提供参考：

- 推荐指数、推荐原因 
- 不推荐指数、不推荐原因
- 相同功能的其他 jar 包 使用
- 更新及时性

     
## 扫描

### 扫描规范创建

项目/项目组 内创建 扫描规范，以及各个扫描规范 的说明文档、反例、正例 等。

扫描规范可以设置公开，以便其他项目/项目组 引用/继承。

### POM 格式检查
分析 POM 检查格式，比如：
- 父 POM 的 `<relativePath>`
- 父 POM 中是否按照 子模块的先后依赖顺序排序（aone 中发布二方包时，有先后顺序要求）
- 子 POM 中手动写了 插件的版本、依赖的jar的版本 等（应该都在 父POM，BOM 中 管理起来的）
- POM 中是否按照 项目/项目组配置 设置相关 properties，jdk 版本、指定插件 等
- POM 中作者、git 仓库，wiki url等信息检查

### 依赖检查

这部分，有相当一部分可以参考 [maven-enforcer-plugin](https://maven.apache.org/enforcer/maven-enforcer-plugin/index.html) 
和其扩展 [org.codehaus.mojo:extra-enforcer-rules](https://www.mojohaus.org/extra-enforcer-rules/)



- maven-enforcer-plugin 中已有功能，比如：
    - bannedPlugins: 禁用某些插件
    - bannedDependencies : 禁用某些依赖。BOM/父 POM 中`dependencyManagement` 的方式只是正向解决，但会有遗漏。该方法是堵漏。
    - banDuplicatePomDependencyVersions : maven 自带的只是 warn，并不阻断，而该规则会阻断。

- extra-enforcer-rules 中已有功能，比如：
    - banDuplicateClasses : 禁止类重复（可以设置例外）
    - enforceBytecodeVersion :  检查二方包自身以及传递依赖的二方包的字节码的最高版本。
      这个对 二方包要兼容 jdk 版本（比如 JDK 1.6, 1,7) 时很有用。
    - banCircularDependencies: 禁止 jar 包循环依赖
    - equireEncoding : 检查文件编码 

- 其他检查
    - 根据应用/应用组配置，对 二方包、三方包打标结果进行 禁用检查。
    - 检查是否使用了 antx（autoconfig）相关功能

- 针对类似 JDK 9/ OSGI Bundle 中 API 和实现分离的相关机制，检查 二方包字节码的 中使用的 类进行依赖分析
    - class 中直接依赖的 应该都是 API 接口，而非内部实现。
    - class 中直接依赖的 应该在 POM 中明确声明，而不应该仅靠传递依赖间接依赖进来。

   
- 在 项目/项目组级别，对上面规则的具体内容进行模板设置，比如：
    - 禁用 `com.alibaba.external:*`
    - 如果项目/项目组是基于 pandora-boot 来运行，禁用 `com.taobao.eagleeye:*`, 而应该使用 `com.alibaba.middleware:eagleeye-core-sdk`

## 辅助创建、检查BOM/父POM
根据工程/工程组配置，生成 BOM、父POM。

## 报告
针对上面的各种扫描结果，可以通知到 相关项目/项目组 的成员，以便及时改进。

## 二方包升级推动
目前推动二方包升级，是一个比较费时费力的工作，只能手动分析、通知、跟进。
 
- 统计二方包被哪些二方包、aone 应用依赖，被使用的版本等。
  需要对接一下 aone 等构建工具，目前基本上是只有二方包才发布到 集团内 maven 仓库的，而 应用没有
- 快捷邮件通知升级，升级任务跟进。不用手动一一去找对应 aone 应用的负责并通知。


## 工具/三方集成

- 平台可作为独立应用，集团外部署
- github/gitlab/jenkins/aone 集成 （git hook 触发 自定义任务）
- maven/gradle 配套插件
- sonarqube 集成
- 集成多 maven 仓库配置，maven 私服配置

## 搜索强化
（可选）按照 class 名，jar包内文件名，文件内字符串搜索。






- maven pom 检查平台 
    - 二方包、三方包:
        - Owner 认领、变更
        - 信息维护：Git仓库链接/
        - 

    - 按照项目自动生成建议的 import 的 pom 文件
        - 直接依赖的二方包进行 exclude
    - github/gitlab/jenkins 集成, maven/gradle 插件，sonarqube 集成
    - 提供下游依赖方的接口，给出下游业务方列表
        - aone 扫描 war 扫描分析，防止遗漏 被ant 之类构建工具添加的 jar 包
        - 平台自身 pom.xml 依赖分析
    - 二方包使用版本百分比分析
    - 提供方便给下游业务方发送通知邮件的功能，需要提供接口，其中一个自定义实现就是对接aone
    - pom.xml 检查
        - 检查 maven 中的源信息 （作者、git 仓库，wiki url）
        - git 仓库
        - wiki url
    - 检查 maven 的 warning
    - 检查 jar 版本号 只出现在 dependencyManagement/pluginDependencyManagement 中
    - 提供搜索 jar 包中 class 名称
    - 提供搜索 jar 文件中，源码中 的文本字符串。
    - 重复类 检查，jar包相似度检查
    - jar包 
        - override pom.xml 中的源信息
        - 评分 
        - 禁用检查
    - 禁止 import 的 class 分析
    - 检查报告提醒
    - 代码目录结构检查
        - .gitignore
        - .editorconfig
        - jslint
    - 参考
        - [classgraph](https://github.com/classgraph/classgraph)
        - [org.codehaus.mojo:extra-enforcer-rules](https://www.mojohaus.org/extra-enforcer-rules/)
  

# FIXME
* 云安全？[1](http://article.liepin.com/ask/qa130273)










