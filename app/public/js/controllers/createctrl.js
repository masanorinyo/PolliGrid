(function() {
  define(['underscore', 'jquery'], function(_, $) {
    return function($scope, $modalInstance, $location, $timeout, filters, question) {
      var findSameOption, message, newQuestion, questions, targets, utility;
      findSameOption = function(item) {
        if (item === newQuestion.newOption) {
          return true;
        } else {
          return false;
        }
      };
      questions = $scope.questions = question;
      targets = $scope.targets = filters;
      newQuestion = $scope.question = {
        newOption: "",
        question: "",
        category: "0",
        options: [],
        targets: []
      };
      $scope.showDetails = false;
      message = $scope.message = {
        questionNotFound: "",
        optionsNotEnough: "",
        categoryNotChosen: ""
      };
      utility = $scope.utility = {
        isOptionAdded: false,
        isSameOptionFound: false,
        isQuestionFound: false,
        isCategoryChosen: false,
        areOptionsEnough: false,
        readyToMakeNewFilter: false,
        isCreatingQuestion: true,
        isQuestionCreated: false,
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
        var chosen;
        if (newQuestion.question !== "") {
          utility.isQuestionFound = true;
          message.questionNotFound = "";
        } else {
          newQuestion.question;
          utility.isQuestionFound = false;
          message.questionNotFound = "Please finish making a question";
        }
        if (_.size(newQuestion.options) >= 2) {
          utility.areOptionsEnough = true;
          message.optionsNotEnough = "";
        } else {
          utility.areOptionsEnough = false;
          message.optionsNotEnough = "Please make at least two options";
        }
        if (newQuestion.category !== "0") {
          chosen = utility.isCategoryChosen = true;
          message.categoryNotChosen = "";
        } else {
          utility.isCategoryChosen = false;
          message.categoryNotChosen = "Please choose a category";
        }
        if (utility.isQuestionFound && utility.areOptionsEnough && utility.isCategoryChosen) {
          utility.isQuestionCreated = true;
          return utility.isCreatingQuestion = false;
        } else {
          return false;
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
