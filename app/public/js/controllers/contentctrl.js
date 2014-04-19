(function() {
  define([], function() {
    return function($scope, question) {
      var questions;
      $scope.isStarFilled = false;
      questions = $scope.questions = question;
      $scope.fillStar = function() {
        $scope.isStarFilled = !$scope.isStarFilled;
        return console.log(questions);
      };
      return $scope.$apply();
    };
  });

}).call(this);
