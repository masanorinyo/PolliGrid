define [], ()->
	($scope,$modalInstance,$location,$timeout)->
		
		switch $location.$$path 
			when '/login' 
			then $scope.title = "Login"

			when '/signup' 
			then $scope.title = "Signup"
		
		

		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')


		$scope.$apply()


