(function() {
  define(['underscore'], function(_) {
    return function($scope, question) {
      $scope.num = 0;
      $scope.showResult = false;
      $scope.submitTarget = function(question) {
        if ($scope.num === question.numOfFilters - 1) {
          $scope.num = question.numOfFilters;
          return $scope.showResult = true;
        } else {
          return $scope.num++;
        }
      };
      return $scope.$apply();
    };
  });

}).call(this);
