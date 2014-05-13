define [], ()->
	(
		$rootScope
		$scope
		$stateParams
		$modalInstance
		$location
		$timeout
		Error
		User
		$http
		ipCookie
		$state
	)->
		
		switch $location.$$path.split('/')[1]
			when 'login' 
			then $scope.title = "Login"

			when 'signup' 
			then $scope.title = "Signup"

		
		$scope.alertMessage = Error.auth
		$scope.newUser = 
			remember_me : true

		$scope.user = User.visitor

		
		
		$scope.signup = (data)->
			console.log 'test'
			

		$scope.login = (data)->

			$http
				method  : 'POST',
				url     : '/api/auth/login',
				data    : $.param(data)
				headers : 
					'Content-Type': 'application/x-www-form-urlencoded'
					'X-Requested-With' : 'XMLHttpRequest'
				
			.success (data)-> 
				console.log 'succesfully logged in'
				console.log data
				data.isLoggedIn = true

				

				if $scope.newUser.remember_me

					ipCookie("loggedInUser",data,{expires:365})
				
				else 

					ipCookie("loggedInUser",data)
				
				
				if User.visitor.questionsAnswered.length || User.visitor.filterQuestionsAnswered.length
					
					console.log "User.visitor.questionsAnswered.length"
					console.log User.visitor.questionsAnswered.length

					userId = data._id

					# check to see if there is any duplicate answer in the server
					$http
						url 	: "/api/visitorToGuest"
						method 	: "PUT"
						data 	: {
							userId 	: userId
							questions : $scope.user.questionsAnswered
							filters : $scope.user.filterQuestionsAnswered
						} 

					.success (data)->
						
						# get the updated user information
						$http 
							url 	: "/api/getUser"
							method 	: "GET"
							params 	: {userId: userId}

						.success (loggedInUser)-> 
							loggedInUser.isLoggedIn = true
							User.user = loggedInUser
							$rootScope.$broadcast 'userLoggedIn',User
							

				else

					User.user = data

					# and add the answers to the user info
					# in case of users resetting their answers
					# replace the answeredby user id of the questino with the loggedin user's
					console.log $scope.user.questionsAnswered
					$rootScope.$broadcast 'userLoggedIn',User

				# if $scope.user.filterQuestionsAnswered.length
				# 	# check to see if there is any duplicate answer in the server
					
				# 	# and add the answers to the user info
				# 	console.log $scope.user.filterQuestionsAnswered



				
				

				
				$scope.$dismiss()
				$location.path('/')
				Error.auth = ''
				
				$timeout ->
					
					# reload the page
					$state.transitionTo($state.current, $stateParams, {
						reload: true
						inherit: false
						notify: true
					})

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


