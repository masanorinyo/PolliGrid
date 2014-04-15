(function() {
  define([], function() {
    return function($scope) {
      $scope.content = "content";
      $scope.isStarFilled = false;
      $scope.fillStar = function() {
        $scope.isStarFilled = !$scope.isStarFilled;
        return console.log($scope.isStarFilled);
      };
      return $scope.$apply();
    };
  });

}).call(this);
