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

		.directive 'focusMe', ($timeout)->

			restrict : "A"
			scope:{
				focusMe : "="
			}
			link : (scope,element)->
				$timeout ->
					
					element.bind 'focus', ->	
						scope.$apply(scope.focusMe = true)

				,300,true

		.directive "reset", ($timeout,$window)->
			restrict: "A"
			scope: {
				reset : "="
			}
			link: (scope, element,attr)->
				
				w = angular.element($window)
				w.bind "click", (e)->
					
					switch e.target.id
						when 'categorybox','searchbox',"category-select","order-select"  
						then scope.$apply(scope.reset = true)


						else scope.$apply(scope.reset = false)
		
		# .directive "flexGridParent", ()->
		# 	restrict: "A"
		# 	link: (scope, element,attr)->
				
		# 		# createDivs = ->
		# 		console.log colWidth = 215
		# 		console.log element[0].offsetWidth
		# 		console.log element[0].offsetHeight

		# .directive "flexGridChild", ()->
		# 	restrict: "A"
		# 	link: (scope, element,attr)->
				
		# 		# createDivs = ->
		# 		# console.log colWidth = 215
		# 		console.log element[0].offsetWidth
		# 		console.log element[0].offsetHeight
				
				

				

        

    

        #     var createparentHDivs = function(){
    
        #         var x, y; 
        #         //column width
        #         var colWidth = 215;

        #         //get parent
        #         var parent = $('#main-content'); 
        #         var parentW = $(parent).width();
        #         var parentH = $(parent).height();

        #         //no. of columns that'll fit
        #         var noOfCol = Math.floor(parentW/colWidth);

        #         //array to store y position in each column initialize to top margin, 50px
        #         var colYs = []; 
        #         for (var i = 0; i < noOfCol; i++) {
        #             colYs.push(50);
        #         }

        #         for (var i = 0; i < data.length; i++) {
        #         //for each column
        #             for (var j = 0; j < noOfCol && i < data.length; j++, i++) {
        #                 //calculate x and y positions
        #                 x = j*colWidth; 
        #                 y = colYs[j];

        #                 //create a new bit and place it in the correct position
        #                 var itemDiv = "<div class='grid-item' style='background-color:"
        #                     + data[i].color + ";"
        #                     + "left: "
        #                     + x +"px;"
        #                     + "top:"
        #                     + y + "px;"
        #                     + "width: "
        #                     + (colWidth - 25) +"px;" 
        #                     + "height: "
        #                     + data[i].height+"px;"
        #                     +"'></div>"
        #                 parent.append(itemDiv); 
        #                 colYs[j] += data[i].height + 10; 
        #             }
        #         }
        #     };

        #     $(window).bind("resize", function(){
        #         //clear the main content
        #         $("#main-content").html("");
        #         //recreate grid
        #         createDivs();
        #     });

        #     createDivs();
            

        # });













