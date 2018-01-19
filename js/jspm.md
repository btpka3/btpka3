 
 [jspm](http://jspm.io/)
 
 
 《[使用 jspm 把握 JavaScript 模块的未来](http://www.ibm.com/developerworks/cn/web/wa-use-jspm-javascript-modules/index.html)》
 
 
 ## 安装
 
```bash

npm install --save-dev jspm
# 修改 package.json 在 "script" 中追加 `"jspm":"jspm"`
npm run jspm -- init -p
npm run jspm -- install jquery

npm install -g jspm-server


# 在工程根目录执行
jspm-server
```


## bundle

* bundle
    ```bash
    jspm bundle app --inject
    
    <link rel="stylesheet" href="build.css">  <!-- 如果 separateCSS && buildCSS -->
    <script src="bower_components/system.js/dist/system.js"></script>
    <script src="config.js"></script>
    <script src="build.js"></script>
    
    <script>
        System.import('angular1-app');
    </script>
    ```


* injectable bundle

    ```bash
    jspm bundle app --inject
    
    <script src="bower_components/system.js/dist/system.js"></script>
    <script src="config.js"></script>
    <script src="build.js"></script>
    ```
## System.js

```txt
1. config.js 中手动指定多个 bundle, 并打包。
2. gulp脚本：以下资源打包
    1. bundle.js, bundle.css
    2. app.js, app.css  (不含bundle中的资源）
    3. html,css中所引用到的外部资源（图标，图片，字体等）
3. 测试，确保发布包中没有缺少内容。
```