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
							controller:'AuthCtrl'
						
						
						'utility':
							
							templateUrl:'/partials/utility.html'
							controller:'UtilityCtrl'
						
						'content':

							templateUrl:'/partials/content.html'
							controller:'ContentCtrl'

					}

				.state 'home.login',
					
					url:'/login'

					views:{

					}

				.state 'home.signin',

					url:'/signin'

					views:{

					}



				.state 'profile',

					url:'/profile'

					views:{

					}


			$urlRouterProvider.otherwise('/')

		)
)