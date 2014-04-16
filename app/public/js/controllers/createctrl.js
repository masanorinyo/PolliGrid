(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $location, $timeout) {
      var findSameOption, options, question;
      findSameOption = function(item) {
        if (item === question.newAnswer) {
          return true;
        } else {
          return false;
        }
      };
      options = $scope.options = [];
      question = $scope.question = function() {
        return {
          newAnswer: "",
          problem: "",
          alertBox: false,
          added: false
        };
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        $timeout(function() {
          return $location.path('/');
        });
        return console.log(question.newAnswer);
      };
      $scope.createOption = function(option) {
        var sameOptionFound;
        sameOptionFound = _.find(options, findSameOption);
        question.newAnswer = '';
        if (sameOptionFound) {
          return question.alertBox = true;
        } else {
          question.added = true;
          question.alertBox = false;
          return options.push(option);
        }
      };
      return $scope.$apply();
    };
  });

}).call(this);
