(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $location, $timeout) {
      var findSameOption, question;
      findSameOption = function(item) {
        if (item === question.newAnswer) {
          return true;
        } else {
          return false;
        }
      };
      question = $scope.question = {
        newAnswer: "",
        problem: "",
        confirm: "next",
        options: [],
        optionAdded: false,
        alert_sameOption: false,
        alert_emptyQuestion: false,
        move_toTarget: true
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          return $location.path('/');
        });
      };
      $scope.createOption = function(option) {
        var sameOptionFound;
        sameOptionFound = _.find(question.options, findSameOption);
        if (option === "" || !option) {
          return false;
        } else if (sameOptionFound) {
          question.alert_sameOption = true;
        } else {
          question.options.push(option);
          question.optionAdded = true;
          question.alert_sameOption = false;
          $timeout(function() {
            return question.optionAdded = false;
          }, 500, true);
        }
        return question.newAnswer = '';
      };
      $scope.removeOption = function(index) {
        return question.options.splice(index, 1);
      };
      $scope.submitQuestion = function() {
        var enoughOptions;
        enoughOptions = false;
        if (_.size(question.options) >= 2) {
          enoughOptions = true;
        }
        if (question.problem === "" || !question.problem || !enoughOptions) {
          return question.alert_emptyQuestion = true;
        } else {
          question.alert_emptyQuestion = false;
          return question.move_toTarget = true;
        }
      };
      $scope.back = function() {
        question.move_toTarget = false;
        return question.confirm = "Next";
      };
      return $scope.$apply();
    };
  });

}).call(this);
