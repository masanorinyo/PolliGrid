(function() {
  define(['underscore'], function(_) {
    return function($scope, Question, $window) {
      $scope.questions = Question;
      $scope.order = "Recent";
      $scope.reverse = false;
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
      $scope.sortBy = function(order) {
        console.log(order);
        switch (order) {
          case "Recent":
            $scope.orderBy = "created_at";
            $scope.reverse = true;
            return $scope.order = "Recent";
          case "Old":
            $scope.orderBy = "created_at";
            $scope.reverse = false;
            return $scope.order = "Old";
          case "Most voted":
            $scope.orderBy = "totalResponses";
            $scope.reverse = true;
            return $scope.order = "Most voted";
          case "Most popular":
            $scope.orderBy = "numOfFavorites";
            $scope.reverse = true;
            return $scope.order = "Most popular";
        }
      };
      $scope.orders = ["Recent", "Old", "Most voted", "Most popular"];
      $scope.categories = ["Animal", "Architecture", "Art", "Cars & Motorcycles", "Celebrities", "Design", "DIY & Crafts", "Education", "Film, Music & Books", "Food & Drink", "Gardening", "Geek", "Hair & Beauty", "Health & Fitness", "History", "Holidays & Events", "Home Decor", "Humor", "Illustration & Posters", "Men's Fashion", "Outdoors", "Photography", "Products", "Quotes", "Science & Nature", "Sports", "Tatoos", "Technology", "Travel", "Weddings", "Women's Fashion", "Other"];
      return $scope.$apply();
    };
  });

}).call(this);
