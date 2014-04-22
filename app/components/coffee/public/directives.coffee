define ['angular','controllers','underscore'], (angular,controllers,_) ->
	angular.module('myapp.directives', ['myapp.controllers','myapp.services'])

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


		.directive 'answered', ($timeout)->

			restrict : "A"
			scope:{
				answered  	: "="
				submitted 	: "="
			}
			link : (scope)->
				
				$timeout ()->
				
					if scope.answered.alreadyAnswered
				
						scope.submitted = true
						
				
				,500,true      

		.directive 'favorited', ($timeout,User)->

			restrict : "A"
			scope:{
				question 		: "=favorited"
				favorite 		: "="
			}
			link : (scope)->
				
				$timeout ()->
					
									
					favoriteQuestion = _.find User.favorites, (id)->
						Number(id) == Number(scope.question.id)

					if favoriteQuestion
						scope.favorite = true
						
				,550,true 

	
