define(
	[

		'angular'
		'app'
		
	]

	(angular,app)->
		
		app.config(($stateProvider,$urlRouterProvider)->

			$stateProvider
				
				.state 'routes',

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


			$urlRouterProvider.otherwise('/')

					


				

		)
)