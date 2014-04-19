(function() {
  define([], function() {
    return function($scope, question) {
      $scope.questions = question;
      $scope.isStarFilled = false;
      $scope.searchQuestion = '';
      $scope.searchByCategory = function(category) {
        console.log($scope.searchQuestion);
        return $scope.searchQuestion = category;
      };
      $scope.fillStar = function() {
        return $scope.isStarFilled = !$scope.isStarFilled;
      };
      return $scope.$apply();
    };
  });

}).call(this);
