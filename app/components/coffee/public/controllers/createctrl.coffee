define ['underscore'], ( _ )->
	($scope,$modalInstance,$location,$timeout,filters,question)->
		
		# --------------------- Functions for utility --------------------- #
		
		findSameOption = (item)->
			
			if item == newQuestion.newOption then true else false
				
		
		# ----------------- Scope functions and variables ----------------- #
		# ---  data --- #

		newQuestion = $scope.question = 
			newOption 			: ""
			question 			: ""
			options 			: []
			targets 			: []
				
		targets = $scope.targets = filters
			
		
		# --- variables  --- #
		
		$scope.showDetails 		= false

		utility = $scope.utility =
			confirm 			: 'Next'
			isOptionAdded 		: false
			isSameOptionFound  	: false
			isQuestionEmpty 	: false
			readyToMakeNewFilter: false
			isQuestionCreated	: false

		

		# --- functions --- #
		
		$scope.closeModal = ()->

			$scope.$dismiss()

			$timeout ->
				$location.path('/')

		$scope.createOption	= (option)->

			sameOptionFound = _.find(newQuestion.options,findSameOption)
			

			if option is "" or !option

				return false

			else if sameOptionFound 
				
				utility.isSameOptionFound = true 
			
			else 

				newQuestion.options.push(option)
				utility.isOptionAdded = true
				utility.isSameOptionFound = false 
				$timeout ->
					utility.isOptionAdded = false
				,500,true

			newQuestion.newOption = ''

		$scope.removeOption = (index)->

			newQuestion.options.splice(index,1)
			
		$scope.submitQuestion = ()->
			
			enoughOptions = false
			
			if _.size(newQuestion.options) >= 2
				
				enoughOptions = true


			if newQuestion.question is "" or !newQuestion.question or !enoughOptions
				
				utility.isQuestionEmpty = true	
			
			else

				utility.isQuestionEmpty 	= false
				utility.isQuestionCreated 	= true
				utility.confirm 		  	= 'Done'


		$scope.addFilter = (target)->
			
			target.isFilterAdded = !target.isFilterAdded

			if target.isFilterAdded 
				newQuestion.targets.push(target)
			else
				# remove the index #
				index = newQuestion.targets.indexOf(target)
				newQuestion.targets.splice(index,1)
			
			console.log question
			console.log filters


		$scope.back = ()->
			utility.isQuestionCreated = false
			utility.confirm = "Next"

		$scope.openCreateFilterBox = ()->

			utility.readyToMakeNewFilter = !utility.readyToMakeNewFilter

			

		# --- invoke the scope --- #
		
		$scope.$apply()


