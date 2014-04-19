define [], ()->
	($scope,question)->

		$scope.isStarFilled = false

		questions = $scope.questions = question

		$scope.fillStar = ()->
			$scope.isStarFilled = !$scope.isStarFilled
			console.log(questions)
		$scope.$apply()


