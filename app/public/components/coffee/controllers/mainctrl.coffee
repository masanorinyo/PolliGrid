define ["underscore"], (_)->
	($scope,$location,$q,$stateParams,$timeout,$state,User,Page,FindQuestions,Debounce,Search,QuestionTypeHead)->


		# --------------- Util functions --------------- #					
		capitaliseFirstLetter = (string)->
			string.charAt(0).toUpperCase() + string.slice(1);
		
		# --------------- Models --------------- #					

		$scope.user = User
		# get the questions when the page loads up
		$scope.questions = FindQuestions.default()

		# --------------- Variables --------------- #			
		
		
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
			

			Page.questionPage = 0
			
			if $scope.searchQuestion is ""
				$scope.searchTerm = "All"
			else
				$scope.searchTerm = $scope.searchQuestion

			$scope.questions = FindQuestions.get(
				{
					searchTerm 	: encodeURI($scope.searchTerm)
					category 	: encodeURI($scope.category)
					order 		: encodeURI($scope.order)
					offset 		: Page.questionPage
				}
			)



		


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
			
			$scope.searchQuestion = $item
			searchSpecificQuestions()

		$scope.getPartOfQuestion = (term)->
			console.log $scope.category
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
				.then -> $scope.order = value
				.then -> searchSpecificQuestions()
			defer.resolve()
			
			
			

		$scope.changeCategory = (value)->
			
			defer = $q.defer()
			defer.promise
				.then -> $scope.category = value
				.then -> searchSpecificQuestions()
			defer.resolve()



		$scope.searchingQuestions = -> searchSpecificQuestions()
		

		# delays typing event
		$scope.updateSearch = Debounce($scope.searchingQuestions, 333, false);
		
		
		$scope.$on 'category-changed',(category)->
			
			$scope.changeCategory(capitaliseFirstLetter(Search.category))

		
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


