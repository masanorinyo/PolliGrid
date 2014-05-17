(function() {
  define(['angular', 'app', 'underscore'], function(angular, app, _) {
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
        onEnter: function($state, $modal, $stateParams, $location, Error, User) {
          if (User.user) {
            return $location.path('/');
          } else {
            return $modal.open({
              templateUrl: 'views/modals/authmodal.html',
              controller: "AuthCtrl",
              windowClass: "authModal "
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              $location.path('/');
              return Error.auth = '';
            });
          }
        }
      }).state('home.loginRedirect', {
        url: 'login/:id',
        onEnter: function($state, $modal, $stateParams, $location, Error, User) {
          if (User.user) {
            return $location.path('/deepResult/' + $stateParams.id);
          } else {
            return $modal.open({
              templateUrl: 'views/modals/authmodal.html',
              controller: "AuthCtrl",
              windowClass: "authModal "
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              $location.path('/');
              return Error.auth = '';
            });
          }
        }
      }).state('home.signup', {
        url: 'signup',
        onEnter: function($state, $modal, $stateParams, $location, Error, User) {
          if (User.user) {
            return $location.path('/');
          } else {
            return $modal.open({
              templateUrl: 'views/modals/authmodal.html',
              controller: "AuthCtrl",
              windowClass: 'authModal'
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              $location.path('/');
              return Error.auth = '';
            });
          }
        }
      }).state('home.signupRedirect', {
        url: 'signup/:id',
        onEnter: function($state, $modal, $stateParams, $location, Error, User) {
          var newUrl;
          if (User.user) {
            newUrl = '/deepResult/' + $stateParams.id;
            return $location.path(newUrl);
          } else {
            Error.auth = "You need to sign up or login to proceed";
            return $modal.open({
              templateUrl: 'views/modals/authmodal.html',
              controller: "AuthCtrl",
              windowClass: 'authModal'
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              $location.path('/');
              return Error.auth = '';
            });
          }
        }
      }).state("verify", {
        url: '/verification/:type/:result',
        onEnter: function($stateParams, $location, Account) {
          var result, type;
          result = $stateParams.result;
          type = $stateParams.type;
          console.log('test');
          if (type === "email") {
            if (result === "success") {
              Account.verifiedMessage("Your account is successfully verified", 'success');
              return $location.path('/');
            } else if (result === "fail") {
              Account.verifiedMessage("Account verification failed", 'fail');
              return $location.path('/');
            } else if (result === "resetFail") {
              Account.verifiedMessage("The reset password token is not valid", 'fail');
              return $location.path('/');
            }
          } else if (type === "pass") {
            if (result === "success") {
              Account.verifiedMessage("Your password is reset", 'success');
              return $location.path('/');
            } else if (result === "fail") {
              return Account.verifiedMessage("Your password reset failed", 'fail');
            }
          }
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
        onEnter: function($state, $modal, $location, $stateParams, $timeout, User, Error) {
          if (!User.user) {
            Error.auth = 'Please sign up to proceed';
            return $timeout(function() {
              return $location.path('signup');
            });
          } else {
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
        onEnter: function($state, $modal, $timeout, $stateParams, $location, User, Error) {
          var found, onlineUser;
          console.log(User.user);
          if (User.user) {
            onlineUser = User.user;
          } else {
            onlineUser = User.visitor;
          }
          console.log(onlineUser);
          found = _.find(onlineUser.questionsAnswered, function(question) {
            return question._id === $stateParams.id;
          });
          console.log(found);
          if ($stateParams.id === "") {
            return $location.path('/');
          } else if (!User.user) {
            Error.auth = 'Please sign up to proceed';
            return $timeout(function() {
              return $state.transitionTo("home.signup", false);
            });
          } else if (!found) {
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
              backdrop: "static",
              windowClass: "questionModal"
            }).result.then(function() {
              return console.log('modal is open');
            }, function() {
              return $location.path('/');
            });
          }
        }
      }).state('home.setting', {
        url: 'setting/:type/:id',
        onEnter: function($stateParams, $location) {
          var check, type;
          type = $stateParams.type;
          check = 0;
          if (type === "favorites") {
            check++;
          }
          if (type === "profile") {
            check++;
          }
          if (type === "answers") {
            check++;
          }
          if (type === "filters") {
            check++;
          }
          if (type === "questions") {
            check++;
          }
          if (check === 0) {
            return $location.path('/');
          }
        },
        views: {
          'content@': {
            templateUrl: '/views/partials/setting.html',
            controller: 'SettingCtrl'
          },
          "result@home.setting": {
            templateUrl: 'views/partials/targetQuestions.html',
            controller: 'TargetAudienceCtrl'
          }
        }
      });
      return $urlRouterProvider.otherwise('/');
    });
  });

}).call(this);
