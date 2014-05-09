(function() {
  define(["underscore"], function(_) {
    return function($scope, $location, $stateParams, $timeout, $state, User, Page, Question, findQuestions) {
      $scope.questions = Question.get();
      $scope.user = User;
      $scope.searchQuestion = '';
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
        $scope.order = encodeURI(value);
        encodeURI($scope.searchQuestion);
        encodeURI($scope.category);
        return Page.questionPage;
      };
      $scope.changeCategory = function(value) {
        $scope.category = encodeURI(value);
        encodeURI($scope.searchQuestion);
        encodeURI($scope.order);
        return Page.questionPage;
      };
      $scope.updateSearch = function() {
        $scope.order;
        encodeURI($scope.category);
        encodeURI($scope.searchQuestion);
        return Page.questionPage;
      };
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
