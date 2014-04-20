define ['underscore'], ( _ )->
	($scope,$timeout,filters,question)->
		
		# --------------------- utility functions --------------- #
		
		findSameOption = (item)->
			
			if item == filterUtil.newList then true else false


		# --------------------- scope variables --------------- #

		filterUtil = $scope.filterUtil = 
			newList 	 			: ""
			sameListFound 			: false
			isNotFilledOut 			: false

		newFilter = $scope.newFilter = 
			
			title 			: ""
			question 		: ""
			lists 			: []
			

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
				
				
				clone_newFilter = angular.copy(newFilter)

				$scope.targets.unshift(clone_newFilter)

				
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


