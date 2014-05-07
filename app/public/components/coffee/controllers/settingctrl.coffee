define ['underscore'], (_)->
	($scope,$location,$modal,$stateParams,$timeout,Question,User,Filters,Error,Setting)->

		$scope.type = $stateParams.type
		$scope.id = $stateParams.id
		$scope.user = User
		$scope.isAccessedFromSetting = true
		
		
		# shows which page is on
		Setting.isSetting = true
		
		

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

			ids = _.pluck User.questionsAnswered,"_id"
			$scope.questions = findQuestion(Question,ids)

			

		showFilters = $scope.showFilters = ->
			$scope.type = "filters"
			$location.path('setting/'+$scope.id+"/filters")

			# empty the questions
			$scope.questions=[]
			
			ids = _.pluck User.filterQuestionsAnswered,"_id"
			

			$scope.filters = findQuestion(Filters,ids)

			
			$scope.answer = []
			_.each User.filterQuestionsAnswered, (filter,index)->
				console.log filter.answer

				$scope.answer[index] = filter.answer



		showDeepResult = $scope.showDeepResult = (id)->
			Setting.questionId = id
			modalInstance = $modal.open(			
				templateUrl : 'views/modals/deepResultModal.html'
				controller 	: "DeepResultCtrl"
				windowClass : "deepResult"
			)


		$scope.openShareModal = (id)->
			Setting.questionId = id
			Setting.section = "setting/"+$scope.id+"/"+$scope.type
			modalInstance 	= $modal.open(			
				templateUrl : 'views/modals/shareModal.html'
				controller 	: "ShareCtrl"
				windowClass : "shareModal"
			)			



		# -------------------------- for initial load --------------------------#
		do ()->
			if $scope.type == "favorites" || $scope.type == "profile"
				
				showFavorites()

			else if $scope.type == "answers"
				
				showAnswers()

			else if $scope.type == "questions"
				
				showQuestions()

			else if $scope.type == "filters"
				
				showFilters()




		# ------------------ invoke the scope ------------------ #
		$scope.$apply()


