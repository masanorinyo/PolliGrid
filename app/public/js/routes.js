(function() {
  define(['angular', 'app'], function(angular, app) {
    return app.config(function($stateProvider, $urlRouterProvider) {
      $stateProvider.state('routes', {
        url: "/",
        views: {
          'header': {
            templateUrl: '/partials/header.html',
            controller: 'AuthCtrl'
          },
          'utility': {
            templateUrl: '/partials/utility.html',
            controller: 'UtilityCtrl'
          },
          'content': {
            templateUrl: '/partials/content.html',
            controller: 'ContentCtrl'
          }
        }
      });
      return $urlRouterProvider.otherwise('/');
    });
  });

}).call(this);
