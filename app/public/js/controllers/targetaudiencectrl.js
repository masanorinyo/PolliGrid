(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question, User) {
      var checkFilterQuestionStatus, checkIfEverythingAnswered, makeTargetChecker, skipThroughFilterQuestions;
      checkFilterQuestionStatus = function(answer) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          return makeTargetChecker(answer);
        }).then(function() {
          return skipThroughFilterQuestions();
        }).then(function() {
          return checkIfEverythingAnswered();
        });
        return defer.resolve();
      };
      makeTargetChecker = function(answer) {
        var answeredIds, foundId, i, length, questionId, target;
        $scope.targetChecker = [];
        if ($scope.card !== void 0) {
          if ($scope.question) {
            $scope.card = $scope.question;
          }
          length = $scope.card.targets.length;
          i = 0;
          answeredIds = _.pluck($scope.user.filterQuestionsAnswered, 'id');
        }
        if (length) {
          while (i < length) {
            questionId = Number($scope.card.targets[i].id);
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
        }
      };
      skipThroughFilterQuestions = function() {
        var i, length, matchedOption;
        $scope.filterNumber = 0;
        length = $scope.targetChecker.length;
        i = 0;
        while (i < length) {
          if ($scope.targetChecker[i].isAnswered) {
            matchedOption = null;
            _.each($scope.user.filterQuestionsAnswered, function(answer, index) {
              matchedOption = _.find($scope.card.targets[i].lists, function(list) {
                return list.option === answer.answer;
              });
              if (matchedOption) {
                if (!_.contains(matchedOption.answeredBy, $scope.user.id)) {
                  return matchedOption.answeredBy.push($scope.user.id);
                }
              }
            });
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
        console.count("Checker was called for");
        console.log("filterNumber");
        console.log($scope.filterNumber);
        if (numOfAnswers === length) {
          $scope.areAllQuestionAnswered = true;
          return $scope.filterNumber = -1;
        }
      };
      $scope.showResult = false;
      $scope.areAllQuestionAnswered = false;
      $scope.filterNumber = 0;
      $scope.targetChecker = [];
      console.count('test');
      console.log(this);
      (function() {
        return checkFilterQuestionStatus('');
      })();
      $scope.submitTarget = function(question, targetAnswer, index) {
        var answer, answeredOption, defer, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[index].id;
          answer = {
            id: targetQuestionID,
            answer: targetAnswer
          };
          answeredOption = _.findWhere(question.targets[index].lists, {
            option: targetAnswer
          });
          answeredOption.answeredBy.push($scope.user.id);
          $scope.user.filterQuestionsAnswered.push(answer);
          defer = $q.defer();
          defer.promise.then(function() {
            return checkFilterQuestionStatus(answer);
          }).then(function() {
            skipThroughFilterQuestions();
            if ($scope.areAllQuestionAnswered) {
              return $scope.card.alreadyAnswered = true;
            }
          });
          return defer.resolve();
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.areAllQuestionAnswered = false;
        makeTargetChecker('');
        $scope.showResult = false;
        $scope.card.alreadyAnswered = false;
        return $scope.$emit('resetAnswer', question);
      };
      $scope.$on("showGraph", function(result) {
        return $scope.showResult = true;
      });
      $scope.$on('answerSubmitted', function(message) {
        checkFilterQuestionStatus('');
        return $timeout(function() {
          return skipThroughFilterQuestions();
        }, 300, true);
      });
      return $scope.$apply();
    };
  });

}).call(this);
