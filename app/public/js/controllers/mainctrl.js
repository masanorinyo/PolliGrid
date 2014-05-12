(function() {
  define(["underscore"], function(_) {
    return function($scope, $location, $q, $stateParams, $timeout, $state, User, Page, FindQuestions, Debounce, Search, QuestionTypeHead, NewQuestion, Verification) {
      var capitaliseFirstLetter, searchSpecificQuestions;
      capitaliseFirstLetter = function(string) {
        return string.charAt(0).toUpperCase() + string.slice(1);
      };
      if (User.user) {
        $scope.user = User.user;
      } else {
        $scope.user = User.visitor;
      }
      $timeout(function() {
        var defer, foundUser;
        foundUser = false;
        defer = $q.defer();
        if (!User.user) {
          defer.promise.then(function() {
            return Verification.findUser({
              id: $scope.user._id
            }).$promise.then(function(data) {
              return foundUser = data.foundUser;
            });
          }).then(function() {
            var randomNum;
            if (foundUser) {
              randomNum = Math.floor(Math.random() * 99);
              $scope.user._id = $scope.user._id.concat(randomNum);
              return Verification.findUser({
                id: $scope.user._id
              }).$promise.then(function(data) {
                return foundUser = data.foundUser;
              });
            }
          });
          return defer.resolve();
        }
      }, 200, true);
      $scope.questions = FindQuestions["default"]();
      $scope.showLoader = false;
      $scope.anyContentsLeft = false;
      $scope.searchQuestion = '';
      $scope.searchTerm = 'All';
      $scope.toggleSearchBox = false;
      $scope.orderBox = false;
      $scope.categoryBox = false;
      $scope.parentSize = {
        width: 0,
        height: 0
      };
      $scope.category = "All";
      $scope.order = "Recent";
      $scope.options = {
        categories: ["All", "Animal", "Architecture", "Art", "Cars & Motorcycles", "Celebrities", "Design", "DIY & Crafts", "Education", "Film, Music & Books", "Food & Drink", "Gardening", "Geek", "Hair & Beauty", "Health & Fitness", "History", "Holidays & Events", "Home Decor", "Humor", "Illustration & Posters", "Lifestyle", "Men's Fashion", "Outdoors", "Photography", "Products", "Quotes", "Science & Nature", "Sports", "Tatoos", "Technology", "Travel", "Weddings", "Women's Fashion", "Other"],
        orders: ["Recent", "Old", "Most voted", "Most popular"]
      };
      searchSpecificQuestions = function() {
        if ($scope.searchQuestion === "") {
          $scope.searchTerm = "All";
        } else {
          $scope.searchTerm = $scope.searchQuestion;
        }
        return FindQuestions.get({
          searchTerm: escape($scope.searchTerm),
          category: escape($scope.category),
          order: escape($scope.order),
          offset: Page.questionPage
        }).$promise.then(function(data) {
          if (!data.length) {
            $scope.showLoader = false;
            return $scope.anyContentsLeft = true;
          } else {
            return data.forEach(function(val, key) {
              return $scope.questions.push(val);
            });
          }
        });
      };
      $scope.refresh = function() {
        $location.path('/');
        return $timeout(function() {
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        }, 100, true);
      };
      $scope.selectedTypehead = function($item) {
        Page.questionPage = 0;
        $scope.questions = [];
        $scope.searchQuestion = $item;
        return searchSpecificQuestions();
      };
      $scope.getPartOfQuestion = function(term) {
        return QuestionTypeHead.get({
          term: escape(term),
          category: escape($scope.category)
        }).$promise.then(function(data) {
          var questions;
          questions = [];
          data.forEach(function(val, key) {
            return questions.push(val.question);
          });
          return questions;
        });
      };
      $scope.changeOrder = function(value) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          $scope.anyContentsLeft = false;
          Page.questionPage = 0;
          return $scope.questions = [];
        }).then(function() {
          return $scope.order = value;
        }).then(function() {
          return searchSpecificQuestions();
        });
        return defer.resolve();
      };
      $scope.changeCategory = function(value) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          $scope.anyContentsLeft = false;
          Page.questionPage = 0;
          return $scope.questions = [];
        }).then(function() {
          return $scope.category = value;
        }).then(function() {
          return searchSpecificQuestions();
        });
        return defer.resolve();
      };
      $scope.searchingQuestions = function() {
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.questions = [];
        return searchSpecificQuestions();
      };
      $scope.updateSearch = Debounce($scope.searchingQuestions, 500, false);
      $scope.$on('category-changed', function(category) {
        return $scope.changeCategory(capitaliseFirstLetter(Search.category));
      });
      $scope.$on('newQuestionAdded', function(value) {
        return $scope.questions.unshift(NewQuestion.question);
      });
      $scope.$on('downloadMoreQuestions', function(value) {
        var callback, defer;
        Page.questionPage += 6;
        $scope.showLoader = true;
        callback = function() {
          return $scope.showLoader = false;
        };
        defer = $q.defer();
        defer.promise.then(function() {
          return searchSpecificQuestions();
        });
        return defer.resolve(callback);
      });
      $scope.$on('userLoggedIn', function(value) {
        console.log("main");
        return $scope.user = User.user;
      });
      $scope.logout = function() {
        User.visitor.questionsAnswered = [];
        User.visitor.filterQuestionsAnswered = [];
        $scope.user = User.visitor;
        $location.path('/');
        return $timeout(function() {
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        }, 100, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
