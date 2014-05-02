define [

	'angular'
	'controllers'
	'directives'
	'services'
	'filters'
	'template'
	'angularUiRouter'
	'angular-bootstrap'
	'angles'
	'angular-deckgrid'

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
		])