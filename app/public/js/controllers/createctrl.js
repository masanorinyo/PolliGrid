(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $location, $timeout, filters, question) {
      var findSameOption, newQuestion, targets, utility;
      findSameOption = function(item) {
        if (item === newQuestion.newOption) {
          return true;
        } else {
          return false;
        }
      };
      newQuestion = $scope.question = {
        newOption: "",
        question: "",
        options: [],
        targets: []
      };
      targets = $scope.targets = filters;
      $scope.showDetails = false;
      utility = $scope.utility = {
        confirm: 'Next',
        isOptionAdded: false,
        isSameOptionFound: false,
        isQuestionEmpty: false,
        readyToMakeNewFilter: false,
        isQuestionCreated: false
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          return $location.path('/');
        });
      };
      $scope.createOption = function(option) {
        var sameOptionFound;
        sameOptionFound = _.find(newQuestion.options, findSameOption);
        if (option === "" || !option) {
          return false;
        } else if (sameOptionFound) {
          utility.isSameOptionFound = true;
        } else {
          newQuestion.options.push(option);
          utility.isOptionAdded = true;
          utility.isSameOptionFound = false;
          $timeout(function() {
            return utility.isOptionAdded = false;
          }, 500, true);
        }
        return newQuestion.newOption = '';
      };
      $scope.removeOption = function(index) {
        return newQuestion.options.splice(index, 1);
      };
      $scope.submitQuestion = function() {
        var enoughOptions;
        enoughOptions = false;
        if (_.size(newQuestion.options) >= 2) {
          enoughOptions = true;
        }
        if (newQuestion.question === "" || !newQuestion.question || !enoughOptions) {
          return utility.isQuestionEmpty = true;
        } else {
          utility.isQuestionEmpty = false;
          utility.isQuestionCreated = true;
          return utility.confirm = 'Done';
        }
      };
      $scope.addFilter = function(target) {
        var index;
        target.isFilterAdded = !target.isFilterAdded;
        if (target.isFilterAdded) {
          newQuestion.targets.push(target);
        } else {
          index = newQuestion.targets.indexOf(target);
          newQuestion.targets.splice(index, 1);
        }
        console.log(question);
        return console.log(filters);
      };
      $scope.back = function() {
        utility.isQuestionCreated = false;
        return utility.confirm = "Next";
      };
      $scope.openCreateFilterBox = function() {
        return utility.readyToMakeNewFilter = !utility.readyToMakeNewFilter;
      };
      return $scope.$apply();
    };
  });

}).call(this);
