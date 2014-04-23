define ['underscore'], (_)->
	($scope,$timeout,$q,Question)->

		# ------------------ Utility functions ------------------ #		
		
		# determine the initial filter questions
		# increment filterNumber until it hits the unanswered filter question
		skipThroughFilterQuestions = ()->

			#initial number
			$scope.filterNumber = 0
			
			length = $scope.targetChecker.length
			i = 0
			
			# keep skipping the filter question until it hits 
			# the question which has not been answered.
			while i < length
				
				if $scope.targetChecker[i].isAnswered
					
					$scope.filterNumber++
									
					
				else
					
					break

				i++


			return $scope.filterNumber
				

		# check if all of the filter question is answered
		checkIfEverythingAnswered = ()->
			
			length = $scope.targetChecker.length
			i=0
			numOfAnswers = 0



			while i < length
				

				if $scope.targetChecker[i].isAnswered
					numOfAnswers++ 
					
				i++

			

			# if the number of filter questions and 
			# number of filter questions answered
			# make allQuestionAnswered true, which show the result section
			if numOfAnswers == length
				$scope.areAllQuestionAnswered = true
				$scope.filterNumber = -1
				

		# this will determine which filter question is not answered
		makeTargetChecker = (answer)->
			

			#cleans up the checker first
			$scope.targetChecker = []
			
			
			# get how many filter questions the question has
			length = $scope.question.targets.length
			i=0

			# get which question the user already answered to
			answeredIds = _.pluck $scope.user.filterQuestionsAnswered, 'id'


			while i < length
				
				questionId = Number($scope.question.targets[i].id)

				# find out if the question has filter questions, which
				# the user already answered to
				foundId = _.find answeredIds, (id)->
					Number(id) == questionId

				# if found, then this filter question won't show up
				if foundId
					
					#this will be used to show if the user already answered to the filter question	
					target  =
						id 			: foundId
						isAnswered 	: true



				# if not found, then this filter question will show up
				else 


					#this will be used to show if the user already answered to the filter question	
					target  =
						id 			: questionId
						isAnswered 	: false


				# after determining if the filter question is answered
				# add it to the targetChecker object
				$scope.targetChecker.push(target)

				i++


			return $scope.targetChecker
			

		# check to see if all the filter question is answered
		checkFilterQuestionStatus = (answer)->
			defer = $q.defer()
			defer.promise
				.then ()->
					
					makeTargetChecker(answer)
					
				
				.then ()->

					checkIfEverythingAnswered()

			defer.resolve()


		# check if the question is already answered by the user
		checkIfQuestionAlaredyAnswered = ()->
			
			found = _.pluck $scope.user.questionsAnswered,'id'

			isThisQuestionAnswered = _.find found, (id)->
				id == $scope.question.id

			if isThisQuestionAnswered
				
				$scope.question.alreadyAnswered = true		


		# ------------------ Scope variables ------------------ #
		
		$scope.showResult = false
		$scope.targetAnswer = ""
		$scope.areAllQuestionAnswered = false

		# this will show and hide specific filter questions
		$scope.filterNumber = 0
		

		# target filter answered or not
		$scope.targetChecker =[]
		

		# inital loading - to show results of the questions users already answered
		do ()->

			checkFilterQuestionStatus('')
			checkIfQuestionAlaredyAnswered()
			skipThroughFilterQuestions()
			

		# ------------------ Scope funcitons ------------------ #
		
		$scope.submitTarget = (question,targetAnswer,index)->
			

			# warning message pops up if users didn't choose any answer
			if targetAnswer is "" or !targetAnswer
			
				$scope.warning = true

			else

				# remove the warniing popup since the user selected something
				$scope.warning = false

				# this will get the id of the target audience question.
				targetQuestionID = question.targets[index].id

				

				# user's answer to the target question
				answer = 
					id 		: targetQuestionID
					answer 	: targetAnswer
				


				# add the answered filter question to the user's filterQuestionsAnswered collection
				# this way, the same filter question won't show up from the next time
				$scope.user.filterQuestionsAnswered.push(answer)

				
				defer = $q.defer()
				defer.promise
					.then ->

						checkFilterQuestionStatus(answer)

					.then ->
					
						# skip the filter question which is already answered
						skipThroughFilterQuestions()
							

						# if everything is answered, show result
						if $scope.areAllQuestionAnswered
							

							# by making this true, the question will show result from the next time
							# without answering.
							$scope.question.alreadyAnswered = true

				defer.resolve()



		# reset everything 
		$scope.resetAnswer = (question)->
			
			# cancels out all the answers
			$scope.areAllQuestionAnswered = false
			
			makeTargetChecker('')
			
			#cancels out everything
			$scope.showResult = false

			$scope.question.alreadyAnswered = false
			

			# send the information to the upper scopes
			$scope.$emit('resetAnswer',question)
			
			
			

		$scope.$on "showGraph", (result)->
			
			$scope.showResult = true
			
		# when users answer to a main question,
		# check if the user already answered to all its filter questions
		$scope.$on 'answerSubmitted',(message)->



			checkFilterQuestionStatus('')
			
			$timeout ()->
			
				skipThroughFilterQuestions()
				
				console.log "low"
				console.log $scope.filterNumber
				console.log "low"
				console.log $scope.targetChecker
			


			,300,true
			
		
		# ------------------ Invoke the scope ------------------ #		
		
		$scope.$apply()


