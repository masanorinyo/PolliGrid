(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.directives', []).directives('newFilter', function() {
      return {
        restrict: 'A',
        templateUrl: 'views/partials/newFilter.html',
        controller: NewFilterCtrl,
        link: function(scope, elem, attr) {
          return console.log('test');
        }
      };
    });
  });

}).call(this);
