define ['underscore'], (_)->
	($scope,$timeout,$q,Question)->

		# ------------------ Utility functions ------------------ #		
		
		# check if all of the filter question is answered
		checkIfEverythingAnswered = ()->
			
			length = $scope.targetChecker.length
			i=0

			while i < length

				if $scope.targetChecker[i].isAnswered
					
					$scope.areAllQuestionAnswered = true

				else 

					$scope.areAllQuestionAnswered = false
				i++
				

		addFilterAnswer = (answer)->
			#once answers to the filter added, 
			defer = $q.defer()
			defer.promise
				.then ()->
					# add the answer to the user's list
					$scope.user.filterQuestionsAnswered.push(answer)					
				.then ()->

					# for show-result directive
					# used to compare the question's target id 
					# if it is found in the question's target id, then removes it.
					$scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered),'id')
			defer.resolve()


		makeTargetChecker = ()->

			length = $scope.question.targets.length
			i=0

			
			
			while i < length
				
				#this will be used to show if the user already answered to the filter question	
				target  =
					id  		: $scope.question.targets[i].id
					isAnswered 	: false



				$scope.targetChecker.push(target)
				i++

		# ------------------ Scope variables ------------------ #
		
		$scope.num = 0	
		$scope.showResult = false
		$scope.targetAnswer = ""
		$scope.areAllQuestionAnswered = false

		# target filter answered or not
		$scope.targetChecker =[]

		# for show-result directive
		# used to compare the question's target id 
		# if it is found in the question's target id, then removes it.
		$scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered),'id')




		do ()->

			makeTargetChecker()


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
				
				
				# find the answered filter question 
				# make true the boolean value isAnswered of the targetChecker related to the filter id 
				defer = $q.defer()
				defer.promise
					.then ()->
						
						answer = _.find $scope.targetChecker, (target)->

							target.id == targetQuestionID

						
						answer.isAnswered = true

					.then ()->

						checkIfEverythingAnswered()

				defer.resolve()



				# if everything is answered, show result
				if $scope.areAllQuestionAnswered
					
					# this will add the filter answer to user's answers list
					addFilterAnswer(answer)

					# this will show the result section
					$scope.showResult = true

					# by making this true, the question will show result from the next time
					# without answering.
					$scope.question.alreadyAnswered = true

				# if everything is not answered, go to the next filter question
				else

					# this will add the filter answer to user's answers list
					addFilterAnswer(answer)



		# reset everything 
		$scope.resetAnswer = (question)->
			
			# cancels out all the answers
			$scope.areAllQuestionAnswered = false
			makeTargetChecker()
			
			#cancels out everything
			$scope.showResult = false

			$scope.question.alreadyAnswered = false
			

			# send the information to the upper scopes
			$scope.$emit('resetAnswer',question)
			
			
			


		
		
		# ------------------ Invoke the scope ------------------ #		
		
		$scope.$apply()


