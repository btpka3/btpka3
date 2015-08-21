

## 工具

* [yeoman](http://yeoman.io/)
* gulp
* grunt

## 参考

* 《[AngularJS开发人员最常犯的10个错误](http://blog.jobbole.com/78946/)》
* 《[The Top 10 Mistakes AngularJS Developers Make](https://www.airpair.com/angularjs/posts/top-10-mistakes-angularjs-developers-make)》
* 《[推荐 15 个 Angular.js 应用扩展指令](http://www.oschina.net/translate/15-directives-to-extend-your-angular-js-apps)》


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