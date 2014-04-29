(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, $window) {
      $scope.questions = Question;
      $scope.searchFocused = false;
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
      $scope.categories = ["Animal", "Architecture", "Art", "Cars & Motorcycles", "Celebrities", "Design", "DIY & Crafts", "Education", "Film, Music & Books", "Food & Drink", "Gardening", "Geek", "Hair & Beauty", "Health & Fitness", "History", "Holidays & Events", "Home Decor", "Humor", "Illustration & Posters", "Men's Fashion", "Outdoors", "Photography", "Products", "Quotes", "Science & Nature", "Sports", "Tatoos", "Technology", "Travel", "Weddings", "Women's Fashion", "Other"];
      return $scope.$apply();
    };
  });

}).call(this);
