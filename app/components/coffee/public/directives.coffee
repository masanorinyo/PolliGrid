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


		# this will check if target question is already added to the question
		.directive 'buttonOk', ($timeout)->
	        
			restrict 	: 'A'
			scope 		:{
				question 	: "=buttonOk"
				target 		: "="
				filterAdded : "="

			}
			link		: (scope,elem)->
				
				$timeout ()->
					
					# if the target question is already added to the question
					# change the button looks
					targetIds = _.pluck scope.question.targets,'id'
									
					addedFilter = _.find targetIds, (id)->
						Number(id) == Number(scope.target.id)

					if addedFilter
						scope.filterAdded = true
						
				,100,true 


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

	
