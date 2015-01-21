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

```jsp
<spring:eval var="defaultUrl" expression="@config['default.url']" />
click <a href="${fn:escapeXml(defaultUrl)}">here</a>.
```
提醒：Spring的PlaceHolder是支持在properties中进行级联配置的

```properties
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

```txt
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
