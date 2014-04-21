define ['angular','controllers'], (angular,controllers) ->
	angular.module('myapp.directives', ['myapp.controllers'])

		.directive 'newFilter',()->
			restrict 	: 'EA'
			scope 		: true
			templateUrl : 'views/partials/newfilter.html'
			controller 	: 'NewFilterCtrl'
		
		.directive 'stopEvent', ()->
	        
			restrict: 'A'
			link: (scope, element, attr) ->
				element.bind attr.stopEvent, (e)->
					e.stopPropagation()


		.directive 'buttonOk', ()->
	        
			restrict 	: 'A'
			replace		: true
			scope 		: true
			transclude  : true
			link		: (scope,elem)->
					
				clickingCallback = ()->
					
					if !elem.hasClass('bg-blue')
						
						elem.addClass('bg-blue')
						elem.children('i').addClass('glyphicon-ok')
						elem.children('i').addClass('white')
					
					else

						elem.removeClass('bg-blue')
						elem.children('i').removeClass('glyphicon-ok')
						elem.children('i').removeClass('white')

				elem.bind('click', clickingCallback)







		.directive 'graph', ()->
			restrict	:'EA'
			scope 		: {
				
				data 	: "=test"
				type 	: "@"
			
			}
			link		: (scope,elem,attr)->
				
				ctx = elem[0].getContext("2d")
				
				# if scope.type == "doughnutchart"
				console.log scope.data

				# new Chart(ctx).Line(scope.data,scope.option)
					
