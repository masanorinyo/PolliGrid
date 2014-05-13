define ['underscore'], (_)->
	(
		$scope
		$location
		$state
		$stateParams
		$timeout
		$q
		FindQuestions
		User
		Filters
		Error
		Search
		UpdateQuestion
		Question
		Page
		UpdateUserInfo
	
	)->


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
		if User.user
			console.count "user user"
			$scope.user = User.user

		else
			
			$scope.user = User.visitor

		$scope.isAccessedViaLink = false
		

		
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
			
			# if the question is accessed via external link
			# get the url id and find the question with the id
			defer = $q.defer()
			defer.promise
				.then ->

					if $location.$$path.split('/')[1] == "question" 
						
											
						$scope.isAccessedViaLink = true
						
						questionId = $stateParams.id
						
						
						$scope.question = Question.get(
												{
													questionId:escape(questionId)
												}
											)
						
						$scope.question.$promise.then (data)->
							#  close the modal box and redirect to the main page
							#  question is not found
							unless data._id
								
								$scope.$dismiss()
								$timeout -> 
									$location.path('/')
								,100,true
								

						$scope.answered = _.find $scope.question.respondents,(id)->
							id == $scope.user._id



					else

						$scope.cards = FindQuestions.default()

				.then ->

					if $scope.question
						$scope.card = $scope.question

					
					alreadyAnswered = _.find _.pluck($scope.user.questionsAnswered,'_id'),(id)->
						
						if $scope.card != undefined
							$scope.card._id == id


					if alreadyAnswered
						
						$scope.card.alreadyAnswered = true
						getData()

			defer.resolve()



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

				

				# server side
				console.log UpdateQuestion.updateQuestion(
					questionId 	: question._id
					userId 		: $scope.user._id
					title 		: escape(choice.title)
					filterId 	: 0
					index 		: 0
				)

				# front side
				question.respondents.push($scope.user._id)
				# update the option related data 
				choice.answeredBy.push($scope.user._id)
				choice.count++
				question.totalResponses++
				

				# update user 
				answer = 
					_id 	: question._id
					answer 	: choice.title
				
				# add the answer to user's database
				$scope.user.questionsAnswered.push(answer)


				console.log "update user info"


				if $scope.user.isLoggedIn
					# save info in the server
					UpdateUserInfo.answerQuestion(
						userId 			: escape($scope.user._id)
						questionId 		: escape(question._id )
						questionAnswer 	: escape(choice.title)
					)

				console.log $scope.user
				$scope.submitted = true

				getData()

				

		$scope.fillStar = (question)->
			console.log question
			if $scope.user.isLoggedIn

				$scope.favorite = !$scope.favorite

				if $scope.favorite

					$scope.user.favorites.push(question._id)
					question.numOfFavorites++

					console.log $scope.user._id

					# increment the number of filters of the question
					Question.favorite(
						questionId 	: escape(question._id)
						action 		: escape("increment")
					)

					# save question id in user's favorite questions
					UpdateUserInfo.favorite(
						userId 		: escape($scope.user._id)
						questionId  : escape(question._id)
						task		: escape("favoritePush")
					)


				else

					# attach it to the question
					index = $scope.user.favorites.indexOf(question._id)	
					$scope.user.favorites.splice(index,1)
					question.numOfFavorites--
					
					# decrement the number of filters of the question
					Question.favorite(
						questionId 	: escape(question._id)
						action 		: escape("decrement")
					)					

					console.log $scope.user._id

					# save question id in user's favorite questions
					UpdateUserInfo.favorite(
						userId 		: escape($scope.user._id)
						questionId  : escape(question._id)
						task		: escape("favoritePull")
					)

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
				

			console.log foundOption.title
			console.log questionId
			console.log $scope.user._id
			console.log UpdateQuestion.removeAnswer(
				questionId 	: questionId
				userId 		: $scope.user._id
				title 		: escape(foundOption.title)
				filterId 	: 0
				index 		: 0
			)
			
			# reset the chosen answers
			$scope.answer = ''
			

		$scope.$on 'userLoggedIn', (value)->
			console.log User.user
			$scope.user = User.user

		$scope.$on 'logOff',(value)->
			console.log "Log off from list"
			
			$scope.submitted = false
			$timeout ->
				$scope.user = User.visitor
				console.log $scope.user

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


