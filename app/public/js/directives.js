(function() {
  define(['angular', 'controllers', 'underscore'], function(angular, controllers, _) {
    return angular.module('myapp.directives', ['myapp.controllers', 'myapp.services']).directive('newFilter', function() {
      return {
        restrict: 'EA',
        scope: true,
        templateUrl: 'views/partials/newfilter.html',
        controller: 'NewFilterCtrl'
      };
    }).directive('stopEvent', function() {
      return {
        restrict: 'A',
        link: function(scope, element, attr) {
          return element.bind(attr.stopEvent, function(e) {
            return e.stopPropagation();
          });
        }
      };
    }).directive('buttonOk', function() {
      return {
        restrict: 'A',
        replace: true,
        scope: true,
        transclude: true,
        link: function(scope, elem) {
          var clickingCallback;
          clickingCallback = function() {
            if (!elem.hasClass('bg-blue')) {
              elem.addClass('bg-blue');
              elem.children('i').addClass('glyphicon-ok');
              return elem.children('i').addClass('white');
            } else {
              elem.removeClass('bg-blue');
              elem.children('i').removeClass('glyphicon-ok');
              return elem.children('i').removeClass('white');
            }
          };
          return elem.bind('click', clickingCallback);
        }
      };
    }).directive('answered', function($timeout) {
      return {
        restrict: "A",
        scope: {
          answered: "=",
          submitted: "="
        },
        link: function(scope) {
          return $timeout(function() {
            if (scope.answered.alreadyAnswered) {
              return scope.submitted = true;
            }
          }, 500, true);
        }
      };
    }).directive('skipToResult', function($timeout) {
      return {
        restrict: "A",
        scope: {
          question: "=",
          num: "="
        },
        link: function(scope) {
          return $timeout(function() {
            if (scope.question.alreadyAnswered) {
              return scope.num = -1;
            }
          }, 520, true);
        }
      };
    }).directive('showResult', function($timeout) {
      return {
        restrict: "A",
        scope: {
          showResult: "=showResult",
          question: "="
        },
        link: function(scope) {
          return $timeout(function() {
            if (scope.question.alreadyAnswered) {
              return scope.showResult = true;
            }
          }, 550, true);
        }
      };
    }).directive('favorited', function($timeout, User) {
      return {
        restrict: "A",
        scope: {
          question: "=favorited"
        },
        link: function(scope) {
          return $timeout(function() {
            var foundUser;
            foundUser = _.find(scope.question.favoritedBy, function(id) {
              return Number(id) === Number(User.id);
            });
            console.log(foundUser);
            if (foundUser) {
              return scope.question.favorite = true;
            }
          }, 550, true);
        }
      };
    });
  });

}).call(this);
