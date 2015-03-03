### RESTful API
* 尽量朝着RESTFul方向努力，但用户认证的仍难免
* 要统一访问URL，不应当有重复功能的定义
* 要能够被缓存，且条件缓存

### Codes.java
```java
/** 数据库代码常量 */
// 使用枚举型会有版本问题，但是如果在序列化时，使用的枚举的底层value，
// 不要声明任何枚举类型的成员变量、参数类型，也是OK的。
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


### JsonMessage.java
```java
package com.tc.his.web.vo;

import java.io.Serializable;

public class JsonMessage implements Serializable {
    private static final long serialVersionUID = 1L;

    // 0 - 成功， 其他值 - 失败
    private Integer status = STATUS_SUCCESS;
    // 成功、失败消息
    private String msg;
    // 结果集
    private Object result;
    // ...
}

```
### log
* 日志的配置文件中的路径应为绝对路径
### 自定义错误画面
* 要能根据请求返回HTML或者JSON
* 要通过配置，可以在HTML中开发时显示错误堆栈，上线时不显示
* 要通过自定义的Error Controllor或resolver将错误记录到日志里? DB中?