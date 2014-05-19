define(
	[

		'angular'
		'app'
		'underscore'
		
	]

	(angular,app,_)->
		
		
		app.config ($stateProvider,$urlRouterProvider,$locationProvider)->
			
			# url = $locationProvider.hashPrefix("!") + url	
			$stateProvider
				
				.state 'home',

					url:"/"
						
					views:

						'header':

							templateUrl:'views/partials/header.html'
							
						
						'content':

							templateUrl:'views/partials/content.html'
							controller:'ContentCtrl'						

						# "result@home":
							
						# 	templateUrl :'views/partials/targetQuestions.html'
						# 	controller:'TargetAudienceCtrl'
					
					
					
				.state 'home.login',
					url:'login'
					onEnter:(ipCookie,$state,$modal,$stateParams,$location,Error,User)->
						
						console.log ipCookie('user')

						if User.user

							$location.path('/')

						else 
							$modal.open(
							
								templateUrl : 'views/modals/authmodal.html'
								controller 	: "AuthCtrl"
								windowClass : "authModal "
							
							).result.then ()->
	  						
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')
								Error.auth = ''

				.state 'home.loginRedirect',
					url:'login/:id'
					onEnter:($state,$modal,$stateParams,$location,Error,User)->
						
						if User.user

							$location.path '/deepResult/'+$stateParams.id
							
						else	

							$modal.open(
							
								templateUrl : 'views/modals/authmodal.html'
								controller 	: "AuthCtrl"
								windowClass : "authModal "
							
							).result.then ()->
	  						
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')
								Error.auth = ''
  							
				.state 'home.signup',
					url:'signup'
					onEnter:($state,$modal,$stateParams,$location,Error,User)->
						if User.user

							$location.path('/')

						else 

							$modal.open(
								
								templateUrl : 'views/modals/authmodal.html'
								controller 	: "AuthCtrl"
								windowClass : 'authModal'
							
							).result.then ()->
	  						
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')
								Error.auth = ''

				.state 'home.signupRedirect',
					url:'signup/:id'
					onEnter:($state,$modal,$stateParams,$location,Error,User)->
						if User.user
							
							newUrl = '/deepResult/'+$stateParams.id
							$location.path(newUrl)

						else
							Error.auth = "You need to sign up or login to proceed"
							$modal.open(
								
								templateUrl : 'views/modals/authmodal.html'
								controller 	: "AuthCtrl"
								windowClass : 'authModal'
							
							).result.then ()->
	  						
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')
								Error.auth = ''

				.state "verify",
					
					url:'/verification/:type/:result'

					onEnter:($stateParams,$location,Account)->
						result = $stateParams.result
						type = $stateParams.type
						console.log 'test'

						if type == "email"
							if result == "success"
								Account.verifiedMessage("Your account is successfully verified",'success')
								$location.path('/')
							else if result == "fail"
								Account.verifiedMessage("Account verification failed",'fail')
								$location.path('/')
							else if result == "resetFail"
								Account.verifiedMessage("The reset password token is not valid",'fail')
								$location.path('/')
						
						else if type =="pass"
						
							if result == "success"
								Account.verifiedMessage("Your password is reset",'success')
								$location.path('/')
							else if result == "fail"
								Account.verifiedMessage("Your password reset failed",'fail')
								$location.path('/')						

						else if type =="auth"
						
							if result == "success"
								Account.verifiedMessage("Authentication went successful",'success')
								$location.path('/')
							else if result == "fail"
								Account.verifiedMessage("Authentication failed",'fail')
								$location.path('/')
				.state "oauthenticate",
					
					url:'/oauth/:result'

					onEnter:($timeout,$http,$stateParams,$location, ipCookie,User)->
					
						result = $stateParams.result

						if result == "success"
							$http
								method:"GET"
								url:"/api/getLoggedInUser"
							.success (data)-> 
								if data 
									ipCookie.remove("loggedInUser")
									data.isLoggedIn = true
									User.user = data
									ipCookie("loggedInUser",data,{expires:365})
									$location.path('/verification/auth/success')
									$timeout ->
										User.checkState()
									,500,true
									
								else 
									$location.path('/verification/auth/fail')
						else 
							$location.path('/verification/auth/fail')
						# else if type =="auth"
						
						# 	if result == "success"
						# 		Account.verifiedMessage("Authentication went successful",'success')
						# 		$location.path('/')
						# 	else if result == "fail"
						# 		Account.verifiedMessage("Authentication failed",'fail')
						# 		$location.path('/')
						

							

				.state 'home.share',
					url:'share/:id'
					onEnter:($state,$modal,$stateParams,$location)->
						
						if $stateParams.id is "" 

							$location.path('/')

						else

							$modal.open(
							
								templateUrl : 'views/modals/shareModal.html'
								controller 	: "ShareCtrl"
								windowClass : "shareModal"
								
							
							).result.then ()->
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')

				.state 'home.deepResult',
					url:'deepResult/:id'
					onEnter:($state,$modal,$timeout,$stateParams,$location,User,Error)->
						console.log User.user
						if User.user
							onlineUser = User.user
						else
							onlineUser = User.visitor

						console.log onlineUser

						# check to see if the answer is already answered by the user
						found = _.find onlineUser.questionsAnswered,(question)->
							
							question._id == $stateParams.id

						console.log found
						
						
						if $stateParams.id is "" 
							
							$location.path('/')

						else if !User.user
							
							Error.auth = 'Please sign up to proceed'

							$timeout ()->
								
								 $state.transitionTo("home.signup", false)

							

						# if the question has not been answered, redirect back
						else if !found

							$location.path('/')

						else

							$modal.open(
							
								templateUrl : 'views/modals/deepResultModal.html'
								controller 	: "DeepResultCtrl"
								windowClass : "deepResult"
								
							
							).result.then ()->
	  							console.log('modal is open')
							
							, ()->
								
								$location.path('/')

								
								


				.state 'home.question',
					url:'question/:id'
					views:

						"content@":
							templateUrl : 'views/partials/sharedQuestion.html'
							


					onEnter:($state,$stateParams,$location)->
						console.log "yoyoyoyo"
						# if $stateParams.id is "" 

						# 	$location.path('/')

						
				
				.state 'home.setting',
					url:'setting/:type/:id'
					onEnter:($stateParams,$location)->
						type = $stateParams.type
						check = 0
						if  type is "favorites" then check++
						if  type is "profile" then check++
						if  type is "answers" then check++
						if  type is "filters" then check++
						if  type is "questions" then check++
						if check == 0 then $location.path('/')
						
							
						
						
					views:

						'content@':

							templateUrl:'/views/partials/setting.html'
							controller:'SettingCtrl'

						"result@home.setting":
							
							templateUrl :'/views/partials/targetQuestions.html'
							controller:'TargetAudienceCtrl'


					
			$urlRouterProvider.otherwise('/')

		)
