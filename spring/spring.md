
# Dependency resolution process

参考:
- [4.1.x : Dependency Resolution Process](https://docs.spring.io/spring-framework/docs/4.1.x/spring-framework-reference/html/beans.html#beans-dependency-resolution)
- [5.3.x : Dependency Resolution Process](https://docs.spring.io/spring-framework/docs/5.3.x/reference/html/core.html#beans-dependency-resolution)

流程：
- 创建 ApplicationContext, 并初始化描述bean的配置的元信息。这些元信息来自 spring xml配置文件，java代码和注解。
- 每个bean，其依赖表现为 属性（properties）、构造参数、静态工厂方法的参数、




# @Transactional

```java
@Transactional
public class ParentService {

    @Transactional(transactionManager="transactionManager101")
    public void aaa(){}

    @Transactional(transactionManager="transactionManager102")
    public void bbb(){}

    public void ccc(){}

    public void ddd(){}
}

@Transactional(transactionManager="transactionManager200")
public class ChildService extends ParentService {
    @Transactional(transactionManager="transactionManager201")
    public void aaa(){}

    public void ddd(){}
}
```
假设 Spring ApplicationContext 中有以下名称的 transactionManager:
- "transactionManager"
- "transactionManager101"
- "transactionManager102"
- "transactionManager201"
- "transactionManager202"

问： 针对一个 childService 实例，调用不同方法会使用哪个 transactionManager?

答：
- aaa: transactionManager201. 使用 方法上声明的 Transactional 配置.
- bbb: transactionManager102. 使用 方法上声明的 Transactional 配置.
- ccc: 报错. 找声明该方法的类上(ChildService)的 Transactional 配置。
   但是由于未明确指定 transactionManager，会按照class类型去找，会因为找到多个而报错。
   如果类 ChildService 上明确指定了，则会用 明确指定的。
- ddd: transactionManager200. 使用 声明该方法的类上(ChildService)的 Transactional 配置

参考：
- org.springframework.transaction.interceptor.AbstractFallbackTransactionAttributeSource#computeTransactionAttribute


# 扩展
- `META-INF/spring.factories` : see [here](https://github.com/spring-projects/spring-boot/blob/main/spring-boot-project/spring-boot-autoconfigure/src/main/resources/META-INF/spring.factories)
  - org.springframework.context.ApplicationListener
  - org.springframework.context.ApplicationContextInitializer
  - org.springframework.boot.autoconfigure.EnableAutoConfiguration
  - org.springframework.boot.env.EnvironmentPostProcessor
  - org.springframework.boot.actuate.autoconfigure.ManagementContextConfiguration
  - org.springframework.boot.autoconfigure.AutoConfigurationImportListener
  - org.springframework.boot.diagnostics.FailureAnalyzer
  - org.springframework.boot.autoconfigure.template.TemplateAvailabilityProvider
  - org.springframework.boot.sql.init.dependency.DatabaseInitializerDetector
  - org.springframework.boot.sql.init.dependency.DependsOnDatabaseInitializationDetector
- `META-INF/spring.handlers` : spring xml 配置文件自定义 namespace 的 handler
- `META-INF/spring.schemas`  :
- `META-INF/spring.components` : 由 spring-context-indexer 自动生成
- `META-INF/ra.xml` : deployment descriptor for Java EE RAR File
- `META-INF/aop.xml` : spring 使用 AspectJ 进行 aop 的相关配置
