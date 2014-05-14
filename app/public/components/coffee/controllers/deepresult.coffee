define ['underscore'], (_)->
	($scope,$modalInstance,$stateParams,$location,$q,$timeout,Question,Setting,$state)->
		

		# ----------------- Utility functions ----------------- #
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)
		
		getPercentage = (num,overall)->
    		
    		return percentage = Math.floor((num/overall) * 100)
    		

    	# get data when the page loads up
		getData = (message)->
			
			$scope.myChartDataDeep = []
			

			# clean up the data in the filter
			$scope.myChartInfo.datasets[1].data = []


			if message == 'createOverallPieData'
				ref = $scope.question.option
			else
				ref = $scope.filterGroup.answers
				
			
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

				if message == 'createOverallPieData'

					$scope.myChartDataOverall.push(data)
					
				else
					
					$scope.myChartDataDeep.push(data)
				

				# if any filters selected
				if $scope.foundRespondents
					# put it into the filter data chart
					$scope.myChartInfo.datasets[1].data.push(count)
				
				i++

			# if foundRespondents is false, meaning no filters selected
			# reset the count numbers in the filter box
			if !$scope.foundRespondents

				_.each $scope.filterGroup.answers,(obj)->
					obj.count = 0


			# if the number of question options is less than 2
			if i <= 2 && $scope.foundRespondents
				$scope.myChartInfo.datasets[1].data.push(0)

			return

		# ------------- Data for chart ------------- #

		# create targetAnswers object, which helps in identifiying
		# who answered to what filter question.		

		# create the variable for filling overall data
		$scope.myChartInfo = 
			labels : []
			datasets : [
			
				fillColor : "rgba(220,220,220,0.5)"
				strokeColor : "rgba(220,220,220,1)"
				pointColor : "rgba(220,220,220,1)"
				pointStrokeColor : "#fff"
				data : []
			,
			
				fillColor : "rgba(151,187,205,0.5)"
				strokeColor : "rgba(151,187,205,1)"
				pointColor : "rgba(151,187,205,1)"
				pointStrokeColor : "#fff"
				data : []
			
			]



		$scope.donutDataOverall = []

		$scope.donutDataFiltered = []


		$scope.filters = []
		$scope.filterGroup = 
			total 		: 0
			filters		: []
			answers 	: []

		$scope.myChartDataOverall = []
		$scope.filterAdded = true
		$scope.oneAtATime = true

		$scope.showMessageBox = false
		# ------------- graph configuration ------------- #
		$scope.pieChartOptions = 
			animationEasing : "easeOutQuart"
			animation:false

		$scope.radarChartOptions = 
			scaleShowLabels 	: true
			pointLabelFontSize 	: 12
			pointLabelFontColor : "rgb(120,120,120)"
			scaleFontSize 		: 13
			scaleFontColor 		: "rgb(56,121,217)"
			scaleOverlay 		: true
			
			
		

		$scope.lineChartOptions = 
			scaleShowLabels : true
			scaleFontFamily : "'Arial'"
			scaleFontSize 	: 9
			scaleFontColor 	: "#666"
			

		$scope.donutOption =  
			
			#The percentage of the chart that we cut out of the middle.
			percentageInnerCutout : 50

			#Boolean - Whether we should animate the chart
			showTooltips:false
			animation:false


		

		# ------------- Scope Variables ------------- #
		console.log Setting.isSetting
		if Setting.isSetting
			questionId = Setting.questionId
			
		else 
			questionId = $stateParams.id
		
		$scope.chartType = "pie"

		$scope.filterAdded = false
		
		console.log questionId

		
		# answer:null / count:0 

		$scope.filterAdded = 'Add to filter'
		$scope.filterCategories = []
		$scope.foundRespondents = false

		$scope.isFiltered = false



		$scope.buttonMessage = "See comments"

		$scope.showMessages = ()->
			$scope.showMessageBox=!$scope.showMessageBox

			if $scope.showMessageBox
				$scope.buttonMessage = "Back to result"	
			else
				$scope.buttonMessage = "See comments"	

			

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
					
					foundCategory.option.push(answer.option)
				
				else

					category = 
						categoryTitle 	: target.title
						option			: [
							answer.option
						]

					$scope.filterCategories.push(category)


				# number of added users from the specific filter question
				answer.filterBtn = "Remove filter"
				target.numOfAdded += answer.numOfResponses

				# number of filtered respondents
				
				filter = 
					_id 			: target._id
					respondents : answer.answeredBy
						

				sameIdFound = _.findWhere filters, {_id:target._id}

				if sameIdFound
					
					sameIdFound.respondents = _.union sameIdFound.respondents,answer.answeredBy

				else 
					$scope.filterGroup.filters.push(filter)


				
				
			else

				# remove the added category
				
				foundCategory = _.findWhere $scope.filterCategories, {categoryTitle:target.title} 
				index = foundCategory.option.indexOf(answer.option)
				foundCategory.option.splice(index,1)



				if foundCategory.option.length == 0
					$scope.filterCategories = _.without $scope.filterCategories,foundCategory
				
						

					
				
				# change the button text and decrement the total number of responses
				answer.filterBtn = "Add to filter"				
				target.numOfAdded -= answer.numOfResponses

				# find the filter group with the same id
				# if any, then remove it from the group
				sameIdFound = _.findWhere filters, {_id:target._id}

				
				sameIdFound.respondents = _.difference sameIdFound.respondents,answer.answeredBy
				
				
				# if the filter is empty, remove it
				if sameIdFound.respondents.length == 0
					
					filters = _.without filters,_.findWhere filters,{_id:target._id}
					
			

			$scope.filterGroup.filters = filters

			length = $scope.filterGroup.filters.length
			i = 0 


			while i < length

				users = _.intersection(users,$scope.filterGroup.filters[i].respondents)
				i++

			
			

			if $scope.filterGroup.filters.length == 0

				$scope.filterGroup.total = 0
				$scope.foundRespondents = false
			
			else 
			
				$scope.filterGroup.total = users.length
			

			defer = $q.defer()
			test = []
			defer.promise
				.then ()->
					data = []
					_.each $scope.question.option,(option,index)->
						
						data[index] = option.answeredBy

						_.each $scope.filterGroup.filters,(filter)->

							data[index] = _.intersection data[index],filter.respondents

					_.each data,(filteredRespondents,index)->
						$scope.filterGroup.answers[index].count = filteredRespondents.length
				.then ()->	

					getData('filtered')

				.then ()->
					# get the percentage of the filtered data
					sumOfFilteredData = 0
					
					# reset the donutData for percentage 
					$scope.donutDataFiltered = []
					_.each $scope.filterGroup.answers,(obj)->
						
						sumOfFilteredData += obj.count

						console.log "sumOfFilteredData"
						console.log sumOfFilteredData

					_.each $scope.filterGroup.answers, (obj)->


						percentage = parseInt(getPercentage(obj.count,sumOfFilteredData))
						
						if isNaN(parseFloat(percentage))
							percentage = 0
							
						
						filteredDataForDonut = [
							
								
								label : obj.title
								value: percentage
								color: "rgb(100,150,245)"
							,
								label : obj.title
								value : 100 - percentage
								color: "rgb(235,235,235)"
							
						]


						$scope.donutDataFiltered.push(filteredDataForDonut)

						

				

			defer.resolve()





		
		# create filters array
		do ()->

			defer = $q.defer()
			defer.promise
				.then ->					
					$scope.question = Question.get(
											{
												questionId:escape(questionId)
											}
										)
					
					$scope.question.$promise.then (data)->
						console.log data
				.then ->

					#make a pie at the initial load
					getData('createOverallPieData')

					#load information of overall for other charts
					_.each $scope.question.option,(option)->
						$scope.myChartInfo.labels.push(option.title)
						$scope.myChartInfo.datasets[0].data.push(option.count)
						
					# if the number of question options is less than 2
					# put a blank data
					if $scope.myChartInfo.labels.length <=2
						$scope.myChartInfo.labels.push('')
						$scope.myChartInfo.datasets[0].data.push(0)




					length = $scope.question.targets.length
					i = 0


					# add option answers to $scope filter group
					_.each $scope.question.option, (obj)->
						answer = 
							title : obj.title
							count : 0
						$scope.filterGroup.answers.push(answer)

					

					# create filter array
					while i < length
						targets = []
						targetId 	= $scope.question.targets[i]._id
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
							_id  		: targetId
							title 		: targetTitle
							numOfAdded 	: 0
							lists 		: targets
							

						$scope.filters.push(data)

						i++		


					_.each $scope.question.option, (obj)->


						percentage = parseInt(getPercentage(obj.count,$scope.question.totalResponses))
						
						
						overallDataForDonut = [ 
								label : obj.title
								value : percentage
								color : "rgb(100,250,245)"
							,
								label : obj.title
								value : 100-percentage
								color : "rgb(235,235,235)"
						]

						filteredDataForDonut =[

								label : obj.title
								value: 0
								color: "rgb(100,150,245)"
							,
								label : obj.title
								value : 100
								color: "rgb(235,235,235)"
						]


						$scope.donutDataOverall.push(overallDataForDonut) 
						$scope.donutDataFiltered.push(filteredDataForDonut) 

			defer.resolve()

		# ------------- Scope Function ------------- #

		$scope.closeModal = ()->

			$scope.$dismiss()

			


		# -------------- Invoke Scope --------------#
		$scope.$apply()