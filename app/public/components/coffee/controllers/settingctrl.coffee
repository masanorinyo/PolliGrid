define ['underscore'], (_)->
	(
		$scope
		$location
		$modal
		$stateParams
		$timeout
		$http
		$q
		Question
		User
		Page
		Filters
		Error
		Setting
		FindQuestions
		Verification
		location
	)->

		$scope.type = $stateParams.type
		$scope.id = $stateParams.id
		$scope.onMyPage = false
		$scope.showLoader = false
		$scope.anyContentsLeft = false
		$scope.userLoaded = false

		$scope.anotherUser = 
			username : null
			photo : null

		$scope.questionsCreatedByAnother = []

		$scope.filtersOnSettingPage = false
		$scope.isAccessedFromSetting = true
		$scope.filters = []
		
		# shows which page is on
		Setting.isSetting = true
		
		

		findQuestion = ->
			# empties questions first

			

			$http
				method	: "GET"
				url 	: "/api/findQuestionsAndFiltersByIds"
				params	:
					ids 	: $scope.requiredIds
					offset 	: 0
					type 	: $scope.type
			
			.success (data)-> 
				
				if $scope.type != "filters"
				
					$scope.questions = data
				
				else 
					
					defer = $q.defer()
										
					defer.promise
						.then ->
							_.each data,(targets)->
								_.each targets.lists,(list)->
									console.log list
									console.log 'test'
									list.option = unescape(list.option)

						.then -> 
							
							
							console.log $scope.filters = data
						
						.then ->
							$scope.answer = []
							
							_.each $scope.user.filterQuestionsAnswered, (filter,index)->
								
								_.each $scope.filters,(s_filter,s_index)->
									
									if s_filter._id == filter._id
								
										$scope.answer[s_index] = unescape(filter.answer)

					
					defer.resolve()
					
				
				if data.length < 6 
					$scope.anyContentsLeft = true


		$scope.downloadMoreData = ()->


			if $scope.type != "filters"
				Page.questionPage +=5
				page = Page.questionPage
			else 
				Page.filterPage +=5
				page = Page.filterPage
			
			removeIndex = $scope.requiredIds.length - page
			console.log removeIndex

			if parseInt(removeIndex) > 0
			
				$scope.showLoader = true
				ids = []
				
				defer = $q.defer()
				defer.promise
					.then ->
						
						$scope.requiredIds.forEach (val,key)->
							if key > page and key < page + 6
								console.log val
								ids.push(val)
					
					.then ->
						
						$http
							method	: "GET"
							url 	: "/api/findQuestionsAndFiltersByIds"
							params	:
								ids 	: ids
								offset 	: page
								type 	: $scope.type
						
						.success (data)->
							console.log 'test'
							
							$scope.showLoader = false
							if !data.length
								$scope.anyContentsLeft = true
							else
								data.forEach (val,key)->
									
									if $scope.type != "filters"
										console.log 'test'
										$scope.questions.push(val)
									else 

										defer = $q.defer()
										
										defer.promise
											.then ->
												_.each val.lists,(list)->
													list.option = unescape(list.option)

											.then -> 
												console.log val
												$scope.filters.push(val)
										defer.resolve()

				
				defer.resolve()
			else 
				
				
				$scope.showLoader = false
				$timeout ->
					$scope.anyContentsLeft = true

				
		

		# --------------- Setting Content navi --------------- #

		showFavorites = $scope.showFavorites = ->
			$scope.filtersOnSettingPage = false
			$scope.anyContentsLeft = false
			Page.questionPage = 0
			$scope.type = "favorites"
			console.log $scope.user.favorites
			
			# url = 'setting/favorites/'+$scope.id

			#without reload - currently not working
			# location.skipReload().path(url).replace()

			# 
			$scope.questions = []
			$scope.requiredIds = $scope.user.favorites
			findQuestion()

			
			
		showQuestions = $scope.showQuestions = ->
			$scope.filtersOnSettingPage = false
			$scope.anyContentsLeft = false
			Page.questionPage = 0
			$scope.type = "questions"
			console.log $scope.user.questionMade
			
			# url = 'setting/questions/'+$scope.id
			#without reload - currently not working
			# location.skipReload().path(url).replace()
			$scope.questions = []

			unless $scope.onMyPage
				
				$scope.requiredIds = $scope.questionsCreatedByAnother	
			
			else 

				$scope.requiredIds = $scope.user.questionMade

			
			findQuestion()
			

		showAnswers = $scope.showAnswers = ->
			$scope.filtersOnSettingPage = false
			$scope.anyContentsLeft = false
			Page.questionPage = 0
			$scope.type = "answers"
			
			# url = 'setting/answers/'+$scope.id
			
			#without reload - currently not working
			# location.skipReload().path(url).replace()
			
			$scope.requiredIds = _.pluck $scope.user.questionsAnswered,"_id"
			
			
			findQuestion()
			

			

		showFilters = $scope.showFilters = ->
			$scope.filtersOnSettingPage = true
			$scope.anyContentsLeft = false
			Page.filterPage = 0
			$scope.type = "filters"
			
			# url = 'setting/filters/'+$scope.id

			#without reload - currently not working
			# location.skipReload().path(url).replace()


			$scope.requiredIds = _.pluck $scope.user.filterQuestionsAnswered,"_id"
			
			
			findQuestion()




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

		$scope.verificationBtn = "Send a verification E-mail"
		$scope.sendVerification = ->
			$scope.verificationBtn = "E-mail sent"
			$timeout ->
				$scope.verificationBtn = "Send a verification E-mail again"
			,1500,true
			
			$http 
				method:"POST"
				url:'/api/resend'
				data:
					user:$scope.user
					
			.success (data)->
				
				
				

		
		# -------------------------- for initial load --------------------------#
		do ()->

			$http 
				method:"GET"
				url:"/api/getUser"
				params:
					userId:$scope.id

			.success (user)->
				
				
				
				# if user is not found, redirect to the main page
				if user._id is undefined 


					$location.path('/')

				else 

					if User.user._id == $scope.id 
						$scope.user = User.user
						$scope.onMyPage = true

					else 
						$scope.questionsCreatedByAnother = user.questionMade
						$scope.anotherUser.username = user.username
						$scope.anotherUser.photo = user.profilePic
					
					$scope.userLoaded = true
				

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


