define ["underscore"], (_)->
	($scope,$location,$stateParams,$timeout,$state,User,Page,Question,FindQuestions)->
		
		# --------------- Variables --------------- #			
		
		$scope.user = User
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




		# get the questions when the page loads up
		

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


		# Contents handler #			
		$scope.changeOrder = (value)->
			
			$scope.order = encodeURI(value)
			encodeURI($scope.searchQuestion)
			encodeURI($scope.category)
			Page.questionPage

		$scope.changeCategory = (value)->
			
			$scope.category = encodeURI(value)
			encodeURI($scope.searchQuestion)
			encodeURI($scope.order)
			Page.questionPage


		$scope.updateSearch = ()->
			
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


