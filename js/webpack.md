



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

* 《[Migrating to Webpack 2](http://javascriptplayground.com/blog/2016/10/moving-to-webpack-2/)》
* [webpack 1.x doc](https://webpack.github.io/docs/)
* [example/multiple-entry-points](https://github.com/webpack/webpack/tree/master/examples/multiple-entry-points)
* 《[Lazy load AngularJS with Webpack](http://michalzalecki.com/lazy-load-angularjs-with-webpack/)》

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
