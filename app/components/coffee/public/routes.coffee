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

							templateUrl:'/partials/header.html'
							
						'utility':
							
							templateUrl:'/partials/utility.html'
							controller:'UtilityCtrl'
						
						'content':

							templateUrl:'/partials/content.html'
							controller:'ContentCtrl'

					}

				.state 'home.login',
					url:'login'
					onEnter:($state,$modal,$location)->
						$modal.open(
						
							templateUrl : '/partials/authmodal.html'
							controller 	: "AuthCtrl"
							#windowClass : "modal fade in"
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')
  							
						
					

					
				.state 'home.signup',
					url:'signup'
					onEnter:($state,$modal,$location)->
						$modal.open(
							
							templateUrl :'/partials/authmodal.html'
							controller 	:"AuthCtrl"
						
						).result.then ()->
  						
  							console.log('modal is open')
						
						, ()->
							$location.path('/')

			

			$urlRouterProvider.otherwise('/')

		)
)