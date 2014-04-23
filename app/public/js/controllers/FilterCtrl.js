(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, Filters, Question, User) {
      $scope.filterAdded = false;
      $scope.addFilter = function(target) {
        var foundSameTarget, index;
        console.log($scope.question);
        foundSameTarget = false;
        $scope.filterAdded = !$scope.filterAdded;
        foundSameTarget = _.find($scope.question.targets, function(item) {
          return _.isEqual(item, target);
        });
        if (_.isUndefined(foundSameTarget) || !foundSameTarget) {
          return $scope.question.targets.push(target);
        } else {
          index = $scope.question.targets.indexOf(target);
          return $scope.question.targets.splice(index, 1);
        }
      };
      return $scope.$apply();
    };
  });

}).call(this);
