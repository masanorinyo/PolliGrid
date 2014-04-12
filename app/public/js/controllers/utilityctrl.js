(function() {
  define([], function() {
    return function($scope) {
      $scope.utility = "utility";
      return $scope.$apply();
    };
  });

}).call(this);
