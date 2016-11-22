

[JSHint](http://jshint.com/) 是一个JS编码风格检查工具，比 jslint 相对灵活一些。

## IDEA 配置

```
IDEA -> File -> Settings -> Language & Frameworks -> JavaScript -> Code Quality Tools -> JSHint
    : 选中 Enable
    : 选中 Use config files
```


## 工程配置

假设有以下工程目录结构

```
xxxProj/
xxxProj/bower_components
xxxProj/mock/                                       # 使用Express模拟后台API（Node环境）
xxxProj/mock/.jshintrc
xxxProj/node_modules
xxxProj/src/                                        # 主要源码（针对浏览器）
xxxProj/src/.jshintrc
xxxProj/src/lib                                     # 使用的第三方JS类库
xxxProj/target/                                     # 编译、压缩用的目录
xxxProj/.jshintignore                               # jsHint忽略路径的配置文件
xxxProj/.jshintrc                                   # jsHint基础配置
```

### xxxProj/.jshintrc

```json
{
  "bitwise": true,
  "immed": true,
  "newcap": true,
  "noarg": true,
  "noempty": true,
  "nonew": true,
  "trailing": true,
  "maxlen": 200,
  "boss": true,
  "eqnull": true,
  "expr": true,
  "globalstrict": true,
  "laxbreak": true,
  "loopfunc": true,
  "sub": true,
  "undef": true,
  "indent": 2,
  "browser": true
}
```

### xxxProj/.jshintignore

```
bower_components
node_modules
target
src/lib
```


### xxxProj/mock/.jshintrc

```json
{
  "extends": "../.jshintrc",
  "node": true
}
```

### xxxProj/src/.jshintrc

```json
{
  "extends": "../.jshintrc",
  "predef": [
    "wx",
    "WebUploader",
    "app"
  ]
}
```


