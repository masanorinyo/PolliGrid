define ['underscore'], (_)->
	($scope,$modalInstance,$stateParams,$location,$timeout,Question)->
		

		# ----------------- Utility functions ----------------- #
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

		getInvertColor = (color)->

    		color = color.substring(1)
    		color = parseInt(color, 16)
    		color = 0xFFFFFF ^ color
    		color = color.toString(16)
    		color = ("000000" + color).slice(-6)
    		color = "#" + color
    		return color


    	# get data when the page loads up
		getData = ->
			$scope.myChartData = []
			ref = $scope.question.options
			i = 0
			len = ref.length

			while i < len
				obj = ref[i]
				count = obj.count
				title = obj.title
				color = getColor()
				
				data =
					value 			: count
					color 			: color
					label 			: title
					labelColor 		: "#FEFEFE"
					labelFontSize 	: "18"
					labelAlign 		: 'center'

				$scope.myChartData.push data
				i++
			return

		# ------------- Data for chart ------------- #

		$scope.myChartDataDeep = [			
	            
				value: 30
				color:"#F7464A"
			,
				value : 50,
				color : "#E2EAE9"
			,
			
				value : 100,
				color : "#D4CCC5"
			,
			
				value : 40,
				color : "#949FB1"
			,
			
				value : 120,
				color : "#4D5360"
			
	    ]


		$scope.chart = 
			labels 	: ["Monday", "Tuesday",'','','','']
			datasets : [
				fillColor : "rgba(151,187,205,0)"
				strokeColor : "#e67e22"
				pointColor : "rgba(151,187,205,0)"
				pointStrokeColor : "#e67e22"
				data : [4, 3,0,0,0,0]
			,
		
				fillColor : "rgba(151,187,205,0)"
				strokeColor : "#f1c40f"
				pointColor : "rgba(151,187,205,0)"
				pointStrokeColor : "#f1c40f"
				data : [8, 3,0,0,0,0]
			]
		
		



		$scope.donutOption =  
			
			#The percentage of the chart that we cut out of the middle.
			percentageInnerCutout : 50

			#Boolean - Whether we should animate the chart
			animation : false

			#Number - Amount of animation steps
			animationSteps : 100

			#String - Animation easing effect
			animationEasing : "easeOutBounce"

			#Boolean - Whether we animate the rotation of the Doughnut
			animateRotate : true

			#Boolean - Whether we animate scaling the Doughnut from the centre
			animateScale : false

			#Function - Will fire on animation completion.
			onAnimationComplete : null




		$scope.donutData = [
			
			value: 35,
			color: color = getColor()
		,
			
			value : 100-35,
			color : getInvertColor(color)

		]

		# ------------- Scope Variables ------------- #

		$scope.oneAtATime = true

		questionId = $stateParams.id

		# if $stateParams.id.$http(get) -> false -> $location.path('/')
		# http request
		
		foundQuestion = _.findWhere Question,Number(questionId)

		$scope.chartType = "pie"
		
		$scope.question = foundQuestion

		$scope.filteredData = [
			answer 	: null # which answer of the question
			count 	: 0    # how many filtered people voted 
		]

		$scope.overallData = [
			answer 	: null # which answer of the question
			count 	: 0    # how many people voted 
		]




		$scope.filterAdded = 'Add to filter'

		$scope.groups = [

			title: "Dynamic Group Header - 1",
			content: "Dynamic Group Body - 1",
			open: false
		,

			title: "Dynamic Group Header - 2",
			content: "Dynamic Group Body - 2",
			open: false

		]







		# ------------- Scope Function ------------- #

		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')


		# -------------- Invoke Scope --------------#
		$scope.$apply()