(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $state, $stateParams, $timeout, $q, $http, FindQuestions, User, Filters, Error, Search, UpdateQuestion, Question, Page, UpdateUserInfo) {
      var getColor, getData, targetQ;
      $scope.$on('userLoggedIn', function(data) {
        console.log("$scope.user = User.user");
        return $scope.user = User.user;
      });
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
        $scope.submitted = false;
        $scope.card.totalResponses--;
        if (userId) {
          indexOfRespondents = $scope.card.respondents.indexOf(userId);
        } else {
          indexOfRespondents = $scope.card.respondents.indexOf(visitorId);
        }
        $scope.card.respondents.splice(indexOfRespondents, 1);
        questionId = $scope.card._id;
        if (User.user) {
          found = _.find(User.user.questionsAnswered, function(answer) {
            return answer._id === questionId;
          });
        } else {
          found = _.find($scope.user.questionsAnswered, function(answer) {
            return answer._id === questionId;
          });
        }
        foundOption = _.find($scope.card.option, function(option) {
          return option.title === found.answer;
        });
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
        _.each($scope.card.targets, function(target, index) {
          return _.find(target.lists, function(list, index) {
            if (_.contains(list.answeredBy, userId) || _.contains(list.answeredBy, visitorId)) {
              if (userId) {
                list.answeredBy = _.without(list.answeredBy, userId);
              }
              if (visitorId) {
                list.answeredBy = _.without(list.answeredBy, visitorId);
              }
              return UpdateQuestion.removeFiltersAnswer({
                questionId: $scope.card._id,
                userId: userId,
                visitorId: visitorId,
                title: "0",
                filterId: target._id,
                index: index
              });
            }
          });
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
      $scope.$on('logOff', function(value) {
        console.log("Log off from list");
        $scope.submitted = false;
        $scope.user = User.visitor;
        $scope.warning = false;
        $scope.favorite = false;
        $scope.submitted = false;
        return $scope.user.questionsAnswered = [];
      });
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      getData = function() {
        var color, count, data, i, len, maxLength, obj, ref, title, trimmedTitle;
        $scope.myChartData = [];
        ref = $scope.card.option;
        i = 0;
        len = ref.length;
        while (i < len) {
          obj = ref[i];
          count = obj.count;
          title = obj.title;
          color = getColor();
          if (title.split(/\s+/).length > 3 || title.length > 10) {
            maxLength = 20;
            trimmedTitle = title.substr(0, maxLength);
            title = trimmedTitle.substr(0, Math.min(trimmedTitle.length, trimmedTitle.lastIndexOf(" ")));
            title = title.concat("..");
          }
          data = {
            value: count,
            color: color,
            label: title,
            labelColor: "#FEFEFE",
            labelFontSize: "15",
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
      $scope.myChartOptions = {
        animation: false
      };
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
        var answeredQuestions, defer;
        $scope.card.alreadyAnswered = false;
        answeredQuestions = null;
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
          if ($scope.question) {
            return $scope.card = $scope.question;
          }
        }).then(function() {
          return answeredQuestions = _.find(_.pluck($scope.user.questionsAnswered, '_id'), function(id) {
            if ($scope.card !== void 0) {
              return $scope.card._id === id;
            }
          });
        }).then(function() {
          if (answeredQuestions) {
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
      return $scope.$apply();
    };
  });

}).call(this);
