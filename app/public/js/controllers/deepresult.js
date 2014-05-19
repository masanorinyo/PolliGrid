(function() {
  define(['underscore'], function(_) {
    return function($scope, $modalInstance, $stateParams, $location, $q, $timeout, Question, Setting, $state) {
      var getColor, getData, getPercentage, questionId;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
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
          ref = $scope.question.option;
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
      $scope.showMessageBox = false;
      $scope.pieChartOptions = {
        animationEasing: "easeOutQuart",
        animation: false
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
      console.log(Setting.isSetting);
      if (Setting.isSetting) {
        questionId = Setting.questionId;
      } else {
        questionId = $stateParams.id;
      }
      $scope.chartType = "pie";
      $scope.filterAdded = false;
      console.log(questionId);
      $scope.filterAdded = 'Add to filter';
      $scope.filterCategories = [];
      $scope.foundRespondents = false;
      $scope.isFiltered = false;
      $scope.buttonMessage = "See comments";
      $scope.showMessages = function() {
        $scope.showMessageBox = !$scope.showMessageBox;
        if ($scope.showMessageBox) {
          return $scope.buttonMessage = "Back to result";
        } else {
          return $scope.buttonMessage = "See comments";
        }
      };
      $scope.addFilter = function(answer, target) {
        var category, defer, filter, filters, foundCategory, i, index, length, sameIdFound, users;
        users = $scope.question.respondents;
        filters = $scope.filterGroup.filters;
        answer.isAdded = !answer.isAdded;
        console.log(filters);
        if (answer.isAdded) {
          $scope.foundRespondents = true;
          foundCategory = _.findWhere($scope.filterCategories, {
            categoryTitle: target.title
          });
          if (foundCategory) {
            foundCategory.option.push(answer.option);
          } else {
            category = {
              categoryTitle: target.title,
              option: [answer.option]
            };
            $scope.filterCategories.push(category);
          }
          answer.filterBtn = "Remove filter";
          target.numOfAdded += answer.numOfResponses;
          filter = {
            _id: target._id,
            respondents: answer.answeredBy
          };
          sameIdFound = _.findWhere(filters, {
            _id: target._id
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
          index = foundCategory.option.indexOf(answer.option);
          foundCategory.option.splice(index, 1);
          if (foundCategory.option.length === 0) {
            $scope.filterCategories = _.without($scope.filterCategories, foundCategory);
          }
          answer.filterBtn = "Add to filter";
          target.numOfAdded -= answer.numOfResponses;
          sameIdFound = _.findWhere(filters, {
            _id: target._id
          });
          sameIdFound.respondents = _.difference(sameIdFound.respondents, answer.answeredBy);
          if (sameIdFound.respondents.length === 0) {
            filters = _.without(filters, _.findWhere(filters, {
              _id: target._id
            }));
          }
        }
        $scope.filterGroup.filters = filters;
        length = $scope.filterGroup.filters.length;
        i = 0;
        while (i < length) {
          users = _.uniq(_.intersection(users, $scope.filterGroup.filters[i].respondents));
          i++;
        }
        if ($scope.filterGroup.filters.length === 0) {
          $scope.filterGroup.total = 0;
          $scope.foundRespondents = false;
        } else {
          $scope.filterGroup.total = users.length;
        }
        defer = $q.defer();
        defer.promise.then(function() {
          var data;
          data = [];
          _.each($scope.question.option, function(option, index) {
            data[index] = option.answeredBy;
            return _.each($scope.filterGroup.filters, function(filter) {
              return data[index] = _.uniq(_.intersection(data[index], filter.respondents));
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
            sumOfFilteredData += obj.count;
            console.log("sumOfFilteredData");
            return console.log(sumOfFilteredData);
          });
          return _.each($scope.filterGroup.answers, function(obj) {
            var filteredDataForDonut, percentage;
            percentage = parseInt(getPercentage(obj.count, sumOfFilteredData));
            if (isNaN(parseFloat(percentage))) {
              percentage = 0;
            }
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
            return $scope.donutDataFiltered.push(filteredDataForDonut);
          });
        });
        return defer.resolve();
      };
      (function() {
        var defer;
        defer = $q.defer();
        defer.promise.then(function() {
          $scope.question = Question.get({
            questionId: escape(questionId)
          });
          return $scope.question.$promise.then(function(data) {
            return console.log(data);
          });
        }).then(function() {
          var data, i, length, targetId, targetTitle, targets;
          getData('createOverallPieData');
          _.each($scope.question.option, function(option) {
            $scope.myChartInfo.labels.push(option.title);
            return $scope.myChartInfo.datasets[0].data.push(option.count);
          });
          if ($scope.myChartInfo.labels.length <= 2) {
            $scope.myChartInfo.labels.push('');
            $scope.myChartInfo.datasets[0].data.push(0);
          }
          length = $scope.question.targets.length;
          i = 0;
          _.each($scope.question.option, function(obj) {
            var answer;
            answer = {
              title: obj.title,
              count: 0
            };
            return $scope.filterGroup.answers.push(answer);
          });
          while (i < length) {
            targets = [];
            targetId = $scope.question.targets[i]._id;
            targetTitle = $scope.question.targets[i].title;
            _.each($scope.question.targets[i].lists, function(num) {
              var optionData;
              num.answeredBy = _.intersection(num.answeredBy, $scope.question.respondents);
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
              _id: targetId,
              title: targetTitle,
              numOfAdded: 0,
              lists: targets
            };
            $scope.filters.push(data);
            i++;
          }
          return _.each($scope.question.option, function(obj) {
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
        });
        return defer.resolve();
      })();
      $scope.closeModal = function() {
        return $scope.$dismiss();
      };
      return $scope.$apply();
    };
  });

}).call(this);
