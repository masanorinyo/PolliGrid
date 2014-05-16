(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $state, $stateParams, $timeout, $q, $http, FindQuestions, User, Filters, Error, Search, UpdateQuestion, Question, Page, UpdateUserInfo) {
      var getColor, getData, targetQ;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      getData = function() {
        var color, count, data, i, len, obj, ref, title;
        $scope.myChartData = [];
        ref = $scope.card.option;
        i = 0;
        len = ref.length;
        while (i < len) {
          obj = ref[i];
          count = obj.count;
          title = obj.title;
          color = getColor();
          data = {
            value: count,
            color: color,
            label: title,
            labelColor: "#FEFEFE",
            labelFontSize: "18",
            labelAlign: 'center'
          };
          $scope.myChartData.push(data);
          i++;
        }
      };
      $scope.searchByCategory = function(category) {
        Search.category = category;
        return $scope.$emit("category-changed", category);
      };
      $scope.myChartData = [];
      if ($scope.isAccessedFromSetting !== void 0 || $scope.isAccessedFromSetting) {
        $scope.myChartOptions = {
          animation: false
        };
      } else {
        $scope.myChartOptions = {
          animation: false,
          animationStep: 30,
          animationEasing: "easeOutQuart"
        };
      }
      if (User.user && !$scope.isAccessedFromSetting) {
        $scope.user = User.user;
      } else if (!$scope.isAccessedFromSetting) {
        $scope.user = User.visitor;
      }
      $scope.isAccessedViaLink = false;
      $scope.answer = '';
      $scope.isStarFilled = false;
      $scope.submitted = false;
      targetQ = $scope.targetQ = {
        isQuestionAnswered: false
      };
      $scope.warning = false;
      $scope.favorite = false;
      (function() {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          var questionId;
          if ($location.$$path.split('/')[1] === "question") {
            $scope.isAccessedViaLink = true;
            questionId = $stateParams.id;
            $scope.question = Question.get({
              questionId: escape(questionId)
            });
            return $scope.question.$promise.then(function(data) {
              if (!data._id) {
                $scope.$dismiss();
                $timeout(function() {
                  return $location.path('/');
                }, 100, true);
              }
              return _.each(data.respondents, function(id) {
                console.log("respondents found");
                if (id === $scope.user._id) {
                  $scope.question = data;
                  $scope.submitted = true;
                  $scope.question.alreadyAnswered = true;
                }
                return _.each($scope.user.visitorId, function(vid) {
                  if (vid === id) {
                    $scope.question = data;
                    $scope.submitted = true;
                    return $scope.question.alreadyAnswered = true;
                  }
                });
              });
            });
          } else {
            return $scope.cards = FindQuestions["default"]();
          }
        }).then(function() {
          var alreadyAnswered;
          console.log($scope.question);
          if ($scope.question) {
            $scope.card = $scope.question;
          }
          alreadyAnswered = _.find(_.pluck($scope.user.questionsAnswered, '_id'), function(id) {
            if ($scope.card !== void 0) {
              return $scope.card._id === id;
            }
          });
          if (alreadyAnswered) {
            $scope.card.alreadyAnswered = true;
            return getData();
          }
        });
        return defer.resolve();
      })();
      $scope.submitAnswer = function(choice, question) {
        var answer;
        if (choice === "" || !choice) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          $scope.$broadcast('answerSubmitted', 'submitted');
          UpdateQuestion.updateQuestion({
            questionId: question._id,
            userId: $scope.user._id,
            title: escape(choice.title),
            filterId: 0,
            index: 0
          });
          question.respondents.push($scope.user._id);
          choice.answeredBy.push($scope.user._id);
          choice.count++;
          question.totalResponses++;
          answer = {
            _id: question._id,
            answer: choice.title
          };
          $scope.user.questionsAnswered.push(answer);
          console.log("update user info");
          if (User.user) {
            UpdateUserInfo.answerQuestion({
              userId: escape($scope.user._id),
              questionId: escape(question._id),
              questionAnswer: escape(choice.title)
            });
          }
          $scope.user;
          $scope.submitted = true;
          return getData();
        }
      };
      $scope.fillStar = function(question) {
        var index;
        if ($scope.user.isLoggedIn) {
          $scope.favorite = !$scope.favorite;
          if ($scope.favorite) {
            $scope.user.favorites.push(question._id);
            question.numOfFavorites++;
            console.log($scope.user._id);
            Question.favorite({
              questionId: escape(question._id),
              action: escape("increment")
            });
            return UpdateUserInfo.favorite({
              userId: escape($scope.user._id),
              questionId: escape(question._id),
              task: escape("favoritePush")
            });
          } else {
            index = $scope.user.favorites.indexOf(question._id);
            $scope.user.favorites.splice(index, 1);
            question.numOfFavorites--;
            Question.favorite({
              questionId: escape(question._id),
              action: escape("decrement")
            });
            console.log($scope.user._id);
            return UpdateUserInfo.favorite({
              userId: escape($scope.user._id),
              questionId: escape(question._id),
              task: escape("favoritePull")
            });
          }
        } else {
          Error.auth = "Please sign up to proceed";
          return $location.path('/signup');
        }
      };
      $scope.test = function() {
        return console.log(User.user);
      };
      $scope.$on('resetAnswer', function(question) {
        var answers, found, foundOption, index, indexOfRespondents, optionIndex, questionId, userId, visitorId;
        if (_.isArray($scope.user.visitorId)) {
          visitorId = _.intersection($scope.card.respondents, $scope.user.visitorId);
        } else {
          visitorId = _.intersection($scope.card.respondents, [$scope.user.visitorId]);
        }
        visitorId = visitorId[0];
        if (User.user) {
          userId = _.intersection($scope.card.respondents, [User.user._id]);
          userId = userId[0];
          if (userId) {
            visitorId = 0;
          } else {
            userId = 0;
          }
        } else {
          visitorId = User.visitor._id;
        }
        if (!visitorId || visitorId === void 0) {
          visitorId = 0;
        }
        if (!userId || userId === void 0) {
          userId = 0;
        }
        console.log("userId");
        console.log(userId);
        console.log("visitorId");
        console.log(visitorId);
        $scope.submitted = false;
        $scope.card.totalResponses--;
        if (userId) {
          indexOfRespondents = $scope.card.respondents.indexOf(userId);
        } else {
          indexOfRespondents = $scope.card.respondents.indexOf(visitorId);
        }
        $scope.card.respondents.splice(indexOfRespondents, 1);
        questionId = $scope.card._id;
        console.log("$scope.user.questionsAnswered");
        console.log($scope.user.questionsAnswered);
        if (User.user) {
          found = _.find(User.user.questionsAnswered, function(answer) {
            return answer._id === questionId;
          });
        } else {
          found = _.find($scope.user.questionsAnswered, function(answer) {
            return answer._id === questionId;
          });
        }
        console.log("found");
        console.log(found);
        console.log(found.answer);
        foundOption = _.find($scope.card.option, function(option) {
          console.log("option.title");
          console.log(option.title);
          return option.title === found.answer;
        });
        console.log("foundOption");
        console.log(foundOption);
        if (userId) {
          optionIndex = foundOption.answeredBy.indexOf(userId);
        } else {
          optionIndex = foundOption.answeredBy.indexOf(visitorId);
        }
        foundOption.answeredBy.splice(optionIndex, 1);
        if (User.user) {
          UpdateUserInfo.reset({
            questionId: questionId,
            userId: User.user._id
          });
        }
        foundOption.count--;
        answers = _.pluck($scope.user.questionsAnswered, '_id');
        index = answers.indexOf(questionId);
        _.find($scope.user.questionsAnswered, function(answer) {
          if (answer._id === questionId) {
            return $scope.user.questionsAnswered.splice(index, 1);
          }
        });
        UpdateQuestion.removeAnswer({
          questionId: questionId,
          userId: userId,
          title: escape(foundOption.title),
          filterId: 0,
          index: 0,
          visitorId: visitorId
        });
        return $scope.answer = '';
      });
      $scope.$on('userLoggedIn', function(value) {
        return $scope.user = User.user;
      });
      $scope.$on('logOff', function(value) {
        console.log("Log off from list");
        return $timeout(function() {
          $scope.user = User.visitor;
          $scope.warning = false;
          $scope.submitted = false;
          $scope.favorite = false;
          return $scope.submitted = false;
        }, 500, true);
      });
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          $location.path('/');
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        });
      };
      $scope.closeQuestionModal = function() {
        return $scope.$dismiss();
      };
      return $scope.$apply();
    };
  });

}).call(this);
