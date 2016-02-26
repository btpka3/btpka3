

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