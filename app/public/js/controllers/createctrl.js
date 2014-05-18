(function() {
  define(['underscore'], function(_) {
    return function($rootScope, $scope, $modalInstance, $location, $timeout, Filters, Question, User, Page, $state, $stateParams, $q, Debounce, FilterTypeHead, NewQuestion, UpdateUserInfo) {
      var changeInSearchText, findSameOption, message, newQuestion, utility;
      findSameOption = function(item) {
        if (item.title === newQuestion.newOption) {
          return true;
        } else {
          return false;
        }
      };
      $scope.searchText = "";
      $scope.searchTerm = "all";
      $scope.completeButton = "Next";
      $scope.targets = Filters.get({
        searchTerm: $scope.searchTerm,
        offset: Page.filterPage
      });
      newQuestion = $scope.question = {
        newOption: "",
        question: "",
        category: "0",
        respondents: [],
        favorite: false,
        favoritedBy: [],
        numOfFilters: 0,
        totalResponses: 0,
        alreadyAnswered: false,
        created_at: Date,
        option: [],
        targets: [],
        creator: null,
        photo: ""
      };
      $scope.showDetails = false;
      $scope.outOfFilters = false;
      $scope.loadData = "Load more data";
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
      changeInSearchText = function() {
        return $scope.searchText;
      };
      $scope.$watch(changeInSearchText, function() {
        if ($scope.searchText === "") {
          return $scope.searchTerm = "all";
        } else {
          return $scope.searchTerm = $scope.searchText;
        }
      });
      $scope.getFilterTitles = function(term) {
        return FilterTypeHead.get({
          term: escape(term)
        }).$promise.then(function(data) {
          var titles;
          titles = [];
          data.forEach(function(val, key) {
            console.log(val.title);
            return titles.push(val.title);
          });
          return titles;
        });
      };
      $scope.selectedTypehead = function($item) {
        $scope.searchTerm = $item;
        return $scope.searching();
      };
      $scope.downloadFilters = function() {
        $scope.loadData = "...Loading data";
        Page.filterPage += 6;
        return Filters.get({
          searchTerm: $scope.searchTerm,
          offset: Page.filterPage
        }).$promise.then(function(data) {
          var newlyDownloaded;
          newlyDownloaded = data;
          if (newlyDownloaded.length === 0 || _.isUndefined(newlyDownloaded)) {
            return $scope.loadData = "No more data";
          } else {
            newlyDownloaded.forEach(function(val, key) {
              return $scope.targets.push(val);
            });
            return $scope.loadData = "Load more data";
          }
        });
      };
      $scope.searching = function() {
        Page.filterPage = 0;
        return $scope.targets = Filters.get({
          searchTerm: escape($scope.searchTerm),
          offset: Page.filterPage
        });
      };
      $scope.searchFilter = Debounce($scope.searching, 333, false);
      $scope.closeModal = function() {
        $scope.$dismiss();
        $location.path('/');
        return $timeout(function() {
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        });
      };
      $scope.createOption = function(option) {
        var newlyCreatedOption, sameOptionFound;
        sameOptionFound = _.find(newQuestion.option, findSameOption);
        if (option === "" || !option) {
          return false;
        } else if (sameOptionFound) {
          utility.isSameOptionFound = true;
        } else {
          newlyCreatedOption = {
            title: option,
            count: 0,
            answeredBy: []
          };
          newQuestion.option.push(newlyCreatedOption);
          utility.isOptionAdded = true;
          utility.isSameOptionFound = false;
          $timeout(function() {
            return utility.isOptionAdded = false;
          }, 500, true);
        }
        return newQuestion.newOption = '';
      };
      $scope.removeOption = function(index) {
        return newQuestion.option.splice(index, 1);
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
        if (_.size(newQuestion.option) >= 2) {
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
        $scope.completeButton = "..creating the question";
        newQuestion.numOfFilters = _.size(newQuestion.targets);
        newQuestion.created_at = new Date().getTime();
        newQuestion.photo = User.user.profilePic;
        newQuestion.creatorName = User.user.username;
        newQuestion.creator = User.user._id;
        console.log(newQuestion);
        return Question.save(newQuestion, function(data) {
          var link;
          utility.isQuestionCreated = false;
          utility.isQuestionCompleted = true;
          $scope.completeButton = "Next";
          NewQuestion.question = data;
          $rootScope.$broadcast('newQuestionAdded', newQuestion);
          User.user.questionMade.push(data._id);
          link = window.location.origin;
          return $scope.sharableLink = link.concat("/#/question/", data._id);
        });
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
