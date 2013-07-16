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