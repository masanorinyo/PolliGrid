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
    }).directive('skipToResult', function($timeout, User) {
      return {
        restrict: "A",
        scope: {
          question: "=",
          num: "=",
          showResult: "=showResult",
          index: "@",
          answers: "="
        },
        link: function(scope) {
          return $timeout(function() {
            var i, length, targetIds;
            targetIds = _.pluck(scope.question.targets, 'id');
            length = scope.answers.length;
            i = 0;
            if (Number(scope.index) !== Number(scope.num)) {
              while (i < length) {
                if (Number(targetIds[scope.index]) === Number(scope.answers[i])) {
                  scope.num++;
                  scope.answers.splice(i, 1);
                  break;
                }
                i++;
              }
            }
            if (Number(scope.num) === Number(scope.question.numOfFilters)) {
              return scope.showResult = true;
            }
          }, 520, true);
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
            if (foundUser) {
              return scope.question.favorite = true;
            }
          }, 550, true);
        }
      };
    });
  });

}).call(this);
