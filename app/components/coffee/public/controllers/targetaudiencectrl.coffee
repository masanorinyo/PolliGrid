define ['underscore'], (_)->
	($scope,$timeout,$q,Question)->

		# ------------------ Utility functions ------------------ #		
		
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
				

		# this will determine which filter question needs to be shown
		makeTargetChecker = (answer)->
			
			#cleans up the checker first
			$scope.targetChecker = []
			
			# get how many filter questions the question has
			length = $scope.question.targets.length
			i=0


			# get which question the user already answered to
			answeredIds = _.pluck $scope.user.filterQuestionsAnswered, 'id'

			# if the user answered to a filter question
			# add the filter id into the answeredIds array
			if answer != ""
				answeredIds.push(answer.id)
			
			while i < length
				
				# find out if the question has filter questions, which
				# the user already answered to
				found = _.find answeredIds, (id)->
					Number(id) == Number($scope.question.targets[i].id)

				# if found, then this filter question won't show up
				if found
					
					#this will be used to show if the user already answered to the filter question	
					target  =
						id 			: found
						isAnswered 	: true

				# if not found, then this filter question will show up
				else 

					# get the filter question id
					$scope.question.targets[i].id

					#this will be used to show if the user already answered to the filter question	
					target  =
						id 			: $scope.question.targets[i].id
						isAnswered 	: false



				$scope.targetChecker.push(target)
				i++

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

		# target filter answered or not
		$scope.targetChecker =[]


		# inital loading - to show results of the questions users already answered
		do ()->

			checkFilterQuestionStatus('')
			checkIfQuestionAlaredyAnswered()
		

		# when users answer to a main question,
		# check if the user already answered to all its filter questions
		$scope.$on 'answerSubmitted',(message)->

			checkFilterQuestionStatus('')

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
				

<<<<<<< HEAD
				# $scope num will increment everytime users answer to
				# target audience question.
				# when the $scope num matches the total number of the filter questions
				# then the result seciton will be shown.
				if $scope.num == question.numOfFilters-1
					console.log 'current scope num :'+$scope.num
					# since the question.numOfFilters is one more
					# than $scope.num so by euqalizing them, 
					# the target audience section will be hidden
					$scope.num = question.numOfFilters


					addFilterAnswer(answer)
=======
				checkFilterQuestionStatus(answer)
>>>>>>> testing

		
				# if everything is answered, show result
				if $scope.areAllQuestionAnswered
					

					# by making this true, the question will show result from the next time
					# without answering.
					$scope.question.alreadyAnswered = true

<<<<<<< HEAD

				else
					console.log 'current scope num :'+$scope.num
					$scope.num++

					addFilterAnswer(answer)

=======
			
>>>>>>> testing


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
			
		
		
		# ------------------ Invoke the scope ------------------ #		
		
		$scope.$apply()


