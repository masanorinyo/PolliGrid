(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $stateParams, $location, $q, $timeout, Question) {
      var foundQuestion, getColor, getData, getInvertColor, getPercentage, questionId;
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
      getPercentage = function(num, overall) {
        var percentage;
        return percentage = Math.floor((num / overall) * 100);
      };
      getData = function(message) {
        var color, count, data, i, len, obj, ref, title;
        $scope.myChartDataDeep = [];
        $scope.myChartInfo.datasets[1].data = [];
        if (message === 'createOverallPieData') {
          ref = $scope.question.options;
        } else {
          ref = $scope.filterGroup.answers;
        }
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
          if (message === 'createOverallPieData') {
            $scope.myChartDataOverall.push(data);
          } else {
            $scope.myChartDataDeep.push(data);
          }
          if ($scope.foundRespondents) {
            $scope.myChartInfo.datasets[1].data.push(count);
          }
          i++;
        }
        if (!$scope.foundRespondents) {
          _.each($scope.filterGroup.answers, function(obj) {
            return obj.count = 0;
          });
        }
        if (i <= 2 && $scope.foundRespondents) {
          $scope.myChartInfo.datasets[1].data.push(0);
        }
      };
      $scope.myChartInfo = {
        labels: [],
        datasets: [
          {
            fillColor: "rgba(220,220,220,0.5)",
            strokeColor: "rgba(220,220,220,1)",
            pointColor: "rgba(220,220,220,1)",
            pointStrokeColor: "#fff",
            data: []
          }, {
            fillColor: "rgba(151,187,205,0.5)",
            strokeColor: "rgba(151,187,205,1)",
            pointColor: "rgba(151,187,205,1)",
            pointStrokeColor: "#fff",
            data: []
          }
        ]
      };
      $scope.donutDataOverall = [];
      $scope.donutDataFiltered = [];
      $scope.filters = [];
      $scope.filterGroup = {
        total: 0,
        filters: [],
        answers: []
      };
      $scope.myChartDataOverall = [];
      $scope.filterAdded = true;
      $scope.oneAtATime = true;
      $scope.pieChartOptions = {
        animationEasing: "easeOutQuart"
      };
      $scope.radarChartOptions = {
        scaleShowLabels: true,
        pointLabelFontSize: 12,
        pointLabelFontColor: "rgb(120,120,120)",
        scaleFontSize: 13,
        scaleFontColor: "rgb(56,121,217)",
        scaleOverlay: true
      };
      $scope.lineChartOptions = {
        scaleShowLabels: true,
        scaleFontFamily: "'Arial'",
        scaleFontSize: 9,
        scaleFontColor: "#666"
      };
      $scope.donutOption = {
        percentageInnerCutout: 50,
        showTooltips: false,
        animation: false
      };
      questionId = $stateParams.id;
      foundQuestion = _.findWhere(Question, Number(questionId));
      $scope.chartType = "pie";
      $scope.filterAdded = false;
      $scope.question = foundQuestion;
      $scope.filterAdded = 'Add to filter';
      $scope.filterCategories = [];
      $scope.foundRespondents = false;
      $scope.isFiltered = false;
      $scope.addFilter = function(answer, target) {
        var category, defer, filter, filters, foundCategory, i, index, length, sameIdFound, test, users;
        users = $scope.question.respondents;
        filters = $scope.filterGroup.filters;
        answer.isAdded = !answer.isAdded;
        if (answer.isAdded) {
          $scope.foundRespondents = true;
          foundCategory = _.findWhere($scope.filterCategories, {
            categoryTitle: target.title
          });
          if (foundCategory) {
            foundCategory.options.push(answer.option);
          } else {
            category = {
              categoryTitle: target.title,
              options: [answer.option]
            };
            $scope.filterCategories.push(category);
          }
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
          foundCategory = _.findWhere($scope.filterCategories, {
            categoryTitle: target.title
          });
          index = foundCategory.options.indexOf(answer.option);
          foundCategory.options.splice(index, 1);
          if (foundCategory.options.length === 0) {
            $scope.filterCategories = _.without($scope.filterCategories, foundCategory);
          }
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
          $scope.filterGroup.total = 0;
          $scope.foundRespondents = false;
        } else {
          $scope.filterGroup.total = users.length;
        }
        defer = $q.defer();
        test = [];
        defer.promise.then(function() {
          var data;
          data = [];
          _.each($scope.question.options, function(option, index) {
            data[index] = option.answeredBy;
            return _.each($scope.filterGroup.filters, function(filter) {
              return data[index] = _.intersection(data[index], filter.respondents);
            });
          });
          return _.each(data, function(filteredRespondents, index) {
            return $scope.filterGroup.answers[index].count = filteredRespondents.length;
          });
        }).then(function() {
          return getData('filtered');
        }).then(function() {
          var sumOfFilteredData;
          sumOfFilteredData = 0;
          $scope.donutDataFiltered = [];
          _.each($scope.filterGroup.answers, function(obj) {
            return sumOfFilteredData += obj.count;
          });
          console.log("Number of filters added : " + sumOfFilteredData);
          return _.each($scope.filterGroup.answers, function(obj) {
            var filteredDataForDonut, percentage;
            percentage = parseInt(getPercentage(obj.count, sumOfFilteredData));
            console.log("Percentage " + percentage);
            filteredDataForDonut = [
              {
                label: obj.title,
                value: percentage,
                color: "rgb(100,150,245)"
              }, {
                label: obj.title,
                value: 100 - percentage,
                color: "rgb(235,235,235)"
              }
            ];
            $scope.donutDataFiltered.push(filteredDataForDonut);
            return console.log($scope.donutDataFiltered);
          });
        });
        return defer.resolve();
      };
      (function() {
        var data, i, length, targetId, targetTitle, targets;
        getData('createOverallPieData');
        _.each($scope.question.options, function(option) {
          $scope.myChartInfo.labels.push(option.title);
          return $scope.myChartInfo.datasets[0].data.push(option.count);
        });
        if ($scope.myChartInfo.labels.length <= 2) {
          $scope.myChartInfo.labels.push('');
          $scope.myChartInfo.datasets[0].data.push(0);
        }
        length = $scope.question.targets.length;
        i = 0;
        _.each($scope.question.options, function(obj) {
          var answer;
          answer = {
            title: obj.title,
            count: 0
          };
          return $scope.filterGroup.answers.push(answer);
        });
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
          i++;
        }
        return _.each($scope.question.options, function(obj) {
          var filteredDataForDonut, overallDataForDonut, percentage;
          percentage = parseInt(getPercentage(obj.count, $scope.question.totalResponses));
          overallDataForDonut = [
            {
              label: obj.title,
              value: percentage,
              color: "rgb(100,250,245)"
            }, {
              label: obj.title,
              value: 100 - percentage,
              color: "rgb(235,235,235)"
            }
          ];
          filteredDataForDonut = [
            {
              label: obj.title,
              value: 0,
              color: "rgb(100,150,245)"
            }, {
              label: obj.title,
              value: 100,
              color: "rgb(235,235,235)"
            }
          ];
          $scope.donutDataOverall.push(overallDataForDonut);
          return $scope.donutDataFiltered.push(filteredDataForDonut);
        });
      })();
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
