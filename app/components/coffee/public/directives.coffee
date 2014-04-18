define ['angular','controllers'], (angular,controllers) ->
	angular.module('myapp.directives', ['myapp.controllers'])
		.directive 'newFilter',()->
			restrict 	: 'EA'
			templateUrl : 'views/partials/newfilter.html'
			controller 	: 'NewFilterCtrl'
			

		

			