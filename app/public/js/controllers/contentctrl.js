(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, $window, $stateParams, $q, $timeout, $state) {
      $scope.filteredQuestions = [];
      $scope.downloadMoreContents = function() {
        return $scope.$emit('downloadMoreQuestions', "question");
      };
      return $scope.$apply();
    };
  });

}).call(this);
