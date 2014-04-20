define ['underscore'], (_)->
	($scope,question)->

		$scope.num = 0
		$scope.showResult = false

		$scope.submitTarget = (question)->

			if $scope.num == question.numOfFilters-1

				$scope.num = question.numOfFilters
				$scope.showResult = true

			else

				$scope.num++	

		$scope.$apply()


