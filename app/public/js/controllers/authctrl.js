(function() {
  define([], function() {
    return function($rootScope, $scope, $stateParams, $modalInstance, $location, $timeout, Error, User, $http, $cookieStore) {
      switch ($location.$$path.split('/')[1]) {
        case 'login':
          $scope.title = "Login";
          break;
        case 'signup':
          $scope.title = "Signup";
      }
      console.log(User.user);
      $scope.alertMessage = Error.auth;
      $scope.newUser = {
        remember_me: true
      };
      $scope.user = User.visitor;
      $scope.signup = function(data) {
        return console.log('test');
      };
      $scope.login = function(data) {
        console.log(data);
        return $http({
          method: 'POST',
          url: '/api/auth/login',
          data: $.param(data),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          }
        }).success(function(data) {
          data.isLoggedIn = true;
          console.log("success");
          console.log(data);
          $cookieStore.put("loggedInUser", data);
          User.user = data;
          if ($scope.user.questionsAnswered.length) {
            console.log($scope.user.questionsAnswered);
          }
          if ($scope.user.filterQuestionsAnswered.length) {
            console.log($scope.user.filterQuestionsAnswered);
          }
          $rootScope.$broadcast('userLoggedIn', User);
          $scope.user = User.user;
          $scope.$dismiss();
          return $timeout(function() {
            $location.path('/');
            return Error.auth = '';
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
