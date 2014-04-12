(function() {
  define(['angular', 'controllers'], function(angular, controllers) {
    return angular.module('myapp', ['ui.router', 'myapp.controllers']);
  });

}).call(this);
