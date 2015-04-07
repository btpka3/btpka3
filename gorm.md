# 业务组合主键

```
class Xxx {
    static constraints = {
        a nullable : false
        b nullable : false
        c nullable : false, unique: ['a','b']
    }
    String a
    String b
    String c
    String d
}

// FIXME ：SQL 组合主键。
```


# 一对一 双向

```
class Face {
    static hasOne = [nose:Nose]
    static constraints = { nose unique: true } 
}
class Nose {
    Face face
}

```


## 

## GORM 一对多

* 建议
    * 在子记录上给出parent的引用，而不要在父记录上包含子记录的list/set
    * 不要使用 List 来包含子元素，用默认的Set即可。更改List的中的顺序尚未尝试成功
    * 不要使用 parentRec.addToXxx(childRec) ，使用 childRec.parent = xxx 来取代。

* case 1

    ```
    class Zzz {
        static hasMany = [list:Zzz]
        String id
        String name
    }
    ```

    结果，父记录的list属性有值

* case 2

    ```
    class Zzz {
        static hasMany = [list:Zzz]
        String id
        Zzz parent
    }
    ```

    结果，父记录没有list属性，子记录的parent有值（经过测验，parent 可以随便更名）


* case 3

    ```
    class Zzz {
        static hasMany = [list:Zzz]
        String id
        Zzz p1
        Zzz p2
        Zzz p3
    }
    ```

    报错：

    ```
    Caused by: org.codehaus.groovy.grails.exceptions.GrailsDomainException: 
    Property [list] in class [class com.jujn.domain.domain.Zzz] is a bidirectional one-to-many with two possible properties on the inverse side. 
    Either name one of the properties on other side of the relationship [zzz] or use the 'mappedBy' static to define the property that the relationship is mapped with. 
    Example: static mappedBy = [list:'myprop']
    ```

* case 4

    ```
    class Zzz {
        static hasMany = [list:Zzz]
        static mappedBy = [list : 'p2']
        String id
        Zzz p1
        Zzz p2    
        Zzz p3
    }
    ```

    结果，父记录没有list属性，子记录的p2有值, p1和p3没有值

 


# 查询出部分列

```groovy
class CmsPageView {

    static constraints = {
        cmspage nullable:false;
        date nullable: false;
        times nullable: false;
    }

    static mapping = {
        date type: "date"
    }
   CmsPage cmspage;
    Date date;

    Integer times;
}
```

查询出部分列

```
// list：类型 grails.orm.PagedResultList, 长度：1
// 元素一：类型Object[2] {java.sql.Date, Long}
def list = CmsPageView.createCriteria().list(max:1) {
    projections {
        //min('date')
        property('date')
        cmspage {
            property('id')
        }
    }
}

```

查询出最小日期

```groovy
def minDate = CmsPageView.createCriteria().get {
    projections {
        min('date')
    }
}
```


# createCriteria

createCriteria 方法实际调用的是 [HibernateGormStaticApi](https://github.com/grails/grails-data-mapping/blob/master/grails-datastore-gorm-hibernate/src/main/groovy/org/codehaus/groovy/grails/orm/hibernate/HibernateGormStaticApi.groovy)上的 createCriteria() 方法。

FIXME：该方法调用是何时与Domain类关联上的？

HibernateCriteriaBuilder [javadoc](http://grails.github.io/grails-data-mapping/current/api/index.html?grails/orm/HibernateCriteriaBuilder.html)、
[java](https://github.com/grails/grails-data-mapping/blob/master/grails-datastore-gorm-hibernate/src/main/groovy/grails/orm/HibernateCriteriaBuilder.java)


```
Xxx.createCriteria().list { /* ... */ } 
// 等价于
new HibernateCriteriaBuilder(Xxx.class, sessionFactory).list { /* ... */ }
```
## createCriteria 圆括弧中可以传递哪些参数？

分析AbstractHibernateCriteriaBuilder#invokeMethod() 方法，和 GrailsHibernateUtil#populateArgumentsForCriteria() 得知：
圆括弧中的参数只对 `list` 方法有效。且下列属性最终调用的是 Hibernate的 [Criteria](https://docs.jboss.org/hibernate/orm/3.6/javadocs/index.html?org/hibernate/Criteria.html) 上的相关方法。

|param| type| description|
|-----|-----|------------|
|max       |Integer          |设置结果集的最大值数量 |
|offset    |Integer          |偏移量   |
|fetchSize |Integer          |预取记录数的数量 |
|timeout   |Integer          |Sql执行超时时间 |
|flushMode |FlushMode,String | |
|readOnly  |Boolean          |是否只读|
|sort      |String,Map       |排序字段。如果为map，则key是排序字段，value是排序方式。|
|order     |String           |排序方式:"asc","desc"。仅当sort参数类型为String时其作用 |
|ignoreCase|Boolean          |排序时，是否区分大小写|
|fetch     |Map              |指定字段的读取模式。key为字段名，value为FetchMode(String） |
|lock      |Boolean          |读取时是否加锁|
|cache     |Boolean          |是否使用缓存。当lock=true时忽略设置。|


## createCriteria 花括号——闭包中可以使用哪些语句？

结合分析AbstractHibernateCriteriaBuilder#invokeMethod() 方法得知，可以调用：

* HibernateCriteriaBuilder 及其父类明确声明地方法。
* HibernateCriteriaBuilder 提供的 `list`、`listDistinct`、`count`、`get`、`scroll`等动态方法，会有特殊处理;
* 尝试调用该builder的metaClass上的metaMethod
* 尝试调用该builder的criteriaMetaClass上的metaMethod、setter。即调用[Criteria](https://docs.jboss.org/hibernate/orm/3.6/javadocs/index.html?org/hibernate/Criteria.html) 上的相关方法。
* 如果方法 （1）仅有有一个参数，且是Closure；（2）有两个参数，第一个是数值型，第二个是Closure。则方法名当作关联字段名进行关联处理。




# left join

see [here](http://stackoverflow.com/questions/17083204/criteria-uses-inner-join-instead-left-join-approach-by-default-making-my-que)

```groovy
// domain
class A {
    B b
}

class B {
    C c
}

class C {
   boolean isDeleted;
}


// left join query : b.c is null or b.c.isDeleted = true

def result = A.withCriteria{
    createAlias('b', 'bb', CriteriaSpecification.LEFT_JOIN)
    createAlias('bb.c', 'cc', CriteriaSpecification.LEFT_JOIN)
    or {
        isNull('bb.c')
        eq('cc.isDeleted', true)
    } 
}
```




