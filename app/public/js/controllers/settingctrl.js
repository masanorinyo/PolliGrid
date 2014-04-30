(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, Question, User, Filters, Error) {
      var findQuestion, showAnswers, showDeepResult, showFavorites, showFilters, showQuestions;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.user = User;
      $scope.isAccessedFromSetting = true;
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
        ids = _.pluck(User.questionsAnswered, "id");
        return $scope.questions = findQuestion(Question, ids);
      };
      showFilters = $scope.showFilters = function() {
        var ids;
        $scope.type = "filters";
        $location.path('setting/' + $scope.id + "/filters");
        $scope.questions = [];
        ids = _.pluck(User.filterQuestionsAnswered, "id");
        $scope.filters = findQuestion(Filters, ids);
        $scope.answer = [];
        return _.each(User.filterQuestionsAnswered, function(filter, index) {
          console.log(filter.answer);
          return $scope.answer[index] = filter.answer;
        });
      };
      showDeepResult = $scope.showDeepResult = function(id) {
        var modalInstance;
        return modalInstance = $modal.open({
          templateUrl: 'views/modals/deepResultModal.html',
          controller: "DeepResultCtrl",
          windowClass: "deepResult"
        });
      };
      (function() {
        if ($scope.type === "favorites" || $scope.type === "profile") {
          console.log('i am favorite');
          return showFavorites();
        } else if ($scope.type === "answers") {
          console.log('i am answers');
          return showAnswers();
        } else if ($scope.type === "questions") {
          console.log('i am questions');
          return showQuestions();
        } else if ($scope.type === "filters") {
          console.log('i am filter');
          return showFilters();
        }
      })();
      return $scope.$apply();
    };
  });

}).call(this);
