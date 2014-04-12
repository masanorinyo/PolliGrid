define [

	'angular'
	'controllers'

], (
		
		angular
		controllers
		
	)->
		angular.module('myapp',[
		
			'ui.router'
			'myapp.controllers'
			
		])

  