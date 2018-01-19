


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


### Page
1. 每个 Page 都提供 `a`,`p` 两个数据，前者为全局数据，后者为当前网页数据。
1. 当前页面的的数据 `p` == `a.page['page/path'']`
1. 数据中不能有 function
1. 数据不能有循环引用


### 自定义组件

单例组件: 该组件一个小程序内只有一种展示样式和处理方式。可以多个页面都使用。一般通过 `<include />` 引入。
多例组件: 单个页面内都可能出现多个示例，展示方式和处理方式均有可能相互不同。一般通过 `<import />` 引入。

1. 建议:组件都放在同一个目录下，名称唯一
1. WXML
    * 使用自定义tag名，或class名，确保唯一。
    * 每个模块的 wxml 不定义模板，可以直接 include
    * 通过工具将所有模块的 wxml汇总生成一个 tpl.wxml。 
     格式为: `<template name="path/xxx"><include src="path/xxx.wxml"/></template>` 
    * 通过 `<include src="path/xxx.xml"/>` 直接引用单例组件
    * 通过 `<template for="path/xxx"/>` 使用多例组件

1. WXSS
    * 使用 scss/less 预定义各种 mixin 备用。（因为微信小程序不支持 CSS 组合选择器）
    * 通过工具将所有 scss/less 文件编译并生成一个 lib.wxss 文件
    * app.wxss 中 @import lib.wxss, 默认使用单例组件样式
    * 通过在各个Page的 wxss 文件中重写css，重写多例组件样式
    
1. JS
    * template 中的 button 通过`bindtap="{{dataProp}}"` 的方式来间接引用handler，
    * 使用: 
        * 在 Page 中通过 Object.assign(dest, ...src) 的方式将单例组件的事件处理函数
        * 注意: Page 中的事件处理函数只能定义在顶层。
        

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


