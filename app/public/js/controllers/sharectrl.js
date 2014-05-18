(function() {
  define([], function() {
    return function($scope, $modalInstance, $stateParams, $location, $timeout, Setting, Question) {
      var link, lists, question, sharableLink;
      if (Setting.questionId) {
        $scope.questionId = Setting.questionId;
      } else {
        $scope.questionId = $stateParams.id;
      }
      link = window.location.origin;
      sharableLink = $scope.sharableLink = link.concat("/#/question/", $scope.questionId);
      $scope.showShareForm = false;
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
      lists = '';
      question = '';
      Question.get({
        questionId: $scope.questionId
      }).$promise.then(function(data) {
        question = data.question.concat("\n");
        return _.each(data.option, function(option, index) {
          var bullet;
          bullet = "[" + index + "] - ";
          return lists = lists.concat(bullet, option.title, "\n");
        });
      }).then(function(data) {
        var text;
        text = question + " - " + sharableLink;
        text = escape(text);
        $scope.twitterShareText = 'https://twitter.com/intent/tweet?text=' + text;
        $scope.googleShareText = "https://plus.google.com/share?url=" + sharableLink;
        return $scope.showShareForm = true;
      });
      $scope.shareFacebook = function() {
        return FB.ui({
          method: 'feed',
          name: question,
          link: sharableLink,
          picture: "http://www.hyperarts.com/external-xfbml/share-image.gif",
          caption: lists,
          description: "PolliGrid lets you analyze people's optinions from different angles",
          message: ''
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
