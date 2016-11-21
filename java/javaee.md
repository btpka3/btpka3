
# Servlet 3.0:



## 新特性：

1. SCI (javax.servlet.ServletContainerInitializer)。主要用来在 `WEB-INF/lib/*.jar!/META-INF/services/javax.servlet.ServletContainerInitializer`
    中包含一个实现该接口的类的全限定名，该文件不应当出现在 webapp 本身中。用于模块化开发。而基于`ServletContextListener`/`@WebListener`的话，有可能被禁用掉的。spring-web.jar 中的 `SpringServletContainerInitializer` 就是基于该接口，进而提供了 `WebApplicationInitializer` 类型的回调。

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
// 注意：这是通过Spring boot Bean的注册机制设置的。
@Bean
public FilterRegistrationBean registration(MyFilter filter) {
    FilterRegistrationBean registration = new FilterRegistrationBean(filter);
    registration.setEnabled(false);                 // 不启用
    registration.setOrder(Integer.MAX_VALUE - 1);   // 如果启用的话，可以设置优先级。
    return registration;
}
```

如果针对 `@WebServlet` 等注解，在Spring boot中，只有启用 `@Configuration` + `@ServletComponentScan` 才会扫描注册。

## DispatcherType
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



## Java EE 版本
[参考](http://en.wikipedia.org/wiki/Java_EE_version_history)

<table>
<tr>
  <th></th>
  <th>JavaEE 1.4</th>
  <th>JavaEE 5</th>
  <th>JavaEE 6</th>
</tr>
<tr>
  <th>Date</th>
  <td>2003/11/11</td>
  <td>2006/05/11</td>
  <td>2009/12/10</td>
</tr>
<tr>
  <th>Servlet</th>
  <td>2.4</td>
  <td>2.5</td>
  <td>3.0</td>
</tr>
<tr>
  <th>JSP</th>
  <td>2.0</td>
  <td>2.1</td>
  <td>2.2</td>
</tr>
<tr>
  <th>JSTL</th>
  <td>1.1</td>
  <td>1.2</td>
  <td>1.2</td>
</tr>
</table>


### JavaEE 1.4
maven 
```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>servlet-api</artifactId>
  <version>2.4</version>
  <scope>provided</scope>
</dependency>
```
web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app
    xmlns="http://java.sun.com/xml/ns/j2ee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
    version="2.4">

</web-app>
```

###JavaEE 5
maven
```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>servlet-api</artifactId>
  <version>2.5</version>
  <scope>provided</scope>
</dependency>       
```
web.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app 
    xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_2_5.xsd"
    version="2.5">

</web-app>
```

### JavaEE 6
maven
```
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>javax.servlet-api</artifactId>
  <version>3.0.1</version>
  <scope>provided</scope>
</dependency>
```

web.xml
```
<?xml version="1.0" encoding="UTF-8"?>
<web-app
    xmlns="http://java.sun.com/xml/ns/javaee"
    xmlns:web="http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/javaee http://java.sun.com/xml/ns/javaee/web-app_3_0.xsd"
    version="3.0">
 
</web-app>
```

## JSTL
参考：
[JSTL 1.1 Tag Reference](http://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/index.html)
[JSTL@stackOverFlow](http://stackoverflow.com/tags/jstl/info)

*.jsp
```xml
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
```

1.1 for maven
```xml
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>jstl</artifactId>
  <version>1.1.2</version>
</dependency>
```

1.2 for maven
来自于 Servlet 2.5 / JSP 2.1
适用于 Servlet 2.4 / JSP 2.0、 Servlet 2.5 / JSP 2.1 
<source>
<dependency>
  <groupId>javax.servlet</groupId>
  <artifactId>jstl</artifactId>
  <version>1.2</version>
</dependency>
</source>

1.2.1 for maven
来自于 Servlet 3.0 / JSP 2.2 
适用于 Servlet 2.5 / JSP 2.1、Servlet 2.4 / JSP 2.0 、 Servlet 3.0 / JSP 2.2 
```xml
<dependency>
  <groupId>javax.servlet.jsp.jstl</groupId>
  <artifactId>javax.servlet.jsp.jstl-api</artifactId>
  <version>1.2.1</version>
</dependency>
<dependency>
  <groupId>org.glassfish.web</groupId>
  <artifactId>javax.servlet.jsp.jstl</artifactId>
  <version>1.2.1</version>
</dependency>
```


```markup
<c:forEach items="${xxxList}" var="xxx" varStatus="loopStatus">
   <tr class="${loopStatus.index % 2 == 0 ? 'even_row' : 'odd_row'}">...</tr>
</c:forEach>
```

```markup
<c:forEach items="${xxxList}" var="xxx" >
  <tr>
      <td>XXX</td>
      <td>XXX</td>
      <td>XXX</td>
  </tr>
</c:forEach>
<c:forEach var="i" begin="${fn:length(xxxList)}" end="9"  > <%-- Output padding lines --%>
<table >
  <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
  </tr>
</c:forEach>
```

## 问题
* ??? : response.sendError(int,String)之后，无法使用 :
    * request.setAttribute("javax.servlet.error.message", yourErrorMessage)
    * request.setAttribute("javax.servlet.error.exception", yourException )
* ??? : response.sendError(int,String)之后，再调用 request.setAttribute("javax.servlet.error.exception", yourException )将会变成500错误