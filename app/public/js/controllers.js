(function() {
  define(['angular', 'services'], function(angular) {
    return angular.module('myapp.controllers', ['myapp.services']).controller('WhichOneCtrl', function($scope) {
      return $scope.whichone = 'whichone';
    }).controller('UtilityCtrl', function($scope, $injector) {
      return require(['controllers/utilityctrl'], function(utilityctrl) {
        return $injector.invoke(utilityctrl, this, {
          "$scope": $scope
        });
      });
    }).controller('AuthCtrl', function($scope, $injector, $modalInstance, $location, $timeout) {
      return require(['controllers/authctrl'], function(authctrl) {
        return $injector.invoke(authctrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout
        });
      });
    }).controller('CreateCtrl', function($scope, $injector, $modalInstance, $location, $timeout) {
      return require(['controllers/createctrl'], function(createctrl) {
        return $injector.invoke(createctrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout
        });
      });
    }).controller('NewFilterCtrl', function($scope, $injector, $timeout) {
      return require(['controllers/newfilterctrl'], function(newfilterctrl) {
        return $injector.invoke(newfilterctrl, this, {
          "$scope": $scope,
          "$timeout": $timeout
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
