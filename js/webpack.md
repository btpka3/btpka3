



```
npm install webpack -g

npm install webpack-dev-server -g
webpack-dev-server \
    --progress \
    --colors \
    --open \
    --content-base ./dist \ 
    --host localhost \
    --port 8080 \
    --inline \
    --output-public-path /\
    --client-log-level info

# 浏览器访问 http://localhost:8080/
# 注意：如果使用 frame 模式（而非 inline 模式）则需浏览器访问 http://localhost:8080/webpack-dev-server/bundle
```

## loaders

* json


## 参考

* [Webpack + Angular的组件化实践](https://segmentfault.com/a/1190000003915443)
* 《[Migrating to Webpack 2](http://javascriptplayground.com/blog/2016/10/moving-to-webpack-2/)》
* [webpack 1.x doc](https://webpack.github.io/docs/)
* [example/multiple-entry-points](https://github.com/webpack/webpack/tree/master/examples/multiple-entry-points)
* 《[Lazy load AngularJS with Webpack](http://michalzalecki.com/lazy-load-angularjs-with-webpack/)》
* 《[如何在WebStrorm 中调试 WebPack 工程](https://blog.jetbrains.com/webstorm/2015/09/debugging-webpack-applications-in-webstorm/)》
## FIXME

* 编译、打包的 js、css文件名是否都有 md5 值？
* 编译、打包的 js、css文件名是否都有 sourcemap ？
* 如何加载外部网上的JS？比如 百度地图的，微信 API 的。
* html,css中引用的图片文件能否在文件名上自动追加 md5 值？
* css中引用的字体文件能否在文件明上自动追加 md5 值？
* 打包时，能否排除特定的js？比如用于 wepy？
    IgnorePlugin 
    
    ```js
    {
        externals: {
            // require("jquery") is external and available on the global var jQuery
            "jquery": "jQuery"
        }
    }
    ```

* 能够使用 AMD 的方式(lazy load)来加载资源，而非打包到一个文件中。
* 如果打包的js文件过大，能否切割为多个小文件？
    LimitChunkCountPlugin、CommonsChunkPlugin、DedupePlugin
    
* 能否生成依赖的可视化报表？


## external vs ProvidePlugin

参考 

[Managing Jquery plugin dependency in webpack](http://stackoverflow.com/questions/28969861/managing-jquery-plugin-dependency-in-webpack)

[Webpack ProvidePlugin vs externals?](http://stackoverflow.com/questions/23305599/webpack-provideplugin-vs-externals)

[webpack-howto](https://github.com/petehunt/webpack-howto#9-async-loading)

[Angular 2 CLI moves from SystemJS to Webpack](http://www.tuicool.com/articles/63yaAzn)

* 普通方式
    jquery 会被打包。

    * xxx.js

        ```js
        var $ = require("jquery");
        $.xxx()
        ```

* external
    需要手动通过 script 标签注入，jquery由外部提供，不会被打包。

    * index.html
 
        ```html
        <!-- index.html 需要手动引入 script 标签 -->
        <script src="https://code.jquery.com/jquery-git2.min.js"></script>
        ```
    * config.js
    
        ```js
        module.exports = { 
          externals: {
              jquery: "jQuery"  // 通过判断全局变量 `jQuery` 是否存在来确定该模块是否已经注入。
          }
        }
        ```
        
    * xxx.js

        ```js
        var $ = require("jquery");
        $.xxx();
        ```
* ProvidePlugin
    自动全局依赖注入

    * config.js
    
        ```js
        module.exports = { 
          plugins: [
            new webpack.ProvidePlugin({
              $: "jquery",
              jQuery: "jquery",
              'window.jQuery': 'jquery',
            }) 
          ]

        }
        ```
    * xxx.js

        ```js
        $.xxx();   // 直接使用即可  
        ```
        
## FIXME

* 要使用 bootstrap，但 bootstrap 依赖 jquery，如果设置为 bootstrap 追加依赖声明，
   我们自己的代码只 require("bootstrap"), 就能自动依赖注入 jquery？
   
   参考 [Require external (unmanaged) file](https://github.com/webpack/webpack/issues/150), 
   使用其他的工具去加载 (比如 scriptjs)
   
* script-loader 在全局环境下执行给定脚本的代码，
   但是并没有使用 script 标签，
   该脚本内容会打包在 bundle.js 中,
   该脚本中的变量、函数并不会暴露在 window 下面。
   该脚本是作为字符输出（未压缩），并exec的。
   
* exports-loader  仅仅追加一句 "module.exports = yourVarName;", 
   并不会暴露该变量到 window/global 上去， 需要配合 expose-loader ，比如：
   
    aaa.js
   
    ```js
    var mypluginData=["0.chunk.js","index.js","testJson.js","user.js"];
    ```
    
    使用以下语句require
    
    ```js
    import 'expose-loader?mypluginData!exports-loader?mypluginData!./src/myplugin.js'
    ```
    
    最后就可以全局直接访问了
    
    ```html
    <button onclick="console.log('mypluginData = ',mypluginData)">see console</button>
    ```

    

## plugin

```
// https://webpack.github.io/docs/plugins.html
webpack plugin      : 访问 compiler 对象
    Compiler            :   
        run(compiler: Compiler)         : 
        watch-run(watching: Watching)   :
        compile         :   
        compilation(c: Compilation, params: Object): 访问 compilation 对象
        normal-module-factory(nmf: NormalModuleFactory) :
        context-module-factory(cmf: ContextModuleFactory)
        compile(params)
        make(c: Compilation)
        after-compile(c: Compilation)
        emit(c: Compilation)            // 在生成资源前最后一次机会增加资源
        after-emit(c: Compilation)
        done(stats: Stats)
        failed(err: Error)
        invalid()
        after-plugins()
        after-resolvers()
    Compilation                         // 扩展自 Compiler
    
        optimize    : 
```