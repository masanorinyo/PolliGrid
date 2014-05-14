(function() {
  define(['underscore'], function(_) {
    return function($scope, $location, $modal, $stateParams, $timeout, $http, $q, Question, User, Page, Filters, Error, Setting, FindQuestions, Verification, location) {
      var findQuestion, showAnswers, showDeepResult, showFavorites, showFilters, showQuestions;
      $scope.type = $stateParams.type;
      $scope.id = $stateParams.id;
      $scope.onMyPage = false;
      $scope.showLoader = false;
      $scope.anyContentsLeft = false;
      $scope.userLoaded = false;
      $scope.filtersOnSettingPage = false;
      $scope.isAccessedFromSetting = true;
      Setting.isSetting = true;
      findQuestion = function() {
        return $http({
          method: "GET",
          url: "/api/findQuestionsAndFiltersByIds",
          params: {
            ids: $scope.requiredIds,
            offset: 0,
            type: $scope.type
          }
        }).success(function(data) {
          if ($scope.type !== "filters") {
            $scope.questions = data;
          } else {
            $scope.filters = data;
          }
          if (data.length < 6) {
            return $scope.anyContentsLeft = true;
          }
        });
      };
      $scope.downloadMoreData = function() {
        var defer, ids, page, removeIndex;
        if ($scope.type !== "filters") {
          Page.questionPage += 5;
          page = Page.questionPage;
        } else {
          Page.filterPage += 5;
          page = Page.filterPage;
        }
        removeIndex = $scope.requiredIds.length - page;
        console.log(removeIndex);
        if (parseInt(removeIndex) > 0) {
          $scope.showLoader = true;
          ids = [];
          defer = $q.defer();
          defer.promise.then(function() {
            return $scope.requiredIds.forEach(function(val, key) {
              if (key > page && key < page + 6) {
                console.log(val);
                return ids.push(val);
              }
            });
          }).then(function() {
            return $http({
              method: "GET",
              url: "/api/findQuestionsAndFiltersByIds",
              params: {
                ids: ids,
                offset: page,
                type: $scope.type
              }
            }).success(function(data) {
              console.log('test');
              $scope.showLoader = false;
              if (!data.length) {
                return $scope.anyContentsLeft = true;
              } else {
                return data.forEach(function(val, key) {
                  if ($scope.type !== "filters") {
                    return $scope.questions.push(val);
                  } else {
                    return $scope.filters.push(val);
                  }
                });
              }
            });
          });
          return defer.resolve();
        } else {
          $scope.showLoader = false;
          return $timeout(function() {
            return $scope.anyContentsLeft = true;
          });
        }
      };
      showFavorites = $scope.showFavorites = function() {
        var url;
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "favorites";
        console.log($scope.user.favorites);
        url = 'setting/favorites/' + $scope.id;
        $scope.questions = [];
        $scope.requiredIds = $scope.user.favorites;
        return findQuestion();
      };
      showQuestions = $scope.showQuestions = function() {
        var url;
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "questions";
        console.log($scope.user.questionMade);
        url = 'setting/questions/' + $scope.id;
        $scope.questions = [];
        $scope.requiredIds = $scope.user.questionMade;
        return findQuestion();
      };
      showAnswers = $scope.showAnswers = function() {
        var url;
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "answers";
        url = 'setting/answers/' + $scope.id;
        $scope.requiredIds = _.pluck($scope.user.questionsAnswered, "_id");
        return findQuestion();
      };
      showFilters = $scope.showFilters = function() {
        var defer, url;
        $scope.filtersOnSettingPage = true;
        $scope.anyContentsLeft = false;
        Page.filterPage = 0;
        $scope.type = "filters";
        url = 'setting/filters/' + $scope.id;
        $scope.requiredIds = _.pluck($scope.user.filterQuestionsAnswered, "_id");
        defer = $q.defer();
        defer.promise.then(function() {
          return findQuestion();
        }).then(function() {
          $scope.answer = [];
          return _.each($scope.user.filterQuestionsAnswered, function(filter, index) {
            return _.each($scope.filters, function(s_filter, s_index) {
              if (s_filter._id === filter._id) {
                return $scope.answer[s_index] = filter.answer;
              }
            });
          });
        });
        return defer.resolve();
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
        return $http({
          method: "GET",
          url: "/api/getUser",
          params: {
            userId: $scope.id
          }
        }).success(function(user) {
          $scope.user = user;
          if (user._id === void 0) {
            return $location.path('/');
          } else {
            if (User.user._id === $scope.id) {
              $scope.user = User.user;
              $scope.onMyPage = true;
            }
            $scope.userLoaded = true;
            if ($scope.type === "favorites" || $scope.type === "profile") {
              return showFavorites();
            } else if ($scope.type === "answers") {
              return showAnswers();
            } else if ($scope.type === "questions") {
              return showQuestions();
            } else if ($scope.type === "filters") {
              return showFilters();
            }
          }
        });
      })();
      return $scope.$apply();
    };
  });

}).call(this);
