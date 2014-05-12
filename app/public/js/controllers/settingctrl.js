(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, Question, User, Filters, Error, Setting) {
      var findQuestion, showAnswers, showDeepResult, showFavorites, showFilters, showQuestions;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.user = User.user;
      $scope.isAccessedFromSetting = true;
      Setting.isSetting = true;
      findQuestion = function(target, requiredIds) {
        var questions;
        questions = [];
        _.each(requiredIds, function(requiredId) {
          var foundQuestion;
          foundQuestion = _.findWhere(target, {
            id: requiredId
          });
          return questions.push(foundQuestion);
        });
        return questions;
      };
      showFavorites = $scope.showFavorites = function() {
        $scope.type = "favorites";
        $location.path('setting/' + $scope.id + "/favorites");
        return $scope.questions = findQuestion(Question, User.favorites);
      };
      showQuestions = $scope.showQuestions = function() {
        $scope.type = "questions";
        $location.path('setting/' + $scope.id + "/questions");
        return $scope.questions = findQuestion(Question, User.questionMade);
      };
      showAnswers = $scope.showAnswers = function() {
        var ids;
        $scope.type = "answers";
        $location.path('setting/' + $scope.id + "/answers");
        ids = _.pluck(User.questionsAnswered, "_id");
        return $scope.questions = findQuestion(Question, ids);
      };
      showFilters = $scope.showFilters = function() {
        var ids;
        $scope.type = "filters";
        $location.path('setting/' + $scope.id + "/filters");
        $scope.questions = [];
        ids = _.pluck(User.filterQuestionsAnswered, "_id");
        $scope.filters = findQuestion(Filters, ids);
        $scope.answer = [];
        return _.each(User.filterQuestionsAnswered, function(filter, index) {
          console.log(filter.answer);
          return $scope.answer[index] = filter.answer;
        });
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
        if ($scope.type === "favorites" || $scope.type === "profile") {
          return showFavorites();
        } else if ($scope.type === "answers") {
          return showAnswers();
        } else if ($scope.type === "questions") {
          return showQuestions();
        } else if ($scope.type === "filters") {
          return showFilters();
        }
      })();
      return $scope.$apply();
    };
  });

}).call(this);
