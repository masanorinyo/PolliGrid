define ['underscore'], ( _ )->
	($scope,$timeout,filters,question)->
		
		findSameOption = (item)->
			
			if item == filterUtil.newList then true else false


		filterUtil = $scope.filterUtil = 
			newList 	 			: ""
			sameListFound 			: false
			isNotFilledOut 			: false

		newFilter = $scope.newFilter =
			
			title 			: ""
			question 		: ""
			isFilterAdded 	: true
			lists 			: []
			


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



				filterUtil.isNotFilledOut = false	
				
				filters.unshift(newFilter)
				$scope.question.targets.unshift(newFilter)
				question.unshift($scope.question)
				

				#this will hide the filter creation box
				$scope.utility.readyToMakeNewFilter = false

				$scope.$new(true)
				

				console.log newFilter
				console.log filters

		

		$scope.cancelToMakeFIlter = ()->
			$scope.utility.readyToMakeNewFilter = false	

		$scope.$apply()


