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
		Verification
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
		$scope.warning = 
			password 	: null
			email 		: null
			unkwown 	: null
		$scope.somethingWrongWith = 
			login 		: false
			signup 		: false


		# --------------------- util functions --------------------- #

		makeCookie = (data)->
			if $scope.newUser.remember_me

				ipCookie("loggedInUser",data,{expires:365})
			
			else 

				ipCookie("loggedInUser",data)
		
		closeDownModal = ->

			$scope.$dismiss()
			
			Error.auth = ''
			
			$timeout ->
			
				# reload the page
				$state.transitionTo($state.current, $stateParams, {
					reload: true
					inherit: false
					notify: true
				})


			

		transformToRealUser = (data)->
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


		# --------------------- scope functions --------------------- #

		$scope.signup = (data)->
			all_conditions = false	
			condition_length = false
			noSameEmail = false

			check_allConditions = (condition_length,noSameEmail)->
						

				if condition_length && noSameEmail
				
					$scope.somethingWrongWith.signup = false
	
					$http
						method  : 'POST',
						url     : '/api/auth/signup',
						data    : $.param(data)
						headers : 
							'Content-Type': 'application/x-www-form-urlencoded'
							'X-Requested-With' : 'XMLHttpRequest'
						
					.success (data)-> 
						console.log 'succesfully registered'
						console.log data
						$scope.somethingWrongWith.signup = false
						data.isLoggedIn = true

						# whether user clicked "remember me" or not
						makeCookie(data)

						# if user answer to questions when in the visitor's state
						# pass the data to the user
						transformToRealUser(data)

						# close the modal and refresh the page
						closeDownModal()

					.error (data)-> 
						$scope.somethingWrongWith.signup = true
						$scope.warning = 
						console.log "err"
						console.log data

				else

					$scope.somethingWrongWith.signup = true
					$scope.warning.unknown = "Something is wrong"

			if data.password.length > 6
				
				$scope.warning.password = null
				condition_length = true
			
			else	
				$scope.somethingWrongWith.signup = true
				$scope.warning.password = "- Password - Pleaes type more than 6 characters"

			
			Verification.findUserByEmail({email:escape(data.email)}).$promise.then (data)->
					console.log 'ready?'
					if data.length == 0
						console.log 'success'
						$scope.warning.email = null
						noSameEmail = true

						check_allConditions(condition_length,noSameEmail)

					else
						console.log 'fail'
						$scope.somethingWrongWith.signup = true
						$scope.warning.email = "- The Email is already used" 
						noSameEmail = false
						
			



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
				$scope.somethingWrongWith.login = false
				data.isLoggedIn = true

				# whether user clicked "remember me" or not
				makeCookie(data)

				# if user answer to questions when in the visitor's state
				# pass the data to the user
				transformToRealUser(data)

				# close the modal and refresh the page
				closeDownModal()

			.error (data)-> 
				console.log "err"
				console.log data
				$scope.somethingWrongWith.login = true



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


