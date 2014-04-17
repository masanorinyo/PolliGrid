(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $location, $timeout) {
      var findSameOption, question, target, utility;
      findSameOption = function(item) {
        if (item === question.newOption) {
          return true;
        } else {
          return false;
        }
      };
      utility = $scope.utility = {
        confirm: 'next',
        isOptionAdded: false,
        isSameOptionFound: false,
        isQuestionEmpty: false,
        isQuestionCreated: true,
        readyToMakeNewFilter: true
      };
      question = $scope.question = {
        newOption: "",
        question: "",
        options: [],
        targets: []
      };
      target = $scope.targets = [
        {
          title: "Age",
          question: "How old are you?",
          showDetails: false,
          isFilterAdded: false,
          lists: ["~ 10", "11 ~ 20", "21 ~ 30", "31 ~ 40", "41 ~ 50", "51 ~ 60", "61 ~ "]
        }, {
          title: "Ethnicity",
          question: "What is your ethnicity?",
          lists: ["Asian", "Hispanic", "Caucasian", "African-American"]
        }
      ];
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
          utility.isSameOptionFound = true;
        } else {
          question.options.push(option);
          utility.isOptionAdded = true;
          utility.isSameOptionFound = false;
          $timeout(function() {
            return utility.isOptionAdded = false;
          }, 500, true);
        }
        return question.newOption = '';
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
        if (question.question === "" || !question.question || !enoughOptions) {
          return utility.isQuestionEmpty = true;
        } else {
          utility.isQuestionEmpty = false;
          return utility.isQuestionCreated = true;
        }
      };
      $scope.addFilter = function(target) {
        var index;
        target.isFilterAdded = !target.isFilterAdded;
        if (target.isFilterAdded) {
          question.targets.push(target);
        } else {
          index = question.targets.indexOf(target);
          question.targets.splice(index, 1);
        }
        return console.log(question);
      };
      $scope.back = function() {
        utility.isQuestionCreated = false;
        return utility.confirm = "Next";
      };
      return $scope.$apply();
    };
  });

}).call(this);
