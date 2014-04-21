(function() {
  define(['angular', 'controllers', 'directives', 'services', 'filters', 'angularUiRouter', 'angular-bootstrap', 'angles'], function(angular) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers', 'myapp.directives', 'myapp.services', 'myapp.filters', 'angles']);
  });

}).call(this);
