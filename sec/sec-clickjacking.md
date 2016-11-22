## 攻击原理
恶意用户使用某种途径将透明的HTML内容定位到其他HTML元素上方，使用户以为在点击所看到的内容时，被恶意用户所拦截，并进行其他操作。示例：假设www.a.com/a.html的内容如下：

```html
<html>
<body>
    ...
    <button type="button">Get Free Ipad!</button> <!-- 正常网站提供的代码 --->
    ...
    <iframe src="http://www.b.com/b.html" style="position:absolute; ..."><iframe> <!-- 恶意用户的代码 --->
    ...
</body>
</html>
```

假设www.b.com/b.html的内容如下：

```html
<html>
<body>
    ...
    <button type="button">Watch Me!</button> <!-- 正常网站提供的代码 --->
    ...
</body>
</html>
```

## 防御方式

### 使用 X-Frame-Options
可选值：

* DENY - 禁止响应的HTML被作为iframe内容
* SAMEORIGIN - 只允许当前域下其他网页可以将当前响应的HTML作为iframe内容
* ALLOW-FROM uri - 只允许指定URL将当前响应的HTML作为iframe内容

在示例中，www.b.com就应该为/b.html设置以下HTTP响应头来禁止该内容被恶意用户作为iframe内容在其他网站上使用。

```
X-Frame-Options:DENY
```
| 浏览器 | 支持DENY/SAMEORIGIN的版本 | 支持ALLOW-FROM的版本 |
|---|---|---|
|Chrome |4.1.249.1042||
|Firefox (Gecko) |3.6.9 (1.9.2.9) |18.0 |
|Internet Explorer |8.0||
|Opera |10.50||
|Safari |4.0||


不足之处

* 需要为每个页面均进行设定
* 多域名、有子域名时设置繁琐
* 代理服务器可能会删除该HTTP响应头而造成保护失效


### 使用 JavaScript
到目前为止，对老浏览器的处理最好方式：在每个页面中均引入以下代码

```html
  <style id="antiClickjack">body{display:none !important;}</style>
  <script type="text/javascript">
   if (self === top) {
       var antiClickjack = document.getElementById("antiClickjack");
       antiClickjack.parentNode.removeChild(antiClickjack);
   } else {
       top.location = self.location;
   }
  </script>
```