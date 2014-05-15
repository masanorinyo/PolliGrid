(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Filters, Question) {
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
        id: null,
        title: "",
        question: "",
        lists: [],
        created_at: Date
      };
      $scope.addNewList = function(list) {
        var data, sameOptionFound;
        sameOptionFound = _.find(newFilter.lists, findSameOption);
        if (list === "" || !list) {
          return false;
        } else if (sameOptionFound) {
          return filterUtil.sameListFound = true;
        } else {
          data = {
            option: list,
            answeredBy: []
          };
          newFilter.lists.push(data);
          filterUtil.newList = "";
          return filterUtil.sameListFound = false;
        }
      };
      $scope.submitNewFilter = function(newFilter) {
        var clone_newFilter, defer, enoughOptions, newlySavedFilter;
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
          clone_newFilter = angular.copy(newFilter);
          clone_newFilter.created_at = new Date().getTime();
          defer = $q.defer();
          newlySavedFilter = null;
          defer.promise.then(function() {
            return _.each(clone_newFilter.lists, function(list) {
              list.option = escape(list.option);
              return console.log(list.option);
            });
          }).then(function() {
            return newlySavedFilter = Filters.save(clone_newFilter);
          }).then(function() {
            return _.each(clone_newFilter.lists, function(list) {
              list.option = unescape(list.option);
              return console.log(list.option);
            });
          }).then(function() {
            return $scope.targets.unshift(newlySavedFilter);
          });
          defer.resolve();
          newFilter.title = "";
          newFilter.question = "";
          newFilter.lists = [];
          return $scope.utility.readyToMakeNewFilter = false;
        }
      };
      $scope.removeList = function(index) {
        return newFilter.lists.splice(index, 1);
      };
      $scope.cancelToMakeFIlter = function() {
        return $scope.utility.readyToMakeNewFilter = false;
      };
      return $scope.$apply();
    };
  });

}).call(this);
