define ['underscore'], (_)->
	($scope,Question,$window,$stateParams,$q,$timeout,$state)->

		# ----------------- Scope functions and variables ----------------- #
		
		# ***************  Models *************** #
		
		$scope.questions = Question

		$scope.order = "Recent"
		# $scope.reverse = false
		$scope.searchFocused = false
		$scope.filteredQuestions = []

		$scope.showLoader = false
		

		download = ->
			object = 
				id 					: 5
				newOption 			: ""
				question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
				category 			: "Lifestyle"
				respondents 		: [8,3,2,4,5,6,7,9]
				alreadyAnswered 	: false
				numOfFavorites 		: 4
				numOfFilters 		: 2
				totalResponses 		: 8
				created_at			: 1398108220
				creator 			: 1
				creatorName 		: "Masanori"
				photo				: "/img/users/profile-pic.jpg"

				
				options 			: [
						title : 'positive'
						count : 5
						answeredBy :[3,2,5,8]
					,
						title : 'negative'
						count : 4
						answeredBy :[4,6,7,9]
				]
				targets 			: [

					id 				: 1
					title 			: "Age"
					question 		: "How old are you?"
					lists:[
							option 		: "~ 10"
							answeredBy 	: [9]
						,
							option 		: "11 ~ 20"
							answeredBy 	: [2,5]
						,
							option 		: "21 ~ 30"
							answeredBy 	: [3,6,7]
						,
							option 		: "31 ~ 40"
							answeredBy 	: [4,8]
						,
							option 		: "41 ~ 50"
							answeredBy	: []
						,
							option 		: "51 ~ 60"
							answeredBy 	: []
						,
							option 		: "61 ~ "
							answeredBy	: []
					]
				,
					id 				: 2
					title 			: "Ethnicity"
					question 		: "What is your ethnicity?"
					lists:[
							option 		: "Asian"
							answeredBy 	: [7,9]
						,
							option 		: "Hispanic"
							answeredBy 	: [2]
						,
							option 		: "Caucasian"
							answeredBy 	: [3,6,8]
						,
							option 		: "African-American"
							answeredBy 	: [4,5]
					]
					
					
				]
			
			$scope.questions.push(object)

		$scope.downloadMoreContents = ()->
			$scope.showLoader = true
			defer = $q.defer()
			defer.promise
				
				.then -> download()
				
				.then -> 
					$scope.showLoader = false


			defer.resolve()

			


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
						$scope.questions = _.sortBy Question,(object)-> -object.created_at
						
						
					when "Old"
						$scope.order = "Old"
						$scope.questions = _.sortBy Question,(object)-> object.created_at
						

					when "Most voted"
						$scope.order = "Most voted"
						$scope.questions= _.sortBy Question,(object)-> -object.totalResponses
						

					when "Most popular"
						$scope.order = "Most popular"
						$scope.questions = _.sortBy Question,(object)-> -object.numOfFavorites
						

			,100,true


		

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


