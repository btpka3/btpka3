### RESTful API
* 尽量朝着RESTFul方向努力，但用户认证的仍难免
* 要统一访问URL，不应当有重复功能的定义
* 要能够被缓存，且条件缓存

### Codes.java
```java
/** 数据库代码常量 */
public interface Codes {

    /** 性别 */
    interface GENDER{
        /** 未知 */
        Short UNKNOWN=0;
        /** 男 */
        Short MALE=1;
        /** 女 */
        Short FEMALE=2;
    }
}
```

### Config.java
 

### PagedRecords.java
```java
public class PagedRecords<E> implements Serializable {

    private static final long serialVersionUID = 1L;

    /** 总记录数 */
    private Integer totalCount = 0;

    /** 起始索引 */
    private Integer startIndex;

    /** 分页后的数据集 */
    private List<E> data = Collections.emptyList();
    // getter, setter ...
}

```

### log
* 日志的配置文件中的路径应为绝对路径