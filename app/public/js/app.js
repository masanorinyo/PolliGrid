(function() {
  define(['angular', 'controllers'], function(angular, controllers) {
    return angular.module('myapp', ['ngRoute', 'myapp.controllers']);
  });

}).call(this);
