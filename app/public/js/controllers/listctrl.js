(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, Question, User, Filters) {
      var getColor, getData, targetQ;
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
      $scope.questions = Question;
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
          $scope.$broadcast('answerSubmitted', 'submitted');
          $scope.warning = false;
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
        $scope.favorite = !$scope.favorite;
        if ($scope.favorite) {
          $scope.user.favorites.push(question.id);
        } else {
          index = $scope.user.favorites.indexOf(question.id);
          $scope.user.favorites.splice(index, 1);
        }
        return console.log(User);
      };
      $scope.$on('resetAnswer', function(question) {
        var answers, foundAnswerId, foundAnswered, foundOption, index, questionId;
        $scope.submitted = false;
        $scope.question.totalResponses--;
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
        foundOption.count--;
        index = answers.indexOf(questionId);
        console.log(index);
        _.find($scope.user.questionsAnswered, function(answer) {
          if (Number(answer.id) === Number(questionId)) {
            return $scope.user.questionsAnswered.splice(index, 1);
          }
        });
        console.log($scope.user);
        return $scope.answer = '';
      });
      return $scope.$apply();
    };
  });

}).call(this);