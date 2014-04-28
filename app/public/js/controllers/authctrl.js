(function() {
  define([], function() {
    return function($scope, $stateParams, $modalInstance, $location, $timeout, Error, User) {
      switch ($location.$$path.split('/')[1]) {
        case 'login':
          $scope.title = "Login";
          break;
        case 'signup':
          $scope.title = "Signup";
      }
      $scope.alertMessage = Error.auth;
      $scope.signin = function() {
        var newUrl;
        User.isLoggedIn = true;
        $scope.$dismiss();
        if ($location.$$path.split('/')[2]) {
          newUrl = "deepResult/" + $stateParams.id;
          return $timeout(function() {
            return $location.path(newUrl);
          }, 100, true);
        }
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
