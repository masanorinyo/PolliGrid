define [], ()->
	($scope,question)->

		# models
		$scope.questions = question
		

		# scope variables
		$scope.isStarFilled = false

		$scope.searchQuestion = ''

		# scope functions

		$scope.searchByCategory = (category)->

			console.log $scope.searchQuestion

			$scope.searchQuestion = category

		$scope.fillStar = ()->
			
			$scope.isStarFilled = !$scope.isStarFilled
			
		$scope.$apply()


