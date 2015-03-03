==攻击原理==
恶意用户使用某种途径将透明的HTML内容定位到其他HTML元素上方，使用户以为在点击所看到的内容时，被恶意用户所拦截，并进行其他操作。示例：假设www.a.com/a.html的内容如下：
<source>
  <html>
  <body>
    ... 
    <button type="button">Get Free Ipad!</button> <!-- 正常网站提供的代码 --->
    ...
    <iframe src="http://www.b.com/b.html" style="position:absolute; ..."><iframe> <!-- 恶意用户的代码 --->
    ...
  </body>
  </html>
</source>

假设www.b.com/b.html的内容如下：
<source>
  <html>
  <body>
    ... 
    <button type="button">Watch Me!</button> <!-- 正常网站提供的代码 --->
    ...
  </body>
  </html>
</source>

==防御方式==
<ul>
<li>使用 X-Frame-Options。可选值：
* DENY - 禁止响应的HTML被作为iframe内容
* SAMEORIGIN - 只允许当前域下其他网页可以将当前响应的HTML作为iframe内容
* ALLOW-FROM uri - 只允许指定URL将当前响应的HTML作为iframe内容
在示例中，www.b.com就应该为/b.html设置以下HTTP响应头来禁止该内容被恶意用户作为iframe内容在其他网站上使用。
<source>
  X-Frame-Options:DENY
</source>
<table>
<tr><th>浏览器</th><th>支持DENY/SAMEORIGIN的版本</th><th>支持ALLOW-FROM的版本</th></tr>
<tr><td>Chrome</td><td>4.1.249.1042</td><td></td></tr>
<tr><td>Firefox (Gecko</td><td>3.6.9 (1.9.2.9)</td><td>18.0</td></tr>
<tr><td>Internet Explorer</td><td>8.0</td><td></td></tr>
<tr><td>Opera</td><td>10.50</td><td></td></tr>
<tr><td>Safari</td><td>4.0</td><td></td></tr>
</table>

不足之处
* 需要为每个页面均进行设定
* 多域名、有子域名时设置繁琐
* 代理服务器可能会删除该HTTP响应头而造成保护失效


</li>
<li>
到目前为止，对老浏览器的处理最好方式：在每个页面中均引入以下代码
<source>
  <style id="antiClickjack">body{display:none !important;}</style>
  <script type="text/javascript">
   if (self === top) {
       var antiClickjack = document.getElementById("antiClickjack");
       antiClickjack.parentNode.removeChild(antiClickjack);
   } else {
       top.location = self.location;
   }
  </script>
</source>
</li>
</ul>