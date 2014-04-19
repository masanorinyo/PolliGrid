define [], ()->
	($scope,question)->

		$scope.isStarFilled = false

		$scope.questions = question

		$scope.fillStar = ()->
			
			$scope.isStarFilled = !$scope.isStarFilled
			
		$scope.$apply()


