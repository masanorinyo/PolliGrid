define [], ()->
	($scope,$modalInstance,$location,$timeout,Error)->
		
		switch $location.$$path 
			when '/login' 
			then $scope.title = "Login"

			when '/signup' 
			then $scope.title = "Signup"
		
		
		$scope.alertMessage = Error.auth


		$scope.switch = (type)->
			$scope.$dismiss()
			$timeout ->
				$location.path(type)
				Error.auth = ''

			,100,true

		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')
				Error.auth = ''

			,100,true


		$scope.$apply()


