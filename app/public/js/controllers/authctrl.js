(function() {
  define([], function() {
    return function($rootScope, $scope, $stateParams, $modalInstance, $location, $timeout, Error, User, $http, ipCookie, $state, Verification) {
      var closeDownModal, makeCookie, transformToRealUser;
      switch ($location.$$path.split('/')[1]) {
        case 'login':
          $scope.title = "Login";
          break;
        case 'signup':
          $scope.title = "Signup";
      }
      $scope.alertMessage = Error.auth;
      $scope.newUser = {
        remember_me: true
      };
      $scope.user = User.visitor;
      $scope.warning = {
        password: null,
        email: null,
        unkwown: null
      };
      $scope.somethingWrongWith = {
        login: false,
        signup: false,
        reset: false
      };
      $scope.success = false;
      $scope.forgotPass = false;
      makeCookie = function(data) {
        if ($scope.newUser.remember_me) {
          return ipCookie("loggedInUser", data, {
            expires: 365
          });
        } else {
          return ipCookie("loggedInUser", data);
        }
      };
      closeDownModal = function() {
        $scope.$dismiss();
        Error.auth = '';
        return $timeout(function() {
          $location.path('/');
          return $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
        });
      };
      transformToRealUser = function(data) {
        var userId;
        if (User.visitor.questionsAnswered.length || User.visitor.filterQuestionsAnswered.length) {
          userId = data._id;
          console.log('Transformation began');
          return $http({
            url: "/api/visitorToGuest",
            method: "PUT",
            data: {
              userId: userId,
              questions: $scope.user.questionsAnswered,
              filters: $scope.user.filterQuestionsAnswered,
              visitorId: User.visitor._id
            }
          }).success(function(data) {
            console.log('Transformation done');
            console.log(data);
            return $http({
              url: "/api/getUser",
              method: "GET",
              params: {
                userId: userId
              }
            }).success(function(loggedInUser) {
              var newUrl;
              console.log("successful");
              loggedInUser.isLoggedIn = true;
              User.user = loggedInUser;
              $scope.user = User.user;
              $rootScope.$broadcast('userLoggedIn', User);
              if ($stateParams.id) {
                newUrl = '/deepResult/' + $stateParams.id;
                $location.path(newUrl);
                $timeout(function() {
                  $state.transitionTo($state.current, $stateParams, {
                    reload: true,
                    inherit: false,
                    notify: true
                  });
                  return Error.auth = '';
                }, 100, true);
                return Error.auth = '';
              } else {
                return $scope.closeModal();
              }
            });
          });
        } else {
          console.log('Transformation err');
          console.log(data);
          User.user = data;
          console.log($scope.user.questionsAnswered);
          $rootScope.$broadcast('userLoggedIn', User);
          return $scope.closeModal();
        }
      };
      $scope.signup = function(data) {
        var all_conditions, check_allConditions, condition_length, noSameEmail;
        all_conditions = false;
        condition_length = false;
        noSameEmail = false;
        check_allConditions = function(condition_length, noSameEmail) {
          if (condition_length && noSameEmail) {
            $scope.somethingWrongWith.signup = false;
            data.visitorId = User.visitor._id;
            return $http({
              method: 'POST',
              url: '/api/auth/signup',
              data: $.param(data),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
                'X-Requested-With': 'XMLHttpRequest'
              }
            }).success(function(data) {
              var randLetter, uniqid;
              $scope.somethingWrongWith.signup = false;
              data.isLoggedIn = true;
              makeCookie(data);
              transformToRealUser(data);
              randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
              uniqid = randLetter + Date.now();
              return User.visitor._id = uniqid;
            }).error(function(data) {
              $scope.somethingWrongWith.signup = true;
              $scope.warning = console.log("err");
              return console.log(data);
            });
          } else {
            $scope.somethingWrongWith.signup = true;
            return $scope.warning.unknown = "Something is wrong";
          }
        };
        if (data.password.length > 6) {
          $scope.warning.password = null;
          condition_length = true;
        } else {
          $scope.somethingWrongWith.signup = true;
          $scope.warning.password = "- Password - Pleaes type more than 6 characters";
        }
        return Verification.findUserByEmail({
          email: escape(data.email)
        }).$promise.then(function(data) {
          console.log('ready?');
          if (data.length === 0) {
            console.log('success');
            $scope.warning.email = null;
            noSameEmail = true;
            return check_allConditions(condition_length, noSameEmail);
          } else {
            console.log('fail');
            $scope.somethingWrongWith.signup = true;
            $scope.warning.email = "- The Email is already used";
            return noSameEmail = false;
          }
        });
      };
      $scope.login = function(data) {
        console.log('succesfully logged in');
        data.visitorId = User.visitor._id;
        return $http({
          method: 'POST',
          url: '/api/auth/login',
          data: $.param(data),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          }
        }).success(function(data) {
          var randLetter, uniqid;
          $scope.somethingWrongWith.login = false;
          data.isLoggedIn = true;
          makeCookie(data);
          transformToRealUser(data);
          randLetter = String.fromCharCode(65 + Math.floor(Math.random() * 26));
          uniqid = randLetter + Date.now();
          return User.visitor._id = uniqid;
        }).error(function(data) {
          console.log("err");
          console.log(data);
          return $scope.somethingWrongWith.login = true;
        });
      };
      $scope.toggleForm = function() {
        return $scope.forgotPass = !$scope.forgotPass;
      };
      $scope.resetPass = function(registeredUser) {
        console.log(registeredUser);
        return $http({
          method: "POST",
          url: "/api/reset",
          data: $.param(registeredUser),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-Requested-With': 'XMLHttpRequest'
          }
        }).success(function(data) {
          if (data === "fail") {
            $scope.somethingWrongWith.reset = true;
            return $timeout(function() {
              return $scope.somethingWrongWith.reset = false;
            }, 3000, true);
          } else {
            $scope.success = true;
            return $timeout(function() {
              return $scope.success = false;
            }, 3000, true);
          }
        }).error(function(data) {
          $scope.somethingWrongWith.reset = true;
          return $timeout(function() {
            return $scope.somethingWrongWith.reset = false;
          }, 3000, true);
        });
      };
      $scope["switch"] = function(type) {
        if ($stateParams.id) {
          type = type + '/' + $stateParams.id;
        }
        $scope.$dismiss();
        return $timeout(function() {
          $location.path(type);
          return Error.auth = '';
        }, 100, true);
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        $location.path('/');
        return $timeout(function() {
          $state.transitionTo($state.current, $stateParams, {
            reload: true,
            inherit: false,
            notify: true
          });
          return Error.auth = '';
        }, 100, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
