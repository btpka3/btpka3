
# provider vs. factory vs. service

1.  provider 是唯一可以通过  `app.config()` 方法，在使用前进行全局配置的。定义的函数是一个构造函数，该类实现了一个 `$get` 方法。

    ```js
    myApp.provider('xxxProvider', function XxxProvider() {
      var xxxConfig = false;

      this.setXxxConfig = function(value) {
        xxxConfig = !!value;
      };

      this.$get = ["xxxDep", function xxxFactory(xxxDep) {

        function XxxService (){ /* ... */ };

        return new XxxService(xxxDep, xxxConfig);
      }];
    });
    ```

    config

    ```js
    myApp.config(["xxxProvider", function(xxxProvider) {
      xxxProvider.setXxxConfig(true);
    }]);
    ```

    初始化流程：

    ```
    1. ng框架:  var xxxProvider : new XxxProvider();
    2. myApp.config("xxxProvider"， function(xxxProvider) {});  // 传入 xxxProvider 对 provider 进行初始化
    3. myApp.controller("xxxProvider", function(xxxProvider){  }) // 传入 xxxProvider.$get()
    ```




1. factory 定义一个工厂方法，直接传入依赖后调用，通常需要明确指明一个 `return` 语句。
该工厂方法也仅仅会被调用一次，并缓存结果，供后续依赖注入使用。因此都是单例（singleton）。


    ```js
    app.factory('myFactory', function() {

      // 工厂方法，返回实例化后的对象
      // 因此需要有一个 return 对象。

      return {
        sayHello : function(name) {
          return "Hi " + name + "!";
        }
      }
    });
    ```

1. service 返回的是一个 `function`。但无论依赖注入多少次，只有第一次时会 new 一次，之后都返回同一个实例。换句话说 service 在 angular 中都是单例 （singleton）。

    ```js
    app.service('myService', function() {

      // 该方法就是一个构造函数，不需要有 return 语句。
      // 会通过 new 操作符实例化对象（单例）

      this.sayHello = function(name) {
         return "Hi " + name + "!";
      };
    });
    ```



# directive

```js
angular.module('xxx', [])
.directive('myCustomer', ['$interval', function($interval) {

  var timeoutId;

  function linkFunc(scope, element, attrs, controllers){
    var myPanelCtrl = controllers[0];
    var myItemCtrl = controllers[1];

    element.on('$destroy', function() {
      $interval.cancel(timeoutId);
    });
    timeoutId = $interval(function() {
      element.text("" + new Date())); // update DOM
    }, 1000);
  };

  return {
    restrict: 'AE',   // A : attribute, E : element, C : class 
    transclude: true,
    require: [
      '^myPanel',    // require controller in parent
       'myItem',     // require controller in own elements
    ],

    scope: {
      aaa:      "@aaa",      // use data data-binding from the parent scope
      bbb:      '=bbb',      // bind a model
      customer: '=',         // same as '=customer'
      close:    '&onClose'   //  reference a fucntion   
    },

    //template: 'Name: {{customer.name}} Address: {{customer.address}}'
    //templateUrl: function(elem, attr) {
    //  return 'customer-'+attr.type+'.html';
    //},
    templateUrl: 'my-customer.html',

    link: linkFunc,

    replace: false,

  };
}]);
```