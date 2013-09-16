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


```jsp
<c:forEach items="${xxxList}" var="xxx" varStatus="loopStatus">
   <tr class="${loopStatus.index % 2 == 0 ? 'even_row' : 'odd_row'}">...</tr>
</c:forEach>
```

```jsp
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

