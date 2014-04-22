(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question) {
      var addFilterAnswer;
      $scope.num = 0;
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered), 'id');
      addFilterAnswer = function(answer) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          return $scope.user.filterQuestionsAnswered.push(answer);
        }).then(function() {
          return $scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered), 'id');
        });
        return defer.resolve();
      };
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
            console.log('current scope num :' + $scope.num);
            $scope.num = question.numOfFilters;
            addFilterAnswer(answer);
            $scope.showResult = true;
            return $scope.question.alreadyAnswered = true;
          } else {
            console.log('current scope num :' + $scope.num);
            $scope.num++;
            return addFilterAnswer(answer);
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.num = 0;
        $scope.showResult = false;
        $scope.question.alreadyAnswered = false;
        return $scope.$emit('resetAnswer', question);
      };
      $scope.$on("showGraph", function(result) {
        return $scope.showResult = true;
      });
      return $scope.$apply();
    };
  });

}).call(this);
