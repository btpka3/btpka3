
# Servlet 3.0:



## 新特性：

1. SCI (javax.servlet.ServletContainerInitializer)。主要用来在 `WEB-INF/lib/*.jar!/META-INF/services/javax.servlet.ServletContainerInitializer`
    中包含一个实现该接口的类的全限定名，该文件不应当出现在 webapp 本身中。用于模块化开发。而基于`ServletContextListener`/`@WebListener`的话，有可能被禁用掉的。

1. Web fragments。 主要用来扫描 `WEB-INF/lib/*.jar!/META-INF/web-fragment.xml`。
     web-fragment.xml 可以包括几乎所有可以在web.xml中指定的元素。
     当web.xml设置了 `metadata-complete="true"` 时，会不被扫描。
     web.xml中可以设置 `<absolute-ordering>` 以通过filter名称明确指定filter顺序。

1. 直接从 `META-INF/resources/*` 下获取静态资源。
1. @WebFilter,@WebListener,@WebServlet 等注解
1. 被@HandlesTypes标识的类可以传递给 SCI 来执行。
1. 对文件上传优化。 `HttpServletRequest#getPart`、 `#getParts`
1. 异步编程

## 新注解
* `@HandlesTypes` : 该注解用以定义一组要传递到 `ServletContainerInitializer`(SCI) 中类的数组
* `@HttpConstraint` : 安全限定：是否允许未登录访问，是否需要https，是否需要特定权限
* `@HttpMethodConstraint` : 安全限定：同上
* `@MultipartConfig` : 为servlet设定文件上传时的相关限定：文件临时存储路径，大小限制等
* `@ServletSecurity` : 组合使用 `@HttpConstraint`、 `@HttpMethodConstraint` 为Servlet进行安全限定，配合 `@WebServlet`，但是，由于主流框架通常由单个Servlet代理了所有的请求，故此方式多不实用。
* `@WebFilter` : 注册一个filter。 FIXME：但是无法指定顺序
* `@WebInitParam` : 配合 `@WebFilter`，`@WebServlet` 使用
* `@WebListener` : 注册一个listener
* `@WebServlet` : 注册一个servlet

## 如何禁用Servlet3的注解扫描？
参考《[How do I make Tomcat startup faster?](https://wiki.apache.org/tomcat/HowTo/FasterStartUp)》。
示例：

```xml
<web-app metadata-complete="true">
    <absolute-ordering/>
</web-app>
```

如何在Spring boot中禁用 Servlet 3的注解扫描？（因为可能就压根没有web.xml)。
参考[这里](http://docs.spring.io/spring-boot/docs/1.4.1.RELEASE/reference/htmlsingle/#howto-disable-registration-of-a-servlet-or-filter)：

```
// 注意：这是通过Spring Bean的注册机制设置的。
@Bean
public FilterRegistrationBean registration(MyFilter filter) {
    FilterRegistrationBean registration = new FilterRegistrationBean(filter);
    registration.setEnabled(false);
    return registration;
}
```

如果针对 `@WebServlet` 等注解，在Spring boot中，只有启用 `@Configuration` + `@ServletComponentScan` 才会扫描注册。

## 
[DispatcherType](http://docs.oracle.com/javaee/6/api/javax/servlet/DispatcherType.html) 有以下四种枚举值：

* `ASYNC`: 比如:

    ```
    AsyncContext actx = request.startAsync();  
    actx.setTimeout(30*1000);  
    actx.start(new YourExecutor(actx));  
    ```

* `ERROR`:  当发生404，500等错误时，进行错误处理时。 
* `FORWARD`: 比如:  `GenericServlet#getServletContext().getRequestDispatcher(String).forward(req,resp)` 
* `INCLUDE`: 比如: `GenericServlet#getServletContext().getRequestDispatcher(String).include(req,resp)` 
* `REQUEST`: ??? 用户正常请求时，第一个接收请求的servlet就是该类型。

理解上述类型很重要，会影响filter的配置。

可以通过 `ServletRequest#getDispatcherType()` 获取当前请求是哪种类型。


# Servlet 4.0
[Servlet 4.0](https://jcp.org/en/jsr/detail?id=369) 预计会在 2017年定稿。 内容变更有：

1. 请求/响应复用(Request/Response multiplexing)
1. 流的优先级(Stream Prioritization)
1. 服务器推送(Server Push)
1. HTTP1.1升级(Upgrade from HTTP 1.1)
