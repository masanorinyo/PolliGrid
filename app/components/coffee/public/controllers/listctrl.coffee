define ['underscore'], (_)->
	($scope,$location,$state,$stateParams,$timeout,Question,User,Filters)->

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
		$scope.user = User
		$scope.isAccessedViaLink = false
		# if the question is accessed via external link
		# get the url id and find the question with the id
		if $stateParams.id
			
			$scope.isAccessedViaLink = true
			console.log $scope.isAccessedViaLink
			questionId = Number($stateParams.id)
			foundQuestion = _.findWhere Question,{id:questionId}
			$scope.question = foundQuestion	


		else

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


		# this handles user's question answer submission 
		$scope.submitAnswer = (choice,question)->

			if choice is "" or !choice
			
				$scope.warning = true

			else
				

				$scope.warning = false

				# trigger targetaudience's function, 
				# which will skip the already answered filter questions	
				$scope.$broadcast('answerSubmitted','submitted')

				# by adding user id to the question respondents,
				# users won't have to answer to the question again
				$scope.question.respondents.push($scope.user.id)

				# update the option related data 
				choice.answeredBy.push($scope.user.id)
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
			console.clear()
			console.trace()
			console.count "Reset was called:"

			
			


			#shows the main question section
			$scope.submitted = false
			
			# decrement the total resonse for the reset
			$scope.question.totalResponses--


			# remove the user's id from the question's respondendents array
			indexOfRespondents = $scope.question.respondents.indexOf($scope.user.id)	
			$scope.question.respondents.splice(indexOfRespondents,1)

			# -- remove the question id from the user's questionAnswered Array -- #			
			# 1: get the question id
			questionId = Number($scope.question.id)
			
			# 2: extract the IDs from the question already answered array from User
			answers = _.pluck($scope.user.questionsAnswered,'id')
			

			# 3: compare the extracted IDs with the question ID# 3
			foundAnswerId = _.find answers,(id)->		
					Number(id) == Number(questionId)
			# 4: find which option the user chose for the question
			foundAnswered = _.find $scope.user.questionsAnswered, (answer)->
				Number(answer.id) == Number(foundAnswerId)

			# find the question option, which the user chose for the question
			foundOption = _.find $scope.question.options,(option)->
				option.title == foundAnswered.answer

			# remove the user's id from the options's answeredBy array
			optionIndex = foundOption.answeredBy.indexOf($scope.user.id)
			foundOption.answeredBy.splice(optionIndex,1)
			


			# using the found option, decrement the count for the reset
			foundOption.count--

			# find the index of the question id in the user's array
			index = answers.indexOf(questionId)
			
			# remove the question id from the user's array
			_.find $scope.user.questionsAnswered,(answer)->
				
				if Number(answer.id) == Number(questionId)
					
					$scope.user.questionsAnswered.splice(index,1)
				

			
			# reset the chosen answers
			$scope.answer = ''
			
		# ------------- Scope Function ------------- #

		$scope.closeModal = ()->
			$scope.$dismiss()
			
			$timeout ->
				$location.path('/')

				# reload the page
				$state.transitionTo($state.current, $stateParams, {
					reload: true
					inherit: false
					notify: true
				})

			,100,true

		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


