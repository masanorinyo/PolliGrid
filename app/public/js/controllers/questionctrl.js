(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $stateParams, Question, User, Filters) {
      var foundQuestion, getColor, getData, questionId;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
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
      $scope.myChartData = [];
      $scope.myChartOptions = {
        animation: true,
        animationStep: 30,
        animationEasing: "easeOutQuart"
      };
      questionId = Number($stateParams.id);
      foundQuestion = _.findWhere(Question, {
        id: questionId
      });
      $scope.question = foundQuestion;
      return $scope.$apply();
    };
  });

}).call(this);
