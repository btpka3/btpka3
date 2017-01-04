


* 微信应用号
    * [管理页面](https://mp.weixin.qq.com)
    * [开发文档](https://mp.weixin.qq.com/debug/wxadoc/introduction/index.html)
    * [开发者工具](https://mp.weixin.qq.com/debug/wxadoc/dev/devtools/download.html)



* wepy
    * 《[微信小程序框架wepy](http://dev.qq.com/topic/5844d6947badb2796037f9e3)》
    * [小程序框架wepy文档](https://wepyjs.github.io/wepy/)
    * [wepy@Github](https://github.com/wepyjs/wepy)
    * [Babel](https://babeljs.io/)
    
* [mustache 语法](https://mustache.github.io/mustache.5.html)

## 总结

###  认证

```
1. session_key = wx.login()
1. rawData = wx.getUserInfo()
1. POST  MyOAuth2AuthServer /api/login?session_key, rawData,
    1. 以类似 password 的模进行（验证）签名，并返回 access_token (JWT)
1. wx.setStorage(key, {session_key, UserInfo, access_token}
1. POST  MyResourceServer /api/xxx?access_token&k1&k2

```



### 使用图标字体

 WXSS 不能包含font静态资源文件, 使用 data url 取代, FIXME: 微信Web开发者工具测试OK，但实际运行出错。
 
xxx.wxss

```css

@font-face {
  font-family: 'Xxx';
  src: url(data:application/font-woff2;charset=utf-8;base64,d09G......2I4d) format('woff2');
  /*src: url('https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.woff2?v=4.6.3') format('woff2');*/
  font-weight: normal;
  font-style: normal;
}

span{
  background-color: grey;
  border:1rpx solid red;
  width: 120rpx;
  height: 120rpx;
  display: inline-block;
  font: normal normal normal 200rpx Xxx;
  font-size: inherit;
  text-rendering: auto;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.u::before{
  content: "\f178";
}
```

xxx.wxml

```html
<span class="eye"></span>
<span class="u"></span>
<span class="h"></span>
```


