define ['underscore'], ( _ )->
	($scope,$modalInstance,$location,$timeout)->
		
		# --------------------- Functions for utility --------------------- #
		findSameOption = (item)->
			
			if item == question.newAnswer then true else false
				
		
		# ----------------- Scope functions and variables ----------------- #
		# --- variables  --- #

		options = $scope.options = []

		question = $scope.question = ()->
			
			newAnswer 		: ""
			problem 		: ""
			alertBox  		: false
			added 			: false

		# --- functions --- #
		
		$scope.closeModal = ()->

			$scope.$dismiss()

			$timeout ->
				$location.path('/')

			console.log(question.newAnswer)


		$scope.createOption	= (option)->

			sameOptionFound = _.find(options,findSameOption)
			question.newAnswer = ''
			
			if sameOptionFound
				
				question.alertBox = true 
			
			else 
				question.added = true
				question.alertBox = false 
				options.push(option)



		# --- invoke the scope --- #
		
		$scope.$apply()


