define ['underscore'], (_)->
	($scope,$modalInstance,$stateParams,$location,$timeout,Question)->
		
		# ------------ Variables ---------------#
		questionId = $stateParams.id

		# if $stateParams.id.$http(get) -> false -> $location.path('/')
		# http request
		
		foundQuestion = _.findWhere Question,Number(questionId)


		$scope.question = foundQuestion


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
			
				value: 30
				color:"#F7464A"
				label 			: 'test'
				labelColor 		: "#FEFEFE"
				labelFontSize 	: "18"
				labelAlign 		: 'center'
			,
			
				value : 50
				color : "#E2EAE9"
			,
			
				value : 100
				color : "#D4CCC5"
			,
			
				value : 40
				color : "#949FB1"
			,
			
				value : 120
				color : "#4D5360"
		]
		


		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')


		# -------------- Invoke Scope --------------#
		$scope.$apply()