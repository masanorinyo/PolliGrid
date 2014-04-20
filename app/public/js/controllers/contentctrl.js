(function() {
  define(['underscore'], function(_) {
    return function($scope, question) {
      var targetQ;
      $scope.questions = question;
      $scope.answer = '';
      $scope.isStarFilled = false;
      $scope.submitted = false;
      targetQ = $scope.targetQ = {
        isQuestionAnswered: false
      };
      $scope.submitAnswer = function(choice, question) {
        choice.count++;
        question.totalResponses++;
        return $scope.submitted = true;
      };
      $scope.fillStar = function(question) {
        return question.favorite = !question.favorite;
      };
      return $scope.$apply();
    };
  });

}).call(this);
