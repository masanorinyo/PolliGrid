define [], ()->
	($scope,$stateParams,$modalInstance,$location,$timeout,Error,User)->
		
		switch $location.$$path.split('/')[1]
			when 'login' 
			then $scope.title = "Login"

			when 'signup' 
			then $scope.title = "Signup"

	
		$scope.alertMessage = Error.auth


		$scope.signin = ()->

			User.isLoggedIn = true

			$scope.$dismiss()
	
			# if there is a second parameter after signup or login
			if $location.$$path.split('/')[2]
				console.log $location.$$path.split('/')[2]
				newUrl = "deepResult/"+$stateParams.id

				$timeout ()->
					$location.path newUrl
				,300,true



		$scope.switch = (type)->
			
			# if the user is prompted to sign in or log in
			if $stateParams.id
				type = type+'/'+$stateParams.id


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


