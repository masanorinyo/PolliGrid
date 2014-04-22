define ['underscore'], (_)->
	($scope,$timeout,$q,Question)->

		
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

		getInvertColor = (hexTripletColor)->
    		color = hexTripletColor
    		color = color.substring(1)          
    		color = parseInt(color, 16)         
    		color = 0xFFFFFF ^ color          
    		color = color.toString(16)
    		color = ("000000" + color).slice(-6)
    		color = "#" + color 
    		color

		# ------------------ Scope variables ------------------ #
		
		$scope.num = 0
		$scope.showResult = false
		$scope.targetAnswer = ""


		#chartJS / angles - chart configuration
		$scope.myChartOptions =  
	       
	        # Boolean - Whether we should animate the chart
	        animation : true

	        # Number - Number of animation steps
	        animationStep : 100

	        # String - Animation easing effect
	        animationEasing : "easeOutQuart"

	    # ---- chart data ---- #
	    
	    # data holder
	    $scope.myChartData = []

		# get data when the page loads up
		getData = ->
			$scope.myChartData = []
			_ref = $scope.question.options
			_i = 0
			_len = _ref.length

			while _i < _len
				obj = _ref[_i]
				count = obj.count
				title = obj.title
				color = getColor()
				invertColor = getInvertColor(color)
				data =
					value: count
					color: color
					label: title
					labelColor: invertColor
					labelFontSize: "20"

				$scope.myChartData.push data
				_i++
			return
	    
	    # loads the chart data when the page initially is loaded
		do ()->
			
			getData()

			

		# ------------------ Scope funcitons ------------------ #
		
		$scope.submitTarget = (question,targetAnswer)->


			# warning message pops up if users didn't choose any answer
			if targetAnswer is "" or !targetAnswer
			
				$scope.warning = true

			else

				# remove the warniing popup since the user selected something
				$scope.warning = false

				# this will get the id of the target audience question.
				targetQuestionID = question.targets[$scope.num].id

				# user's answer to the target question
				answer = 
					id 		: targetQuestionID
					answer 	:targetAnswer
				
				

				# $scope num will increment everytime users answer to
				# target audience question.
				# when the $scope num matches the total number of the filter questions
				# then the result seciton will be shown.
				if $scope.num == question.numOfFilters-1
					
					# since the question.numOfFilters is one more
					# than $scope.num so by euqalizing them, 
					# the target audience section will be hidden
					$scope.num = question.numOfFilters

					# add the answer to the user's list
					$scope.user.filterQuestionsAnswered.push(answer)

					# this will show the result section
					$scope.showResult = true

					$scope.question.alreadyAnswered = true

					getData()

				else

					$scope.num++

					# add the answer to the user's list
					$scope.user.filterQuestionsAnswered.push(answer)					




		# reset everything 
		$scope.resetAnswer = (question)->
			
			# remove filterQuestionAnswered one by one
			# $scope.num = 0 means no new answers
			$scope.num = 0

			#cancels out everything
			$scope.showResult = false

			$scope.question.alreadyAnswered = false
			

			# send the information to the upper scopes
			$scope.$emit('resetAnswer',question)
			
			
			


		
		
		# ------------------ Invoke the scope ------------------ #		
		
		$scope.$apply()


