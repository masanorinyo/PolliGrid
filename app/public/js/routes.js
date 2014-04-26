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
          },
          "result@home": {
            templateUrl: 'views/partials/targetQuestions.html',
            controller: 'TargetAudienceCtrl'
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
        views: {
          'create@': {
            templateUrl: 'views/partials/createQuestion.html'
          },
          'target@': {
            templateUrl: 'views/partials/targetAudience.html'
          },
          'share@': {
            templateUrl: 'views/partials/shareQuestion.html'
          }
        },
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
      }).state('home.share', {
        url: 'share/:id',
        onEnter: function($state, $modal, $stateParams, $location) {
          if ($stateParams.id === "") {
            return $location.path('/');
          } else {
            return $modal.open({
              templateUrl: 'views/modals/shareModal.html',
              controller: "ShareCtrl",
              windowClass: "shareModal"
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              return $location.path('/');
            });
          }
        }
      }).state('home.deepResult', {
        url: 'deepResult/:id',
        onEnter: function($state, $modal, $stateParams, $location) {
          if ($stateParams.id === "") {
            return $location.path('/');
          } else {
            return $modal.open({
              templateUrl: 'views/modals/deepResultModal.html',
              controller: "DeepResultCtrl",
              windowClass: "deepResult"
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              return $location.path('/');
            });
          }
        }
      }).state('home.question', {
        url: 'question/:id',
        views: {
          "questionResult@": {
            templateUrl: 'views/partials/targetQuestions.html',
            controller: 'TargetAudienceCtrl'
          }
        },
        onEnter: function($state, $timeout, $modal, $stateParams, $location) {
          if ($stateParams.id === "") {
            return $location.path('/');
          } else {
            return $modal.open({
              templateUrl: 'views/modals/questionModal.html',
              controller: "ListCtrl",
              windowClass: "questionModal"
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              $location.path('/');
              return $timeout(function() {
                return $state.transitionTo($state.current, $stateParams, {
                  reload: true,
                  inherit: false,
                  notify: true
                });
              }, 200, true);
            });
          }
        }
      });
      return $urlRouterProvider.otherwise('/');
    });
  });

}).call(this);
