- 如何打印日志1？

    - 如果是 mybatis 使用的xml配置文件，则是 `${namespace}.${statementId}`
    - 如果是使用自动映射的 Dao 接口，则是 `${Dao全类名}.${Dao方法名}`
    - 具体可以在 `SimpleExecutor#doQuery` 内加断点,
      查看 `MappedStatement#statementLog#log#logger#name`，
      监控表达式为 `((Slf4jLocationAwareLoggerImpl) ((Slf4jImpl) ms.statementLog).log).logger`

- 如何打印日志2？
  修改 mybatis 配置文件

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE configuration PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <settings>
            <setting name="logImpl" value="STDOUT_LOGGING" />
        </settings>
    </configuration>
    ```


- 如何获取分页时，总记录数？

### mapper 接口支持哪种参数和返回值？

参考：
— org.apache.ibatis.binding.MapperProxyFactory

- org.apache.ibatis.binding.MapperProxy
- org.apache.ibatis.binding.MapperMethod

```java
public interface XxxMapper {
    // ------------------------------------------ insert/update/delete
    void insert(
        @Param("xxx") String xxx
    );

    Integer insert(
        @Param("xxx") String xxx
    );

    Long insert(
        @Param("xxx") String xxx
    );

    Boolean insert(
        @Param("xxx") String xxx
    );


    // ------------------------------------------ select
    // 使用 ResultHandler, 大数据量时使用
    void select(
        @Param("xxx") String xxx,
        RowBounds rowBounds,
        ResultHandler handler
    );

    // 可以使用 RowBounds 参数
    List<X> select(
        @Param("xxx") String xxx,
        RowBounds rowBounds
    );

    // 将查询到的多条记录，放到 map 中。
    Map<K, V> select(
        @Param("xxx") String xxx,
        RowBounds rowBounds
    );

    // 返回游标, 大数据量时使用
    Cursor<T> select(
        @Param("xxx") String xxx,
        RowBounds rowBounds
    );

    T select(
        @Param("xxx") String xxx
    );
}
```

### TypeHandler 可以通过 resultMap 指定。那没有使用 resultMap，又是如何选择 默认的 typeHandler ?

参考 org.apache.ibatis.executor.resultset.DefaultResultSetHandler#getRowValue
