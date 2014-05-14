(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, $http, Question, User, Page, Filters, Error, Setting, FindQuestions) {
      var findQuestion, showAnswers, showDeepResult, showFavorites, showFilters, showQuestions;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.anyContentsLeft = false;
      if (User.user) {
        $scope.user = User.user;
      } else {
        $location.path('/');
      }
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
          return $scope.questions = questions;
        });
      };
      $scope.downloadMoreQuestions = function() {
        console.log(Page.questionPage += 6);
        $scope.showLoader = true;
        return $http({
          method: "GET",
          url: "/api/findQuestionsByIds",
          params: {
            ids: $scope.requiredIds,
            offset: Page.questionPage
          }
        }).success(function(questions) {
          if (!questions.length) {
            $scope.anyContentsLeft = true;
            $scope.showLoader = false;
          }
          return $scope.questions.push(questions);
        });
      };
      showFavorites = $scope.showFavorites = function() {
        Page.questionPage = 0;
        $scope.type = "favorites";
        $scope.questions = [];
        $scope.requiredIds = $scope.user.favorites;
        return findQuestion();
      };
      showQuestions = $scope.showQuestions = function() {
        Page.questionPage = 0;
        $scope.type = "questions";
        $scope.questions = [];
        $scope.requiredIds = $scope.user.questionMade;
        return findQuestion();
      };
      showAnswers = $scope.showAnswers = function() {
        var ids;
        Page.questionPage = 0;
        $scope.type = "answers";
        ids = _.pluck($scope.user.questionsAnswered, "_id");
        $scope.requiredIds = ids;
        return findQuestion();
      };
      showFilters = $scope.showFilters = function() {
        var ids;
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
