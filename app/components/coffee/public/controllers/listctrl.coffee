define ['underscore'], (_)->
	($scope,$timeout,Question,User,Filters)->

		# ----------------- Utility functions ----------------- #
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

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



		# ----------------- Scope functions and variables ----------------- #
	
		# ***************  ChartJS configuration *************** #
		
		# chart data #
		$scope.myChartData = []

	    #chartJS / angles - chart configuration
		$scope.myChartOptions =  
	       
	        # Boolean - Whether we should animate the chart
	        animation : true

	        # Number - Number of animation steps
	        animationStep : 30

	        # String - Animation easing effect
	        animationEasing : "easeOutQuart"




		
		# ***************  Models *************** #
		$scope.questions = Question
		
		$scope.answer = ''
		

		# ***************  Variables *************** #
		$scope.isStarFilled = false
		$scope.submitted = false

		targetQ = $scope.targetQ =
			isQuestionAnswered : false



		$scope.warning = false
		
		$scope.favorite = false
		# ***************  Functions *************** #
		# loads the chart data when the page initially is loaded
		
		do ()->
		
			alreadyAnswered = _.find _.pluck($scope.user.questionsAnswered,'id'),(id)->

				Number($scope.question.id) == Number(id)

			if alreadyAnswered

				getData()



		$scope.submitAnswer = (choice,question)->

			if choice is "" or !choice
			
				$scope.warning = true

			else
				

					
				$scope.$broadcast('answerSubmitted','submitted')

				$scope.question.respondents.push($scope.user.id)

				$scope.warning = false
				choice.count++
				question.totalResponses++
				
				answer = 
					id 		: question.id
					answer 	: choice.title

				# add the answer to user's database
				$scope.user.questionsAnswered.push(answer)

				$scope.submitted = true

				getData()


		

		$scope.fillStar = (question)->
			
			$scope.favorite = !$scope.favorite

			if $scope.favorite

				$scope.user.favorites.push(question.id)
				question.numOfFavorites++

			else

				# attach it to the question
				index = $scope.user.favorites.indexOf(question.id)	
				$scope.user.favorites.splice(index,1)
				question.numOfFavorites--
				
			console.log User
			
		# ------------------ IO listeners ------------------ #
			
		# reset everything	
		$scope.$on 'resetAnswer',(question)->
			
			#shows the main question section
			$scope.submitted = false
			
			# decrement the total resonse for the reset
			$scope.question.totalResponses--

			indexOfRespondents = $scope.question.respondents.indexOf($scope.user.id)	
			$scope.question.respondents.splice(indexOfRespondents,1)


			questionId = Number($scope.question.id)
			
			answers = _.pluck($scope.user.questionsAnswered,'id')
			
			foundAnswerId = _.find answers,(id)->	
					
					Number(id) == Number(questionId)

			foundAnswered = _.find $scope.user.questionsAnswered, (answer)->
				Number(answer.id) == Number(foundAnswerId)

			
			foundOption = _.find $scope.question.options,(option)->
				option.title == foundAnswered.answer

			# decrement the count for the reset
			foundOption.count--


			index = answers.indexOf(questionId)
			
			console.log index

			_.find $scope.user.questionsAnswered,(answer)->
				if Number(answer.id) == Number(questionId)
					
					$scope.user.questionsAnswered.splice(index,1)
				

			console.log $scope.user
			
			# reset the chosen answers
			$scope.answer = ''
			

		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


