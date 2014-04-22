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

		#  should not be based on alreadyAnswered -> based on each answer to the filter question
		.directive 'skipToResult', ($timeout)->

			restrict : "A"
			scope:{
				question  	: "="
				num 		: "="
			}
			link : (scope)->
				
				$timeout ()->
				
				
					if scope.question.alreadyAnswered

				
						scope.num = -1
						
						
				,520,true    
		
		.directive 'showResult', ($timeout)->

			restrict : "A"
			scope:{
				showResult  	: "=showResult"
				question 		: "="
			}
			link : (scope)->
				
				$timeout ()->
				
					if scope.question.alreadyAnswered
				
						scope.showResult = true
						
				,550,true 

		# check if the question is already favorited -> if yes, then fill the star
		.directive 'favorited', ($timeout,User)->

			restrict : "A"
			scope:{
				question 		: "=favorited"
			}
			link : (scope)->
				
				$timeout ()->
					
					

					foundUser = _.find scope.question.favoritedBy, (id)->
						Number(id) == Number(User.id)

					if foundUser
						scope.question.favorite = true
						
				,550,true 

	
