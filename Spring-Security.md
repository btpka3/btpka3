##  概念
*   Authentication
*   Principal


## CAS
### 允许所有的URL接收ST
[参考](http://static.springsource.org/spring-security/site/docs/3.1.x/reference/springsecurity-single.html#cas-pt)   

1.  serviceProperties
    *   设置 authenticateAllArtifacts = true
2.  casAuthenticationFilter
    *   指定 serviceProperties
    *   指定 authenticationDetailsSource
    *   （可选）指定proxyGrantingTicketStorage
3.  casProcessingFilterEntryPoint
    *   指定 serviceProperties
    *   （可选）指定 ticketValidator 为 Cas20ProxyTicketValidator
    *   （可选）指定 statelessTicketCache

## 使用桌面程序打开SSO web应用
1. 使用 CAS 的[RESTful API](https://wiki.jasig.org/display/CASUM/RESTful+API) 获取PGT
2. 使用 wininet.dll # InternetSetCookie 设置Cookie。此步骤即模拟登陆CAS服务器。
3. 新打开 WebBroswer 控件到SSO web应用，如果碰到需登录才能使用的URL，则会自动跳转后完成单点登录。由于中间牵涉跳转，所以只针对GET请求有效。否则，应当使用CAS的RESTFul API先获取ST后，直接单个登录到具体的SSO Web 应用。  
    FIXME：
    1.  上述只能对进程内的WebBroswer 有效，如何对进程外的也有效（打开独立IE窗口）？使用 ieframe.dll # IESetProtectedModeCookie() ？
    2.  如何避免客户端程序非得设置Cookie才有效？使用[Second-Level CAS Server](https://wiki.jasig.org/display/CASUM/Second-Level+CAS+Server)？

## NOTICE
1. 如果在同一个Controller中，当前用户只有权限a，则用户访问`/a`是不会抛出"没有权限"的异常的，而访问`/b`会抛异常。虽然`a()`方法内部有调用`b()`方法。该现象可能与AOP有关系。
```java
@Controller
public class MyController {
    @RequestMapping("/a")
    @PreAuthorize("hasRole('a')")
    public String a() {
        b();
        // ...
        return "a";
    }

    @RequestMapping("/b")
    @PreAuthorize("hasRole('b')")
    public String b() {
        // ...
        return "b";
    }
}
```