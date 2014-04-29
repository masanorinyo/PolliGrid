(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $q, $timeout, Question, User) {
      $scope.fadeOut = false;
      $scope.answerChanged = false;
      $scope.changeAnswer = function(answer, filter) {
        var answeredFilter;
        answeredFilter = _.findWhere(User.filterQuestionsAnswered, {
          id: filter.id
        });
        answeredFilter.answer = answer;
        $scope.answerChanged = true;
        $timeout(function() {
          return $scope.fadeOut = true;
        }, 1000, true);
        return $timeout(function() {
          return $scope.answerChanged = false;
        }, 2000, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
