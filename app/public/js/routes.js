(function() {
  define(['angular', 'app'], function(angular, app) {
    return app.config(function($stateProvider, $urlRouterProvider) {
      $stateProvider.state('home', {
        url: "/",
        views: {
          'header': {
            templateUrl: 'views/partials/header.html'
          },
          'content': {
            templateUrl: 'views/partials/content.html',
            controller: 'ContentCtrl'
          }
        }
      }).state('home.login', {
        url: 'login',
        onEnter: function($state, $modal, $location) {
          return $modal.open({
            templateUrl: 'views/modals/authmodal.html',
            controller: "AuthCtrl",
            windowClass: "authModal "
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
            templateUrl: 'views/modals/authmodal.html',
            controller: "AuthCtrl",
            windowClass: 'authModal'
          }).result.then(function() {
            return console.log('modal is open');
          }, function() {
            return $location.path('/');
          });
        }
      }).state('home.create', {
        url: 'create',
        onEnter: function($state, $modal, $location) {
          return $modal.open({
            templateUrl: 'views/modals/createModal.html',
            controller: "CreateCtrl",
            windowClass: "createModal"
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
