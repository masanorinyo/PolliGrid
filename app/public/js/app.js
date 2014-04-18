(function() {
  define(['angular', 'controllers', 'directives', 'services', 'filters'], function(angular, controllers, directives, services, filters) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers', 'myapp.directives', 'myapp.services', 'myapp.filters']);
  });

}).call(this);
