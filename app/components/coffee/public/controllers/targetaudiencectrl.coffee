define ['underscore'], (_)->
	($scope,Question)->

		


		# ------------------ Scope variables ------------------ #
		
		$scope.num = 0
		$scope.showResult = false
		$scope.targetAnswer = ""

		
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

					console.log $scope.user



				else

					$scope.num++

					# add the answer to the user's list
					$scope.user.filterQuestionsAnswered.push(answer)					



		# reset everything 
		$scope.resetAnswer = (user)->

			# get rid of the last question answered
			$scope.user.questionsAnswered.pop()

			# remove filterQuestionAnswered one by one
			# $scope.num = 0 means no new answers
			while $scope.num != 0
				
				$scope.user.filterQuestionsAnswered.pop()

				$scope.num--

			#cancels out everything
			$scope.showResult = false
			


			# send the information to the upper scopes
			$scope.$emit('resetAnswer',user)
			
			
			


		
		
		# ------------------ Invoke the scope ------------------ #		
		
		$scope.$apply()


