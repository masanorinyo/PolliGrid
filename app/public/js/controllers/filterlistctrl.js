(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $q, $timeout, Question, User, UpdateUserInfo) {
      $scope.fadeOut = false;
      $scope.answerChanged = false;
      $scope.changeAnswer = function(answer, filter) {
        var answeredFilter;
        answeredFilter = _.findWhere(User.user.filterQuestionsAnswered, {
          _id: filter._id
        });
        console.log(answeredFilter._id);
        console.log(answer);
        answeredFilter.answer = answer;
        UpdateUserInfo.changeFilter({
          userId: User.user._id,
          filterId: answeredFilter._id,
          filterAnswer: escape(answer)
        });
        $scope.answerChanged = true;
        return $timeout(function() {
          return $scope.answerChanged = false;
        }, 2000, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
