define ['underscore'], (_)->
	($scope,Question,User,Filters)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		$scope.questions = Question
		
		$scope.answer = ''
		

		# ***************  Variables *************** #
		$scope.isStarFilled = false
		$scope.submitted = false

		targetQ = $scope.targetQ =
			isQuestionAnswered : false


		$scope.warning = false
		

		





		# ***************  Functions *************** #
		$scope.submitAnswer = (choice,question)->

			if choice is "" or !choice
			
				$scope.warning = true

			else
				
				$scope.warning = false
				choice.count++
				question.totalResponses++
				
				answer = 
					id 		: question.id
					answer 	: choice.title

				# add the answer to user's database
				$scope.user.questionsAnswered.push(answer)

				$scope.submitted = true
		



		

		$scope.fillStar = (question)->
			
			question.favorite = !question.favorite

			if question.favorite

				$scope.user.favorites.push(question.id)

			else

				# attach it to the question
				index = $scope.user.favorites.indexOf(question.id)	
				$scope.user.favorites.splice(index,1)
				

			
		# ------------------ IO listeners ------------------ #
			
		# reset everything	
		$scope.$on 'resetAnswer',(question)->
			
			#shows the main question section
			$scope.submitted = false
			
			# decrement the total resonse for the reset
			$scope.question.totalResponses--


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


