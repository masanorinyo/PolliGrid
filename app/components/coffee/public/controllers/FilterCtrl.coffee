define ['underscore'], ( _ )->
	($scope,$timeout,Filters,Question,User)->
		
		# -- for target audience section --#

		$scope.filterAdded = false

		#this will add a filter to the question
		$scope.addFilter = (target)->
			
			console.log $scope.question

			foundSameTarget = false
			

			$scope.filterAdded = !$scope.filterAdded

			# check to see if the same filter is attached with the question.
			foundSameTarget = _.find($scope.question.targets,(item)->
				
				_.isEqual(item,target)

			)

			if _.isUndefined(foundSameTarget) or !foundSameTarget
				
				# attach it to the question
				$scope.question.targets.push(target)				

			else
				
				# if found with the question, then remove it.				
				index = $scope.question.targets.indexOf(target)	
				$scope.question.targets.splice(index,1)
			

		
		# --- invoke the scope --- #
		
		$scope.$apply()


