
# provider vs. factory vs. service

1.  provider 是唯一可以通过  `app.config()` 方法，在使用前进行全局配置的。

    ```js
    myApp.provider('unicornLauncher', function UnicornLauncherProvider() {
      var useTinfoilShielding = false;

      this.useTinfoilShielding = function(value) {
        useTinfoilShielding = !!value;
      };

      this.$get = ["apiToken", function unicornLauncherFactory(apiToken) {

        // let's assume that the UnicornLauncher constructor was also changed to
        // accept and use the useTinfoilShielding argument
        return new UnicornLauncher(apiToken, useTinfoilShielding);
      }];
    });
    ```

    config

    ```js
    myApp.config(["unicornLauncherProvider", function(unicornLauncherProvider) {
      unicornLauncherProvider.useTinfoilShielding(true);
    }]);
    ```

1. factory 返回一个实例后的对象（Object）。通过该Object（即factory对象），可以访问、调用其上的任意属性、方法。这些方法可以是在调用时实例化新对象（工厂模式的原意）。

1. service 返回的是一个 `function`。但无论依赖注入多少次，只有第一次时会 new 一次，之后都返回同一个实例。换句话说 service 在 angular 中都是单例 （singleton）。




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