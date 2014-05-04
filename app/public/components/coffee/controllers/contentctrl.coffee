define ['underscore'], (_)->
	($scope,Question,$window,$stateParams,$timeout,$state)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		
		$scope.questions = Question

		$scope.order = "Recent"
		$scope.reverse = false
		$scope.searchFocused = false
		$scope.filteredQuestions = []

		$scope.searchByCategory = (category)->

				$scope.searchQuestion = category

		$scope.putCategory = (category)->

			$scope.searchQuestion = category

			$scope.searchFocused = false


		$scope.updateSearch = ->

			$scope.searchFocused = false


		$scope.sortBy = (order)->
			$scope.questions = []

			console.log Question

			$timeout ->
				switch order
					when "Recent"
						$scope.order = "Recent"
						Question = _.sortBy Question,(object)-> -object.created_at
						
						
					when "Old"
						$scope.order = "Old"
						Question = _.sortBy Question,(object)-> object.created_at
						

					when "Most voted"
						$scope.order = "Most voted"
						Question= _.sortBy Question,(object)-> -object.totalResponses
						

					when "Most popular"
						$scope.order = "Most popular"
						Question = _.sortBy Question,(object)-> -object.numOfFavorites
						

			,100,true

		$scope.changeInQuestions = ->
			return Question	

		$scope.$watch $scope.changeInQuestions, (newVal)->
			
			$scope.questions = newVal	

		$scope.parentSize = 
			width  : 0
			height : 0
		

		$scope.orders = [
			"Recent"
			"Old"
			"Most voted"
			"Most popular"

		]

		$scope.categories = [
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


		# ***************  Variables *************** #
		
			
		$scope.$apply()


