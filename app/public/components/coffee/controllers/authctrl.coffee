define [], ()->
	($rootScope,$scope,$stateParams,$modalInstance,$location,$timeout,Error,User,$http)->
		
		switch $location.$$path.split('/')[1]
			when 'login' 
			then $scope.title = "Login"

			when 'signup' 
			then $scope.title = "Signup"

		console.log $scope.user
		$scope.alertMessage = Error.auth
		$scope.newUser = 
			remember_me : true

		$scope.user = User.visitor

		
		
		$scope.signup = (data)->
			console.log 'test'
			

		$scope.login = (data)->
			console.log data
			$http
				method  : 'POST',
				url     : '/api/auth/login',
				data    : $.param(data)
				headers : 
					'Content-Type': 'application/x-www-form-urlencoded'
					'X-Requested-With' : 'XMLHttpRequest'
				
			.success (data)-> 
				console.log "success"
				console.log data
				User.user = data
				User.user.isLoggedIn = true
				
				if $scope.user.questionsAnswered.length
					# check to see if there is any duplicate answer in the server
					console.log $scope.user.questionsAnswered

				if $scope.user.filterQuestionsAnswered.length
					# check to see if there is any duplicate answer in the server
					console.log $scope.user.filterQuestionsAnswered

				$rootScope.$broadcast 'userLoggedIn',User
				$scope.user = User.user

				$scope.$dismiss()
				$timeout ->
					$location.path('/')
					Error.auth = ''

				,100,true



			.error (data)-> 
				console.log "err"
				console.log data



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


