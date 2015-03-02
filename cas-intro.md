
[CAS](http://jasig.github.io/cas/4.0.x/index.html) 是一个比较知名的单点登录框架，但要用好，要求比较高：

* 需要熟悉 [CAS 协议](http://jasig.github.io/cas/development/protocol/CAS-Protocol-Specification.html)。
* 要定制它的话，需要熟悉 Maven 的 [war overlay](http://maven.apache.org/plugins/maven-war-plugin/overlays.html) 开发方式
* 需要熟悉 [Spring Security](http://projects.spring.io/spring-security/)， [Spring Web Flow](http://projects.spring.io/spring-webflow/)， Spring MVC。
* CAS 的 java客户端 webapp 需要使用 Spring Security。

# 约定

所有工程中，均使用账户ID作为用户身份标识，无论用户在官网上注册的账户，还是通过第三方账户（ QQ 账户登录、CPS 账户登录）登录、注册、绑定的账户。


# 功能划分

## lizi-cas
* 提供单点登录功能

    为 Web 应用提供 CAS 协议的接口，为手机APP等应用提供改造的 [REST 协议](http://jasig.github.io/cas/development/protocol/REST-Protocol.html)

* 外部账户代理认证功能

    使用 QQ、CPS 等外部账户登录时，可以分为以下流程：
    1. 通过 OAuth 等协议到 QQ 等第三方账户服务商完成用户身份认证。
    1. 如果该第三方账号已经绑定到了既有的 LIZI 账户，则认证成功
    1. 如果该第三方账号尚未绑定既有的 LIZI 账户（即第一次使用该方式登录），则需要先创建 LIZI 账户

        1. 需要用户提供 "邮箱/手机号"、"昵称" 来创建内部丽子账户，该部分应当通过 mq service 实现。
        1. 如果提供的信息已经被使用，则应当提示用户使用 LIZI账户名/密码 来登录，或者其他已经绑定的方式来登录，此时，不可为其再创建 LIZI 账户。 


##  CAS Web应用客户端

* 提供 LIZI 账户注册表单画面

    * 该注册方式，需要验证手机号或邮箱的真实性，只有通过验证之后，方可进行后续业务操作。
    * 该流程应当能记录一个注册成功后跳转的 URL 路径

* 使用 Spring Security，通过 OAuth 协议 与 cas 对接


## 手机APP等 非 Java Web应用

* 使用 CAS REST 协议完成登录
* 如果使用手机端 QQ 等第三方 app 的账户登录，也需要像 lizi-cas 一样检查第三方帐号是否已经绑定，若未绑定还需要用户提供 "邮箱/手机号"、"昵称" 来创建内部丽子账户。