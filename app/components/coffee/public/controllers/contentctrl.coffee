define ['underscore'], (_)->
	($scope,Question,$window)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		$scope.questions = Question
		$scope.order = "Recent"
		$scope.reverse = false
		$scope.searchFocused = false

		$scope.searchByCategory = (category)->

				$scope.searchQuestion = category

		$scope.putCategory = (category)->

			$scope.searchQuestion = category

			$scope.searchFocused = false

			
		$scope.updateSearch = ->

			$scope.searchFocused = false


		$scope.sortBy = (order)->
			console.log order
			switch order
				when "Recent"
					$scope.orderBy = "created_at"
					$scope.reverse = true
					$scope.order = "Recent"

				when "Old"
					$scope.orderBy = "created_at"
					$scope.reverse = false
					$scope.order = "Old"

				when "Most voted"
					$scope.orderBy = "totalResponses"
					$scope.reverse = true
					$scope.order = "Most voted"

				when "Most popular"
					$scope.orderBy = "numOfFavorites"
					$scope.reverse = true
					$scope.order = "Most popular"
				

			

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


