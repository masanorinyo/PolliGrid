(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question) {
      var addFilterAnswer, checkIfEverythingAnswered, makeTargetChecker;
      checkIfEverythingAnswered = function() {
        var i, length, _results;
        length = $scope.targetChecker.length;
        i = 0;
        _results = [];
        while (i < length) {
          if ($scope.targetChecker[i].isAnswered) {
            $scope.areAllQuestionAnswered = true;
          } else {
            $scope.areAllQuestionAnswered = false;
          }
          _results.push(i++);
        }
        return _results;
      };
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
      makeTargetChecker = function() {
        var i, length, target, _results;
        length = $scope.question.targets.length;
        i = 0;
        _results = [];
        while (i < length) {
          target = {
            id: $scope.question.targets[i].id,
            isAnswered: false
          };
          $scope.targetChecker.push(target);
          _results.push(i++);
        }
        return _results;
      };
      $scope.num = 0;
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.areAllQuestionAnswered = false;
      $scope.targetChecker = [];
      $scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered), 'id');
      (function() {
        return makeTargetChecker();
      })();
      $scope.submitTarget = function(question, targetAnswer, index) {
        var answer, defer, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[index].id;
          answer = {
            id: targetQuestionID,
            answer: targetAnswer
          };
          defer = $q.defer();
          defer.promise.then(function() {
            answer = _.find($scope.targetChecker, function(target) {
              return target.id === targetQuestionID;
            });
            return answer.isAnswered = true;
          }).then(function() {
            return checkIfEverythingAnswered();
          });
          defer.resolve();
          if ($scope.areAllQuestionAnswered) {
            addFilterAnswer(answer);
            $scope.showResult = true;
            return $scope.question.alreadyAnswered = true;
          } else {
            return addFilterAnswer(answer);
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.areAllQuestionAnswered = false;
        makeTargetChecker();
        $scope.showResult = false;
        $scope.question.alreadyAnswered = false;
        return $scope.$emit('resetAnswer', question);
      };
      return $scope.$apply();
    };
  });

}).call(this);
