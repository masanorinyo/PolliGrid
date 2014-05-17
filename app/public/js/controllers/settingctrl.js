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
      $scope.anotherUser = {
        username: null,
        photo: null
      };
      $scope.questionsCreatedByAnother = [];
      $scope.filtersOnSettingPage = false;
      $scope.isAccessedFromSetting = true;
      $scope.filters = [];
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
          var defer;
          if ($scope.type !== "filters") {
            $scope.questions = data;
          } else {
            defer = $q.defer();
            defer.promise.then(function() {
              return _.each(data, function(targets) {
                return _.each(targets.lists, function(list) {
                  console.log(list);
                  console.log('test');
                  return list.option = unescape(list.option);
                });
              });
            }).then(function() {
              return console.log($scope.filters = data);
            }).then(function() {
              $scope.answer = [];
              return _.each($scope.user.filterQuestionsAnswered, function(filter, index) {
                return _.each($scope.filters, function(s_filter, s_index) {
                  if (s_filter._id === filter._id) {
                    return $scope.answer[s_index] = unescape(filter.answer);
                  }
                });
              });
            });
            defer.resolve();
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
                    console.log('test');
                    return $scope.questions.push(val);
                  } else {
                    defer = $q.defer();
                    defer.promise.then(function() {
                      return _.each(val.lists, function(list) {
                        return list.option = unescape(list.option);
                      });
                    }).then(function() {
                      console.log(val);
                      return $scope.filters.push(val);
                    });
                    return defer.resolve();
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
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "favorites";
        console.log($scope.user.favorites);
        $scope.questions = [];
        $scope.requiredIds = $scope.user.favorites;
        return findQuestion();
      };
      showQuestions = $scope.showQuestions = function() {
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "questions";
        console.log($scope.user.questionMade);
        $scope.questions = [];
        if (!$scope.onMyPage) {
          $scope.requiredIds = $scope.questionsCreatedByAnother;
        } else {
          $scope.requiredIds = $scope.user.questionMade;
        }
        return findQuestion();
      };
      showAnswers = $scope.showAnswers = function() {
        $scope.filtersOnSettingPage = false;
        $scope.anyContentsLeft = false;
        Page.questionPage = 0;
        $scope.type = "answers";
        $scope.requiredIds = _.pluck($scope.user.questionsAnswered, "_id");
        return findQuestion();
      };
      showFilters = $scope.showFilters = function() {
        $scope.filtersOnSettingPage = true;
        $scope.anyContentsLeft = false;
        Page.filterPage = 0;
        $scope.type = "filters";
        $scope.requiredIds = _.pluck($scope.user.filterQuestionsAnswered, "_id");
        return findQuestion();
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
      $scope.verificationBtn = "Send a verification E-mail";
      $scope.sendVerification = function() {
        $scope.verificationBtn = "E-mail sent";
        $timeout(function() {
          return $scope.verificationBtn = "Send a verification E-mail again";
        }, 1500, true);
        return $http({
          method: "POST",
          url: '/api/resend',
          data: {
            user: $scope.user
          }
        }).success(function(data) {});
      };
      (function() {
        return $http({
          method: "GET",
          url: "/api/getUser",
          params: {
            userId: $scope.id
          }
        }).success(function(user) {
          if (user._id === void 0) {
            return $location.path('/');
          } else {
            if (User.user._id === $scope.id) {
              $scope.user = User.user;
              $scope.onMyPage = true;
            } else {
              $scope.questionsCreatedByAnother = user.questionMade;
              $scope.anotherUser.username = user.username;
              $scope.anotherUser.photo = user.profilePic;
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
