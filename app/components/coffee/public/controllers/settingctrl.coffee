define ['underscore'], (_)->
	($scope,$location,$modal,$stateParams,$timeout,Question,User,Filters,Error)->

		$scope.type = $stateParams.type
		$scope.id = $stateParams.id
		$scope.user = User
		$scope.isAccessedFromSetting = true
		
		

		findQuestion = (target,requiredIds)->
			# empties questions first
			questions = []

			_.each requiredIds, (requiredId)->
				foundQuestion = _.findWhere target,{id:requiredId}
				questions.push(foundQuestion)

			
			return questions



		# --------------- Setting Content navi --------------- #

		showFavorites = $scope.showFavorites = ->
			$scope.type = "favorites"
			$location.path('setting/'+$scope.id+"/favorites")

			$scope.questions = findQuestion(Question,User.favorites)
			
		showQuestions = $scope.showQuestions = ->
			$scope.type = "questions"
			$location.path('setting/'+$scope.id+"/questions")

			$scope.questions = findQuestion(Question,User.questionMade)

		showAnswers = $scope.showAnswers = ->
			$scope.type = "answers"
			$location.path('setting/'+$scope.id+"/answers")

			ids = _.pluck User.questionsAnswered,"id"
			$scope.questions = findQuestion(Question,ids)

			

		showFilters = $scope.showFilters = ->
			$scope.type = "filters"
			$location.path('setting/'+$scope.id+"/filters")

			# empty the questions
			$scope.questions=[]
			
			ids = _.pluck User.filterQuestionsAnswered,"id"
			

			$scope.filters = findQuestion(Filters,ids)

			
			$scope.answer = []
			_.each User.filterQuestionsAnswered, (filter,index)->
				console.log filter.answer

				$scope.answer[index] = filter.answer





		# -------------------------- for initial load --------------------------#
		do ()->
			if $scope.type == "favorites" || $scope.type == "profile"
				console.log 'i am favorite'
				showFavorites()

			else if $scope.type == "answers"
				console.log 'i am answers'
				showAnswers()

			else if $scope.type == "questions"
				console.log 'i am questions'
				showQuestions()

			else 
				console.log 'i am filter'
				showFilters()




		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


