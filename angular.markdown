

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
      customerInfo: '=info', // bind a model
      customer: '=',         // same as '=customer'
      'close': '&onClose'    //  reference a fucntion   
    },

    //template: 'Name: {{customer.name}} Address: {{customer.address}}'
    //templateUrl: function(elem, attr) {
    //  return 'customer-'+attr.type+'.html';
    //},
    templateUrl: 'my-customer.html',
    link: linkFunc
  };
}]);
```