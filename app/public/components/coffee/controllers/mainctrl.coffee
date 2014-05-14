define ["underscore"], (_)->
	(
		$scope
		$location
		$q
		$stateParams
		$timeout
		$state
		User
		Page
		FindQuestions
		Debounce
		Search
		QuestionTypeHead
		NewQuestion
		Verification
		ipCookie
	)->


		# --------------- Util functions --------------- #					
		capitaliseFirstLetter = (string)->
			string.charAt(0).toUpperCase() + string.slice(1);
		
		# --------------- Models --------------- #					

		# if user is a returnee, then assign User.user
		
		if User.user
			
			$scope.user = User.user

		else
			
			$scope.user = User.visitor
		
		# make sure the user id doesn't conflict with others'
		$timeout ->
					

			foundUser = false

			defer = $q.defer()

			# generate unique id for visitor
			if !User.user
				defer.promise
				
					.then -> 
						
						Verification.findUserById({id:escape($scope.user._id)}).$promise.then (data)->
							foundUser = data.foundUser
						
					.then ->

						
						
						# if user is found, keep changin the id until it becomes unique
						
						if foundUser 
							
							
							randomNum = Math.floor(Math.random() * 99)
							$scope.user._id = $scope.user._id.concat(randomNum)
							Verification.findUserById({id:escape($scope.user._id)}).$promise.then (data)->
								foundUser = data.foundUser
							
							
				defer.resolve()
			
			
			

		,200,true



		# get the questions when the page loads up
		$scope.questions = FindQuestions.default()

		# --------------- Variables --------------- #			
		
		$scope.showLoader = false

		$scope.anyContentsLeft = false
		
		$scope.searchQuestion = ''
		$scope.searchTerm = 'All'


		$scope.toggleSearchBox = false
		$scope.orderBox = false
		$scope.categoryBox = false
		$scope.parentSize = 
			width  : 0
			height : 0
		
		# default option
		$scope.category = "All"
		$scope.order = "Recent"

		$scope.options = 
			categories : [
				"All"
				"Animal"
				"Architecture"
				"Art"
				"Cars & Motorcycles"
				"Celebrities"
				"Design"
				"DIY & Crafts"
				"Education"
				"Film, Music & Books"
				"Food & Drink"
				"Gardening"
				"Geek"
				"Hair & Beauty"
				"Health & Fitness"
				"History"
				"Holidays & Events"
				"Home Decor"
				"Humor"
				"Illustration & Posters"
				"Lifestyle"
				"Men's Fashion"
				"Outdoors"
				"Photography"
				"Products"
				"Quotes"
				"Science & Nature"
				"Sports"
				"Tatoos"
				"Technology"
				"Travel"
				"Weddings"
				"Women's Fashion"
				"Other"
			]

			orders : [
				"Recent"
				"Old"
				"Most voted"
				"Most popular"
			]


		# ----------- utility functions ----------- #

		searchSpecificQuestions = ->
			console.log $scope.questions
			
			if $scope.searchQuestion is ""
				$scope.searchTerm = "All"
			else
				$scope.searchTerm = $scope.searchQuestion

			FindQuestions.get(
				{
					searchTerm 	: escape($scope.searchTerm)
					category 	: escape($scope.category)
					order 		: escape($scope.order)
					offset 		: Page.questionPage
				}
			).$promise
				.then (data)->

					if !data.length
						$scope.showLoader = false
						$scope.anyContentsLeft = true

					else 
						data.forEach (val,key)->
						
							$scope.questions.push(val)


		


		# --------------- scope functions --------------- #
		$scope.refresh = ()->
			
			$location.path('/')
			
			
			# reload the page
			$state.transitionTo($state.current, $stateParams, {
				reload: true
				inherit: false
				notify: true
			})

			


		# type head
		$scope.selectedTypehead = ($item)->
			Page.questionPage = 0
			$scope.questions = []
			$scope.searchQuestion = $item
			searchSpecificQuestions()

		$scope.getPartOfQuestion = (term)->
			
			QuestionTypeHead.get(
				{
					term:escape(term)
					category:escape($scope.category)
				}
			).$promise
				.then (data)->

					questions = []
					data.forEach (val,key)->
						
						questions.push(val.question)

					return questions




		# Contents handler #			
		$scope.changeOrder = (value)->
			
			defer = $q.defer()
			defer.promise
				
				.then -> 
				
					$scope.anyContentsLeft = false
					Page.questionPage = 0
					$scope.questions = []
				
				.then -> $scope.order = value
				
				.then -> searchSpecificQuestions()
			
			defer.resolve()
			
			
			

		$scope.changeCategory = (value)->
			
			defer = $q.defer()
			defer.promise

				.then -> 
					$scope.anyContentsLeft = false
					Page.questionPage = 0
					$scope.questions = []

				.then -> $scope.category = value

				.then -> searchSpecificQuestions()

			defer.resolve()



		$scope.searchingQuestions = -> 
			$scope.anyContentsLeft = false
			Page.questionPage = 0
			$scope.questions = []
			searchSpecificQuestions()
			
		

		# delays typing event
		$scope.updateSearch = Debounce($scope.searchingQuestions, 500, false);
		
		
		$scope.$on 'category-changed',(category)->
			
			$scope.changeCategory(capitaliseFirstLetter(Search.category))


		

		$scope.$on 'newQuestionAdded',(value)->
			
			$scope.questions.unshift(NewQuestion.question)


		$scope.$on 'downloadMoreQuestions',(value)->
			Page.questionPage += 6
			$scope.showLoader = true
			
			callback = -> 
				$scope.showLoader = false



			defer = $q.defer()
			defer.promise
				
				.then -> searchSpecificQuestions()

			defer.resolve(callback)

		$scope.$on 'userLoggedIn', (value)->
			console.log "main"

			
			$scope.user = User.user
			console.log $scope.user
		
		$scope.logout = ()->
		
			# cleans up the visitor varable
			User.visitor.questionsAnswered = []
			User.visitor.filterQuestionsAnswered = []

			$scope.user = User.visitor
			
			ipCookie.remove("loggedInUser")
			
			# $scope.questions = FindQuestions.default()
			
			$scope.$broadcast 'logOff', User.visitor
			User.user = null
			$location.path('/')
			

			# $http 
			# 	method 	: "GET"
			# 	url 	: "/api/auth/logout"
			# .success (data)-> console.log data

			$timeout ->
				
				# reload the page
				$state.transitionTo($state.current, $stateParams, {
					reload: true
					inherit: false
					notify: false
				})

			,100,true
		

		# --------------- Apply scope --------------- #			

		$scope.$apply()


