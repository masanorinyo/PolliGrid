(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question) {
      var checkFilterQuestionStatus, checkIfEverythingAnswered, checkIfQuestionAlaredyAnswered, makeTargetChecker;
      checkIfEverythingAnswered = function() {
        var i, length, numOfAnswers;
        length = $scope.targetChecker.length;
        i = 0;
        numOfAnswers = 0;
        while (i < length) {
          if ($scope.targetChecker[i].isAnswered) {
            numOfAnswers++;
          }
          i++;
        }
        if (numOfAnswers === length) {
          return $scope.areAllQuestionAnswered = true;
        }
      };
      makeTargetChecker = function(answer) {
        var answeredIds, found, i, length, target, _results;
        $scope.targetChecker = [];
        length = $scope.question.targets.length;
        i = 0;
        answeredIds = _.pluck($scope.user.filterQuestionsAnswered, 'id');
        if (answer !== "") {
          answeredIds.push(answer.id);
        }
        _results = [];
        while (i < length) {
          found = _.find(answeredIds, function(id) {
            return Number(id) === Number($scope.question.targets[i].id);
          });
          if (found) {
            target = {
              id: found,
              isAnswered: true
            };
          } else {
            $scope.question.targets[i].id;
            target = {
              id: $scope.question.targets[i].id,
              isAnswered: false
            };
          }
          $scope.targetChecker.push(target);
          _results.push(i++);
        }
        return _results;
      };
      checkFilterQuestionStatus = function(answer) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          return makeTargetChecker(answer);
        }).then(function() {
          return checkIfEverythingAnswered();
        });
        return defer.resolve();
      };
      checkIfQuestionAlaredyAnswered = function() {
        var found, isThisQuestionAnswered;
        found = _.pluck($scope.user.questionsAnswered, 'id');
        isThisQuestionAnswered = _.find(found, function(id) {
          return id === $scope.question.id;
        });
        if (isThisQuestionAnswered) {
          return $scope.question.alreadyAnswered = true;
        }
      };
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.areAllQuestionAnswered = false;
      $scope.targetChecker = [];
      (function() {
        checkFilterQuestionStatus('');
        return checkIfQuestionAlaredyAnswered();
      })();
      $scope.$on('answerSubmitted', function(message) {
        return checkFilterQuestionStatus('');
      });
      $scope.submitTarget = function(question, targetAnswer, index) {
        var answer, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[index].id;
          answer = {
            id: targetQuestionID,
            answer: targetAnswer
          };
<<<<<<< HEAD
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
=======
          $scope.user.filterQuestionsAnswered.push(answer);
          checkFilterQuestionStatus(answer);
          if ($scope.areAllQuestionAnswered) {
            return $scope.question.alreadyAnswered = true;
>>>>>>> testing
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.areAllQuestionAnswered = false;
        makeTargetChecker('');
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
