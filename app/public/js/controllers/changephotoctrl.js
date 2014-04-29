(function() {
  define(['underscore'], function(_) {
    return function($scope, $modal, $stateParams, $location, $q, $timeout, Question) {
      var ChangePhotoCtrl;
      ChangePhotoCtrl = function($scope) {
        return $scope.closeModal = function() {
          return $scope.$dismiss();
        };
      };
      $scope.openPhotoModal = function() {
        var modalInstance;
        console.log('test');
        return modalInstance = $modal.open({
          templateUrl: "views/modals/changePhotoModal.html",
          controller: ChangePhotoCtrl
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
