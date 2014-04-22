(function() {
  define(['underscore'], function(_) {
    return function($scope, Question) {
      $scope.num = 0;
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.submitTarget = function(question, targetAnswer) {
        var answer, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[$scope.num].id;
          answer = {
            id: targetQuestionID,
            answer: targetAnswer
          };
          if ($scope.num === question.numOfFilters - 1) {
            $scope.num = question.numOfFilters;
            $scope.user.filterQuestionsAnswered.push(answer);
            return $scope.showResult = true;
          } else {
            $scope.num++;
            return $scope.user.filterQuestionsAnswered.push(answer);
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.num = 0;
        $scope.showResult = false;
        return $scope.$emit('resetAnswer', question);
      };
      return $scope.$apply();
    };
  });

}).call(this);
