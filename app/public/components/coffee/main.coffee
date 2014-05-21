require.config
	
	paths:

		# -------------- bower installments -------------- #
		
		"angular" 					: "../vendors/angular/angular.min"
		"angularMocks" 				: "../vendors/angular-mock/angular-mock"
		"angularRoute"				: "../vendors/angular-route/angular-route.min"
		"angularResource" 			: "../vendors/angular-resource/angular-resource.min"
		"angularCookie" 			: "../vendors/angular-cookie/angular-cookie.min"
		"angularSanitize" 	 		: "../vendors/angular-sanitize/angular-sanitize.min"		
		"angularLocalStorage"		: "../vendors/angular-local-storage/angular-local-storage.min"
		"angularUiRouter" 			: "../vendors/angular-ui-router/release/angular-ui-router.min"
		"angular-file-upload-shim"	: "../vendors/ng-file-upload/angular-file-upload-shim"
		"angular-file-upload"		: "../vendors/ng-file-upload/angular-file-upload"
		"jquery"					: "../vendors/jquery/dist/jquery.min"
		"angular-bootstrap"			: "../vendors/angular-bootstrap/ui-bootstrap-tpls.min"
		"domReady" 	 				: "../vendors/requirejs-domready/domready"
		"underscore" 	 			: "../vendors/underscore/underscore"
		"ngInfiniteScroll" 			: "../vendors/ngInfiniteScroll/build/ng-infinite-scroll"
		"offline" 					: "../vendors/offline/offline.min"
		"offline" 					: "../vendors/shepherd.js/shepherd"

		
		# -------------- these are manually installed - no bower components -------------- #

		# -- this chart script is tweeked -> ca be found at (git clone https://github.com/Regaddi/Chart.js.git) --#
		"chart"	 	 			: "../vendors/Chart.js-master/Chart"


		# -- this angles script is tweeked - added $timeout function --#
		"angles" 				: "../vendors/angles-master/angles"

		# at the 58th line
		"angular-deckgrid" 		: "../vendors/angular-deckgrid/angular-deckgrid"
		
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

		"angularCookie" 		: 
			deps 		 		: ['angular']

		"angularSanitize" 		: 
			deps 		 		: ['angular']		

		"angularLocalStorage"	: 
			deps 		 		: ['angular']

		"angularUiRouter" 		: 
			deps 		 		: ['angular']

		"angular-bootstrap" 	: 
			deps 		 		: ['angular']

		"angular-file-upload"	:
			deps				: ["angular",'angular-file-upload-shim']

		"angular-deckgrid"		:
			deps 				: ['angular']

		'angles'				:
			deps 				: ['angular','chart']

		"jquery" 				: 
			exports 		 	: '$'

		"underscore" 			:
			exports 			: '_'

		"ngInfiniteScroll" 		:
			deps 				: ['jquery','angular']



			

require(

	[	
		'jquery'
		'angular'
		'app'
		'routes'
		'domReady'
		"offline"
	]

	(jquery,angular,app,routes,domReady)->
		
		domReady ->
			
			angular.bootstrap(document,['myapp'])
		
)