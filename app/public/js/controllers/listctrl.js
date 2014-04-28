(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $state, $stateParams, $timeout, Question, User, Filters, Error) {
      var foundQuestion, getColor, getData, questionId, targetQ;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      getData = function() {
        var color, count, data, i, len, obj, ref, title;
        $scope.myChartData = [];
        ref = $scope.question.options;
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
      $scope.myChartData = [];
      $scope.myChartOptions = {
        animation: true,
        animationStep: 30,
        animationEasing: "easeOutQuart"
      };
      $scope.user = User;
      $scope.isAccessedViaLink = false;
      if ($stateParams.id) {
        $scope.isAccessedViaLink = true;
        console.log($scope.isAccessedViaLink);
        questionId = Number($stateParams.id);
        foundQuestion = _.findWhere(Question, {
          id: questionId
        });
        $scope.question = foundQuestion;
      } else {
        $scope.questions = Question;
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
        alreadyAnswered = _.find(_.pluck($scope.user.questionsAnswered, 'id'), function(id) {
          return Number($scope.question.id) === Number(id);
        });
        if (alreadyAnswered) {
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
          $scope.question.respondents.push($scope.user.id);
          choice.answeredBy.push($scope.user.id);
          choice.count++;
          question.totalResponses++;
          answer = {
            id: question.id,
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
            $scope.user.favorites.push(question.id);
            question.numOfFavorites++;
          } else {
            index = $scope.user.favorites.indexOf(question.id);
            $scope.user.favorites.splice(index, 1);
            question.numOfFavorites--;
          }
        } else {
          Error.auth = "Please sign up to proceed";
          console.log(Error.auth);
          $location.path('/signup');
        }
        return console.log(User);
      };
      $scope.$on('resetAnswer', function(question) {
        var answers, foundAnswerId, foundAnswered, foundOption, index, indexOfRespondents, optionIndex;
        console.clear();
        console.trace();
        console.count("Reset was called:");
        $scope.submitted = false;
        $scope.question.totalResponses--;
        indexOfRespondents = $scope.question.respondents.indexOf($scope.user.id);
        $scope.question.respondents.splice(indexOfRespondents, 1);
        questionId = Number($scope.question.id);
        answers = _.pluck($scope.user.questionsAnswered, 'id');
        foundAnswerId = _.find(answers, function(id) {
          return Number(id) === Number(questionId);
        });
        foundAnswered = _.find($scope.user.questionsAnswered, function(answer) {
          return Number(answer.id) === Number(foundAnswerId);
        });
        foundOption = _.find($scope.question.options, function(option) {
          return option.title === foundAnswered.answer;
        });
        optionIndex = foundOption.answeredBy.indexOf($scope.user.id);
        foundOption.answeredBy.splice(optionIndex, 1);
        foundOption.count--;
        index = answers.indexOf(questionId);
        _.find($scope.user.questionsAnswered, function(answer) {
          if (Number(answer.id) === Number(questionId)) {
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
            inherit: false,
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
