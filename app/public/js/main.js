(function() {
  require.config({
    paths: {
      "angular": "../vendors/angular/angular.min",
      "angularMocks": "../vendors/angular-mock/angular-mock",
      "angularRoute": "../vendors/angular-route/angular-route.min",
      "angularResource": "../vendors/angular-resource/angular-resource.min",
      "angularCookies": "../vendors/angular-cookies/angular-cookies.min",
      "angularSanitize": "../vendors/angular-sanitize/angular-sanitize.min",
      "angularLocalStorage": "../vendors/angular-local-storage/angular-local-storage.min",
      "angularUiRouter": "../vendors/angular-ui-router/release/angular-ui-router.min",
      "jquery": "../vendors/jquery/dist/jquery.min",
      "angular-bootstrap": "../vendors/angular-bootstrap/ui-bootstrap-tpls.min",
      "domReady": "../vendors/requirejs-domready/domready",
      "underscore": "../vendors/underscore/underscore",
      "chart": "../vendors/Chart.js-master/Chart",
      "angles": "../vendors/angles-master/angles"
    },
    shim: {
      "angular": {
        'exports': 'angular'
      },
      "angularMocks": {
        deps: ['angular'],
        'exports': 'angular.mock'
      },
      "angularRoute": {
        deps: ['angular']
      },
      "angularResource": {
        deps: ['angular']
      },
      "angularCookies": {
        deps: ['angular']
      },
      "angularSanitize": {
        deps: ['angular']
      },
      "angularLocalStorage": {
        deps: ['angular']
      },
      "angularUiRouter": {
        deps: ['angular']
      },
      "angular-bootstrap": {
        deps: ['angular']
      },
      "jquery": {
        exports: '$'
      },
      "underscore": {
        exports: '_'
      },
      'angles': {
        deps: ['angular', 'chart']
      }
    }
  });

  require(['angular', 'app', 'routes', 'domReady'], function(angular, app, routes, domReady) {
    return domReady(function() {
      return angular.bootstrap(document, ['myapp']);
    });
  });

}).call(this);
