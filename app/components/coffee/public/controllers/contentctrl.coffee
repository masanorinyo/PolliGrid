define [], ()->
	($scope)->
		$scope.content = "content"
		$scope.isStarFilled = false

		$scope.fillStar = ()->
			$scope.isStarFilled = !$scope.isStarFilled
			console.log($scope.isStarFilled)
		$scope.$apply()


