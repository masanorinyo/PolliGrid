(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question) {
      var checkFilterQuestionStatus, checkIfEverythingAnswered, checkIfQuestionAlaredyAnswered, makeTargetChecker, skipThroughFilterQuestions;
      skipThroughFilterQuestions = function() {
        var i, length;
        $scope.filterNumber = 0;
        length = $scope.targetChecker.length;
        i = 0;
        console.log('length' + length);
        console.log('from above');
        console.log($scope.targetChecker);
        while (i < length) {
          console.log('index' + i);
          if ($scope.targetChecker[i].isAnswered) {
            console.log('test');
            $scope.filterNumber++;
          } else {
            break;
          }
          i++;
        }
        return $scope.filterNumber;
      };
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
        var answeredIds, foundId, i, length, questionId, target;
        $scope.targetChecker = [];
        length = $scope.question.targets.length;
        i = 0;
        answeredIds = _.pluck($scope.user.filterQuestionsAnswered, 'id');
        while (i < length) {
          questionId = Number($scope.question.targets[i].id);
          foundId = _.find(answeredIds, function(id) {
            return Number(id) === questionId;
          });
          if (foundId) {
            target = {
              id: foundId,
              isAnswered: true
            };
          } else {
            target = {
              id: questionId,
              isAnswered: false
            };
          }
          $scope.targetChecker.push(target);
          i++;
        }
        return $scope.targetChecker;
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
      $scope.filterNumber = 0;
      $scope.targetChecker = [];
      (function() {
        checkFilterQuestionStatus('');
        checkIfQuestionAlaredyAnswered();
        return skipThroughFilterQuestions();
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
          $scope.user.filterQuestionsAnswered.push(answer);
          defer = $q.defer();
          defer.promise.then(function() {
            return checkFilterQuestionStatus(answer);
          }).then(function() {
            $scope.filterNumber++;
            if ($scope.filterNumber <= question.numOfFilters) {
              if ($scope.targetChecker[$scope.filterNumber].isAnswered) {
                $scope.filterNumber++;
              }
            }
            if ($scope.areAllQuestionAnswered) {
              return $scope.question.alreadyAnswered = true;
            }
          });
          return defer.resolve();
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
      $scope.$on('answerSubmitted', function(message) {
        checkFilterQuestionStatus('');
        return $timeout(function() {
          return skipThroughFilterQuestions();
        }, 250, true);
      });
      return $scope.$apply();
    };
  });

}).call(this);
