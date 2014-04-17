define [

	'angular'
	'controllers'
	'directives'


], (
		
		angular
		controllers
		directives

		
	)->
		angular.module('myapp',[

			'ui.router'
			'ui.bootstrap'
			'myapp.controllers'
			'myapp.directives'
			
			
		])

  