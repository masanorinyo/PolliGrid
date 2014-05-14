(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, $http, Question, User, Page, Filters, Error, Setting, FindQuestions, Verification) {
      var findQuestion, showAnswers, showDeepResult, showFavorites, showFilters, showQuestions;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.onMyPage = false;
      $scope.showLoader = false;
      $scope.anyContentsLeft = false;
      $http({
        method: "GET",
        url: "/api/getUser",
        params: {
          userId: $scope.id
        }
      }).success(function(user) {
        $scope.user = user;
        if ($scope.user._id === $scope.id) {
          return $scope.onMyPage = true;
        }
      });
      $scope.isAccessedFromSetting = true;
      Setting.isSetting = true;
      findQuestion = function() {
        return $http({
          method: "GET",
          url: "/api/findQuestionsByIds",
          params: {
            ids: $scope.requiredIds,
            offset: Page.questionPage
          }
        }).success(function(questions) {
          console.log($scope.questions);
          $scope.questions = questions;
          if (questions.length < 6) {
            return $scope.anyContentsLeft = true;
          }
        });
      };
      $scope.downloadMoreQuestions = function() {
        var ids, removeIndex;
        Page.questionPage += 6;
        ids = $scope.requiredIds;
        console.log('removeIndex');
        console.log(removeIndex = ids.length - Page.questionPage);
        if (removeIndex > 0) {
          ids = ids.splice(0, ids.length - Page.questionPage);
          $scope.showLoader = true;
          return $http({
            method: "GET",
            url: "/api/findQuestionsByIds",
            params: {
              ids: ids,
              offset: Page.questionPage
            }
          }).success(function(questions) {
            $scope.showLoader = false;
            if (!questions.length) {
              return $scope.anyContentsLeft = true;
            } else {
              return questions.forEach(function(val, key) {
                return $scope.questions.push(val);
              });
            }
          });
        } else {
          console.log('test');
          $scope.showLoader = false;
          return $scope.anyContentsLeft = true;
        }
      };
      showFavorites = $scope.showFavorites = function() {
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "favorites";
        $scope.questions = [];
        $scope.requiredIds = $scope.user.favorites;
        return findQuestion();
      };
      showQuestions = $scope.showQuestions = function() {
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "questions";
        $scope.questions = [];
        $scope.requiredIds = $scope.user.questionMade;
        console.log($scope.requiredIds);
        return findQuestion();
      };
      showAnswers = $scope.showAnswers = function() {
        var ids;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "answers";
        ids = _.pluck($scope.user.questionsAnswered, "_id");
        $scope.requiredIds = ids;
        return findQuestion();
      };
      showFilters = $scope.showFilters = function() {
        var ids;
        $scope.anyContentsLeft = false;
        $scope.type = "filters";
        $scope.questions = [];
        ids = _.pluck($scope.user.filterQuestionsAnswered, "_id");
        return $scope.filters = findQuestion(ids);
      };
      showDeepResult = $scope.showDeepResult = function(id) {
        var modalInstance;
        Setting.questionId = id;
        return modalInstance = $modal.open({
          templateUrl: 'views/modals/deepResultModal.html',
          controller: "DeepResultCtrl",
          windowClass: "deepResult"
        });
      };
      $scope.openShareModal = function(id) {
        var modalInstance;
        Setting.questionId = id;
        Setting.section = "setting/" + $scope.id + "/" + $scope.type;
        return modalInstance = $modal.open({
          templateUrl: 'views/modals/shareModal.html',
          controller: "ShareCtrl",
          windowClass: "shareModal"
        });
      };
      (function() {
        return $timeout(function() {
          if ($scope.type === "favorites" || $scope.type === "profile") {
            return showFavorites();
          } else if ($scope.type === "answers") {
            return showAnswers();
          } else if ($scope.type === "questions") {
            return showQuestions();
          } else if ($scope.type === "filters") {
            return showFilters();
          }
        });
      })();
      return $scope.$apply();
    };
  });

}).call(this);
