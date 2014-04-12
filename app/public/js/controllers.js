(function() {
  define(['angular'], function(angular) {
    return angular.module('myapp.controllers', []).controller('FlippySurveyCtrl', function($scope) {
      return $scope.flippysurvey = 'flippysurvey';
    }).controller('AuthCtrl', function($scope, $injector) {
      return require(['controllers/authctrl'], function(authctrl) {
        return $injector.invoke(authctrl, this, {
          "$scope": $scope
        });
      });
    }).controller('UtilityCtrl', function($scope, $injector) {
      return require(['controllers/utilityctrl'], function(utilityctrl) {
        return $injector.invoke(utilityctrl, this, {
          "$scope": $scope
        });
      });
    }).controller('ContentCtrl', function($scope, $injector) {
      return require(['controllers/contentctrl'], function(contentctrl) {
        return $injector.invoke(contentctrl, this, {
          "$scope": $scope
        });
      });
    });
  });

}).call(this);
