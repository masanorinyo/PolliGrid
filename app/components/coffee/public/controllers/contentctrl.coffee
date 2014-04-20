define ['underscore'], (_)->
	($scope,question)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		$scope.questions = question
		
		$scope.answer = ''
		

		# ***************  Variables *************** #
		$scope.isStarFilled = false
		$scope.submitted = false

		targetQ = $scope.targetQ =
			isQuestionAnswered : false





		# ***************  Functions *************** #
		$scope.submitAnswer = (choice,question)->
			
			choice.count++
			question.totalResponses++
			
			$scope.submitted = true
		

		

		$scope.fillStar = (question)->
			
			question.favorite = !question.favorite
			
		$scope.$apply()


