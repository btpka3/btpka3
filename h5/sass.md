

[sass](http://sass-lang.com) 是一个css预处理器。但不建议使用sass语法（空格缩进，省略行尾冒号）。

# 如何引用资源文件？即URL
工程使用的是 简单封装了 [node-sass](https://github.com/sass/node-sass), [gulp-sass](https://github.com/dlmanning/gulp-sass) 打包的。
最终的目录结构与实际源代码的结构是不一致的。比如

```
my-app
 ├── src
 │   ├── index.html
 │   ├── assets
 │   │   └── bg.png
 │   └── scss
 │       ├── index.scss
 │       └── common
 │           └── _ks-xxx.scss
 └── dist
     ├── index.html
     ├── assets
     │   └── bg.png
     └── css
         └── app.css

则写在 _ks-xxx.scss 中代码需要按照 `dist/css/app.css` 位置去相对引用 `dist/assets` 下的资源。
```

