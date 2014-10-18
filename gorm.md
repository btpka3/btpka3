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
FIXME: createCriteria 圆括弧中可以传递哪些参数？
分析AbstractHibernateCriteriaBuilder#invokeMethod() 方法，和 GrailsHibernateUtil#populateArgumentsForCriteria() 得知：
圆括弧中的参数只对 `list` 方法有效。

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


FIXME: createCriteria 花括号——闭包中可以使用哪些语句？
分析AbstractHibernateCriteriaBuilder#invokeMethod() 方法，可以的调用HibernateCriteriaBuilder实例上的任何方法。

