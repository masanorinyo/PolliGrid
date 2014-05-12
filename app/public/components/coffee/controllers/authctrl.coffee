define [], ()->
	($rootScope,$scope,$stateParams,$modalInstance,$location,$timeout,Error,User,$http,$cookieStore)->
		
		switch $location.$$path.split('/')[1]
			when 'login' 
			then $scope.title = "Login"

			when 'signup' 
			then $scope.title = "Signup"

		console.log User.user
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
				
				data.isLoggedIn = true

				console.log "success"
				console.log data

				$cookieStore.put("loggedInUser",data)
				User.user = data
				
				if $scope.user.questionsAnswered.length
					# check to see if there is any duplicate answer in the server
					# and add the answers to the user info
					# in case of users resetting their answers
					# replace the answeredby user id of the questino with the loggedin user's
					console.log $scope.user.questionsAnswered


				if $scope.user.filterQuestionsAnswered.length
					# check to see if there is any duplicate answer in the server
					# and add the answers to the user info
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


