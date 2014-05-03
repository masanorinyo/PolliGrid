(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, Filters, Question, User) {
      $scope.targetAnswer = "";
      return $scope.$apply();
    };
  });

}).call(this);
