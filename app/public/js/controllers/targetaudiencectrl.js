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
      $scope.myChartData = [
        {
          value: 30,
          color: "#F38630",
          label: 'Yo yo yo yo yo',
          labelColor: 'black',
          labelFontSize: '12'
        }, {
          value: 50,
          color: "#E0E4CC",
          label: 'HELLO super \nagative omg ',
          labelColor: 'black',
          labelFontSize: '12'
        }, {
          value: 100,
          color: "#69D2E7",
          label: 'HELLO',
          labelColor: 'black',
          labelFontSize: '12'
        }
      ];
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
            return $scope.showResult = true;
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
