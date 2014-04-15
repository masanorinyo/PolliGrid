(function() {
  define(['angular', 'controllers'], function(angular, controllers) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers']);
  });

}).call(this);
