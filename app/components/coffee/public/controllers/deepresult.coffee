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
			labels : ["Eating","Drinking","Sleeping","Designing","Coding","Partying","Running"]
			datasets : [
			
				fillColor : "rgba(220,220,220,0.5)"
				strokeColor : "rgba(220,220,220,1)"
				pointColor : "rgba(220,220,220,1)"
				pointStrokeColor : "#fff"
				data : [65,59,90,81,56,55,40]
			,
			
				fillColor : "rgba(151,187,205,0.5)"
				strokeColor : "rgba(151,187,205,1)"
				pointColor : "rgba(151,187,205,1)"
				pointStrokeColor : "#fff"
				data : [28,48,40,19,96,27,100]
			
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



		# ------------- graph configuration ------------- #
		$scope.radarChartOptions = 
			scaleShowLabels : true
			pointLabelFontSize : 9
			pointLabelFontColor : "rgb(120,120,120)"
			scaleFontSize : 9
			scaleFontColor : "rgb(120,120,120)"
		

		$scope.lineChartOptions = 
			scaleShowLabels : true
			scaleFontFamily : "'Arial'"
			scaleFontSize : 9
			scaleFontColor : "#666"

		$scope.filterAdded = true
		$scope.oneAtATime = true

		# ------------- Scope Variables ------------- #

		questionId = $stateParams.id

		# if $stateParams.id.$http(get) -> false -> $location.path('/')
		# http request
		
		foundQuestion = _.findWhere Question,Number(questionId)

		$scope.chartType = "pie"

		$scope.filterAdded = false
		
		$scope.question = foundQuestion

		$scope.filteredData = [

			answer 	: null # which answer of the question
			count 	: 0    # how many filtered people voted 
		]

		$scope.overallData = [
			answer 	: null # which answer of the question
			count 	: 0    # how many people voted 
		]

		# create targetAnswers object, which helps in identifiying
		# who answered to what filter question.
		

		
		$scope.filters = []
		$scope.filterGroup = []
		$scope.filterAdded = 'Add to filter'

		do ()->
			length = $scope.question.targets.length
			i = 0
			while i < length
				targets = []
				targetId 	= $scope.question.targets[i].id
				targetTitle = $scope.question.targets[i].title

				_.each $scope.question.targets[i].lists,(num)->
					optionData = 
						option 			: num.option
						answeredBy  	: num.answeredBy
						numOfResponses 	: num.answeredBy.length
						isAdded 		: false
						filterBtn 		: "Add to filter"
						


					targets.push(optionData)

				data = 
					id  		: targetId
					title 		: targetTitle
					numOfAdded 	: 0
					lists 		: targets
					

				$scope.filters.push(data)

				i++		

		$scope.filterGroup = 

			total 		: 0
			filters		: []
			answers:
				answer:null
				count:0

		$scope.filterCategories = []

		$scope.foundRespondents = false

		# this will add or remove filtered respondents from
		# filter group
		$scope.addFilter = (answer,target)->
			
			users = $scope.question.respondents
			filters = $scope.filterGroup.filters
			answer.isAdded = !answer.isAdded
			
			if answer.isAdded
				$scope.foundRespondents = true
				# add category
				foundCategory = _.findWhere $scope.filterCategories, {categoryTitle:target.title}
				
				if foundCategory 
					console.log 'found'
					foundCategory.options.push(answer.option)
				
				else

					category = 
						categoryTitle 	: target.title
						options 			: [
							answer.option
						]

					$scope.filterCategories.push(category)


				# number of added users from the specific filter question
				answer.filterBtn = "Remove filter"
				target.numOfAdded += answer.numOfResponses

				# number of filtered respondents
				
				filter = 
					id 			: target.id
					respondents : answer.answeredBy
						

				sameIdFound = _.findWhere filters, {id:target.id}

				if sameIdFound
					
					sameIdFound.respondents = _.union sameIdFound.respondents,answer.answeredBy

				else 
					$scope.filterGroup.filters.push(filter)


				
				
			else

				# remove the added category
				
				foundCategory = _.findWhere $scope.filterCategories, {categoryTitle:target.title} 
				
				console.log foundCategory
				index = foundCategory.options.indexOf(answer.option)
				console.log index

				foundCategory.options.splice(index,1)



				if foundCategory.options.length == 0
					$scope.filterCategories = _.without $scope.filterCategories,foundCategory
				
						

					
				
				# change the button text and decrement the total number of responses
				answer.filterBtn = "Add to filter"				
				target.numOfAdded -= answer.numOfResponses

				# find the filter group with the same id
				# if any, then remove it from the group
				sameIdFound = _.findWhere filters, {id:target.id}
				sameIdFound.respondents = _.difference sameIdFound.respondents,answer.answeredBy
				
				# if the filter is empty, remove it
				if sameIdFound.respondents.length == 0
					console.log 'NO RESPONDENTS'
					filters = _.without filters,_.findWhere filters,{id:target.id}
					$scope.foundRespondents = false
			

			$scope.filterGroup.filters = filters

			length = $scope.filterGroup.filters.length
			i = 0 

			while i < length

				users = _.intersection(users,$scope.filterGroup.filters[i].respondents)
				i++


			if $scope.filterGroup.filters.length == 0

				$scope.filterGroup.total = 0
			
			else 
			
				$scope.filterGroup.total = users.length
			


				




				


		# ------------- Scope Function ------------- #

		$scope.closeModal = ()->
			$scope.$dismiss()
			$timeout ->
				$location.path('/')
			,500,true


		# -------------- Invoke Scope --------------#
		$scope.$apply()