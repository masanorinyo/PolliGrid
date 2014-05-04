(function() {
  define(['angular', 'services'], function(angular) {
    return angular.module('myapp.controllers', ['myapp.services']).controller('WhichOneCtrl', function($sce, $scope, $location, $stateParams, $timeout, $state, User) {
      $scope.searchQuestion = '';
      $scope.user = User;
      $scope.refresh = function() {
        $location.path('/');
        return $timeout(function() {
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        }, 100, true);
      };
      return $scope.logout = function() {
        User.id = 0;
        User.name = '';
        User.email = '';
        User.password = '';
        User.profilePic = "";
        User.isLoggedIn = false;
        User.favorites = [];
        User.questionMade = [];
        User.questionsAnswered = [];
        User.filterQuestionsAnswered = [];
        $location.path('/');
        return $timeout(function() {
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        }, 100, true);
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
    }).controller('CreateCtrl', function($scope, $injector, $modalInstance, $location, $timeout, $state, $stateParams) {
      return require(['controllers/createctrl'], function(createctrl) {
        return $injector.invoke(createctrl, this, {
          "$scope": $scope,
          "$modalInstance": $modalInstance,
          "$location": $location,
          "$timeout": $timeout,
          "$state": $state,
          "$stateParams": $stateParams
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
    }).controller('ContentCtrl', function($scope, $injector, $stateParams, $timeout, $state) {
      return require(['controllers/contentctrl'], function(contentctrl) {
        return $injector.invoke(contentctrl, this, {
          "$scope": $scope,
          "$stateParams": $stateParams,
          "$timeout": $timeout,
          "$state": $state
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
    }).controller('SettingCtrl', function($scope, $modal, $injector, $location, $timeout, $q) {
      return require(['controllers/settingctrl'], function(settingctrl) {
        return $injector.invoke(settingctrl, this, {
          "$scope": $scope,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q,
          "$modal": $modal
        });
      });
    }).controller('ChangePassCtrl', function($scope, $injector, $modal, $location, $timeout, $q) {
      return require(['controllers/changepassctrl'], function(changepassctrl) {
        return $injector.invoke(changepassctrl, this, {
          "$scope": $scope,
          "$modal": $modal,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q
        });
      });
    }).controller('ChangePhotoCtrl', function($scope, $injector, $modal, $location, $timeout, $q) {
      return require(['controllers/changephotoctrl'], function(changephotoctrl) {
        return $injector.invoke(changephotoctrl, this, {
          "$scope": $scope,
          "$modal": $modal,
          "$location": $location,
          "$timeout": $timeout,
          "$q": $q
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
