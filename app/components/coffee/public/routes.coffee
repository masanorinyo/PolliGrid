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

					views:{

						'header':

							templateUrl:'views/partials/header.html'
							
						
						'content':

							templateUrl:'views/partials/content.html'
							controller:'ContentCtrl'

					}

				.state 'home.login',
					url:'login'
					onEnter:($state,$modal,$location)->
						$modal.open(
						
							templateUrl : 'views/modals/authmodal.html'
							controller 	: "AuthCtrl"
							windowClass : "authModal "
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')
  							
				.state 'home.signup',
					url:'signup'
					onEnter:($state,$modal,$location)->
						$modal.open(
							
							templateUrl : 'views/modals/authmodal.html'
							controller 	: "AuthCtrl"
							windowClass : 'authModal'
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')

				.state 'home.create',
					url:'create'
					onEnter:($state,$modal,$location)->
						$modal.open(
						
							templateUrl : 'views/modals/createModal.html'
							controller 	: "CreateCtrl"
							windowClass : "createModal"
							
						
						).result.then ()->
  							console.log('modal is open')
						
						, ()->
							$location.path('/')

			

			$urlRouterProvider.otherwise('/')

		)
)