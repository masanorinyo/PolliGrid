(function() {
  define(['angular', 'services'], function(angular) {
    return angular.module('myapp.controllers', ['myapp.services']).controller('WhichOneCtrl', function($scope) {
      $scope.searchQuestion = '';
      return $scope.searchByCategory = function(category) {
        console.log($scope.searchQuestion);
        return $scope.searchQuestion = category;
      };
    }).controller('ShareCtrl', function($scope, $injector, $modalInstance, $location, $timeout) {
      return require(['controllers/sharectrl'], function(sharectrl) {
        return $injector.invoke(sharectrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout
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
    }).controller('TargetAudienceCtrl', function($scope, $injector) {
      return require(['controllers/targetaudiencectrl'], function(targetaudiencectrl) {
        return $injector.invoke(targetaudiencectrl, this, {
          "$scope": $scope
        });
      });
    });
  });

}).call(this);
