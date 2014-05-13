(function() {
  define([], function() {
    return function($rootScope, $scope, $stateParams, $modalInstance, $location, $timeout, Error, User, $http, ipCookie, $state) {
      switch ($location.$$path.split('/')[1]) {
        case 'login':
          $scope.title = "Login";
          break;
        case 'signup':
          $scope.title = "Signup";
      }
      $scope.alertMessage = Error.auth;
      $scope.newUser = {
        remember_me: true
      };
      $scope.user = User.visitor;
      $scope.signup = function(data) {
        return console.log('test');
      };
      $scope.login = function(data) {
        return $http({
          method: 'POST',
          url: '/api/auth/login',
          data: $.param(data),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          }
        }).success(function(data) {
          var userId;
          console.log('succesfully logged in');
          console.log(data);
          data.isLoggedIn = true;
          if ($scope.newUser.remember_me) {
            ipCookie("loggedInUser", data, {
              expires: 365
            });
          } else {
            ipCookie("loggedInUser", data);
          }
          if (User.visitor.questionsAnswered.length || User.visitor.filterQuestionsAnswered.length) {
            console.log("User.visitor.questionsAnswered.length");
            console.log(User.visitor.questionsAnswered.length);
            userId = data._id;
            $http({
              url: "/api/visitorToGuest",
              method: "PUT",
              data: {
                userId: userId,
                questions: $scope.user.questionsAnswered,
                filters: $scope.user.filterQuestionsAnswered
              }
            }).success(function(data) {
              return $http({
                url: "/api/getUser",
                method: "GET",
                params: {
                  userId: userId
                }
              }).success(function(loggedInUser) {
                loggedInUser.isLoggedIn = true;
                User.user = loggedInUser;
                return $rootScope.$broadcast('userLoggedIn', User);
              });
            });
          } else {
            User.user = data;
            console.log($scope.user.questionsAnswered);
            $rootScope.$broadcast('userLoggedIn', User);
          }
          $scope.$dismiss();
          $location.path('/');
          Error.auth = '';
          return $timeout(function() {
            return $state.transitionTo($state.current, $stateParams, {
              reload: true,
              inherit: false,
              notify: true
            });
          }, 100, true);
        }).error(function(data) {
          console.log("err");
          return console.log(data);
        });
      };
      $scope["switch"] = function(type) {
        if ($stateParams.id) {
          type = type + '/' + $stateParams.id;
        }
        $scope.$dismiss();
        return $timeout(function() {
          $location.path(type);
          return Error.auth = '';
        }, 100, true);
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          $location.path('/');
          return Error.auth = '';
        }, 100, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
