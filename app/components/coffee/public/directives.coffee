define ['angular'], (angular) ->
	angular.module('myapp.directives', [])
		
		.directives 'newFilter', ()->
			restrict:'A'
			templateUrl:'views/partials/newFilter.html'
			controller: NewFilterCtrl
			link:(scope,elem,attr)->
				console.log 'test'
			

		