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
            $scope.showResult = true;
            return console.log($scope.user);
          } else {
            $scope.num++;
            return $scope.user.filterQuestionsAnswered.push(answer);
          }
        }
      };
      $scope.resetAnswer = function(user) {
        $scope.user.questionsAnswered.pop();
        while ($scope.num !== 0) {
          $scope.user.filterQuestionsAnswered.pop();
          $scope.num--;
        }
        $scope.showResult = false;
        return $scope.$emit('resetAnswer', user);
      };
      return $scope.$apply();
    };
  });

}).call(this);
