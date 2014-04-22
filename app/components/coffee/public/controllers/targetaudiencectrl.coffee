define ['underscore'], (_)->
	($scope,$timeout,$q,Question)->

		
		

		# ------------------ Scope variables ------------------ #
		
		$scope.num = 0	
		$scope.showResult = false
		$scope.targetAnswer = ""

		# for show-result directive
		# used to compare the question's target id 
		# if it is found in the question's target id, then removes it.
		$scope.clonedAnsweredIds = _.pluck(angular.copy($scope.user.filterQuestionsAnswered),'id')

	
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


					addFilterAnswer(answer)

					

					# this will show the result section
					$scope.showResult = true

					$scope.question.alreadyAnswered = true


				else

					$scope.num++

					addFilterAnswer(answer)



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


