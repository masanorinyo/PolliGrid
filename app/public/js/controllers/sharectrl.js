(function() {
  define([], function() {
    return function($scope, $modalInstance, $stateParams, $location, $timeout) {
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
