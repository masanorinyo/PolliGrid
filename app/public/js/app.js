(function() {
  define(['angular', 'controllers', 'directives', 'services', 'filters', 'angularUiRouter', 'angular-bootstrap', 'angles', 'angular-deckgrid'], function(angular) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers', 'myapp.directives', 'myapp.services', 'myapp.filters', 'angles', 'akoenig.deckgrid']);
  });

}).call(this);
