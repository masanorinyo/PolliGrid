define ['underscore'], (_)->
	($scope,Question)->

		# ------------------ Utility funcitons ------------------ #
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

		$scope.myChartOptions =  
	       
	        segmentShowStroke : true,
	        segmentStrokeColor : "#fff",
	        animation : true,
	        animationSteps : 100,
	        animationEasing : "easeOutBounce",
	        animateRotate : true,
	        animateScale : true,
	        onAnimationComplete : null
	    

		$scope.myChartData = [
			
				value: 30
				color: getColor()
			,
			
				value : 50
				color : getColor()
			,
			
				value : 100
				color : getColor()
			,
			
				value : 40
				color : getColor()
			,
			
				value : 120
				color : getColor()
			
		]
		
		$scope.$apply()


