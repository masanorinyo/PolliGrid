(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, User, Filters) {
      var targetQ;
      $scope.questions = Question;
      $scope.answer = '';
      $scope.isStarFilled = false;
      $scope.submitted = false;
      targetQ = $scope.targetQ = {
        isQuestionAnswered: false
      };
      $scope.warning = false;
      $scope.submitAnswer = function(choice, question) {
        var answer;
        if (choice === "" || !choice) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          choice.count++;
          question.totalResponses++;
          answer = {
            id: question.id,
            answer: choice.title
          };
          $scope.user.questionsAnswered.push(answer);
          return $scope.submitted = true;
        }
      };
      $scope.fillStar = function(question) {
        var index;
        question.favorite = !question.favorite;
        if (question.favorite) {
          return $scope.user.favorites.push(question.id);
        } else {
          index = $scope.user.favorites.indexOf(question.id);
          return $scope.user.favorites.splice(index, 1);
        }
      };
      $scope.$on('resetAnswer', function(user) {
        $scope.submitted = false;
        return $scope.answer = '';
      });
      return $scope.$apply();
    };
  });

}).call(this);
