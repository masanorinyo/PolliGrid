(function() {
  define(["underscore"], function(_) {
    return function($scope, $location, $q, $stateParams, $timeout, $state, User, Page, FindQuestions, Debounce) {
      var searchSpecificQuestions;
      $scope.user = User;
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
        categories: ["All", "Animal", "Architecture", "Art", "Cars & Motorcycles", "Celebrities", "Design", "DIY & Crafts", "Education", "Film, Music & Books", "Food & Drink", "Gardening", "Geek", "Hair & Beauty", "Health & Fitness", "History", "Holidays & Events", "Home Decor", "Humor", "Illustration & Posters", "Men's Fashion", "Outdoors", "Photography", "Products", "Quotes", "Science & Nature", "Sports", "Tatoos", "Technology", "Travel", "Weddings", "Women's Fashion", "Other"],
        orders: ["Recent", "Old", "Most voted", "Most popular"]
      };
      searchSpecificQuestions = function() {
        console.count("called");
        Page.questionPage = 0;
        if ($scope.searchQuestion === "") {
          $scope.searchTerm = "All";
        } else {
          $scope.searchTerm = $scope.searchQuestion;
        }
        return $scope.questions = FindQuestions.get({
          searchTerm: encodeURI($scope.searchTerm),
          category: encodeURI($scope.category),
          order: encodeURI($scope.order),
          offset: Page.questionPage
        });
      };
      $scope.questions = FindQuestions.get({
        searchTerm: encodeURI($scope.searchTerm),
        category: encodeURI($scope.category),
        order: encodeURI($scope.order),
        offset: Page.questionPage
      });
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
      $scope.changeOrder = function(value) {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
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
          return $scope.category = value;
        }).then(function() {
          return searchSpecificQuestions();
        });
        return defer.resolve();
      };
      $scope.searchingQuestions = function() {
        return searchSpecificQuestions();
      };
      $scope.updateSearch = Debounce($scope.searchingQuestions, 333, false);
      $scope.logout = function() {
        User._id = 0;
        User.name = '';
        User.email = '';
        User.password = '';
        User.profilePic = "";
        User.isLoggedIn = false;
        User.favorites = [];
        User.questionMade = [];
        User.questionsAnswered = [];
        User.filterQuestionsAnswered = [];
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
