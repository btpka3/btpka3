
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



# placeholder





```xml
    <context:property-placeholder
        location="${spring.config.location:file:application.properties}"
        system-properties-mode="ENVIRONMENT"
        null-value="null"
    />
```

- org.springframework.context.config.ContextNamespaceHandler
- org.springframework.context.config.PropertyPlaceholderBeanDefinitionParser
- org.springframework.context.support.PropertySourcesPlaceholderConfigurer
- org.springframework.beans.factory.config.PropertyPlaceholderConfigurer  : @Deprecated
- org.springframework.core.io.ResourceLoader
- org.springframework.util.PropertyPlaceholderHelper#replacePlaceholder
 

设置bean 属性的时候，是如何将 string 转成特定类型的？

```plain
# 使用 PropertyPlaceholderConfigurer 的例子
org.springframework.beans.BeanWrapperImpl#setPropertyValue
  #processLocalProprety()
    .typeConverterDelegate
      .propertyEditorRegistry
        .overriddenDefaultEditors[org.springframework.core.io.Resource]
         -> org.springframework.core.io.ResourceLoader : com.taobao.mbus.biz.spring.AsyncInitXmlWebApplicationContext
```

# init
```plain
org.springframework.context.support.AbstractApplicationContext#refresh
    #prepareRefresh
        #initPropertySources  # 但这个方法仅仅 spring-web 相关 代码才有特定实现， 常用的 placeholder 处理属于 BeanFactoryPostProcessor
    #obtainFreshBeanFactory  
        org.springframework.context.support.AbstractRefreshableApplicationContext.refreshBeanFactory
            org.springframework.context.support.AbstractRefreshableApplicationContext#refreshBeanFactory
                org.springframework.context.support.AbstractXmlApplicationContext#loadBeanDefinitions(DefaultListableBeanFactory)
                    org.springframework.context.support.AbstractXmlApplicationContext#loadBeanDefinitions(XmlBeanDefinitionReader)
                        org.springframework.beans.factory.support.AbstractBeanDefinitionReader#loadBeanDefinitions(String...)
                            org.springframework.beans.factory.support.AbstractBeanDefinitionReader#loadBeanDefinitions(String)  # ⭕️ 处理 <import> 是在该阶段
    #postProcessBeanFactory                # 这个接口与 BeanFactoryPostProcessor 无关，仅仅是留给子类扩展用的，实际在这个地方做宽展的子类已不是很多。
    #invokeBeanFactoryPostProcessors       # 调用 BeanFactoryPostProcessor 
        org.springframework.context.support.PostProcessorRegistrationDelegate#invokeBeanFactoryPostProcessors
           # 前方高能：这里的逻辑真TMD的绕
           # - 先针对 AbstractApplicationContext#beanFactoryPostProcessors (代码编程注册的 BFPP)  中的 BeanDefinitionRegistryPostProcessor 类型，
           #   并调用 BeanDefinitionRegistryPostProcessor#postProcessBeanDefinitionRegistry。
           #   注意：这里处理时，与Order 无关。
           # - 再从 beanFactory 获取 BeanDefinitionRegistryPostProcessor +  PriorityOrdered 类型的 bean
           #   并调用 BeanDefinitionRegistryPostProcessor#postProcessBeanDefinitionRegistry。
           # - 再从 beanFactory 获取 BeanDefinitionRegistryPostProcessor +  Ordered 类型的 bean
           #   并调用 BeanDefinitionRegistryPostProcessor#postProcessBeanDefinitionRegistry。
           # - 【递归】再从 beanFactory 获取 其他 BeanDefinitionRegistryPostProcessor 的 bean
           #   并调用 BeanDefinitionRegistryPostProcessor#postProcessBeanDefinitionRegistry。
           # - 至此：bean definition 全部完成，对收集到的所有的 BeanFactoryPostProcessor 对象，调用 BeanFactoryPostProcessor#postProcessBeanFactory， 这个调用与 
           #   注意： BeanFactoryPostProcessor 不要声明 注解 @Order，该注解无效。

    #registerBeanPostProcessors
        org.springframework.context.support.PostProcessorRegistrationDelegate#registerBeanPostProcessors()  # 从 beanFactory 中获取所有的 BPP, 并注册
        # org.springframework.context.annotation.AnnotationConfigUtils#AUTOWIRED_ANNOTATION_PROCESSOR_BEAN_NAME
        # "org.springframework.context.annotation.internalAutowiredAnnotationProcessor"
        
        
    #initMessageSource 
    #initApplicationEventMulticaster
    #onRefresh                          
    #registerListeners
    #finishBeanFactoryInitialization    # 这里会检查是否有 EmbeddedValueResolver， 如果没有的话，则默认 将 Environment 作为 embeddedValueResolver。  
                                        # 但这个时机就太晚了，所以最好明确声明一个 PlaceholderConfigurerSupport 的子类（比如 PropertySourcesPlaceholderConfigurer）
                                        # 以便在 BFPP初始化阶段就注入好。
    #finishRefresh 
     


```



# API/SPI
```
- org.springframework.boot.env.EnvironmentPostProcessor
- org.springframework.boot.env.EnvironmentPostProcessorsFactory
- org.springframework.boot.SpringApplicationRunListener
- org.springframework.beans.factory.BeanFactory
- org.springframework.beans.factory.FactoryBean
- org.springframework.beans.factory.ObjectFactory
- org.springframework.beans.factory.ObjectProvider
- org.springframework.beans.factory.SmartFactoryBean  # isEagerInit
- org.springframework.beans.factory.SmartInitializingSingleton
- bean factory
- org.springframework.beans.factory.config.BeanFactoryPostProcessor    
    - org.springframework.context.annotation.ConfigurationClassPostProcessor        # @PriorityOrdered, 这里会提前注册一些 BPP 
    - org.springframework.beans.factory.config.PlaceholderConfigurerSupport         # @PriorityOrdered, placeHolder
        - org.springframework.beans.factory.config.PropertyPlaceholderConfigurer  
    - AnnotationAwareAspectJAutoProxyCreator
    - AsyncAnnotationBeanPostProcessor
    - org.springframework.beans.factory.support.BeanDefinitionRegistryPostProcessor  # 额外增加 bean 定义
- org.springframework.beans.factory.config.BeanPostProcessor
    - org.springframework.context.support.ApplicationContextAwareProcessor
- bean
    - org.springframework.beans.factory.InitializingBean
    - org.springframework.beans.factory.DisposableBean
        - org.springframework.beans.factory.support.DisposableBeanAdapter   
    - org.springframework.beans.factory.BeanNameAware
    - org.springframework.beans.factory.BeanClassLoaderAware
    - @javax.annotation.PostConstruct
    - @javax.annotation.PreDestroy

- org.springframework.core.SmartClassLoader
    

# order
- org.springframework.core.Ordered # 数值越小，优先级越高
- org.springframework.core.PriorityOrdered      # 该实现接口的类/对象 的 优先级高于所有 实现了  Ordered 接口的
- org.springframework.core.OrderComparator
- @org.springframework.core.annotation.Order
- org.springframework.context.support.PostProcessorRegistrationDelegate#sortPostProcessors

```
# AbstractAutowireCapableBeanFactory
```
AbstractAutowireCapableBeanFactory#initializeBean
# 1. invokeAwareMethods        # 调用 BeanFactoryAware,BeanNameAware,BeanClassLoaderAware
# 2. applyBeanPostProcessorsBeforeInitialization    # 调用所有 BFF: BeanPostProcessor#postProcessBeforeInitialization
# 3. invokeInitMethods         # 调用 InitializingBean#afterPropertiesSet, 调用自定义的 init 方法
# 4. applyBeanPostProcessorsAfterInitialization     # 调用所有 BFF: BeanPostProcessor#postProcessAfterInitialization

AbstractAutowireCapableBeanFactory#destroyBean
# 1. 调用所有 BFF:  DestructionAwareBeanPostProcessor#postProcessBeforeDestruction
# 2. 调用 DisposableBean#destroy
# 3. 调用自定义的 destroy method

 
```


## BeanFactoryPostProcessor 的 顺序
BFPP  : BeanFactoryPostProcessor
BDRPP : BeanDefinitionRegistryPostProcessor

1. 先调用 实现了 BeanDefinitionRegistryPostProcessor 的 BFPP
    1. AbstractApplicationContext#beanFactoryPostProcessors 中所有实现了 BDRPP 接口的 BFPP，
        这些对象 与 PriorityOrdered/Ordered 无关，按照编程的注册顺序来
    1. beanFactory 中 所有实现了 BDRPP + PriorityOrdered 接口的 BFPP（及其依赖的bean）
    . 
        这些对象 按照 PriorityOrdered 的优先级来
    1. beanFactory 中 所有实现了 BDRPP + Ordered 接口的 BFPP（及其依赖的bean）. 
        这些对象 按照 Ordered 的优先级来。
    1. 【递归】beanFactory 中 其他 BDRPP （未实现 PriorityOrdered/Ordered 接口）的 BFPP（及其依赖的bean）. 
        这些对象 的顺序不保障。 
        如果 在 BDRPP 中又引入了新的 BDRPP，则新引入的这一小批内部按照 PriorityOrdered/Ordered/无 排序后，整批排队后执行。
1. 再调用 未实现 BDRPP 的 BFPP
    1. AbstractApplicationContext#beanFactoryPostProcessors 中 未实现  BDRPP 接口的 BFPP , 
        这些对象 与 PriorityOrdered/Ordered 无关，按照编程的注册顺序来
    1. beanFactory 中 未实现 BDRPP, 但实现了 PriorityOrdered 接口的 BFPP. 
        这些对象 按照 PriorityOrdered 的优先级来
    1. beanFactory 中 未实现 BDRPP, 但实现了 Ordered 接口的 BFPP（及其依赖的bean）. 
        这些对象 按照 Ordered 的优先级来
    1. beanFactory 中 未实现 BDRPP/PriorityOrdered/Ordered 接口的 BFPP（及其依赖的bean）. 
        这些对象 的顺序不保障。 
1. 实例化并注册 BPP
     1. beanFactory 中 实现了 PriorityOrdered 接口的 BPP（及其依赖的bean）
     1. beanFactory 中 实现了 Ordered 接口的 BPP（及其依赖的bean）
     1. beanFactory 中 未实现 PriorityOrdered/Ordered 接口的 BPP（及其依赖的bean）



# @Configuration

- org.springframework.context.annotation.Configuration
- org.springframework.context.annotation.ConfigurationClassPostProcessor

@Configuration 是通过 ConfigurationClassPostProcessor 实现 增加 bean 定义的。


# @Value / placeholder
```
- @org.springframework.beans.factory.annotation.Value

- @org.springframework.context.annotation.PropertySource
- org.springframework.core.env.PropertySource
    - org.springframework.core.env.MapPropertySource
        - org.springframework.core.env.PropertiesPropertySource                 # ⭕️ 
        - org.springframework.boot.DefaultPropertiesPropertySource
    - org.springframework.core.env.CommandLinePropertySource
        - org.springframework.core.env.SimpleCommandLinePropertySource
    - org.springframework.boot.ansi.AnsiPropertySource
    - org.springframework.boot.env.ConfigTreePropertySource
    - org.springframework.core.env.EnumerablePropertySource

- org.springframework.core.env.PropertySources
- org.springframework.context.annotation.PropertySource
- org.springframework.context.annotation.PropertySources

- org.springframework.boot.context.properties.source.ConfigurationPropertySource

- org.springframework.beans.factory.config.PropertyResourceConfigurer
- org.springframework.beans.factory.config.PlaceholderConfigurerSupport
    - org.springframework.context.support.PropertySourcesPlaceholderConfigurer  # ⭕️ 
    - org.springframework.beans.factory.config.PropertyPlaceholderConfigurer    # @Deprecated
  
- org.springframework.beans.factory.config.PreferencesPlaceholderConfigurer # @Deprecated

- org.springframework.core.env.PropertyResolver
- org.springframework.core.env.Environment#
- org.springframework.core.env.PropertySourcesPropertyResolver
```


初始化

```plain
org.springframework.context.support.PropertySourcesPlaceholderConfigurer#postProcessBeanFactory
name : 说明

"systemProperties"      : 从 Environment 内初始化, 代表从 环境变量中取值
"systemEnvironment"     : 从 Environment  内初始化, 代表从 JVM 系统属性上取值
"environmentProperties" : 从 Environment 对象中获取
"localProperties"       : 

```


# Environment

```
- org.springframework.core.env.PropertyResolver
org.springframework.core.env.ConfigurablePropertyResolver   # 
- org.springframework.core.env.Environment
- org.springframework.core.env.ConfigurableEnvironment
- org.springframework.core.env.AbstractEnvironment
- org.springframework.core.env.StandardEnvironment
- org.springframework.core.env.EnvironmentCapable
- org.springframework.context.EnvironmentAware
- org.springframework.context.support.AbstractApplicationContext#createEnvironment
- org.springframework.context.annotation.ConfigurationClassParser#doProcessConfigurationClass 
    # 处理 @PropertySources 注解，并将其加入到 Environment 的 propertySources 中
```

# Bean

```shell
org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#populateBean # org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor#postProcessProperties
```


# BeanPostProcessor

```
- XxxAware
    - org.springframework.context.annotation.ConfigurationClassPostProcessor.ImportAwareBeanPostProcessor
    - org.springframework.context.support.ApplicationContextAwareProcessor      
        #EnvironmentAware
        #EmbeddedValueResolverAware
        #ResourceLoaderAware
        #ApplicationEventPublisherAware
        #MessageSourceAware
        #ApplicationStartupAware
        #ApplicationContextAware

    - org.springframework.context.support.ApplicationListenerDetector
    - org.springframework.context.weaving.LoadTimeWeaverAwareProcessor
    - org.springframework.web.context.support.ServletContextAwareProcessor
    - org.springframework.boot.web.servlet.context.WebApplicationContextServletContextAwareProcessor
 


- BDRPP
    - org.springframework.context.annotation.ConfigurationClassPostProcessor                    # @Configuration, <context:annotation-config/>

- org.springframework.context.weaving.LoadTimeWeaverAwareProcessor 
- org.springframework.beans.factory.support.MergedBeanDefinitionPostProcessor
- init/destory
    - org.springframework.beans.factory.config.InstantiationAwareBeanPostProcessor
        - org.springframework.beans.factory.config.SmartInstantiationAwareBeanPostProcessor
            - org.springframework.beans.factory.annotation.RequiredAnnotationBeanPostProcessor  # @Required, @Deprecated
            - org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor # @Autowired,@Value,@Inject, <context:annotation-config/>
            - ???                                                                               # @Qualifier, @Lookup, @javax.annotation.Priority
            - org.springframework.orm.jpa.support.PersistenceAnnotationBeanPostProcessor        # @javax.persistence.PersistenceUnit, @javax.persistence.PersistenceContext
            - org.springframework.aop.framework.autoproxy.AbstractAutoProxyCreator              # AOP
                - org.springframework.aop.framework.autoproxy.AbstractAdvisorAutoProxyCreator
                    - org.springframework.aop.framework.autoproxy.DefaultAdvisorAutoProxyCreator
                    - org.springframework.aop.aspectj.autoproxy.AspectJAwareAdvisorAutoProxyCreator
                        - org.springframework.aop.aspectj.annotation.AnnotationAwareAspectJAutoProxyCreator     # 
    - org.springframework.beans.factory.config.DestructionAwareBeanPostProcessor
        - org.springframework.scheduling.annotation.ScheduledAnnotationBeanPostProcessor        # @Scheduled
        - org.springframework.web.servlet.handler.SimpleServletPostProcessor                    # Servlet#init, servlet#destory
        - org.springframework.beans.factory.annotation.InitDestroyAnnotationBeanPostProcessor
            - org.springframework.context.annotation.CommonAnnotationBeanPostProcessor          # @Resource,@PostConstruct,@PreDestroy  : <context:annotation-config/>
            

```


创建

```
org.springframework.context.annotation.AnnotationConfigApplicationContext#<init>
org.springframework.context.annotation.AnnotatedBeanDefinitionReader#<init>
org.springframework.context.annotation.AnnotationConfigUtils#registerAnnotationConfigProcessors # ⭕️ : 重点 
    # 注册: ConfigurationClassPostProcessor (PriorityOrdered+BDRPP)
    # 注册: AutowiredAnnotationBeanPostProcessor
    # 注册: CommonAnnotationBeanPostProcessor
    # 注册: PersistenceAnnotationBeanPostProcessor
    # 注册: EventListenerMethodProcessor
    # 注册: DefaultEventListenerFactory
 

```



```
org.springframework.beans.factory.support.AbstractBeanFactory#getBean
    #doGetBean
    #getObjectForBeanInstance
    org.springframework.beans.factory.support.FactoryBeanRegistrySupport#getObjectFromFactoryBean
        org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory#postProcessObjectFromFactoryBean
            #applyBeanPostProcessorsAfterInitialization
                org.springframework.beans.factory.config.BeanPostProcessor#postProcessAfterInitialization

# 该 BFPP （PriorityOrdered）编程添加 ImportAwareBeanPostProcessor
org.springframework.context.annotation.ConfigurationClassPostProcessor#postProcessBeanFactory 

# 编程添加 ApplicationContextAwareProcessor,ApplicationListenerDetector,LoadTimeWeaverAwareProcessor
org.springframework.context.support.AbstractApplicationContext#prepareBeanFactory

# 在 web servlet 环境，在 BDRPP,BFPP 初始化之前 编程注册 ServletContextAwareProcessor
org.springframework.web.context.support.AbstractRefreshableWebApplicationContext#postProcessBeanFactory
org.springframework.web.context.support.GenericWebApplicationContext#postProcessBeanFactory
org.springframework.web.context.support.StaticWebApplicationContext#postProcessBeanFactory

# 在 web servlet 环境，在 BDRPP,BFPP 初始化之前 编程注册 WebApplicationContextServletContextAwareProcessor
org.springframework.boot.web.servlet.context.ServletWebServerApplicationContext#postProcessBeanFactory

# 在 BDRPP,BFPP 之后，从 BeanFactory 中获取作为 bean 初始化的 BPP
org.springframework.context.support.PostProcessorRegistrationDelegate#registerBeanPostProcessors


```


# spring boot
## placeholder
- org.springframework.boot.context.properties.source.ConfigurationPropertySource
    - org.springframework.boot.context.properties.source.SpringConfigurationPropertySource
- org.springframework.boot.context.properties.ConfigurationPropertiesBindingPostProcessor
- org.springframework.boot.context.properties.source.ConfigurationPropertySources
- org.springframework.boot.context.properties.bind.PropertySourcesPlaceholdersResolver
- org.springframework.boot.context.properties.ConfigurationPropertiesBinder


- org.springframework.boot.context.config.ConfigDataResource
    - org.springframework.boot.context.config.ConfigTreeConfigDataResource
    - org.springframework.boot.context.config.StandardConfigDataResource
- org.springframework.boot.env.PropertySourceLoader
    - org.springframework.boot.env.YamlPropertySourceLoader
    - org.springframework.boot.env.PropertiesPropertySourceLoader
- org.springframework.boot.context.config.ConfigDataLoader
    - org.springframework.boot.context.config.StandardConfigDataLoader#
- org.springframework.boot.context.config.ConfigDataLoaders
- org.springframework.boot.context.config.ConfigDataImporter
- org.springframework.boot.context.config.ConfigDataEnvironment


# Q : BeanFactoryPostProcessor 的类上可以 使用 XxxAware 么？ 
A: 可以使用 XxxAware， 
示例：org.springframework.context.support.PropertySourcesPlaceholderConfigurer : 属于 BFPP, 也实现了 BeanFactoryAware, BeanNameAware, EnvironmentAware 接口

调用 XxxAware 接口的地方
- spring 框架内建机制: 比如： AbstractAutowireCapableBeanFactory#invokeAwareMethods 负责调用 BeanNameAware,BeanClassLoaderAware,BeanFactoryAware 接口
- spring 框架编程注册的一些 BPP， 比如 ApplicationContextAwareProcessor 负责调用 EnvironmentAware,MessageSourceAware 等

# Q : 那 BeanPostProcessor 和 BeanFactoryPostProcessor 到底谁先初始化的？
在spring 框架代码中，有通过硬编码的方式提前注册了一些 BPP, 比如 ImportAwareBeanPostProcessor,ApplicationContextAwareProcessor 等 
这些 BPP 支持的功能是可以在 BDRPP, BFPP 中使用的。

但作为Bean初始化的 BPP，则不能使用。


# Q : 父 ApplicationContext 中的 PropertySourcesPlaceholderConfigurer 是否能对 子 ApplicationContext 的bean 管用?


# Q : spring 中如何确保某些代码提前初始化？
1. 放到作为 bean 声明的 BDRPP 中 的 依赖注入的 bean 中。 比如 @Configuration 的类里声明一个 @Autowired 字段
2. 放到 PriorityOrdered,Ordere,无 的 BDRPP 中
3. 放到作为 bean 声明的 BFPP 中 的 依赖注入的 bean 中。
4. 放到 PriorityOrdered,Ordere,无 的 BFPP 中


# @ : ConfigurableEnvironment#getPropertySources 中 除了 JVM 属性，环境变量，默认还有哪些消息源？ 即 PropertySourcesPlaceholderConfigurer 默认可用哪些 placeholder ?
- spring:
    -  org.springframework.core.env.AbstractEnvironment#merge
        子 ApplicationCtonext 中默认继承父 ApplicationContext 的 PropertySource
    -  org.springframework.context.annotation.ConfigurationClassParser#addPropertySource
        在 @Configuration 上声明的  @PropertySources/@PropertySource 声明
    - org.springframework.web.context.support.StandardServletEnvironment#initPropertySources
        在 web servelet 环境中，
        - "servletContextInitParams" : ServletContext#getInitParameterNames
        - "servletConfigInitParams" : ServletConfig#getInitParameter
    - org.springframework.web.context.support.StaticWebApplicationContext#initPropertySources : 同上

- spring boot
    - org.springframework.boot.SpringApplication#configurePropertySources
       命令行参数作为来源


# Q : 如何向 Enviroment 中注入 自定的 propertySource, 后注入的是否会影响 placeholder ?


# Q : @Configuration 中 声明的 @Bean 的方法 的 @Value 是如何解决的？

- 入口: org.springframework.beans.factory.support.ConstructorResolver#instantiateUsingFactoryMethod
      # createArgumentArray
核心代码: org.springframework.beans.factory.support.DefaultListableBeanFactory
    #resolveDependency(DependencyDescriptor,String,Set<String>,TypeConverter)
    #doResolveDependency   # 获取 @Value 的原始值，并处理 placeholder 
org.springframework.beans.factory.annotation.QualifierAnnotationAutowireCandidateResolver#extractValue  # 获取 @Value 的原始值——尚未处理 placeholder 和类型转换
org.springframework.beans.factory.support.AutowireCandidateResolver

- org.springframework.util.StringValueResolver
- org.springframework.beans.factory.support.AbstractBeanFactory#embeddedValueResolvers   # 默认通过 Enviroment 获取 值
- org.springframework.beans.factory.config.PlaceholderConfigurerSupport#doProcessProperties # 在声明 placeholder 的 BFPP 时，也会将其加载的 placeholder 也会调用  beanFactory.addEmbeddedValueResolver


# Q : bean class 中 字段上声明的  @Value 是如何解决的？

调用入口是 AutowiredAnnotationBeanPostProcessor
但底层仍然是 AbstractBeanFactory#embeddedValueResolvers

```
"Test worker@1412" prio=5 tid=0xe nid=NA runnable
  java.lang.Thread.State: RUNNABLE
	  at org.springframework.beans.factory.support.DefaultListableBeanFactory.doResolveDependency(DefaultListableBeanFactory.java:1333)
	  at org.springframework.beans.factory.support.DefaultListableBeanFactory.resolveDependency(DefaultListableBeanFactory.java:1311)
	  at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.resolveFieldValue(AutowiredAnnotationBeanPostProcessor.java:657)
	  at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor$AutowiredFieldElement.inject(AutowiredAnnotationBeanPostProcessor.java:640)
	  at org.springframework.beans.factory.annotation.InjectionMetadata.inject(InjectionMetadata.java:119)
	  at org.springframework.beans.factory.annotation.AutowiredAnnotationBeanPostProcessor.postProcessProperties(AutowiredAnnotationBeanPostProcessor.java:399)
	  at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.populateBean(AbstractAutowireCapableBeanFactory.java:1431)
	  at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.doCreateBean(AbstractAutowireCapableBeanFactory.java:619)
	  at org.springframework.beans.factory.support.AbstractAutowireCapableBeanFactory.createBean(AbstractAutowireCapableBeanFactory.java:542)
	  at org.springframework.beans.factory.support.AbstractBeanFactory.lambda$doGetBean$0(AbstractBeanFactory.java:335)
	  at org.springframework.beans.factory.support.AbstractBeanFactory$$Lambda$330.380702608.getObject(Unknown Source:-1)```


# Q : BFPP 字段上声明的  @Value ，以及 依赖的 bean 的字段里的 @Value 为何无值?
因为 字段上的 @Value 是 AutowiredAnnotationBeanPostProcessor 处理的


# Q : NoSuchMethodException : 找不到 bean 的 无参构造函数
- org.springframework.beans.factory.config.AutowireCapableBeanFactory#AUTOWIRE_CONSTRUCTOR
    #determineConstructorsFromBeanPostProcessors  
- org.springframework.beans.factory.support.AbstractBeanDefinition#getResolvedAutowireMode
