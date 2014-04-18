define [

	'angular'
	'controllers'
	'directives'
	'services'
	'filters'


], (
		
		angular
		controllers
		directives
		services
		filters

		
	)->
		angular.module('myapp',[

			'ui.router'
			'ui.bootstrap'
			'myapp.controllers'
			'myapp.directives'
			'myapp.services'
			'myapp.filters'
			
			
		])

  