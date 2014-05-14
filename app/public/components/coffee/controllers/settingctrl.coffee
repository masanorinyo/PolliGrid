define ['underscore'], (_)->
	(
		$scope
		$location
		$modal
		$stateParams
		$timeout
		$http
		Question
		User
		Page
		Filters
		Error
		Setting
		FindQuestions

	)->

		$scope.type = $stateParams.type
		$scope.id = $stateParams.id
		$scope.anyContentsLeft = false
		if User.user
			
			$scope.user = User.user

		else
			
			$location.path('/')

		$scope.isAccessedFromSetting = true
		
		
		# shows which page is on
		Setting.isSetting = true
		
		

		findQuestion = ->
			# empties questions first



			$http
				method	: "GET"
				url 	: "/api/findQuestionsByIds"
				params	:
					ids 	: $scope.requiredIds
					offset 	: Page.questionPage
			
			.success (questions)-> 
				$scope.questions = questions


		$scope.downloadMoreQuestions = ()->
			 
			console.log Page.questionPage +=6
			$scope.showLoader = true
			$http
				method	: "GET"
				url 	: "/api/findQuestionsByIds"
				params	:
					ids 	: $scope.requiredIds
					offset 	: Page.questionPage
			
			.success (questions)-> 
				if !questions.length 
					$scope.anyContentsLeft = true
					$scope.showLoader = false
				
				$scope.questions.push(questions)
				
				
				

				
					
					
					

		

		# --------------- Setting Content navi --------------- #

		showFavorites = $scope.showFavorites = ->
			Page.questionPage = 0
			$scope.type = "favorites"
			# $location.path('setting/'+$scope.id+"/favorites").replace().reload(false)
			
			$scope.questions = []
			$scope.requiredIds = $scope.user.favorites
			findQuestion()

			
			
		showQuestions = $scope.showQuestions = ->
			Page.questionPage = 0
			$scope.type = "questions"
			# $location.path('setting/'+$scope.id+"/questions").replace().reload(false)
			
			$scope.questions = []
			$scope.requiredIds = $scope.user.questionMade
			findQuestion()
			

		showAnswers = $scope.showAnswers = ->
			Page.questionPage = 0
			$scope.type = "answers"
			# $location.path('setting/'+$scope.id+"/answers").replace().reload(false)
			
			ids = _.pluck $scope.user.questionsAnswered,"_id"
			$scope.requiredIds = ids
			
			findQuestion()
			

			

		showFilters = $scope.showFilters = ->
			
			$scope.type = "filters"
			# $location.path('setting/'+$scope.id+"/filters").replace().reload(false)

			# empty the questions
			$scope.questions=[]
			
			ids = _.pluck $scope.user.filterQuestionsAnswered,"_id"
			

			#
			$scope.filters = findQuestion(ids)

			# #
			# $scope.answer = []
			# _.each $scope.user.filterQuestionsAnswered, (filter,index)->
			# 	console.log filter.answer

			# 	$scope.answer[index] = filter.answer



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
			$timeout ->
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


