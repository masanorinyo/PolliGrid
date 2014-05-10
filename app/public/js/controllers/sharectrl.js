(function() {
  define([], function() {
    return function($scope, $modalInstance, $stateParams, $location, $timeout, Setting) {
      var link;
      if (Setting.questionId) {
        $scope.questionId = Setting.questionId;
      } else {
        $scope.questionId = $stateParams.id;
      }
      link = window.location.origin;
      $scope.sharableLink = link.concat("/#/question/", $scope.questionId);
      $scope.closeModal = function() {
        $scope.$dismiss();
        if (Setting.isSetting) {
          Setting.questionId = "";
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
