(function() {
  define(['angular', 'controllers', 'directives'], function(angular, controllers, directives) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers', 'myapp.directives']);
  });

}).call(this);
