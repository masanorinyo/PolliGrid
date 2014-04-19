(function() {
  define(['underscore', 'jquery'], function(_, $) {
    return function($scope, $modalInstance, $location, $timeout, filters, question) {
      var findSameOption, newQuestion, questions, style, targets, utility;
      findSameOption = function(item) {
        if (item === newQuestion.newOption) {
          return true;
        } else {
          return false;
        }
      };
      questions = $scope.questions = question;
      newQuestion = $scope.question = {
        newOption: "",
        question: "",
        options: [],
        targets: []
      };
      targets = $scope.targets = filters;
      style = $scope.style = false;
      $scope.showDetails = false;
      utility = $scope.utility = {
        isOptionAdded: false,
        isSameOptionFound: false,
        isQuestionEmpty: false,
        readyToMakeNewFilter: false,
        isCreatingQuestion: false,
        isQuestionCreated: true,
        isQuestionCompleted: false
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
      $scope.addFilter = function(target) {
        var foundSameTarget, index;
        foundSameTarget = false;
        foundSameTarget = _.find(newQuestion.targets, function(item) {
          return _.isEqual(item, target);
        });
        if (_.isUndefined(foundSameTarget) || !foundSameTarget) {
          return newQuestion.targets.push(target);
        } else {
          index = newQuestion.targets.indexOf(target);
          return newQuestion.targets.splice(index, 1);
        }
      };
      $scope.openCreateFilterBox = function() {
        return utility.readyToMakeNewFilter = !utility.readyToMakeNewFilter;
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
          utility.isCreatingQuestion = false;
          return utility.isQuestionCreated = true;
        }
      };
      $scope.completeQuestion = function() {
        questions.unshift(newQuestion);
        utility.isQuestionCreated = false;
        return utility.isQuestionCompleted = true;
      };
      $scope.backToCreateQuestion = function() {
        utility.isCreatingQuestion = true;
        return utility.isQuestionCreated = false;
      };
      $scope.backToTargetAudience = function() {
        utility.isQuestionCompleted = false;
        return utility.isQuestionCreated = true;
      };
      return $scope.$apply();
    };
  });

}).call(this);
