## AOP debug 信息

为 `org.springframework.aop.framework` 开启 DEBUG 级别的日志信息。

## spring mvc 注解
```xml
<mvc:default-servlet-handler />
  只有web.xml中DispatcherServlet的<servlet-mapping>为 "/" 时才有意义。
  此时由于DispatcherServlet会处理所有的请求（含静态资源）。
  为了能够高效访问使用静态资源，才有此设计：将DefaultServletHttpRequestHandler作为最后一个HandlerMapping，
  来代理Servlet容器的默认Servelt进行处理（注意order）。
  如果此时想直接通过 *.jsp 的URL后缀访问，则该jsp文件就不能放在 WEB-INF 目录下了。
  个人感角此功能应不会很常用。静态文件通常直接有Nginx等静态服务器代为提供了，
  或者直接有Servlet容器提供了，DispatcherServlet通常都只是映射某个特定的URL的。（比如 "*.do"）

<mvc:resources location="/resources" mapping="/, classpath:/META-INF/web" cache-period="999" order="999"/>
  该功能主要是可以从其他路径下获取资源，比如classpath下。
  相对来说，也全部是静态资源。（FIXME：JSP呢？）

<mvc:view-controller path="/xx" view-name="XX"/>
  该功能主要为少数直接访问JSP页面，而无需执行任何业务逻辑的Controller简化配置。
  但是如果这种情况很多：比如N多JSP都放在WEB-INF目录下，但只能以 *.do 后缀的URL访问。
  觉得以下方式比较好：
  <bean class="org.springframework.web.servlet.handler.SimpleUrlHandlerMapping">
    <property name="defaultHandler">
      <bean class="org.springframework.web.servlet.mvc.UrlFilenameViewController" />
    </property>
    <property name="order" value="999" />
  </bean>
  这样，就相当于对任意URL都提供了一个后备的（注意order）的无任何业务逻辑的Controller，
  仍然可以使用InternalResourceViewResolver返回WEB-INF目录下的JSP文件渲染的内容。
```

## forward prefix
```java
@Controller
@RequestMapping("/aaa/bbb")
public class DispenseAction {

    private static final String searchParamKey = "xxx";

    @RequestMapping(value = "/listInit", method = RequestMethod.GET)
    public String listInit(HttpSession session){
        session.removeAttribute(searchParamKey);
        return "forward:/aaa/bbb/list.do";
    }
    @RequestMapping(value = "/list", method = RequestMethod.GET)
    public String list(...) {
        ///...
   }
}
```



* 在JSP中使用properties中的配置项
    1. 将placeholder和引用properties分离

```xml
<util:properties id="config" location="/WEB-INF/config.properties" />
<bean class="org.springframework.beans.factory.config.PropertyPlaceholderConfigurer"
      p:properties-ref="config" />
```
    2. 在JSP中使用 `<spring:eval />` 执行SpEL，或直接输出，或保存到变量：

```html
<spring:eval var="defaultUrl" expression="@config['default.url']" />
click <a href="${fn:escapeXml(defaultUrl)}">here</a>.
```
提醒：Spring的PlaceHolder是支持在properties中进行级联配置的

```ini
server.name=http://localhost:8080
server.verify.url=${server.name}/verify
```


## SpEL

```java

// 成员变量
@Value("#{ <expression string> }")
private String field;

// 普通方法
@Autowired
public void configure(MovieFinder movieFinder,
                      @Value("#{ <expression string> }"} String defaultLocale) {...}

// 构造函数
@Autowired
public MovieRecommender(CustomerPreferenceDao customerPreferenceDao,
                          @Value("#{systemProperties['user.country']}"} String defaultLocale) {...}
```

```xml
<bean>
  <property name="randomNumber" value="#{ <expression string> }"/>
</bean>
```

```
inline list
#{1,2,3,{'a',"b","c"}}

静态方法调用
#{ T(java.lang.Math).random() * 100.0 }

通过预定义变量systemProperties访问系统属性
#{ systemProperties['user.region'] }

调用Spring管理的bean
#{@beanId.xxxAttr}

```

# config && placeholder

```xml
<util:properties id="CFG" location="classpath:/path/1;classpath:/path/2;" />
<context:property-placeholder location="/WEB-INF/cas.properties" properties-ref="CFG" />
```

检查使用

```java
// Grails 环境？
if (ClassUtils.isPresent("grails.util.Holders",
        MqInfo.class.getClassLoader())) {

    ConfigObject cfgObj = Holders.getConfig();

    String[] configPath = CONFIG_PREFIX_KEY.split("\\.");
    for (int i = 0; i < configPath.length; i++) {
        Object obj = cfgObj.get(configPath[i]);
        if (i < configPath.length - 1) {
            if (obj instanceof ConfigObject) {
                cfgObj = (ConfigObject) obj;
            } else {
                break;
            }
        } else {
            if (obj instanceof String) {
                cfgObj = (ConfigObject) obj;
            }
            break;
        }
    }
}

// 从系统环境变量中读取
if (StringUtils.isEmpty(queueNamePrefix)) {
    queueNamePrefix = System.getProperty(CONFIG_PREFIX_KEY);
}

if (StringUtils.isEmpty(queueNamePrefix)) {
    ApplicationContext appContex = ApplicationContextHolder.getContext();
    if (appContex != null) {
        Properties prop = appContex.getBean("config", Properties.class);
        if (prop != null) {
            queueNamePrefix = prop.getProperty(CONFIG_PREFIX_KEY);
        }
    }
}
```

# ApplicationContextHolder.java

```java
public class ApplicationContextHolder implements ApplicationContextAware {
    private static ApplicationContext applicationContext;

    private ApplicationContextHolder() {
        super();
    }

    public void setApplicationContext(ApplicationContext applicationContext)
            throws BeansException {
        ApplicationContextHolder.applicationContext = applicationContext;
    }

    public static ApplicationContext getContext() {
        return applicationContext;
    }

}
```

## 通过注解进行配置


---------------------------------------------------------------------- spring

FIXME : 使用注解定义bean的时候，如果override 一个同名的bean的定义？
@Inject



@PropertySource        从配置文件加载配置项，可以通过Environment#getProperty() 获取属性，或者通过 @Value("${propName}") 依赖注入。
                    如果有多个被@PropertySource    注解的配置，则key同名的配置项，将取最后一个被@PropertySource    注解的值。



@ComponentScan         默认，Spring仅仅扫描 @Component, @Controller, @Repository, @Service

==================================javax.annotation
@Resource
@PostConstruct

==================================org.springframework.stereotype
@Component         一个通用的，没有特定意义的组件注解。
@Controller     @Component下的一个特定的注解，主要用来在Spring MVC中注册 Controller
@Repository     @Component下的一个特定的注解，主要是DDD（Domain-Driven Design）中用来封装存储动作——即数据持久化
@Service        @Component下的一个特定的注解，主要是DDD（Domain-Driven Design）中用来封装业务操作（无状态）
                   注意：如果该注解包含参数（bean的建议名称），且当前容器中已经有同名bean，将不会创建。
                   因此，如果需要明确覆盖的话，请使用 @Configuration + @Bean


==================================org.springframework.beans.factory.annotation
@Autowired
@Configurable
@Qualifier
@Required
@Value



==================================org.springframework.<context class="annotation"></context>
@Configuration        @Component下的一个特定的注解，说明该类会包含多个被@Bean注解的方法。


@Bean 说明一个方法返回一个bean, 只有在 @Configuration 下才起作用。
@Scope
@Primary
@Lazy


```

@Configuration
@PropertySource("classpath:/com/myco/app.properties")
public class AppConfig {

    @Autowired
    Environment env;

    @Value("${xxx.prop:'defaultValue'}")
    String xxxProp


    @Bean(name={"b1","b2"})
    @Scope("prototype")
    public MyBean myBean() {
        println env.getProperty("xxx.prop")
         return obj;
    }

    // FIXME : 只有该类所有的 @Autowired 解决完毕之后，才会调用相应的 @Bean方法？
    @Autowired(required = false)
    @Qualifier("springSessionDefaultRedisSerializer")
    public void setDefaultRedisSerializer(RedisSerializer<Object> defaultRedisSerializer) {
        this.defaultRedisSerializer = defaultRedisSerializer;
    }
}
```

==================================7788
@WebServlet(urlPatterns = "/AsyncLongRunningServlet", asyncSupported = true)
public class AsyncLongRunningServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    }
}
ServletRequest#getAsyncContext().

startAsync()

servlet dispatcherType


==================================Servlet 注解配置： javax.servlet.annotation
@HandlesTypes            该注解用以定义一组要传递到 ServletContainerInitializer(SCI) 中类的数组
@HttpConstraint         安全限定：是否允许未登录访问，是否需要https，是否需要特定权限
@HttpMethodConstraint   安全限定：同上
@MultipartConfig        为servlet设定文件上传时的相关限定：文件临时存储路径，大小限制等
@ServletSecurity        组合使用 @HttpConstraint、 @HttpMethodConstraint 为Servlet进行安全限定，配合 @WebServlet
                        但是，由于主流框架通常由单个Servlet代理了所有的请求，故此方式多不实用。
@WebFilter              注册一个filter。 FIXME：但是无法指定顺序
@WebInitParam           配合 @WebFilter，@WebServlet    使用
@WebListener            注册一个listener
@WebServlet                注册一个servlet

FIXME： 如何禁用上述注解扫描？修改web.xml

```
<web-app metadata-complete="true">
    <absolute-ordering/>
</web-app>
```

《[How do I make Tomcat startup faster?](https://wiki.apache.org/tomcat/HowTo/FasterStartUp)》

??? Web fragments
