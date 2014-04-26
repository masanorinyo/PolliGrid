(function() {
  define(['angular', 'services'], function(angular) {
    return angular.module('myapp.controllers', ['myapp.services']).controller('WhichOneCtrl', function($scope, $location, $stateParams, $timeout, $state, User) {
      $scope.searchQuestion = '';
      $scope.user = User;
      $scope.refresh = function() {
        return $timeout(function() {
          $location.path('/');
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        }, 100, true);
      };
      return $scope.searchByCategory = function(category) {
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
    }).controller('FilterCtrl', function($scope, $injector, $timeout) {
      return require(['controllers/filterctrl'], function(filterctrl) {
        return $injector.invoke(filterctrl, this, {
          "$scope": $scope,
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
    }).controller('ListCtrl', function($scope, $q, $location, $injector) {
      return require(['controllers/listctrl'], function(listctrl) {
        return $injector.invoke(listctrl, this, {
          "$scope": $scope,
          "$q": $q,
          "$location": $location
        });
      });
    }).controller('TargetAudienceCtrl', function($scope, $timeout, $q, $injector) {
      return require(['controllers/targetaudiencectrl'], function(targetaudiencectrl) {
        return $injector.invoke(targetaudiencectrl, this, {
          "$scope": $scope,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    }).controller('DeepResultCtrl', function($scope, $injector, $modalInstance, $location, $timeout, $q) {
      return require(['controllers/deepresult'], function(deepresult) {
        return $injector.invoke(deepresult, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    });
  });

}).call(this);
