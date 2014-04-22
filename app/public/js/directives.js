(function() {
  define(['angular', 'controllers'], function(angular, controllers) {
    return angular.module('myapp.directives', ['myapp.controllers']).directive('newFilter', function() {
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
        controller: function($scope) {
          return $timeout(function() {
            if ($scope.answered.alreadyAnswered) {
              return $scope.submitted = true;
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
        controller: function($scope) {
          return $timeout(function() {
            if ($scope.question.alreadyAnswered) {
              return $scope.num = -1;
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
        controller: function($scope) {
          return $timeout(function() {
            if ($scope.question.alreadyAnswered) {
              return $scope.showResult = true;
            }
          }, 550, true);
        }
      };
    });
  });

}).call(this);
