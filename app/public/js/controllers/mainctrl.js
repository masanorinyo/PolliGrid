(function() {
  define([], function() {
    return function($scope) {
      $scope.yo = "yo";
      return $scope.$apply();
    };
  });

}).call(this);
