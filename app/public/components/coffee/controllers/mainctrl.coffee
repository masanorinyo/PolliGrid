define ["underscore"], (_)->
	($scope,$location,$q,$stateParams,$timeout,$state,User,Page,FindQuestions,Debounce,Search,QuestionTypeHead,NewQuestion)->


		# --------------- Util functions --------------- #					
		capitaliseFirstLetter = (string)->
			string.charAt(0).toUpperCase() + string.slice(1);
		
		# --------------- Models --------------- #					

		$scope.user = User
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
			
			$timeout ->
				# reload the page
				$state.transitionTo($state.current, $stateParams, {
					reload: true
					inherit: false
					notify: true
				})

			,100,true


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


		
		$scope.logout = ()->
			
			User._id  					 = 0
			User.name  					 = ''
			User.email 					 = ''
			User.password 				 = ''
			User.profilePic 			 = ""
			User.isLoggedIn 			 = false
			User.favorites 				 = []
			User.questionMade 			 = []
			User.questionsAnswered 		 = []
			User.filterQuestionsAnswered = []

			$location.path('/')
			
			$timeout ->
				
				# reload the page
				$state.transitionTo($state.current, $stateParams, {
					reload: true
					inherit: false
					notify: true
				})

			,100,true
		

		# --------------- Apply scope --------------- #			

		$scope.$apply()


