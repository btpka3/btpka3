

# 解析总结

## 通过AOP对Bean进行权限控制

### 配置解析

```xml
// 1. servlet 级别的 Spring 配置文件中配置
<context:component-scan base-package="me.test" />
<sec:global-method-security pre-post-annotations="enabled" proxy-target-class="true" />

// 2. spring-security-config 对 <sec> spring 命名空间进行解析
SecurityNamespaceHandler -> GlobalMethodSecurityBeanDefinitionParser 解析，
通过 SecuredAnnotationSecurityMetadataSource 等 MethodSecurityMetadataSource 获取要进行安全控制的bean,
通过 注册 MethodSecurityMetadataSourceAdvisor 对上述bean进行aop
```

### 调用解析

```
SecuredAnnotationSecurityMetadataSource#getAttributes()
MethodSecurityInterceptor.obtainSecurityMetadataSource()
MethodInvocationPrivilegeEvaluator#isAllowed()

MethodSecurityMetadataSourceAdvisor#getAdvice()
MethodSecurityInterceptor#invoke()
MethodSecurityInterceptor#beforeInvocation()
AffirmativeBased#decide()
WebExpressionVoter#vote()
```

## 通过Filter对URL进行权限控制

### 配置解析

```
SecurityNamespaceHandler -> HttpSecurityBeanDefinitionParser -> HttpConfigurationBuilder

HttpConfigurationBuilder#createFilterSecurityInterceptor()
        // 创建 FilterSecurityInterceptor bean
FilterInvocationSecurityMetadataSourceParser#createSecurityMetadataSource()
        // 创建 ExpressionBasedFilterInvocationSecurityMetadataSource，并保存 <sec:http>/<sec:intercept-url>;
        // 将其注入到 FilterSecurityInterceptor 中
```

### 调用解析

```
FilterSecurityInterceptor#doFilter()
FilterSecurityInterceptor#invoke()
FilterSecurityInterceptor#beforeInvocation()
AffirmativeBased#decide()
AccessDecisionVoter#vote()
```
## 通过JSP标签进行权限控制

```
JspAuthorizeTag#authorizeUsingUrlCheck()
DefaultWebInvocationPrivilegeEvaluator#isAllowed()
FilterSecurityInterceptor#getAccessDecisionManager().decide()
AffirmativeBased#decide()
AccessDecisionVoter#vote()
```

## Spring Security 的 Grails 插件解析
仅仅通过 FilterSecurityInterceptor 进行控制，而没有使用 MethodSecurityInterceptor。
因此，只能对URL进行控制，@Secured 注解只能使用在 Controller 的 Action 上，而无法使用在 Service 等 Spring bean 上。
具体请参考 SpringSecurityCoreGrailsPlugin.groovy。


### 权限检查

```
FilterSecurityInterceptor#beforeInvocation()
AuthenticatedVetoableDecisionManager.decide()
AccessDecisionVoter#vote()

// 通过SpringSecurityUtils.java 会发现有以下 AccessDecisionVoter：
//    authenticatedVoter  : org.springframework.security.access.vote.AuthenticatedVoter
//    roleVoter           : org.springframework.security.access.vote.RoleHierarchyVoter
//    webExpressionVoter  : grails.plugin.springsecurity.web.access.expression.WebExpressionVoter
//    closureVoter        : grails.plugin.springsecurity.access.vote.ClosureVoter
// 主要通过 DefaultWebSecurityExpressionHandler 执行Spring Expression 进行检查。

DefaultWebSecurityExpressionHandler#createSecurityExpressionRoot()
WebSecurityExpressionRoot#xxx()                 // 也即 @Secured 注解中可以使用的 方法都在这里定义。
WebSecurityExpressionRoot#getAuthoritySet()     // 通过从当前 authentication.getAuthorities() 获取权限
```

###  登录流程

```
// request 1 : 用户尚未登录，访问需要登录后才能访问的URL
                                                // “权限检查” 流程中抛出 AuthenticationCredentialsNotFoundException
ExceptionTranslationFilter#doFilter()           // 捕获异常，保存当前访问的URL到requestCache，并引导用户开始登录流程
CasAuthenticationEntryPoint#commence()          // 将浏览器 301 重定向到 cas 的登录URL，带上 `service` 回调 URL

// request 2 : 在 cas 上完成登录，携带 `ticket` 参数访问前面 `service` URL
CasAuthenticationFilter#attemptAuthentication() // 创建 UsernamePasswordAuthenticationToken：
                                                //  username="_cas_stateful_" 或者"_cas_stateless_";
                                                //  password=从cas服务器301跳转带回来的一次性ticket
                                                //  details=远程IP地址和当前sessionId
ProviderManager#authenticate()
CasAuthenticationProvider#authenticate()        // UsernamePasswordAuthenticationToken -> CasAuthenticationToken
                                                // NOTICE：在这一步，GrailsUser 被封装成 CasAuthenticationToken，权限也进行了处理
CasAuthenticationProvider#authenticateNow()     // service ticket -> cas server -> userId
CasAuthenticationProvider#loadUserByAssertion()
UserDetailsByNameServiceWrapper#loadUserDetails()
UserDetailService#loadUserByUsername()          // 通过 userId 查询数据库，构建 UserDetails/GrailsUser 对象，并包含权限列表
```


## CAS

[cas 3.0 协议](http://jasig.github.io/cas/development/protocol/CAS-Protocol-Specification.html)

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

2. 无需使用自定义枚举类来实现GrantedAuthority，枚举会有版本问题。直接使用SimpleGrantedAuthority就好。



## ACL

```sql
-- http://docs.spring.io/spring-security/site/docs/4.2.0.RELEASE/reference/htmlsingle/#domain-acls

-- Sid :
/*
 * Sid
 *    PrincipalSid : Authentication.getPrincipal() -> ID
 *    GrantedAuthoritySid: GrantedAuthority(代表一个权限) -> ID
 */
CREATE TABLE acl_sid (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	principal BOOLEAN NOT NULL,
	sid VARCHAR(100) NOT NULL,
	UNIQUE KEY unique_acl_sid (sid, principal)
) ENGINE=InnoDB;


-- Java class -> ID，以方便其他表高效引用（非高效：通过字符串引用）
CREATE TABLE acl_class (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	class VARCHAR(100) NOT NULL,
	UNIQUE KEY uk_acl_class (class)
) ENGINE=InnoDB;

-- Java 中每个实例化的 Object -> ID
CREATE TABLE acl_object_identity (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	object_id_class BIGINT UNSIGNED NOT NULL,
	object_id_identity BIGINT NOT NULL,
	parent_object BIGINT UNSIGNED,
	owner_sid BIGINT UNSIGNED,                -- 当前对象属于哪个人
	entries_inheriting BOOLEAN NOT NULL,      -- 是否继承
	UNIQUE KEY uk_acl_object_identity (object_id_class, object_id_identity),
	CONSTRAINT fk_acl_object_identity_parent FOREIGN KEY (parent_object) REFERENCES acl_object_identity (id),
	CONSTRAINT fk_acl_object_identity_class FOREIGN KEY (object_id_class) REFERENCES acl_class (id),
	CONSTRAINT fk_acl_object_identity_owner FOREIGN KEY (owner_sid) REFERENCES acl_sid (id)
) ENGINE=InnoDB;

-- 授权关系表： acl_object_identity:sid(被授权人)
CREATE TABLE acl_entry (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	acl_object_identity BIGINT UNSIGNED NOT NULL,   -- 被授权的对象
	ace_order INTEGER NOT NULL,                     -- 顺序
	sid BIGINT UNSIGNED NOT NULL,                   -- 被授权人
	mask INTEGER UNSIGNED NOT NULL,                 -- 被授予的权限
	granting BOOLEAN NOT NULL,                      -- 是否授予了
	audit_success BOOLEAN NOT NULL,                 -- 貌似对权限判断并没卵用，仅仅用以审计
	audit_failure BOOLEAN NOT NULL,                 -- 貌似对权限判断并没卵用，仅仅用以审计
	UNIQUE KEY unique_acl_entry (acl_object_identity, ace_order),
	CONSTRAINT fk_acl_entry_object FOREIGN KEY (acl_object_identity) REFERENCES acl_object_identity (id),
	CONSTRAINT fk_acl_entry_acl FOREIGN KEY (sid) REFERENCES acl_sid (id)
) ENGINE=InnoDB;
```



```
acl_sid
acl_class
acl_object_identity
acl_entry {
    id  自动生成
    acl_object_identity :
    sid
    grantedPermissions: [mask, ...]
    blockedPermissions: [mask, ...]
    audit_success: []


    UNIQUE KEY (acl_object_identity, sid)
}

```

RBAC : Role-based Access Control
ABAC : Attribute-Based Access Control
[jaclp](https://github.com/Neloop/jaclp)
XACML : [Extensible Access Control Markup Language](https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=xacml)

