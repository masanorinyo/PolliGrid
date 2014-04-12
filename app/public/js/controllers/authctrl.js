(function() {
  define([], function() {
    return function($scope) {
      $scope.auth = "auth";
      return $scope.$apply();
    };
  });

}).call(this);
