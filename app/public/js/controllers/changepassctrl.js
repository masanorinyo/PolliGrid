(function() {
  define(['underscore'], function(_) {
    return function($scope, $modal, $stateParams, $location, $q, $timeout, Question, User, Verification, Password, $http) {
      var ChangePassCtrl;
      ChangePassCtrl = function($scope) {
        $scope.rightOldPass = false;
        $scope.conditions = {
          length: false,
          same: false
        };
        $scope.warning = {
          oldPass: '',
          compare: '',
          length: ''
        };
        $scope.newPass = '';
        $scope.confirm = '';
        $scope.closeModal = function() {
          return $scope.$dismiss();
        };
        $scope.checkOldPass = function(oldPass) {
          $scope.rightOldPass = false;
          return Verification.checkPass({
            email: escape(User.user.local.email),
            pass: escape(oldPass)
          }).$promise.then(function(data) {
            console.log(data);
            if (data[0] === "t") {
              console.log('test');
              $scope.rightOldPass = true;
              return $scope.warning.oldPass = '';
            } else {
              $scope.rightOldPass = false;
              return $scope.warning.oldPass = "Wrong password";
            }
          });
        };
        return $scope.comparePass = function(newPass, confirm) {
          console.log(newPass);
          console.log(confirm);
          $scope.conditions.same = false;
          $scope.conditions.length = false;
          if (newPass === confirm) {
            $scope.conditions.same = true;
            $scope.warning.compare = '';
          } else {
            $scope.warning.compare = 'Please type the same passwords';
            $scope.rightNewPass = false;
          }
          if (confirm.length > 6) {
            $scope.conditions.length = true;
            $scope.warning.length = "";
          } else {
            $scope.conditions.length = false;
            $scope.warning.length = "Please type more than 6 characteres";
          }
          if ($scope.conditions.length && $scope.conditions.same && $scope.rightOldPass) {
            return Password.reset({
              email: escape(User.user.local.email),
              pass: escape(confirm)
            }).$promise.then(function(data) {
              console.log(data);
              return $scope.$dismiss();
            });
          }
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
