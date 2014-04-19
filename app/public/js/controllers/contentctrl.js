(function() {
  define([], function() {
    return function($scope, question) {
      $scope.isStarFilled = false;
      $scope.questions = question;
      $scope.fillStar = function() {
        return $scope.isStarFilled = !$scope.isStarFilled;
      };
      return $scope.$apply();
    };
  });

}).call(this);
