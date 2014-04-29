(function() {
  define(['underscore'], function(_) {
    return function($scope, $modal, $stateParams, $location, $q, $timeout, Question) {
      var ChangePassCtrl;
      ChangePassCtrl = function($scope) {
        return $scope.closeModal = function() {
          return $scope.$dismiss();
        };
      };
      $scope.openPassModal = function() {
        var modalInstance;
        return modalInstance = $modal.open({
          templateUrl: "views/modals/changePassModal.html",
          controller: ChangePassCtrl
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
