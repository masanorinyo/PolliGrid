(function() {
  define(['angular', 'app'], function(angular, app) {
    return app.config(function($stateProvider, $urlRouterProvider) {
      $stateProvider.state('home', {
        url: "/",
        views: {
          'header': {
            templateUrl: '/partials/header.html'
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
      }).state('home.login', {
        url: 'login',
        onEnter: function($state, $modal, $location) {
          return $modal.open({
            templateUrl: '/partials/authmodal.html',
            controller: "AuthCtrl"
          }).result.then(function() {
            return console.log('modal is open');
          }, function() {
            return $location.path('/');
          });
        }
      }).state('home.signup', {
        url: 'signup',
        onEnter: function($state, $modal, $location) {
          return $modal.open({
            templateUrl: '/partials/authmodal.html',
            controller: "AuthCtrl"
          }).result.then(function() {
            return console.log('modal is open');
          }, function() {
            return $location.path('/');
          });
        }
      });
      return $urlRouterProvider.otherwise('/');
    });
  });

}).call(this);
