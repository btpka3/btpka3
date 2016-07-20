# 性能优化建议

参考 [1](http://coenraets.org/keypoint/phonegap-performance/)

* Don't generate the UI on the server
* Limit network access
* Don't wait for the data to display the UI
* Use Css Transitions +  hardware acceleration
* Avoid click event's 300ms delay
* Optimize images
* Limit shadows and gradients
* Do you need that framework?
* Minimize browser reflows
* Test

# testing
* [mocha](http://mochajs.org/)
* [jasmine](http://jasmine.github.io/)

    ```
    # Local installation:
    npm install --save-dev jasmine

    # Global installation
    npm install -g jasmine

    jasmine init
    jasmine xxxTest.js
    ```

# 参考
* ECMA-262 Edition 5.1,ECMA-262 Edition 6 (ES2015/ES6)  [ES6 兼容性表](http://kangax.github.io/compat-table/es6/)

* [microsoft-edge - testdrive](https://developer.microsoft.com/en-us/microsoft-edge/testdrive/)
* 《[浅谈移动前端的最佳实践](http://www.cnblogs.com/yexiaochai/p/4219523.html)》
* [前端开发仓库](http://code.ciaoca.com/)
* bootstrap 
    * http://wrapbootstrap.com
* 《[HTML5 本地裁剪图片并上传至服务器](http://segmentfault.com/a/1190000000754560)》
* [Jcrop](http://deepliquid.com/content/Jcrop.html)，[演示](http://code.ciaoca.com/jquery/jcrop/demo/index.html)
* [Modernizr.js](http://modernizr.com/)
* [animate.css](https://github.com/daneden/animate.css)
* [off-canvas](http://ngmodules.org/modules/angular-off-canvas)
* 视差动画
    * [利用CSS固定背景交替实现视差滚动效果](http://www.shejidaren.com/css-fixed-scroll-background.html)
    * [10个优秀视差滚动插件](http://www.w3cplus.com/source/10-best-Parallax-Scrolling-plugin.html)
    * [神奇的鼠标滚轴动画（视差滚动）](http://www.admin5.com/article/20140313/539258.shtml)
* 洗牌/重拍/过滤动画
    * [quicksand](http://razorjack.net/quicksand/)
* link
    * [Hover.css](http://ianlunn.github.io/Hover/)
    * [Creative Link Effects](http://tympanus.net/Development/CreativeLinkEffects/)
* button
    * [Creative Button Styles](http://tympanus.net/Development/CreativeButtons/)
* list 
    * [listamatic](http://css.maxdesign.com.au/listamatic/index.htm)
* icon
    * [Icon Hover Effects](http://tympanus.net/Development/IconHoverEffects/)
* Modal Window 
    * [Nifty Modal Window Effects](http://tympanus.net/Development/ModalWindowEffects/)
* 上传/图片修改
    * [WebUploader](http://fex.baidu.com/webuploader/)
    * [美图开放平台](http://open.web.meitu.com/wiki/)
* [javascript 6](http://es6-features.org/), [ECMAScript 6入门](http://es6.ruanyifeng.com/)
* [以 application/octet-stream 格式上传](http://stackoverflow.com/questions/19959072/sending-binary-data-in-javascript-over-http)

* 日期时间选择器
    * [eternicode/bootstrap-datepicker](http://tarruda.github.io/bootstrap-datetimepicker/)
    * [Eonasdan/bootstrap-datetimepicker](http://eonasdan.github.io/bootstrap-datetimepicker/)
    * [smalot/bootstrap-datetimepicker](https://github.com/smalot/bootstrap-datetimepicker)
    * [mobiscroll](http://demo.mobiscroll.com/datetime/invalid/)
* [function的声明与调用](http://www.johnpapa.net/angular-function-declarations-function-expressions-and-readable-code/)

## js equals

|arg type|conditional result|
|------|------|
|undefined|false|
|number| +0, -0, NaN 为 false，其他为true|
|string| 长度为0则为false，其他为true|
|object|null为false，其他为true|
 

## 参考
* 墨刀在用什么？ [here](https://modao.cc/posts/3344?page=1) 

    在前端，我们用 spine.js、react.js、react-native、electron、webpack、cordova、nightmare.js、pm2、koa.js。而且在墨刀你有机会成为一名全栈开发者，你可以设计数据库，配置 nginx，写 ruby on rails。甚至可以参与设计。
* H5 游戏引擎有哪些？
   * 《[H5游戏开发该如何选择游戏引擎](http://www.diyiyou.com/biz/bagua/54369.html)》
   * 《[想入H5游戏圈 你应该先了解这些基础知识](http://games.qq.com/a/20150522/018816.htm)》
   * 《[排名前10的H5、Js 3D游戏引擎和框架](http://www.html5cn.org/article-8308-1.html)》


# nw.js vs Electron

   [compaire 1 - old](http://tangiblejs.com/posts/nw-js-electron-compared)、
   [compaire 2016](http://tangiblejs.com/posts/nw-js-and-electron-compared-2016-edition)
