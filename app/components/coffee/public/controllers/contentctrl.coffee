define ['underscore'], (_)->
	($scope,Question,$window)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		$scope.questions = Question


		$scope.searchFocused = false

		$scope.searchByCategory = (category)->

				$scope.searchQuestion = category

		$scope.putCategory = (category)->

			$scope.searchQuestion = category

			$scope.searchFocused = false

			
		$scope.updateSearch = ->

			$scope.searchFocused = false

		


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


