define ['underscore'], (_)->
	($scope,Question,$window,$stateParams,$q,$timeout,$state)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		

		$scope.filteredQuestions = []


		
		$scope.downloadMoreContents = ()->
			
			$scope.$emit 'downloadMoreQuestions',"question"

		

		# ***************  Variables *************** #
		
			
		$scope.$apply()


