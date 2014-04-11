require.config
	
	paths:

		"angular" 				: "../vendors/angular/angular.min"
		"angularMocks" 			: "../vendors/angular-mock/angular-mock"
		"angularRoute"			: "../vendors/angular-route/angular-route.min"
		"angularResource" 		: "../vendors/angular-resource/angular-resource.min"
		"angularCookies" 		: "../vendors/angular-cookies/angular-cookies.min"
		"angularSanitize" 	 	: "../vendors/angular-sanitize/angular-sanitize.min"		
		"angularLocalStorage"	: "../vendors/angular-local-storage/angular-local-storage.min"
		"angularUiRouter" 		: "../vendors/angular-ui-route/release/angular-ui-router.min"
		"jquery"				: "../vendors/jquery/dist/jquery.min"
		"sass-bootstrap"		: "../vendors/sass-bootstrap/dist/js/bootstrap.min"
		"domReady" 	 			: "../vendors/requirejs-domready/domready"
		"underscore" 	 		: "../vendors/underscore/underscore"
		
		
		
	shim:
		
		"angular" 				:
			'exports'  			: 'angular'

		"angularMocks" 			: 
			deps 				: ['angular']
			'exports' 			: 'angular.mock'

		"angularRoute" 			: 
			deps 				: ['angular']

		"angularResource"		:
			deps 				: ['angular']

		"angularCookies" 		: 
			deps 		 		: ['angular']

		"angularSanitize" 		: 
			deps 		 		: ['angular']		

		"angularLocalStorage"	: 
			deps 		 		: ['angular']

		"angularUiRouter" 		: 
			deps 		 		: ['angular']

		"jquery" 				: 
			exports 		 	: '$'

		"sass-bootstrap" 		: 
			deps 		 		: ['jquery']

		"underscore" 			:
			exports 			: '_'

require(

	[
		'angular'
		'app'
		'routes'
		'domReady'
		'angularRoute'
	]

	(angular,app,routes,domReady)->
		
		domReady ->
			
			angular.bootstrap(document,['myapp'])
		
)