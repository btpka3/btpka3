

```js
angular.module('xxx', [])
.directive('myCustomer', ['$interval', function($interval) {

  var timeoutId;

  function linkFunc(scope, element, attrs){
    element.on('$destroy', function() {
      $interval.cancel(timeoutId);
    });
    timeoutId = $interval(function() {
      element.text("" + new Date())); // update DOM
    }, 1000);
  };

  return {
    restrict: 'AE',   // A : attribute, E : element, C : class 

    scope: {
      customerInfo: '=info',
      customer: '=',   // same as '=customer'   
    },

    //template: 'Name: {{customer.name}} Address: {{customer.address}}'
    //templateUrl: function(elem, attr){
    //  return 'customer-'+attr.type+'.html';
    //},
    templateUrl: 'my-customer.html',
    link: linkFunc
  };
}]);
```