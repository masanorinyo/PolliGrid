(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $stateParams, $timeout, Question, User, Filters, Error) {
      $scope.test = $stateParams.type + " " + $stateParams.id;
      return $scope.$apply();
    };
  });

}).call(this);
