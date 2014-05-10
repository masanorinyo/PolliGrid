(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $state, $stateParams, $timeout, FindQuestions, User, Filters, Error, Search) {
      var foundQuestion, getColor, getData, questionId, targetQ;
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
      $scope.user = User;
      $scope.isAccessedViaLink = false;
      if ($location.$$path.split('/')[1] === "question") {
        $scope.isAccessedViaLink = true;
        questionId = $stateParams.id;
        foundQuestion = _.findWhere(Question, {
          id: questionId
        });
        $scope.question = foundQuestion;
        $scope.answered = _.find(foundQuestion.respondents, function(id) {
          return id === User._id;
        });
      } else {
        $scope.cards = FindQuestions["default"]();
      }
      $scope.answer = '';
      $scope.isStarFilled = false;
      $scope.submitted = false;
      targetQ = $scope.targetQ = {
        isQuestionAnswered: false
      };
      $scope.warning = false;
      $scope.favorite = false;
      (function() {
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
      })();
      $scope.submitAnswer = function(choice, question) {
        var answer;
        if (choice === "" || !choice) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          $scope.$broadcast('answerSubmitted', 'submitted');
          question.respondents.push($scope.user._id);
          console.log(choice);
          choice.answeredBy.push($scope.user._id);
          choice.count++;
          question.totalResponses++;
          answer = {
            _id: question._id,
            answer: choice.title
          };
          $scope.user.questionsAnswered.push(answer);
          $scope.submitted = true;
          return getData();
        }
      };
      $scope.fillStar = function(question) {
        var index;
        if (User.isLoggedIn) {
          $scope.favorite = !$scope.favorite;
          if ($scope.favorite) {
            $scope.user.favorites.push(question._id);
            return question.numOfFavorites++;
          } else {
            index = $scope.user.favorites.indexOf(question._id);
            $scope.user.favorites.splice(index, 1);
            return question.numOfFavorites--;
          }
        } else {
          Error.auth = "Please sign up to proceed";
          return $location.path('/signup');
        }
      };
      $scope.$on('resetAnswer', function(question) {
        var answers, foundAnswerId, foundAnswered, foundOption, index, indexOfRespondents, optionIndex;
        console.clear();
        console.trace();
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
        foundOption.count--;
        index = answers.indexOf(questionId);
        _.find($scope.user.questionsAnswered, function(answer) {
          if (answer._id === questionId) {
            return $scope.user.questionsAnswered.splice(index, 1);
          }
        });
        return $scope.answer = '';
      });
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          $location.path('/');
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: true,
            notify: true
          });
        }, 100, true);
      };
      $scope.closeQuestionModal = function() {
        return $scope.$dismiss();
      };
      return $scope.$apply();
    };
  });

}).call(this);
