(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, Question, User, Filters, Error) {
      var ChangePassCtrl, ChangePhotoCtrl;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.user = User;
      ChangePassCtrl = function($scope) {
        return $scope.closeModal = function() {
          return $scope.$dismiss();
        };
      };
      ChangePhotoCtrl = function($scope) {
        return $scope.closeModal = function() {
          return $scope.$dismiss();
        };
      };
      $scope.showFavorites = function() {
        $scope.type = "favorites";
        return $location.path('setting/' + $scope.id + "/favorites");
      };
      $scope.showQuestions = function() {
        $scope.type = "questions";
        return $location.path('setting/' + $scope.id + "/questions");
      };
      $scope.showAnswers = function() {
        $scope.type = "answers";
        return $location.path('setting/' + $scope.id + "/answers");
      };
      $scope.showFilters = function() {
        $scope.type = "filters";
        return $location.path('setting/' + $scope.id + "/filters");
      };
      $scope.openPassModal = function() {
        var modalInstance;
        return modalInstance = $modal.open({
          templateUrl: "views/modals/changePassModal.html",
          controller: ChangePassCtrl
        });
      };
      $scope.openPhotoModal = function() {
        var modalInstance;
        return modalInstance = $modal.open({
          templateUrl: "views/modals/changePhotoModal.html",
          controller: ChangePhotoCtrl
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
