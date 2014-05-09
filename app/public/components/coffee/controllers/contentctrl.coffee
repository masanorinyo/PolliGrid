define ['underscore'], (_)->
	($scope,Question,$window,$stateParams,$q,$timeout,$state)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		

		$scope.filteredQuestions = []

		$scope.showLoader = false

		$scope.isContentsLoaded = true

		
		$scope.downloadMoreContents = ()->
			$scope.showLoader = true
			defer = $q.defer()
			defer.promise
				
				.then -> download()
				
				.then -> 
					$scope.showLoader = false


			defer.resolve()

		

		# ***************  Variables *************** #
		
			
		$scope.$apply()


