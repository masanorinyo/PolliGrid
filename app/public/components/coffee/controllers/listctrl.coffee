define ['underscore'], (_)->
	(
		$scope
		$location
		$state
		$stateParams
		$timeout
		$q
		$http
		FindQuestions
		User
		Filters
		Error
		Search
		UpdateQuestion
		Question
		Page
		UpdateUserInfo
		Setting
	)->


		# ------------------ IO listeners ------------------ #
		$scope.$on 'userLoggedIn',(data)->
			console.log "I am not a visitor anymore"
			$scope.user = User.user

			
		
		

		# reset everything	
		$scope.$on 'resetAnswer',(question)->
			


			if _.isArray($scope.user.visitorId)

				# find the visitor id that is in the question's respondnets
				visitorId = _.intersection $scope.card.respondents, $scope.user.visitorId

			else

				# find the visitor id that is in the question's respondnets
				visitorId = _.intersection $scope.card.respondents,[$scope.user.visitorId]
			
			# get the first element of the visitor id in the array			
			visitorId = visitorId[0]


			# if user is logged in
			if User.user

				# find if the question respondnets hold the user's id
				userId = _.intersection $scope.card.respondents,[User.user._id]
				userId = userId[0]
				
				# if the question holds the user's id, then ignore visitorId
				if userId 
					visitorId = 0
				
				else 
					userId = 0
			else
				visitorId = User.visitor._id
			
			if not visitorId or visitorId is undefined then visitorId = 0
			
			if not userId or userId is undefined then userId = 0
			

			
			


			#shows the main question section
			$scope.submitted = false
			
			


			# decrement the total resonse for the reset
			$scope.card.totalResponses--
			# remove the user's id from the question's respondendents array
			if userId 
				indexOfRespondents = $scope.card.respondents.indexOf(userId)
			else
				indexOfRespondents = $scope.card.respondents.indexOf(visitorId)
			
			$scope.card.respondents.splice(indexOfRespondents,1)

			# -- remove the question id from the user's questionAnswered Array -- #			
			# 1: get the question id
			questionId = $scope.card._id
			
			
			if User.user
				found = _.find User.user.questionsAnswered,(answer)->
					answer._id == questionId
			else 
				found = _.find $scope.user.questionsAnswered,(answer)->
					answer._id == questionId

			
			# # 4: find which option the user chose for the question
			# foundAnswered = _.find $scope.user.questionsAnswered, (answer)->
			# 	answer._id == foundAnswerId

			# find the question option, which the user chose for the question
			foundOption = _.find $scope.card.option,(option)->
			
				option.title == found.answer

			

			# remove the user's id from the options's answeredBy array
			if userId 
				optionIndex = foundOption.answeredBy.indexOf(userId)
			else
				optionIndex = foundOption.answeredBy.indexOf(visitorId)

			foundOption.answeredBy.splice(optionIndex,1)
			

			# reset the server side data
			# also remove all the data made when the user was in the visitor state
			if User.user
				UpdateUserInfo.reset(
					questionId 	: questionId
					userId 		: User.user._id
				)


			# using the found option, decrement the count for the reset
			foundOption.count--

			answers = _.pluck($scope.user.questionsAnswered,'_id')

			# find the index of the question id in the user's array
			index = answers.indexOf(questionId)
			
			# remove the question id from the user's array
			_.find $scope.user.questionsAnswered,(answer)->
				
				if answer._id == questionId
					
					$scope.user.questionsAnswered.splice(index,1)
				



			# takes out all the user id 

			_.each $scope.card.targets,(target,index)->
				_.find target.lists,(list,index)->
					
					if _.contains(list.answeredBy,userId) || _.contains(list.answeredBy,visitorId)
				
						if userId then list.answeredBy = _.without(list.answeredBy,userId)
						if visitorId then list.answeredBy = _.without(list.answeredBy,visitorId)
						
						UpdateQuestion.removeFiltersAnswer(
							questionId 			: $scope.card._id
							userId 				: userId
							visitorId 			: visitorId
							title 				: "0"
							filterId 			: target._id
							index 				: index
						)

			
		
			UpdateQuestion.removeAnswer(
				questionId 			: questionId
				userId 				: userId
				title 				: escape(foundOption.title)
				filterId 			: 0
				index 				: 0
				visitorId   		: visitorId
			)
		
				
			# reset the chosen answers
			$scope.answer = ''	
			

		$scope.$on 'logOff',(value)->
			console.log "Log off from list"
			$scope.submitted = false
			$scope.user = User.visitor
			$scope.warning = false
			$scope.favorite = false
			$scope.submitted = false
			$scope.user.questionsAnswered = []
			


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
				
				# if the length of option is longer than 3 words or 10 characters
				if title.split(/\s+/).length > 3 or title.length > 10
					maxLength 		= 20
					trimmedTitle 	= title.substr(0, maxLength)
					title 			= trimmedTitle.substr(0, Math.min(trimmedTitle.length, trimmedTitle.lastIndexOf(" ")))
					title  			= title.concat("..")

				data =
					value 			: count
					color 			: color
					label 			: title
					labelColor 		: "#FEFEFE"
					labelFontSize 	: "15"
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
		
		
			
		$scope.myChartOptions =  
	       
	        # Boolean - Whether we should animate the chart
	       animation : false

	        



		# 	$scope.myChartOptions =  
	       
		#         # Boolean - Whether we should animate the chart
		#         animation : false

		#         # Number - Number of animation steps
		#         animationStep : 30

		#         # String - Animation easing effect
		#         animationEasing : "easeOutQuart"




		
		# ***************  Models *************** #
		if User.user && !$scope.isAccessedFromSetting
			console.log "User.user"
			console.log User.user	
			$scope.user = User.user

		else if !$scope.isAccessedFromSetting
			
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
			
			console.log 'checking the status'
			
			answeredQuestions = null
			
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
	

							_.each data.respondents,(id)->
								
								if id == $scope.user._id 
									$scope.question = data
									$scope.submitted = true
									$scope.question.alreadyAnswered = true 

								_.each $scope.user.visitorId,(vid)->
									if vid == id 
										$scope.question = data
										$scope.submitted = true
										$scope.question.alreadyAnswered = true 





					else

						$scope.cards = FindQuestions.default()
				
				.then -> 
					# cancel the card status for the initial load
					if not Setting.isSetting and not $scope.isAccessedViaLink
						console.log 'Reset the question status'
						$scope.card.alreadyAnswered = false

				.then ->
					
					if $scope.question
						
						$scope.card = $scope.question
						
				.then ->
					
					answeredQuestions = _.find _.pluck($scope.user.questionsAnswered,'_id'),(id)->
						
						if $scope.card != undefined
							$scope.card._id == id

				.then ->
					
					if answeredQuestions
						
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
				UpdateQuestion.updateQuestion(
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


				


				if User.user

					# save info in the server
					UpdateUserInfo.answerQuestion(
						userId 			: escape($scope.user._id)
						questionId 		: escape(question._id )
						questionAnswer 	: escape(choice.title)
					)

				$scope.user
				$scope.submitted = true

				getData()

				

		$scope.fillStar = (question)->
			
			if $scope.user.isLoggedIn

				$scope.favorite = !$scope.favorite

				if $scope.favorite

					$scope.user.favorites.push(question._id)
					question.numOfFavorites++

					

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



					# save question id in user's favorite questions
					UpdateUserInfo.favorite(
						userId 		: escape($scope.user._id)
						questionId  : escape(question._id)
						task		: escape("favoritePull")
					)

			else 

				Error.auth = "Please sign up to proceed"
				
				$location.path('/signup')
				
		
			
		

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

			


				

		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


