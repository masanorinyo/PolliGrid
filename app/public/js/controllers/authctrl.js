(function() {
  define([], function() {
    return function($scope, $modalInstance, $location, $timeout) {
      switch ($location.$$path) {
        case '/login':
          $scope.title = "login";
          break;
        case '/signup':
          $scope.title = "Signup";
      }
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          return $location.path('/');
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
