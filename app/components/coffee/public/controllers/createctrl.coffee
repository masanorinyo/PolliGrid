define ['underscore'], ( _ )->
	($scope,$modalInstance,$location,$timeout)->
		
		# --------------------- Functions for utility --------------------- #
		findSameOption = (item)->
			
			if item == question.newAnswer then true else false
				
		
		# ----------------- Scope functions and variables ----------------- #
		# --- variables  --- #
		
		question = $scope.question = 
			
			newAnswer 			: ""
			problem 			: ""
			confirm 			: "next"
			options 			: []
			optionAdded 		: false
			alert_sameOption  	: false
			alert_emptyQuestion : false
			move_toTarget 		: true
			

		# --- functions --- #
		
		$scope.closeModal = ()->

			$scope.$dismiss()

			$timeout ->
				$location.path('/')


		$scope.createOption	= (option)->

			sameOptionFound = _.find(question.options,findSameOption)
			

			if option is "" or !option

				return false

			else if sameOptionFound 
				
				question.alert_sameOption = true 
			
			else 

				question.options.push(option)
				question.optionAdded = true
				question.alert_sameOption = false 
				$timeout ->
					question.optionAdded = false
				,500,true

			question.newAnswer = ''

		$scope.removeOption = (index)->

			question.options.splice(index,1)
			

		$scope.submitQuestion = ()->
			
			enoughOptions = false
			
			if _.size(question.options) >= 2
				
				enoughOptions = true


			if question.problem is "" or !question.problem or !enoughOptions
				
				question.alert_emptyQuestion = true	
			
			else

				question.alert_emptyQuestion = false
				question.move_toTarget = true


		$scope.back = ()->
			question.move_toTarget = false
			question.confirm = "Next"


		# --- invoke the scope --- #
		
		$scope.$apply()


