(function() {
  define(['underscore'], function(_) {
    return function($scope, Question) {
      var getColor;
      getColor = function() {
        return '#' + (0x1000000 + (Math.random()) * 0xffffff).toString(16).substr(1, 6);
      };
      $scope.num = 0;
      $scope.showResult = false;
      $scope.targetAnswer = "";
      $scope.myChartData = [];
      $scope.submitTarget = function(question, targetAnswer) {
        var answer, color, i, newValue, num, targetQuestionID, _i, _len, _ref, _results;
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
            _ref = question.options;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              i = _ref[_i];
              num = question.options[i].count;
              color = getColor();
              newValue = {
                value: num,
                color: color
              };
              _results.push($scope.myChartData.push(newValue));
            }
            return _results;
          } else {
            $scope.num++;
            return $scope.user.filterQuestionsAnswered.push(answer);
          }
        }
      };
      $scope.resetAnswer = function(question) {
        $scope.num = 0;
        $scope.showResult = false;
        return $scope.$emit('resetAnswer', question);
      };
      return $scope.$apply();
    };
  });

}).call(this);
