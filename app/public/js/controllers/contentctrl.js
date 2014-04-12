(function() {
  define([], function() {
    return function($scope) {
      $scope.content = "content";
      return $scope.$apply();
    };
  });

}).call(this);
