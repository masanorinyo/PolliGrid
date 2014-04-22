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

<<<<<<< HEAD
		#  should not be based on alreadyAnswered -> based on each answer to the filter question
		.directive 'skipToResult', ($timeout,User)->

			restrict : "A"
			scope:{
				question  	: "="
				num 		: "="
				showResult  : "="
				index 		: "@"
				answers 	: "="
			}
			link : (scope)->
				
				

				$timeout ()->

					# scope.num = scope.index
					targetIds 	= _.pluck(scope.question.targets,'id')
					
					length = scope.answers.length
					i = 0




					while i < length


						if Number(targetIds[scope.index]) == Number(scope.answers[i])
							console.log 'yes sir'							
							scope.num++
							scope.answers.splice(i,1)
							

						i++

					console.log 'current scope num from directive:'+scope.num
					if Number(scope.num) == Number(scope.question.numOfFilters)
						
						scope.$emit 'showGraph',true						

						
				,520,true    
		
=======
>>>>>>> testing
		
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

	
