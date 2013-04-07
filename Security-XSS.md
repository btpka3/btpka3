跨站脚本攻击(XSS - Cross Site Scripting)
原理
Web程序将数据直接作为HTML显示（未进行HTML特殊字符转义、script脚本过滤），在浏览器端显示的这些内容的时候，激活其中包含的JavaScript恶意脚本，这些脚本可以用来获取用户敏感信息，追踪用户浏览历史、将用户诱导至其他网站等。

关键点
找到可以注入Script脚本的地方。

大致分类：
1. Stored XSS Attacks：风险代码被先持久存储于服务器上，在读取出来显示到浏览器。比如在博客上发表文章、发表评论。
2. Reflected XSS Attacks：
3. DOM Based XSS：


注入点
1. 客户端：来自用户输入，却未作安全检查。

<code>
    <img src="https://www.owasp.org/skins/monobook/ologo.png" onload="alert('XSS');" >
</code>
2.
2. 服务器端：来自配置文件，却未作安全检查（比如消息模板，头部文件）

DOM Based XSS
  你的程序本身存在一些依赖于来自于客户端的数据并展示，但是对来源数据为做安全检查。



防范方式




https://www.owasp.org/index.php/Cross-site_Scripting_(XSS)
https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet

Cross-Site Request Forgery (CSRF)