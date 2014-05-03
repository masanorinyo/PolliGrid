define ['underscore'], (_)->
	($scope,$location,$q,$timeout,Question,User)->
		

		# ------------- Scope Function ------------- #

		$scope.fadeOut = false
		$scope.answerChanged = false
		$scope.changeAnswer = (answer,filter)->
			
			answeredFilter = _.findWhere User.filterQuestionsAnswered,{id:filter.id}
			
			answeredFilter.answer = answer

			

			
			
			$scope.answerChanged = true
			$timeout ->
				$scope.fadeOut = true
			,1000,true

			$timeout ->
				$scope.answerChanged = false
			,2000,true				
			



		# -------------- Invoke Scope --------------#
		$scope.$apply()