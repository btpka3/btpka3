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


