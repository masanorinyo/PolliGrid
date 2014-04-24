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
        labels: ["Eating", "Drinking", "Sleeping", "Designing", "Coding", "Partying", "Running"],
        datasets: [
          {
            fillColor: "rgba(220,220,220,0.5)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            data: [65, 59, 90, 81, 56, 55, 40]
          }, {
            fillColor: "rgba(151,187,205,0.5)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            data: [28, 48, 40, 19, 96, 27, 100]
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
      $scope.radarChartOptions = {
        scaleShowLabels: true,
        pointLabelFontSize: 9,
        pointLabelFontColor: "rgb(120,120,120)",
        scaleFontSize: 9,
        scaleFontColor: "rgb(120,120,120)"
      };
      $scope.lineChartOptions = {
        scaleShowLabels: true,
        scaleFontFamily: "'Arial'",
        scaleFontSize: 9,
        scaleFontColor: "#666"
      };
      $scope.filterAdded = true;
      $scope.oneAtATime = true;
      questionId = $stateParams.id;
      foundQuestion = _.findWhere(Question, Number(questionId));
      $scope.chartType = "pie";
      $scope.filterAdded = false;
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
      $scope.filters = [];
      $scope.filterGroup = [];
      $scope.filterAdded = 'Add to filter';
      (function() {
        var data, i, length, targetId, targetTitle, targets, _results;
        length = $scope.question.targets.length;
        i = 0;
        _results = [];
        while (i < length) {
          targets = [];
          targetId = $scope.question.targets[i].id;
          targetTitle = $scope.question.targets[i].title;
          _.each($scope.question.targets[i].lists, function(num) {
            var optionData;
            optionData = {
              option: num.option,
              answeredBy: num.answeredBy,
              numOfResponses: num.answeredBy.length,
              isAdded: false,
              filterBtn: "Add to filter"
            };
            return targets.push(optionData);
          });
          data = {
            id: targetId,
            title: targetTitle,
            numOfAdded: 0,
            lists: targets
          };
          $scope.filters.push(data);
          _results.push(i++);
        }
        return _results;
      })();
      $scope.filterGroup = {
        total: 0,
        filters: [],
        answers: {
          answer: null,
          count: 0
        }
      };
      $scope.addFilter = function(answer, target) {
        var filter, filters, i, length, sameIdFound, users;
        users = $scope.question.respondents;
        filters = $scope.filterGroup.filters;
        answer.isAdded = !answer.isAdded;
        if (answer.isAdded) {
          answer.filterBtn = "Remove filter";
          target.numOfAdded += answer.numOfResponses;
          filter = {
            id: target.id,
            respondents: answer.answeredBy
          };
          sameIdFound = _.findWhere(filters, {
            id: target.id
          });
          if (sameIdFound) {
            sameIdFound.respondents = _.union(sameIdFound.respondents, answer.answeredBy);
          } else {
            $scope.filterGroup.filters.push(filter);
          }
        } else {
          console.log('removed');
          answer.filterBtn = "Add to filter";
          target.numOfAdded -= answer.numOfResponses;
          sameIdFound = _.findWhere(filters, {
            id: target.id
          });
          sameIdFound.respondents = _.difference(sameIdFound.respondents, answer.answeredBy);
          if (sameIdFound.respondents.length === 0) {
            console.log('NO RESPONDENTS');
            filters = _.without(filters, _.findWhere(filters, {
              id: target.id
            }));
          }
        }
        $scope.filterGroup.filters = filters;
        length = $scope.filterGroup.filters.length;
        i = 0;
        while (i < length) {
          users = _.intersection(users, $scope.filterGroup.filters[i].respondents);
          i++;
        }
        if ($scope.filterGroup.filters.length === 0) {
          return $scope.filterGroup.total = 0;
        } else {
          return $scope.filterGroup.total = users.length;
        }
      };
      $scope.closeModal = function() {
        $scope.$dismiss();
        return $timeout(function() {
          return $location.path('/');
        }, 500, true);
      };
      return $scope.$apply();
    };
  });

}).call(this);
