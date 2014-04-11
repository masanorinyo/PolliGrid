define(
	[

		'angular'
		'app'
		
	]

	(angular,app)->
		
		app.config(($routeProvider)->

			$routeProvider
				
				.when('/'

					templateUrl	: "partials/main.html"
					controller 	: "MainCtrl"

				)

		)
)