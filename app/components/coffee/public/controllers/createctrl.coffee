define ['underscore'], ( _ )->
	($scope,$modalInstance,$location,$timeout)->
		
		# --------------------- Functions for utility --------------------- #
		
		findSameOption = (item)->
			
			if item == question.newOption then true else false
				
		
		# ----------------- Scope functions and variables ----------------- #
		# --- variables  --- #
		
		utility = $scope.utility =
			confirm 			:'next'
			isOptionAdded 		: false
			isSameOptionFound  	: false
			isQuestionEmpty 	: false
			isQuestionCreated	: true
			readyToMakeNewFilter: true

		question = $scope.question = 
			
			newOption 			: ""
			question 			: ""
			options 			: []
			targets 			: []
			

		target = $scope.targets = [
			{
				title 			: "Age"
				question 		: "How old are you?"
				showDetails 	: false
				isFilterAdded 	: false
				lists:[

					"~ 10"
					"11 ~ 20"
					"21 ~ 30"
					"31 ~ 40"
					"41 ~ 50"
					"51 ~ 60"
					"61 ~ "
				]
			}
			{
				title: "Ethnicity"
				question: "What is your ethnicity?"
				lists:[

					"Asian"
					"Hispanic"
					"Caucasian"
					"African-American"
				]
			}
		]

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
				
				utility.isSameOptionFound = true 
			
			else 

				question.options.push(option)
				utility.isOptionAdded = true
				utility.isSameOptionFound = false 
				$timeout ->
					utility.isOptionAdded = false
				,500,true

			question.newOption = ''

		$scope.removeOption = (index)->

			question.options.splice(index,1)
			
		$scope.submitQuestion = ()->
			
			enoughOptions = false
			
			if _.size(question.options) >= 2
				
				enoughOptions = true


			if question.question is "" or !question.question or !enoughOptions
				
				utility.isQuestionEmpty = true	
			
			else

				utility.isQuestionEmpty = false
				utility.isQuestionCreated = true

		$scope.addFilter = (target)->
			
			target.isFilterAdded = !target.isFilterAdded

			if target.isFilterAdded 
				question.targets.push(target)
			else
				# remove the index #
				index = question.targets.indexOf(target)
				question.targets.splice(index,1)
			
			console.log question


		$scope.back = ()->
			utility.isQuestionCreated = false
			utility.confirm = "Next"


		# --- invoke the scope --- #
		
		$scope.$apply()


