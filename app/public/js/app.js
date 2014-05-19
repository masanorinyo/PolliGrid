(function() {
  define(['angular', 'controllers', 'directives', 'services', 'filters', 'template', 'angularUiRouter', 'angularRoute', 'angularResource', 'angular-bootstrap', 'angles', 'angular-deckgrid', 'ngInfiniteScroll', "angularCookie", "angularRoute", 'angular-file-upload'], function(angular) {
    return angular.module('myapp', ['ui.router', 'ui.bootstrap', 'myapp.controllers', 'myapp.directives', 'myapp.services', 'myapp.filters', 'myapp.template', 'angles', 'ngRoute', 'akoenig.deckgrid', 'infinite-scroll', 'ipCookie', 'ngRoute', "angularFileUpload"]);
  });

}).call(this);
