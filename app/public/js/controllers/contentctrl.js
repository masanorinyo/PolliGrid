(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, $window, $stateParams, $q, $timeout, $state) {
      $scope.filteredQuestions = [];
      $scope.showLoader = false;
      $scope.isContentsLoaded = true;
      $scope.downloadMoreContents = function() {
        var defer;
        $scope.showLoader = true;
        defer = $q.defer();
        defer.promise.then(function() {
          return download();
        }).then(function() {
          return $scope.showLoader = false;
        });
        return defer.resolve();
      };
      return $scope.$apply();
    };
  });

}).call(this);
