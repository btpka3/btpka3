
问：以下两个controller分别执行，那些记录会插入到数据库中？

```java
@Transactional(REQUIRE)
AaaService{
    exec(){
        insertRec1();
        bbbService.exec();
        insertRec2();
    }
}

@Transactional(REQUIRE)
BbbService{
    exec(){
        insertRec3();
        throw exception;
        insertRec4();
    }
}

@Transactional(REQUIRE)
CccService{
    exec(){
        insertRec5();
        insertRec6();
    }
}

YyyController{  // 没有任何AOP
    indexAction(){
        aaaService.exec();
    }
}

XxxController{  // 没有任何AOP
    indexAction(){
        cccService.exec();
        bbbService.exec();
    }
}
```


# java 笔试（初级）
1. == 与 equals() 的区别是？
2. 下面代码输出结果是：

     ```java
     int i=0,s=0;
     do{ 
        if (i % 2 == 0 )
        {   
            i++;
         	continue;
     	}
     	i++;
     	s = s + i;      
     }while (i < 7);
     System.out.println(s);
     ```
3. 介绍一下java的集合框架(可配图解释)。
4. JAVA语言如何进行异常处理，关键字：throws,throw,try,catch,finally分别代表什么意义？在try块中可以抛出异常吗？
5. java中有几种类型的流？JDK为每种类型的流提供了一些抽象类以供继承，请说出他们分别是哪些类？ 
6. 创建线程有哪几种几种方式，并说说它们的区别。
7. GC是什么,为什么要有GC?
8. 说一说Servlet的生命周期?
9. servlet线程安全吗，并说明理由。
10. 写一个Singleton出来。

# Java 笔试（高级）
1. == 与 equals() 的区别是？ equals() 相同时，hashCode()可否不同？如果不同会怎样？
1. A.java中定义了静态常量int num=1，B.java中的方法会将该常量打印到控制台。之后，将A.java中的静态常量值修改为2, 但只重新编译A.java, 此时调用B的方法，会？如果静态常量num的类型改为Integer，重复上述步骤，又会怎样？
1. JavaEE开发中，forward 和 redirect 的区别是？
1. 需要从HTML中找到所有class中包含"cdnImg"的img标签，并将其src属性中的域名替换为 img.lizi.com，该处理需要在服务器端用Java处理，该如何进行？请阐明思路，以及该思路的优点（比如：速度，内存消耗，CPU消耗，可维护性等）。
1. 举例并讲解一个URL组成部分。
1. HTTP有哪些 method？其含义分别是？HTTP请求中与缓存相关的HTTP消息头有哪些？哪些情况会使HTTP缓存失效？
1. 什么是Java序列化？它的适用场景是？应当注意的事项有哪些？
1. 使用new关键字创建对象，和 Class.forName("...").newInstance() 的区别是？ 什么是依赖注入？依赖注入有何好处？
1. 什么是AOP？原理是？适用的场景有？下面的示例代码中，在获取到被AOP之后A的实例a后，分别调用 a.aaa(), a.bbb() 会如何打印？

    ```java
    classs A {
        public void aaa(){
            println "a"
            bbb()
            println "b"
        }

        @MyAOP // AOP的内容是：在目标方法调用前 println "d"
        publi void bbb(){
            println "c"
        }
    }
    ```
1. 结合您的既有经验，给出利用熟悉的框架从接到请求到返回响应的完整流程。该流程中，哪些部分是sigleton的，哪些是是prototype的？
1. 有一万个字符串，要找出前10个出现次数最多的，该如何解决？
1. 有10亿个无序整数，已知无法全部放到内存中，现在需要从中找出最大的10个数，该如何解决？
1. 需要架设一个高可靠、高并发的电商网站，暂不考虑服务器限制，您想如何架构？

ps : 原有的笔试题在这里 `smb://192.168.101.80/share/java/笔试/`


# Java面试/电话面试

这里是“双向沟通”，而非“单向面试”。

* 当前状态
    * 简单自我介绍
    * 当前心态（急迫离职还是看机会？离职原因？）
    * 未来几年的职业规划
    * 对新就职单位的有哪些方面的期望

* 目前的经验积累(主要技术方面)：
    * 讲讲哪个项目中收获最多，如何架构的?
    * 经历的项目中（问题较多，可以选择部分提问）
        * 工具
            * 使用过哪些源代码版本控制工具？（CSV、VSS、SVN、GIT etc.) 如果做产品的版本控制的？
            * 是否使用过持续集工具？（Jenkins、Hudson etc.) 是否亲自在其上面配置过job？
            * 使用过哪些项目管理工具？（禅道 maven etc.）
            * 使用过那些IDE？（Eclipse，IDEA etc.）
        * 架构
            * 有没有分层（RMI，WS，MQ/JMS etc），说说参与的项目的具体架构情况
            * 有没有数据库集群/读写分离/sharding的? 怎么实现的？自己配置的么？
            * 有没有使用过NoSQL（Memecache,Redis,MongoDB etc.）?
            * 有没有使用过基于Lucene的搜索引擎？solr/Elasticsearch/hibernate search？
            * 有没有使用过安全框架（认证、授权）有没有架设起单点登录服务？OAuth服务？如何实现的？
            * 有没有使用过Session复制，或者Sticky Session，如何做到的？自己配置的么？
            * 有没有系统负载均衡的经验？如何实现的
        * 其他
            * 对JVM参数调优有何经验？
            * 有没有遇到过内存溢出，如何定位并解决的？
            * 如何实施测试的（单元测试、集成测试 etc）
            * 对AOP，事务管理有多深入的理解？原理是？
            * 有参与制定或者实施过各种规范么？（代码规约，DB设计规约 etc.)
            * 熟悉的设计模式有哪些？工厂，装饰，代理，观察者模式等？运用场景
        * 学习能力、积极性
            * 目前关注那些方面的技术？非工作时间有做技术学习么？是否有订阅技术咨询网站？
            * 看英文网站上技术资料多，百度的多？
            * 是否阅读过英文版的Spring Reference？能讲讲其中的内容么？
            * 是否熟悉或听说过Groovy，Grails？是否愿意给予时间来学习它们？
            * 是否愿意在团队中没有某方面技术大拿时，独立承担技术调研？
    * 自我补充
        * 自己的特长？

* 电话中能力测试？(个人不建议)
    * 急转弯？
    * 问题分析，设计？
* 公司简介
    * 公司历史
    * 部门构成、员工组成及规模、办公地点。
    * 福利制度
* 项目简介
    * 项目目标、现状。
    * 目标职位的职责：需要参与业务开发，需要参与架构设计、DB设计、维护Wiki文档。
    * 项目开发所用技术：Git、IDEA、Ubuntu、Groovy、Grails



----------------------------------------------------------

# 答案：Java 笔试（高级）
1. `==` 直接对象的内存地址。而equals是按照自定义的业务逻辑比较两个对象。equals方法一版首先就是使用 `==` 判断，不为true之后，才进行后续业务逻辑判断。
    equals()相同的话，hashcode()必须一致，否则HashMap之类的java集合类将无法正常工作。

2. int型的始终都打印1，Integer型的第一次打印1,第二次打印2。该问题是一个很细节的问题，牵涉到了JDK在编译时的优化问题。int型的会把所有引用该变量的地方替换为具体的数值，而对象型的不会。下面是Integer型的一段示例Bash代码。

    ```bash
    #!/bin/bash

    rm -fr a1 a2 b
    mkdir a1 a2 b

    echo "
    public class A {
        public static final Integer num = 1;
    }
    " > a1/A.java
    javac a1/A.java -d a1

    echo "
    public class A {
        public static final Integer num = 2;
    }
    " > a2/A.java
    javac a2/A.java -d a2

    echo '
    public class B {
        public static void main(String[]args){
            System.out.println("A.num is " + A.num);
        }
    }
    ' > b/B.java

    echo compile B with a1, and classpath is a1
    javac -cp a1:b  b/B.java -d b
    java -cp a1:b B

    echo compile B with a1, and classpath is a2
    java -cp a2:b B

    echo compile B with a2, and classpath is a2
    javac -cp a2:b  b/B.java -d b
    java -cp a2:b B
    ```