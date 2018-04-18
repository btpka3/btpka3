

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
