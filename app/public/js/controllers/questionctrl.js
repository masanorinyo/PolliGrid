(function() {
  define([], function() {
    return function($scope, $modalInstance, $location, $timeout) {
      $scope.options = [];
      $scope.answer = function() {
        var newAnswer;
        return newAnswer = '';
      };
      $scope.createOption = function(option) {
        answer.newAnswer = '';
        console.log(answer.newAnswer);
        return $scope.options.push(option);
      };
      return $scope.$apply();
    };
  });

}).call(this);
