define ['underscore'], (_)->
	(
		$scope
		$location
		$q
		$timeout
		Question
		User
		UpdateUserInfo
	)->
		

		# ------------- Scope Function ------------- #

		$scope.fadeOut = false
		$scope.answerChanged = false
		$scope.changeAnswer = (answer,filter)->
			
			answeredFilter = _.findWhere User.user.filterQuestionsAnswered,{_id:filter._id}
			console.log answeredFilter._id
			console.log answer
			answeredFilter.answer = answer
			

			UpdateUserInfo.changeFilter(
				userId : User.user._id 
				filterId : answeredFilter._id
				filterAnswer : answer
			)

			$scope.answerChanged = true
			$timeout ->
				$scope.answerChanged = false
			,2000,true				
			



		# -------------- Invoke Scope --------------#
		$scope.$apply()