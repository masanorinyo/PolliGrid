(function() {
  define(['angular', 'services'], function(angular) {
    return angular.module('myapp.controllers', ['myapp.services']).controller('MainCtrl', function($scope, $injector, $location, $state, $stateParams, $timeout, $q, ipCookie, $http) {
      return require(['controllers/mainctrl'], function(mainctrl) {
        return $injector.invoke(mainctrl, this, {
          "$scope": $scope,
          "$location": $location,
          "$state": $state,
          "$stateParams": $stateParams,
          "$timeout": $timeout,
          "$q": $q,
          "ipCookie": ipCookie,
          "$http": $http
        });
      });
    }).controller('ShareCtrl', function($scope, $injector, $modalInstance, $location, $timeout) {
      return require(['controllers/sharectrl'], function(sharectrl) {
        return $injector.invoke(sharectrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout
        });
      });
    }).controller('AuthCtrl', function($rootScope, $scope, $state, $injector, $modalInstance, $location, $timeout, $http, ipCookie) {
      return require(['controllers/authctrl'], function(authctrl) {
        return $injector.invoke(authctrl, this, {
          "$rootScope": $rootScope,
          "$scope": $scope,
          "$state": $state,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout,
          "$http": $http,
          "ipCookie": ipCookie
        });
      });
    }).controller('CreateCtrl', function($scope, $injector, $modalInstance, $location, $timeout, $state, $stateParams, $q) {
      return require(['controllers/createctrl'], function(createctrl) {
        return $injector.invoke(createctrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout,
          "$state": $state,
          "$stateParams": $stateParams,
          "$q": $q
        });
      });
    }).controller('FilterCtrl', function($scope, $injector, $timeout) {
      return require(['controllers/filterctrl'], function(filterctrl) {
        return $injector.invoke(filterctrl, this, {
          "$scope": $scope,
          "$timeout": $timeout
        });
      });
    }).controller('NewFilterCtrl', function($scope, $injector, $timeout, $q) {
      return require(['controllers/newfilterctrl'], function(newfilterctrl) {
        return $injector.invoke(newfilterctrl, this, {
          "$scope": $scope,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    }).controller('ContentCtrl', function($scope, $injector, $stateParams, $timeout, $state, $q) {
      return require(['controllers/contentctrl'], function(contentctrl) {
        return $injector.invoke(contentctrl, this, {
          "$scope": $scope,
          "$stateParams": $stateParams,
          "$timeout": $timeout,
          "$state": $state,
          "$q": $q
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
    }).controller('DeepResultCtrl', function($scope, $injector, $modalInstance, $location, $timeout, $q, $state) {
      return require(['controllers/deepresult'], function(deepresult) {
        return $injector.invoke(deepresult, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q,
          "$state": $state
        });
      });
    }).controller('SettingCtrl', function($scope, $modal, $injector, $location, $timeout, $q, $http) {
      return require(['controllers/settingctrl'], function(settingctrl) {
        return $injector.invoke(settingctrl, this, {
          "$scope": $scope,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q,
          "$modal": $modal,
          "$http": $http
        });
      });
    }).controller('ChangePassCtrl', function($scope, $injector, $modal, $location, $timeout, $q, $http) {
      return require(['controllers/changepassctrl'], function(changepassctrl) {
        return $injector.invoke(changepassctrl, this, {
          "$scope": $scope,
          "$modal": $modal,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q,
          "$http": $http
        });
      });
    }).controller('ChangePhotoCtrl', function($scope, $injector, $modal, $location, $timeout, $q, $upload) {
      return require(['controllers/changephotoctrl'], function(changephotoctrl) {
        return $injector.invoke(changephotoctrl, this, {
          "$scope": $scope,
          "$modal": $modal,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q,
          "$upload": $upload
        });
      });
    }).controller('FilterListCtrl', function($scope, $injector, $location, $timeout, $q) {
      return require(['controllers/filterlistctrl'], function(filterlistctrl) {
        return $injector.invoke(filterlistctrl, this, {
          "$scope": $scope,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    }).controller('TargetListCtrl', function($scope, $injector, $location, $timeout, $q) {
      return require(['controllers/targetlistctrl'], function(targetlistctrl) {
        return $injector.invoke(targetlistctrl, this, {
          "$scope": $scope,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    });
  });

}).call(this);
