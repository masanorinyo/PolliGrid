define ['underscore'], ( _ )->
	($scope,$timeout,Filters,Question)->
		
		# --------------------- utility functions --------------- #
		
		findSameOption = (item)->
			
			if item == filterUtil.newList then true else false


		# --------------------- scope variables --------------- #

		filterUtil = $scope.filterUtil = 
			newList 	 			: ""
			sameListFound 			: false
			isNotFilledOut 			: false

		newFilter = $scope.newFilter = 
			id 				: null
			title 			: ""
			question 		: ""
			respondents 	: []
			lists 			: []
			created_at	 	: Date
			

		# --------------------- scope functions --------------- #
		
		$scope.addNewList = (list)->
			
			sameOptionFound = _.find(newFilter.lists,findSameOption)


			if list is "" or !list

				return false

			else if sameOptionFound 
				
				filterUtil.sameListFound = true 
			
			else
				newFilter.lists.push(list)
				filterUtil.newList = ""
				filterUtil.sameListFound = false

		$scope.submitNewFilter = (newFilter)->
			
			enoughOptions = false

			if _.size(newFilter.lists) >= 2
				
				enoughOptions = true

			else

				filterUtil.isNotFilledOut = true


			if newFilter.title is "" or !newFilter.title
				
				filterUtil.isNotFilledOut = true
			
			else if newFilter.question is "" or !newFilter.question

				filterUtil.isNotFilledOut = true	

			else if enoughOptions


				filterUtil.isNotFilledOut 	= false	
				
				#clone the newly created filter
				clone_newFilter = angular.copy(newFilter)
				clone_newFilter.created_at = new Date().getTime()

				# development purpose -> once connected with MongoDB
				# this will be removed because MongoDB will do this task
				clone_newFilter.id = Math.random()

				# add it to the filter list
				$scope.targets.unshift(clone_newFilter)
				
				console.log $scope.targets
				#clean up after submitting the data					
				newFilter.title 			= ""
				newFilter.question  		= ""
				newFilter.lists 			= []

				#this will hide the filter creation box
				$scope.utility.readyToMakeNewFilter = false
				

		$scope.removeList = (index)->
			newFilter.lists.splice(index,1)

		$scope.cancelToMakeFIlter = ()->
			$scope.utility.readyToMakeNewFilter = false	

		$scope.$apply()


