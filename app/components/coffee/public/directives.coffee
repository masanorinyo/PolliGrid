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


		.directive 'answered', ($timeout)->

			restrict : "A"
			scope:{
				answered  	: "="
				submitted 	: "="
			}
			controller : ($scope)->
				
				$timeout ()->
				
					if $scope.answered.alreadyAnswered
				
						$scope.submitted = true
						
				
				,500,true      

		#  should not be based on alreadyAnswered -> based on each answer to the filter question
		.directive 'skipToResult', ($timeout)->

			restrict : "A"
			scope:{
				question  	: "="
				num 		: "="
			}
			controller : ($scope)->
				
				$timeout ()->
				
				
					if $scope.question.alreadyAnswered
				
						$scope.num = -1
						
						
				,520,true    
		
		.directive 'showResult', ($timeout)->

			restrict : "A"
			scope:{
				showResult  	: "=showResult"
				question 		: "="
			}
			controller : ($scope)->
				
				$timeout ()->
				
					if $scope.question.alreadyAnswered
				
						$scope.showResult = true
						
				,550,true   
