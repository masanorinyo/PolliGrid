(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question, User, UpdateQuestion, UpdateUserInfo) {
      var checkFilterQuestionStatus, checkIfEverythingAnswered, makeTargetChecker, skipThroughFilterQuestions;
      $scope.$on("logOff", function(result) {
        return $timeout(function() {
          $scope.areAllQuestionAnswered = false;
          return $scope.showResult = false;
        });
      });
      $scope.$on("showGraph", function(result) {
        return $scope.showResult = true;
      });
      $scope.$on('answerSubmitted', function(message) {
        checkFilterQuestionStatus('');
        return $timeout(function() {
          return skipThroughFilterQuestions();
        }, 300, true);
      });
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
          console.log($scope.user);
          answeredIds = _.pluck($scope.user.filterQuestionsAnswered, '_id');
        }
        if (length) {
          while (i < length) {
            questionId = $scope.card.targets[i]._id;
            foundId = _.find(answeredIds, function(id) {
              return id === questionId;
            });
            if (foundId) {
              target = {
                _id: foundId,
                isAnswered: true
              };
            } else {
              target = {
                _id: questionId,
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
        var i, length, matchedOption, userAlreadyAnswered;
        $scope.filterNumber = 0;
        length = $scope.targetChecker.length;
        i = 0;
        while (i < length) {
          if ($scope.targetChecker[i].isAnswered) {
            matchedOption = null;
            userAlreadyAnswered = false;
            _.each($scope.card.targets[i].lists, function(list, index) {
              if (_.contains(list.answeredBy, $scope.user._id) && _.contains($scope.card.respondents, $scope.user._id)) {
                return userAlreadyAnswered = true;
              } else {
                return _.each($scope.user.visitorId, function(vid) {
                  if (_.contains(list.answeredBy, vid) && _.contains($scope.card.respondents, vid)) {
                    console.log('contains user id');
                    console.log(list.answeredBy);
                    return userAlreadyAnswered = true;
                  }
                });
              }
            });
            if (!userAlreadyAnswered) {
              _.each($scope.user.filterQuestionsAnswered, function(answer, index) {
                return _.each($scope.card.targets[i].lists, function(list, index) {
                  var filter, filterOption, userId;
                  if (unescape(list.option) === unescape(answer.answer)) {
                    filter = $scope.card.targets[i];
                    filterOption = $scope.card.targets[i].lists[index];
                    list.answeredBy.push($scope.user._id);
                    if (User.user) {
                      userId = User.user._id;
                    } else {
                      userId = $scope.user._id;
                    }
                    return UpdateQuestion.updateFilters({
                      questionId: $scope.card._id,
                      userId: userId,
                      title: "0",
                      filterId: filter._id,
                      index: index
                    });
                  }
                });
              });
            }
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
          $scope.areAllQuestionAnswered = true;
          return $scope.filterNumber = -1;
        } else {
          return $scope.areAllQuestionAnswered = false;
        }
      };
      $scope.showResult = false;
      $scope.areAllQuestionAnswered = false;
      $scope.filterNumber = 0;
      $scope.targetChecker = [];
      (function() {
        return $timeout(function() {
          console.log(' already answered ');
          console.log($scope.card.alreadyAnswered);
          if ($scope.card.alreadyAnswered) {
            $scope.areAllQuestionAnswered = true;
            return $scope.filterNumber = -1;
          }
        });
      })();
      $scope.submitTarget = function(question, targetAnswer, index) {
        var answer, defer, target, targetAnswerIndex, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[index]._id;
          answer = {
            _id: targetQuestionID,
            answer: targetAnswer
          };
          target = _.find(question.targets[index].lists, function(obj) {
            return obj.option === targetAnswer;
          });
          target.answeredBy.push($scope.user._id);
          targetAnswerIndex = _.indexOf(question.targets[index].lists, target);
          UpdateQuestion.updateFilters({
            questionId: question._id,
            userId: $scope.user._id,
            title: "0",
            filterId: question.targets[index]._id,
            index: targetAnswerIndex
          });
          $scope.user.filterQuestionsAnswered.push(answer);
          if (User.user) {
            UpdateUserInfo.answerFilter({
              userId: escape($scope.user._id),
              filterId: escape(targetQuestionID),
              filterAnswer: escape(targetAnswer)
            });
          }
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
        $scope.filterNumber = 0;
        $scope.card.alreadyAnswered = false;
        return $scope.$emit('resetAnswer', question);
      };
      return $scope.$apply();
    };
  });

}).call(this);
