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
            $scope.question.$promise.then(function(data) {
              if (!data._id) {
                $scope.$dismiss();
                return $timeout(function() {
                  return $location.path('/');
                }, 100, true);
              }
            });
            return $scope.answered = _.find($scope.question.respondents, function(id) {
              return id === $scope.user._id;
            });
          } else {
            return $scope.cards = FindQuestions["default"]();
          }
        }).then(function() {
          var alreadyAnswered;
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
      $scope.$on('resetAnswer', function(question) {
        var answers, foundAnswerId, foundAnswered, foundOption, index, indexOfRespondents, optionIndex, questionId, userId;
        $scope.submitted = false;
        $scope.card.totalResponses--;
        indexOfRespondents = $scope.card.respondents.indexOf($scope.user._id);
        $scope.card.respondents.splice(indexOfRespondents, 1);
        questionId = $scope.card._id;
        answers = _.pluck($scope.user.questionsAnswered, '_id');
        foundAnswerId = _.find(answers, function(id) {
          return id === questionId;
        });
        foundAnswered = _.find($scope.user.questionsAnswered, function(answer) {
          return answer._id === foundAnswerId;
        });
        foundOption = _.find($scope.card.option, function(option) {
          return option.title === foundAnswered.answer;
        });
        optionIndex = foundOption.answeredBy.indexOf($scope.user._id);
        foundOption.answeredBy.splice(optionIndex, 1);
        if (User.user) {
          UpdateUserInfo.reset({
            questionId: questionId,
            userId: User.user._id
          });
        }
        foundOption.count--;
        index = answers.indexOf(questionId);
        _.find($scope.user.questionsAnswered, function(answer) {
          if (answer._id === questionId) {
            return $scope.user.questionsAnswered.splice(index, 1);
          }
        });
        if (!User.user) {
          userId = 0;
        } else {
          userId = User.user._id;
        }
        _.each($scope.card.targets, function(target, index) {
          return _.find(target.lists, function(list, index) {
            if (_.contains(list.answeredBy, $scope.user._id)) {
              if (User.user) {
                list.answeredBy = _.without(list.answeredBy, User.user._id);
              }
              list.answeredBy = _.without(list.answeredBy, User.visitor._id);
              console.log($scope.card);
              return UpdateQuestion.removeFiltersAnswer({
                questionId: $scope.card._id,
                userId: $scope.user._id,
                visitorId: User.visitor._id,
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
          visitorId: User.visitor._id
        });
        $scope.user = User.visitor;
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
        }, 100, true);
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
