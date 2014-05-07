define [

	'angular'
	'controllers'
	'directives'
	'services'
	'filters'
	'template'
	'angularUiRouter'
	'angularResource'
	'angular-bootstrap'
	'angles'
	'angular-deckgrid'
	'ngInfiniteScroll'
], (angular)->
		angular.module('myapp',[

			'ui.router'
			'ui.bootstrap'
			'myapp.controllers'
			'myapp.directives'
			'myapp.services'
			'myapp.filters'
			'myapp.template'
			'angles'
			'akoenig.deckgrid'
			'infinite-scroll'
		])