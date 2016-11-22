

## 工具

* [yeoman](http://yeoman.io/)
* gulp
* grunt

## 参考
* 《[Angular Style Guide](https://github.com/johnpapa/angular-styleguide)》
* 《[AngularJS开发人员最常犯的10个错误](http://blog.jobbole.com/78946/)》
* 《[The Top 10 Mistakes AngularJS Developers Make](https://www.airpair.com/angularjs/posts/top-10-mistakes-angularjs-developers-make)》
* 《[推荐 15 个 Angular.js 应用扩展指令](http://www.oschina.net/translate/15-directives-to-extend-your-angular-js-apps)》
* 《[Angular 1 和 Angular 2 集成：无缝升级的方法](http://www.oschina.net/translate/angular-1-and-angular-2-coexistence?from=20150913)》

### 使用 WebStorm/ IDEA 自动补全功能

1. 下载  [webstorm-angular-live-templates.xml](https://github.com/johnpapa/angular-styleguide/blob/master/a1/assets/webstorm-angular-live-templates/webstorm-angular-live-templates.xml?raw=true)
2. 将下载的xml文件移动到 `~/.IntelliJIdea15/config/templates/` 目录下
3. 重启 IDEA Intellj
4. 之后就可以在编辑 js 文件时， 通过 `ngapp<tab>` 来快速使用模板了。


### $http 提交 form data

```js
controller: ['$http', "$httpParamSerializerJQLike", function ($http, $stateParams, $httpParamSerializerJQLike) {
    // 微信:统一下单, 并准备JS API 支付所需的参数
    $http.post(appConfig.apiPath + '/testZll/testBuy', {
        count: $scope.count,
        price: $scope.price
    }, {
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        },
        transformRequest: $httpParamSerializerJQLike
    }).then(function (resp) {
        //
    });
}]
```

# 参考

* 《[Why you shouldn’t use Angular Material today](https://medium.com/@vayvala/why-you-shouldn-t-use-angular-material-4ffb937ef232#.87o02z8tm)》 需要翻墙。 主要原因为：
    1. 最小化的css，js文件尺寸仍然过大——总共560KB.
    1. 缺少过多的组件： Collapsible content、Pagination、Breadcrumbs、Table、Badge、Vertical or two-handle slider、Responsive footer and navbar、Parallax、Scroll spy
    1. 组件不灵活，难定制
    1. bug多
  该作者推荐使用 [Materialize Css](http://materializecss.com/) 或者 [Polymer](https://www.polymer-project.org/)

## service vs. factory vs.provider

see [here](http://stackoverflow.com/a/34202483/533317)
![service vs. factory vs.provider](http://i.stack.imgur.com/CkdHl.png)
