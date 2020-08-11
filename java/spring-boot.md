

### META-INF/spring.factories 中的类没启动

- org.springframework.boot.autoconfigure.EnableAutoConfiguration
- org.springframework.core.io.support.SpringFactoriesLoader#loadFactories 条件断点
- 开启 trace 日志

    ```properties
    logging.level.org.springframework.core.io.support.SpringFactoriesLoader= TRACE
    ```



### @ConditionalOnProperty 表达式不成立

- [Troubleshoot Auto-configuration](https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/#howto-troubleshoot-auto-configuration)
- org.springframework.boot.autoconfigure.condition.ConditionEvaluationReport
- 开启 debug 日志

    ```properties
    logging.level.org.springframework.core.io.support.SpringFactoriesLoader= TRACE
    ```


## @ConfigurationProperties 的顺序？

- ConfigurationPropertiesBindingPostProcessor


## @Bean BeanFactoryPostProcessor 初始化

```java
/**
 * 注意：这个是 BeanDefinitionRegistryPostProcessor，故
 * - 方法参数不能依赖 @ConfigurationProperties 类，因为它们尚未初始化好。
 * - 方法必须是 static 类型。否则会有初始化问题。
 */
@Bean
//@ConfigurationProperties("my.prefix") // 这个不管用
static MapperScannerConfigurer mapperScannerConfigurer(ConfigurableEnvironment env) {
    MapperScannerConfigurer mapperScannerConfigurer = new MapperScannerConfigurer();
    mapperScannerConfigurer.setSqlSessionFactoryBeanName("yourBeanName");
    ConfUtils.bind(env, "my.prefix", mapperScannerConfigurer);
    return mapperScannerConfigurer;
}
```

## @Value 中的占位符何时处理的？
- PropertySourcesPlaceholderConfigurer
    - 是 BeanFactoryPostProcessor
    - 最低优先级

- 可以通过 `ApplicationContext.getEnvironment().resolvePlaceholders("${x.zz:999}"` 来取值
- 可以通过 `new RelaxedDataBinder(environment.getPropertySources(), "spring.my").bind(new PropertySourcesPropertyValues(propertySources));`
    来 binding 对象

## 给 bean 起别名

```java
/**
 * 起别名: jdbcTemplate -> jdbcTemplateSmeta
 *
 * @param reg
 */
@Autowired
public void test(ConfigurableBeanFactory reg) {
    reg.registerAlias("jdbcTemplate", "jdbcTemplateSmeta");
    reg.registerAlias("jdbcTemplate", "jdbcTemplateMtee");
}
```


## metrics

### 记录日志

- Meters

```java
@Component
@ExportMetricWriter
public class MyMetricWriter implements MetricWriter, Closeable {

    private static final Log logger = LogFactory.getLog(MyMetricWriter.class);

    
    @Override
    public void increment(Delta<?> delta) {
        // record increment to log
    }
    
    @Override
    public void set(Metric<?> value) {
        // record set metric to log
    }
    
    @Override
    public void reset(String name) {
        // Not implemented
    }
    
    @Override
    public void close() {
    /// ...
    }
}
```


