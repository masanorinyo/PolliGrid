define ['angular'], (angular) ->
	angular.module('myapp.services', [])
		.factory 'Filters', ()->
			target = [
					id 				: 1
					title 			: "Age"
					question 		: "How old are you?"
					created_at 	: 1398108212271
					lists:[

						"~ 10"
						"11 ~ 20"
						"21 ~ 30"
						"31 ~ 40"
						"41 ~ 50"
						"51 ~ 60"
						"61 ~ "
					]
				,
				
					id   : 2
					title: "Ethnicity"
					question: "What is your ethnicity?"
					created_at 	: 1398108312271
					lists:[

						"Asian"
						"Hispanic"
						"Caucasian"
						"African-American"
					]
				
			]

		.factory 'Question', ()->
			question = [
					id 					: 1
					newOption 			: ""
					question 			: "Which one of the following best describes you"
					category 			: "Lifestyle"
					respondents 		: []
					favorite			: false
					alreadyAnswered 	: false
					favoritedBy 		: [1]
					numOfFavorites 		: 0
					numOfFilters 		: 2
					totalResponses 		: 8
					created_at			: 1398108212271
					creator 			: 1
					
					options 			: [
							title : 'positive'
							count : 4
						,
							title : 'negative'
							count : 4
					]
					targets 			: [

							id 				: 1
							title 			: "Age"
							question 		: "How old are you?"
							lists:[

								"~ 10"
								"11 ~ 20"
								"21 ~ 30"
								"31 ~ 40"
								"41 ~ 50"
								"51 ~ 60"
								"61 ~ "
							]
						,
							id 				: 2
							title 			: "Ethnicity"
							question 		: "What is your ethnicity?"
							lists:[

								"Asian"
								"Hispanic"
								"Caucasian"
								"African-American"
							]

					]
				,
					id 					: 2
					newOption 			: ""
					question 			: "Which one of the following best describes you"
					category 			: "Lifestyle"
					respondents 		: []
					favorite			: false
					alreadyAnswered 	: false
					favoritedBy 		: [1]
					numOfFavorites 		: 0
					numOfFilters 		: 1
					totalResponses 		: 5
					created_at			: 1398108212271
					creator 			: 1
					
					options 			: [
							title : 'positive'
							count : 2
						,
							title : 'negative'
							count : 3
					]
					targets 			: [

						
							id 				: 2
							title 			: "Ethnicity"
							question 		: "What is your ethnicity?"
							lists:[

								"Asian"
								"Hispanic"
								"Caucasian"
								"African-American"
							]

					]
				,
					id 					: 3
					newOption 			: ""
					question 			: "Which one of the following best describes you"
					category 			: "Lifestyle"
					respondents 		: []
					favorite			: false
					alreadyAnswered 	: false
					favoritedBy 		: [1]
					numOfFavorites 		: 0
					numOfFilters 		: 0
					totalResponses 		: 4
					created_at			: 1398108212271
					creator 			: 1
					
					options 			: [
							title : 'positive'
							count : 0
						,
							title : 'negative'
							count : 4
					]
					targets 			: [

						

					]
				
			]
		.factory 'User', ()->
			user = 
				
				id  					: 1
				name  					: 'Masanori'
				email 					: 'masanorinyo@gmail.com'
				password 				: 'test'
				profilePic 				: "/img/profile-pic.jpg"
				isLoggedIn 				: false
				favorites 				: [1]
				questionMade 			: [1]
				questionsAnswered 		: [
						'id' 	: 1
						'answer': "positive"
						
				]
				filterQuestionsAnswered : [
						'id' 	: 2
						'answer':'Asian'
				]




					
					
				
			