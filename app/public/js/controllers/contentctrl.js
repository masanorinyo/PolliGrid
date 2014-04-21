(function() {
  define(['underscore'], function(_) {
    return function($scope, Question) {
      $scope.questions = Question;
      return $scope.$apply();
    };
  });

}).call(this);
