

# 变量

logback.xml

```xml
<property resource="application.properties" />
```


## conditional config

- [Janino](https://janino-compiler.github.io/janino/#getting_started)
- [PropertyWrapperForScripts](https://github.com/qos-ch/logback/blob/1.1.11/logback-core/src/main/java/ch/qos/logback/core/joran/conditional/PropertyWrapperForScripts.java)


## 使用 spring placeholder

- [Using Profiles in logback-spring.xml](https://reflectoring.io/profile-specific-logging-spring-boot/)


logback-spring.xml 文件

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
  <springProperty name="destination" source="my.loggger.extradest"/>

  <springProfile name="dev">
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
      <encoder>
        <pattern>
          %d{HH:mm:ss.SSS} | %5p | %logger{25} | %m%n
        </pattern>
        <charset>utf8</charset>
      </encoder>
    </appender>

    <root level="DEBUG">
      <appender-ref ref="CONSOLE"/>
    </root>
  </springProfile>

  <springProfile name="staging">
    <appender name="CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
      <encoder>
        <pattern>
          %d{yyyy-MM-dd};%d{HH:mm:ss.SSS};%t;%5p;%logger{25};%m%n
        </pattern>
        <charset>utf8</charset>
      </encoder>
    </appender>

    <root level="DEBUG">
      <appender-ref ref="CONSOLE"/>
    </root>
  </springProfile>

</configuration>```

