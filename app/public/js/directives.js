(function() {
  define(['angular', 'controllers'], function(angular, controllers) {
    return angular.module('myapp.directives', ['myapp.controllers']).directive('newFilter', function() {
      return {
        restrict: 'EA',
        templateUrl: 'views/partials/newfilter.html',
        controller: 'NewFilterCtrl'
      };
    });
  });

}).call(this);
