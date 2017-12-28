
# 参考
- [sass](http://sass-lang.com) 是一个css预处理器。但不建议使用sass语法（空格缩进，省略行尾冒号）。
- [Sass Maps vs. Nested Lists](https://www.sitepoint.com/sass-maps-vs-nested-lists/)

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



# map

```scss
$black-87-opacity: rgba(black, 0.87);
$white-87-opacity: rgba(white, 0.87);
$mat-purple: (
  50: #f3e5f5,
  100: #e1bee7,
  200: #ce93d8,
  300: #ba68c8,
  400: #ab47bc,
  500: #9c27b0,
  600: #8e24aa,
  700: #7b1fa2,
  800: #6a1b9a,
  900: #4a148c,
  A100: #ea80fc,
  A200: #e040fb,
  A400: #d500f9,
  A700: #aa00ff,
  contrast: (
    50: $black-87-opacity,
    100: $black-87-opacity,
    200: $black-87-opacity,
    300: white,
    400: white,
    500: $white-87-opacity,
    600: $white-87-opacity,
    700: $white-87-opacity,
    800: $white-87-opacity,
    900: $white-87-opacity,
    A100: $black-87-opacity,
    A200: white,
    A400: white,
    A700: white,
  )
);

.b{
    color: map-get($mat-purple, 400);
    background-color:map-get(map-get($mat-purple, contrast),900);
}
```
