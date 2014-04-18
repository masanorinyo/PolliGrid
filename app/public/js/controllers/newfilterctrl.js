(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, filters, question) {
      var filterUtil, findSameOption, newFilter;
      findSameOption = function(item) {
        if (item === filterUtil.newList) {
          return true;
        } else {
          return false;
        }
      };
      filterUtil = $scope.filterUtil = {
        newList: "",
        sameListFound: false,
        isNotFilledOut: false
      };
      newFilter = $scope.newFilter = {
        title: "",
        question: "",
        isFilterAdded: true,
        lists: []
      };
      $scope.addNewList = function(list) {
        var sameOptionFound;
        sameOptionFound = _.find(newFilter.lists, findSameOption);
        if (list === "" || !list) {
          return false;
        } else if (sameOptionFound) {
          return filterUtil.sameListFound = true;
        } else {
          newFilter.lists.push(list);
          filterUtil.newList = "";
          return filterUtil.sameListFound = false;
        }
      };
      $scope.submitNewFilter = function(newFilter) {
        var enoughOptions;
        enoughOptions = false;
        if (_.size(newFilter.lists) >= 2) {
          enoughOptions = true;
        } else {
          filterUtil.isNotFilledOut = true;
        }
        if (newFilter.title === "" || !newFilter.title) {
          return filterUtil.isNotFilledOut = true;
        } else if (newFilter.question === "" || !newFilter.question) {
          return filterUtil.isNotFilledOut = true;
        } else if (enoughOptions) {
          filterUtil.isNotFilledOut = false;
          filters.unshift(newFilter);
          $scope.question.targets.unshift(newFilter);
          question.unshift($scope.question);
          $scope.utility.readyToMakeNewFilter = false;
          $scope.$new(true);
          console.log(newFilter);
          return console.log(filters);
        }
      };
      $scope.cancelToMakeFIlter = function() {
        return $scope.utility.readyToMakeNewFilter = false;
      };
      return $scope.$apply();
    };
  });

}).call(this);
