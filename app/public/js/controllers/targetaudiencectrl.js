(function() {
  define(['underscore'], function(_) {
    return function($scope, $timeout, $q, Question) {
      var getColor, getData, getInvertColor;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      getInvertColor = function(hexTripletColor) {
        var color;
        color = hexTripletColor;
        color = color.substring(1);
        color = parseInt(color, 16);
        color = 0xFFFFFF ^ color;
        color = color.toString(16);
        color = ("000000" + color).slice(-6);
        color = "#" + color;
        return color;
      };
      $scope.num = 0;
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.myChartOptions = {
        animation: true,
        animationStep: 100,
        animationEasing: "easeOutQuart"
      };
      $scope.myChartData = [];
      getData = function() {
        var color, count, data, invertColor, obj, title, _i, _len, _ref;
        $scope.myChartData = [];
        _ref = $scope.question.options;
        _i = 0;
        _len = _ref.length;
        while (_i < _len) {
          obj = _ref[_i];
          count = obj.count;
          title = obj.title;
          color = getColor();
          invertColor = getInvertColor(color);
          data = {
            value: count,
            color: color,
            label: title,
            labelColor: invertColor,
            labelFontSize: "20"
          };
          $scope.myChartData.push(data);
          _i++;
        }
      };
      (function() {
        return getData();
      })();
      $scope.submitTarget = function(question, targetAnswer) {
        var answer, targetQuestionID;
        if (targetAnswer === "" || !targetAnswer) {
          return $scope.warning = true;
        } else {
          $scope.warning = false;
          targetQuestionID = question.targets[$scope.num].id;
          answer = {
            id: targetQuestionID,
            answer: targetAnswer
          };
          if ($scope.num === question.numOfFilters - 1) {
            $scope.num = question.numOfFilters;
            $scope.user.filterQuestionsAnswered.push(answer);
            $scope.showResult = true;
            $scope.question.alreadyAnswered = true;
            return getData();
          } else {
            $scope.num++;
            return $scope.user.filterQuestionsAnswered.push(answer);
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.num = 0;
        $scope.showResult = false;
        $scope.question.alreadyAnswered = false;
        return $scope.$emit('resetAnswer', question);
      };
      return $scope.$apply();
    };
  });

}).call(this);
