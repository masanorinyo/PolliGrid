(function() {
  define(['underscore'], function(_) {
    return function($rootScope, $scope, $modalInstance, $location, $timeout, Filters, Question, User, Page, $state, $stateParams, $q, Debounce, FilterTypeHead, NewQuestion, UpdateUserInfo) {
      var changeInSearchText, findSameOption, message, newQuestion, questionLists, utility;
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
      $scope.numOfClicksForSubmit = 0;
      $scope.sharableLink = '';
      $scope.showShareForm = false;
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
      questionLists = '';
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
          var ids, newlyDownloaded;
          newlyDownloaded = data;
          ids = _.pluck($scope.targets, "_id");
          if (newlyDownloaded.length === 0 || _.isUndefined(newlyDownloaded)) {
            return $scope.loadData = "No more data";
          } else {
            return newlyDownloaded.forEach(function(val, key) {
              if (!_.contains(ids, val._id)) {
                $scope.targets.push(val);
                return $scope.loadData = "Load more data";
              } else {
                return $scope.loadData = "No more data";
              }
            });
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
        return $scope.$dismiss();
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
        $scope.numOfClicksForSubmit++;
        if ($scope.numOfClicksForSubmit === 1) {
          $scope.completeButton = "..creating the question";
          newQuestion.numOfFilters = _.size(newQuestion.targets);
          newQuestion.created_at = new Date().getTime();
          newQuestion.photo = User.user.profilePic;
          newQuestion.creatorName = User.user.username;
          newQuestion.creator = User.user._id;
          console.log(newQuestion);
          _.each(newQuestion.option, function(option, index) {
            var bullet;
            bullet = "[" + index + "] - ";
            return questionLists = questionLists.concat(bullet, option.title, "\n");
          });
          return Question.save(newQuestion, function(data) {
            var link, text;
            utility.isQuestionCreated = false;
            utility.isQuestionCompleted = true;
            $scope.completeButton = "Next";
            NewQuestion.question = data;
            $rootScope.$broadcast('newQuestionAdded', newQuestion);
            User.user.questionMade.push(data._id);
            link = window.location.origin;
            $scope.sharableLink = link.concat("/#/question/", data._id);
            text = data.question + " - " + $scope.sharableLink;
            text = escape(text);
            $scope.twitterShareText = 'https://twitter.com/intent/tweet?text=' + text;
            $scope.googleShareText = "https://plus.google.com/share?url=" + $scope.sharableLink;
            $scope.showShareForm = true;
            return $scope.numOfClicksForSubmit = 0;
          });
        }
      };
      $scope.shareFacebook = function() {
        return FB.ui({
          method: 'feed',
          name: newQuestion.question,
          link: $scope.sharableLink,
          picture: "http://www.hyperarts.com/external-xfbml/share-image.gif",
          caption: questionLists,
          description: "PolliGrid lets you analyze people's optinions from different angles",
          message: ''
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
      (function() {
        return $timeout(function() {
          return $scope.targets = Filters.get({
            searchTerm: $scope.searchTerm,
            offset: Page.filterPage
          });
        }, 500, true);
      })();
      return $scope.$apply();
    };
  });

}).call(this);
