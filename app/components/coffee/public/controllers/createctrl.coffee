define ['underscore','jquery'], ( _,$ )->
	($scope,$modalInstance,$location,$timeout,filters,question)->
		
		# --------------------- Functions for utility --------------------- #
		
		findSameOption = (item)->
			
			if item == newQuestion.newOption then true else false

						
		# ----------------- Scope functions and variables ----------------- #
		# ***************  data *************** #



		questions = $scope.questions = question

		newQuestion = $scope.question = 
			
			newOption 			: ""
			question 			: ""
			options 			: []
			targets 			: []
				
		targets = $scope.targets = filters
			
		
		# *************** variables  *************** #
		style = $scope.style = false

		$scope.showDetails 		= false

		utility = $scope.utility =

			isOptionAdded 		: false
			isSameOptionFound  	: false
			isQuestionEmpty 	: false
			readyToMakeNewFilter: false
			isCreatingQuestion  : false
			isQuestionCreated	: true
			isQuestionCompleted	: false

		

		# *************** functions *************** #
		
		# -- applies to all modal sections --#
		
		$scope.closeModal = ()->

			$scope.$dismiss()

			$timeout ->
				$location.path('/')

		
		# -- for create question section --#
			
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
			

		# -- for target audience section --#

		$scope.addFilter = (target)->
			
			foundSameTarget = false
			
			foundSameTarget = _.find(newQuestion.targets,(item)->
				
				_.isEqual(item,target)

			)

			# if found, then remove it
			if _.isUndefined(foundSameTarget) or !foundSameTarget
				
				newQuestion.targets.push(target)				

			else
				
				index = newQuestion.targets.indexOf(target)	
				newQuestion.targets.splice(index,1)
			

			
			

		$scope.openCreateFilterBox = ()->

			utility.readyToMakeNewFilter = !utility.readyToMakeNewFilter


		# -- actions taken by confirmation buttons --#

		$scope.submitQuestion = ()->
			
			enoughOptions = false
			
			if _.size(newQuestion.options) >= 2
				
				enoughOptions = true


			if newQuestion.question is "" or !newQuestion.question or !enoughOptions
				
				utility.isQuestionEmpty = true	
			
			else

				utility.isQuestionEmpty 	= false
				utility.isCreatingQuestion 	= false
				utility.isQuestionCreated 	= true


		$scope.completeQuestion = ()->
			questions.unshift(newQuestion)
			utility.isQuestionCreated 		= false
			utility.isQuestionCompleted 	= true			

		# -- actions taken by back buttons --#

		$scope.backToCreateQuestion = ()->
			
			utility.isCreatingQuestion 	= true
			utility.isQuestionCreated 	= false

		$scope.backToTargetAudience = ()->
			
			utility.isQuestionCompleted = false
			utility.isQuestionCreated 	= true

		

			

		# --- invoke the scope --- #
		
		$scope.$apply()


