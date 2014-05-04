(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, $window, $stateParams, $timeout, $state) {
      $scope.questions = Question;
      $scope.order = "Recent";
      $scope.reverse = false;
      $scope.searchFocused = false;
      $scope.filteredQuestions = [];
      $scope.searchByCategory = function(category) {
        return $scope.searchQuestion = category;
      };
      $scope.putCategory = function(category) {
        $scope.searchQuestion = category;
        return $scope.searchFocused = false;
      };
      $scope.updateSearch = function() {
        return $scope.searchFocused = false;
      };
      $scope.sortBy = function(order) {
        $scope.questions = [];
        console.log(Question);
        return $timeout(function() {
          switch (order) {
            case "Recent":
              $scope.order = "Recent";
              return Question = _.sortBy(Question, function(object) {
                return -object.created_at;
              });
            case "Old":
              $scope.order = "Old";
              return Question = _.sortBy(Question, function(object) {
                return object.created_at;
              });
            case "Most voted":
              $scope.order = "Most voted";
              return Question = _.sortBy(Question, function(object) {
                return -object.totalResponses;
              });
            case "Most popular":
              $scope.order = "Most popular";
              return Question = _.sortBy(Question, function(object) {
                return -object.numOfFavorites;
              });
          }
        }, 100, true);
      };
      $scope.changeInQuestions = function() {
        return Question;
      };
      $scope.$watch($scope.changeInQuestions, function(newVal) {
        return $scope.questions = newVal;
      });
      $scope.parentSize = {
        width: 0,
        height: 0
      };
      $scope.orders = ["Recent", "Old", "Most voted", "Most popular"];
      $scope.categories = ["Animal", "Architecture", "Art", "Cars & Motorcycles", "Celebrities", "Design", "DIY & Crafts", "Education", "Film, Music & Books", "Food & Drink", "Gardening", "Geek", "Hair & Beauty", "Health & Fitness", "History", "Holidays & Events", "Home Decor", "Humor", "Illustration & Posters", "Men's Fashion", "Outdoors", "Photography", "Products", "Quotes", "Science & Nature", "Sports", "Tatoos", "Technology", "Travel", "Weddings", "Women's Fashion", "Other"];
      return $scope.$apply();
    };
  });

}).call(this);
