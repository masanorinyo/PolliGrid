(function() {
  define([], function() {
    return function($scope, $modalInstance, $stateParams, $location, $timeout, Setting) {
      $scope.questionId = Setting.questionId;
      console.log($scope.questionId);
      $scope.closeModal = function() {
        $scope.$dismiss();
        if (Setting.isSetting) {
          return $timeout(function() {
            return $location.path(Setting.section);
          }, 100, true);
        } else {
          return $timeout(function() {
            return $location.path('/');
          }, 100, true);
        }
      };
      return $scope.$apply();
    };
  });

}).call(this);
