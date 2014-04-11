(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.controllers', []).controller('MainCtrl', function($scope, $injector) {
      return require(['controllers/mainctrl'], function(mainctrl) {
        return $injector.invoke(mainctrl, this, {
          "$scope": $scope
        });
      });
    });
  });

}).call(this);
