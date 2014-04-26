(function() {
  define([], function() {
    return function($scope, $modalInstance, $location, $timeout, Error) {
      switch ($location.$$path) {
        case '/login':
          $scope.title = "Login";
          break;
        case '/signup':
          $scope.title = "Signup";
      }
      $scope.alertMessage = Error.auth;
      $scope["switch"] = function(type) {
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
