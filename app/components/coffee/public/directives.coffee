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
					
					if scope.answered and scope.answer != undefined
						console.log scope.answered
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
					
					if scope.question != undefined
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
			
		.directive "getSize", ($timeout)->
			restrict:"A"
			scope:{
				getSize:"="
			}
			link:(scope,elem)->
				
				$timeout ->
					scope.getSize.height = elem[0].offsetHeight
					scope.getSize.width  = elem[0].offsetWidth
				,300,true


		# .directive 'noScopeRepeat', ($compile)->
			# transclude:true
			link: (scope, elem, attrs)->
				scope.$watch attrs.items,(items)->
					if items

						template = '{{ #OBJ#.myValue }}'

						items.forEach (val, key)->
						newElement = angular.element(
							template.replace(/#OBJ#/g, attrs.items + '[' + key + ']')
						)
						$compile(newElement)(scope);
						elem.append(newElement);
					
				
			
		

		# .directive "grid", ($timeout,$window,Grid)->
		# 	restrict:"A"
		# 	link: (scope, element,attr)->

		# 		$timeout ->
					
		# 			# number of items added
		# 			index = Number(scope.$index)
					
		# 			# number of questions
		# 			length = scope.questions.length
					
		# 			# grid wrapper height and width
		# 			parent = scope.parentSize
					
		# 			# each item width size
		# 			colWidth = 360
		# 			element.css({'width':colWidth+"px"})

		# 			# number of columns depending on the parent wrapper width 
		# 			# and the colWidth
		# 			numOfCol= Number(Math.floor(parent.width / colWidth))
		# 			Grid.numOfItems = numOfCol
					

		# 			withMargin = colWidth + 10
		# 			currentColWidth = Number(Grid.numOfItems * withMargin)

		# 			y = 0
					
		# 			# make arrays until it points down one row
		# 			if index < numOfCol
						
		# 				Grid.height.push(element[0].offsetHeight+20)
					

		# 			# from the second row
		# 			if Grid.numOfLoop < numOfCol * 2 && index >= numOfCol

		# 				y = Grid.height[Grid.num]

		# 				Grid.height[Grid.num] += element[0].offsetHeight + 20
		# 				Grid.num++
		# 				Grid.numOfLoop++

		# 			else 

		# 				currentColWidth = 0
		# 				Grid.num = 0
		# 				Grid.numOfLoops = numOfCol


		# 			# while j <  numOfCol
		# 			x = currentColWidth
					

		# 			element.css({'left':x+"px"})
		# 			element.css({'top':y+"px"})
					
					

		# 		,350,true
		

        

    

        #     var createparentHDivs = function(){
    
    

     

        #         //array to store y position in each column initialize to top margin, 50px
        #         var colYs = []; 
        #         for (var i = 0; i < noOfCol; i++) {
        #             colYs.push(50);
        #         }

            #     for (var i = 0; i < data.length; i++) {
            #     //for each column
            #         for (var j = 0; j < noOfCol && i < data.length; j++, i++) {
            #             //calculate x and y positions
            #             x = j*colWidth; 
            #             y = colYs[j];

            #             //create a new bit and place it in the correct position
            #             var itemDiv = "<div class='grid-item' style='background-color:"
            #                 + data[i].color + ";"
            #                 + "left: "
            #                 + x +"px;"
            #                 + "top:"
            #                 + y + "px;"
            #                 + "width: "
            #                 + (colWidth - 25) +"px;" 
            #                 + "height: "
            #                 + data[i].height+"px;"
            #                 +"'></div>"
            #             parent.append(itemDiv); 
            #             colYs[j] += data[i].height + 10; 
            #         }
            #     }
            # };

            # $(window).bind("resize", function(){
            #     //clear the main content
            #     $("#main-content").html("");
            #     //recreate grid
            #     createDivs();
            # });

            # createDivs();
            

        # });













