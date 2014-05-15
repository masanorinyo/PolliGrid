(function() {
  define(['underscore'], function(_) {
    return function($scope, $modal, $stateParams, $location, $q, $timeout, $upload, Question, User) {
      var ChangePhotoCtrl;
      ChangePhotoCtrl = function($scope) {
        $scope.closeModal = function() {
          return $scope.$dismiss();
        };
        console.log($scope.fileData = {
          name: User.user.username
        });
        return $scope.onFileSelect = function($files) {
          var $file, i;
          console.log('test');
          i = 0;
          console.log($files);
          while (i < $files.length) {
            console.log($file = $files[i]);
            $scope.upload = $upload.upload({
              url: "/api/uploadPhoto",
              method: "POST",
              data: {
                fileData: $scope.fileData
              },
              file: $file
            }).progress(function(evt) {
              console.log("percent: " + parseInt(100.0 * evt.loaded / evt.total));
            }).success(function(data, status, headers, config) {
              console.log(data);
            });
            i++;
          }
        };
      };
      $scope.openPhotoModal = function() {
        var modalInstance;
        return modalInstance = $modal.open({
          templateUrl: "views/modals/changePhotoModal.html",
          controller: ChangePhotoCtrl
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
