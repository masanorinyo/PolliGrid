(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $stateParams, $location, $timeout, Question) {
      var color, foundQuestion, getColor, getData, getInvertColor, questionId;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      getInvertColor = function(color) {
        color = color.substring(1);
        color = parseInt(color, 16);
        color = 0xFFFFFF ^ color;
        color = color.toString(16);
        color = ("000000" + color).slice(-6);
        color = "#" + color;
        return color;
      };
      getData = function() {
        var color, count, data, i, len, obj, ref, title;
        $scope.myChartData = [];
        ref = $scope.question.options;
        i = 0;
        len = ref.length;
        while (i < len) {
          obj = ref[i];
          count = obj.count;
          title = obj.title;
          color = getColor();
          data = {
            value: count,
            color: color,
            label: title,
            labelColor: "#FEFEFE",
            labelFontSize: "18",
            labelAlign: 'center'
          };
          $scope.myChartData.push(data);
          i++;
        }
      };
      $scope.groups = [
        {
          title: "Dynamic Group Header - 1",
          content: "Dynamic Group Body - 1",
          open: false
        }, {
          title: "Dynamic Group Header - 2",
          content: "Dynamic Group Body - 2",
          open: false
        }
      ];
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
          value: 35,
          color: color = getColor()
        }, {
          value: 100 - 35,
          color: getInvertColor(color)
        }
      ];
      $scope.oneAtATime = true;
      questionId = $stateParams.id;
      foundQuestion = _.findWhere(Question, Number(questionId));
      $scope.chartType = "pie";
      $scope.question = foundQuestion;
      $scope.filteredData = [
        {
          answer: null,
          count: 0
        }
      ];
      $scope.overallData = [
        {
          answer: null,
          count: 0
        }
      ];
      $scope.filterAdded = 'Add';
      $scope.openAccordion = function(index) {
        return $scope.groups[index].open = !$scope.groups[index].open;
      };
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
