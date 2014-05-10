define ['underscore'], (_)->
	($scope,$location,$state,$stateParams,$timeout,FindQuestions,User,Filters,Error,Search)->




		# ----------------- Utility functions ----------------- #
		getColor = ()->
			'#'+(0x1000000+(Math.random())*0xffffff).toString(16).substr(1,6)

    	# get data when the page loads up
		getData = ->
			$scope.myChartData = []
			ref = $scope.card.option
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


		$scope.searchByCategory = (category)->
			Search.category = category

			$scope.$emit "category-changed", category


		# ----------------- Scope functions and variables ----------------- #
	
		# ***************  ChartJS configuration *************** #
		

		# chart data #
		$scope.myChartData = []

	    #chartJS / angles - chart configuration
		
		if $scope.isAccessedFromSetting != undefined || $scope.isAccessedFromSetting
			
			$scope.myChartOptions =  
	       
		        # Boolean - Whether we should animate the chart
		        animation : false

	        

		else 

			$scope.myChartOptions =  
	       
		        # Boolean - Whether we should animate the chart
		        animation : false

		        # Number - Number of animation steps
		        animationStep : 30

		        # String - Animation easing effect
		        animationEasing : "easeOutQuart"




		
		# ***************  Models *************** #
		$scope.user = User
		$scope.isAccessedViaLink = false
		# if the question is accessed via external link
		# get the url id and find the question with the id
		if $location.$$path.split('/')[1] == "question"
			
			$scope.isAccessedViaLink = true
			
			questionId = $stateParams.id
			foundQuestion = _.findWhere Question,{id:questionId}
			$scope.question = foundQuestion	

			$scope.answered = _.find foundQuestion.respondents,(id)->
				id == User._id




			

		else

			$scope.cards = FindQuestions.default()

		
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
		
			if $scope.question
				$scope.card = $scope.question

			console.log $scope.card
			alreadyAnswered = _.find _.pluck($scope.user.questionsAnswered,'_id'),(id)->
				
				if $scope.card != undefined
					$scope.card._id == id


			if alreadyAnswered
				
				$scope.card.alreadyAnswered = true
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
				
				question.respondents.push($scope.user._id)

				# update the option related data 
				choice.answeredBy.push($scope.user._id)
				choice.count++
				question.totalResponses++
				
				answer = 
					_id 	: question._id
					answer 	: choice.title

				
				# add the answer to user's database
				$scope.user.questionsAnswered.push(answer)

				$scope.submitted = true

				getData()

				

		$scope.fillStar = (question)->
			
			if User.isLoggedIn 

				$scope.favorite = !$scope.favorite

				if $scope.favorite

					$scope.user.favorites.push(question._id)
					question.numOfFavorites++

				else

					# attach it to the question
					index = $scope.user.favorites.indexOf(question._id)	
					$scope.user.favorites.splice(index,1)
					question.numOfFavorites--

			else 

				Error.auth = "Please sign up to proceed"
				
				$location.path('/signup')
				
		
			
		# ------------------ IO listeners ------------------ #
			
		# reset everything	
		$scope.$on 'resetAnswer',(question)->
			console.clear()
			console.trace()
			

			
			


			#shows the main question section
			$scope.submitted = false
			
			# decrement the total resonse for the reset
			$scope.card.totalResponses--


			# remove the user's id from the question's respondendents array
			indexOfRespondents = $scope.card.respondents.indexOf($scope.user._id)	
			$scope.card.respondents.splice(indexOfRespondents,1)

			# -- remove the question id from the user's questionAnswered Array -- #			
			# 1: get the question id
			questionId = $scope.card._id
			
			# 2: extract the IDs from the question already answered array from User
			answers = _.pluck($scope.user.questionsAnswered,'_id')
			

			# 3: compare the extracted IDs with the question ID# 3
			foundAnswerId = _.find answers,(id)->		
					id == questionId
			# 4: find which option the user chose for the question
			foundAnswered = _.find $scope.user.questionsAnswered, (answer)->
				answer._id == foundAnswerId

			# find the question option, which the user chose for the question
			foundOption = _.find $scope.card.option,(option)->
				option.title == foundAnswered.answer

			# remove the user's id from the options's answeredBy array
			optionIndex = foundOption.answeredBy.indexOf($scope.user._id)
			foundOption.answeredBy.splice(optionIndex,1)
			


			# using the found option, decrement the count for the reset
			foundOption.count--

			# find the index of the question id in the user's array
			index = answers.indexOf(questionId)
			
			# remove the question id from the user's array
			_.find $scope.user.questionsAnswered,(answer)->
				
				if answer._id == questionId
					
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
					inherit: true
					notify: true
				})

			,100,true

		$scope.closeQuestionModal = ()->
			

			$scope.$dismiss()
			
				

		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


