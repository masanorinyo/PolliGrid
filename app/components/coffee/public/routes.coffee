define(
	[

		'angular'
		'app'
		
	]

	(angular,app)->
		
		app.config(($stateProvider,$urlRouterProvider)->

			$stateProvider
				
				.state 'home',

					url:"/"

					views:

						'header':

							templateUrl:'views/partials/header.html'
							
						
						'content':

							templateUrl:'views/partials/content.html'
							controller:'ContentCtrl'						

						"result@home":
							
							templateUrl :'views/partials/targetQuestions.html'
							controller:'TargetAudienceCtrl'


				.state 'home.login',
					url:'login'
					onEnter:($state,$modal,$stateParams,$location,Error)->
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
						
						if User.isLoggedIn

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
					onEnter:($state,$modal,$stateParams,$location,Error)->
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
						if User.isLoggedIn

							$location.path '/deepResult/'+$stateParams.id

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

				.state 'home.create',
					url:'create'
					views:

						'create@':

							templateUrl:'views/partials/createQuestion.html'
							
						
						'target@':

							templateUrl:'views/partials/targetAudience.html'

						'share@':

							templateUrl:'views/partials/shareQuestion.html'

					onEnter:($state,$modal,$location,$timeout,User,Error)->
						if !User.isLoggedIn
							
							Error.auth = 'Please sign up to proceed'

							$timeout ()->
								$location.path('signup')
							,300,true

						else


							$modal.open(
							
								templateUrl : 'views/modals/createModal.html'
								controller 	: "CreateCtrl"
								windowClass : "createModal"
								
							
							).result.then ()->
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')

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
						
						if $stateParams.id is "" 

							$location.path('/')

						else if !User.isLoggedIn
							
							Error.auth = 'Please sign up to proceed'

							$timeout ()->
								$location.path('signup')
							,300,true

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

						"questionResult@":
							
							templateUrl :'views/partials/targetQuestions.html'
							controller:'TargetAudienceCtrl'


					onEnter:($state,$timeout,$modal,$stateParams,$location)->
						
						if $stateParams.id is "" 

							$location.path('/')

						else

							$modal.open(
							
								templateUrl : 'views/modals/questionModal.html'
								controller 	: "ListCtrl"
								backdrop 	: "static"
								windowClass : "questionModal"

								
							
							).result.then ()->
	  							console.log('modal is open')
							
							, ()->
								$location.path('/')
								
								
				
				.state 'home.setting',
					url:'setting/:id/:type'
					views:

						'content@':

							templateUrl:'/views/partials/setting.html'
							controller:'SettingCtrl'

				
						

					

			$urlRouterProvider.otherwise('/')

		)
)