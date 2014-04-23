(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $stateParams, $location, $timeout, Question) {
      var foundQuestion, questionId;
      questionId = $stateParams.id;
      foundQuestion = _.findWhere(Question, Number(questionId));
      $scope.question = foundQuestion;
      $scope.myChartDataDeep = [
        {
          value: 30,
          color: "#F7464A"
        }, {
          value: 50,
          color: "#E2EAE9"
        }, {
          value: 100,
          color: "#D4CCC5"
        }, {
          value: 40,
          color: "#949FB1"
        }, {
          value: 120,
          color: "#4D5360"
        }
      ];
      $scope.chart = {
        labels: ["Monday", "Tuesday", '', '', '', ''],
        datasets: [
          {
            fillColor: "rgba(151,187,205,0)",
            strokeColor: "#e67e22",
            pointColor: "rgba(151,187,205,0)",
            pointStrokeColor: "#e67e22",
            data: [4, 3, 0, 0, 0, 0]
          }, {
            fillColor: "rgba(151,187,205,0)",
            strokeColor: "#f1c40f",
            pointColor: "rgba(151,187,205,0)",
            pointStrokeColor: "#f1c40f",
            data: [8, 3, 0, 0, 0, 0]
          }
        ]
      };
      $scope.donutOption = {
        percentageInnerCutout: 50,
        animation: false,
        animationSteps: 100,
        animationEasing: "easeOutBounce",
        animateRotate: true,
        animateScale: false,
        onAnimationComplete: null
      };
      $scope.donutData = [
        {
          value: 30,
          color: "#F7464A",
          label: 'test',
          labelColor: "#FEFEFE",
          labelFontSize: "18",
          labelAlign: 'center'
        }, {
          value: 50,
          color: "#E2EAE9"
        }, {
          value: 100,
          color: "#D4CCC5"
        }, {
          value: 40,
          color: "#949FB1"
        }, {
          value: 120,
          color: "#4D5360"
        }
      ];
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          return $location.path('/');
        });
      };
      return $scope.$apply();
    };
  });

}).call(this);
