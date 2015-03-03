## 攻击原理
Web程序进行重要更新操作的URL保护不当，只要用户已经认证，就可以简单地发送请求进行该操作。攻击流程示例：
<ol>
<li>某个允许“一个月内免登录”的A博客系统赠送积分，在用户已经登录的前提下，使用以下URL的GET请求进行积分赠送：
<source>
http://blog.a.com/curUser/score?transto=zhang3&amp;amount=100
</source>
</li>
<li>
恶意用户B发现了这个漏洞，并对某个知名的博文发表以下评论（注意：该博文可能是在A博客系统上，也可能位于其他任何Web系统上）：
<source>
  <img style="height:0px; width:0px;" src="http://blog.a.com/curUser/score?transto=b&amp;amount=100" />
  楼主的帖子实在是写得太好了。文笔流畅,修辞得体,深得魏晋诸朝遗风,....
</source>
</li>
<li>
结果：如果受害者C访问了该帖子，并且C是A博客系统的使用者，且已经登录，则会触发该积分赠送操作。当然，如果不跨站攻击的成功率更高一些。
</li>

</ol>

## 无效的预防措施
### 使用Secret Cookie
Secret Cookie是指只能在HTTPS协议下的保护下才能使用的Cookie。不能使用的原因是：在发送HTTP请求时都会携带上请求域下所有的Cookie（比如jsessionid）。
下面的HTTP响应片段是设置了一个既是Secure又是HTTPOnly的Cookie。
<source>
  Set-Cookie: SSID=Ap4P….GTEq; Domain=.foo.com; Path=/; Expires=Wed, 13-Jan-2021 22:23:01 GMT; Secure;  HttpOnly
</source>

### 只允许POST请求
因为攻击者可以填写隐藏的表单，并诱导受害者点击以出发submit请求。
===多步骤事务===
将一个事务分成多个步骤（HTTP请求），并不能完全胜任预防工作。只要攻击者能够预测、或模拟完整事务的每一个步骤，就仍能够进行攻击。
===重写URL===
是指不使用Cookie，而将sessionId作为URL参数。而攻击者是无法猜测sessionId的。这可能会被认为是一个有效方案，因为攻击者无法猜测到受害者的sessionID，但是会暴露用户凭证。

==预防措施==
===使用Synchronizer Token模式（常用方式）===
该模式主要原理是：针对敏感操作（比如更新、转账等业务操作），显示最初的编辑画面前，要先在服务器端生成一个随机的challenge Token，并使之与当前用户的session关联。challenge token 被插入到表单的隐藏项，或URL中。在用户提交请求时，服务器端对该token进行存在性检查和正确性检查。通常检查逻辑是：

# 检查请求中的token是否存在
# 如果存在，该值是否与session中的值一致
# 如果前两步的结果均是否，则拒绝该请求，并重设token。
加强该模式的方法可以有：
# token的名称也能够随机
# 一个session一个token变为一个request一个token
<source>
  <form action="/transfer.do" method="post">  <!-- 表单隐藏项 -->
    <input type="hidden" name="CSRFToken" value="OWY4NmQwOOA">
  </form>
  <a href="/xxxx.do?CSRFToken=OWY4NmQwOOA"> XXX </a>  <!-- 链接URL参数 -->
</source>
注意：该模式会影响使用性，比如，无法使用浏览器的后退按钮，因为前一个页面中包含的token可能已经失效了。
应当鼓励像保护用户认证过的SessionId那样保护CSRF token，比如使用SSLv3/TLS。使用一个Session一个token的模式，就无法让用户同时进行多个更新操作，因为第二个更新操作的画面会清除第一个画面产生的token。

该模式的一个变种就是 “Double Submit Cookies”， 是指，token同时保存cookie中和form的隐藏项中，提交时再对比两者是否一致。

===Challenge-Response===
<ul>
<li>使用CAPTCHA。CAPTCHA通常是指刻意模糊、扭曲的文字图片，用以区分机器人还是用户。</li>
<li>重新认证。是指通过RemeberMe可以进行保护级别较低的业务（大多是非敏感数据的查看），但是涉及到重要操作时，必须让用户重新输入密码。（PS：这个在Spring Security框架中就有所体现）</li>
<li>One-time Token。 举例：在淘宝购物时，会向绑定的手机发送一次性的验证码。</li>
</ul>


==其他==
* 针对Flash：合理配置crossdomain.xml
==检查Referer==
==检查Origin==

==参考==
* [https://www.owasp.org/index.php/Category:OWASP_CSRFGuard_Project OWASP CSRFGuard]
* [https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF) OWASP上的资源]
* [https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF) wikipedia上的说明]
* [http://struts.apache.org/release/1.2.x/api/org/apache/struts/util/TokenProcessor.html Struts中的相关处理类]