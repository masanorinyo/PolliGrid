define ['angular'], (angular) ->
	angular.module('myapp.services', [])
		.factory 'Filters', ()->
			target = [
					id 				: 1
					title 			: "Age"
					question 		: "How old are you?"
					created_at 	: 1398108212271
					lists:[
							option 		: "~ 10"
							answeredBy 	: []
						,
							option 		: "11 ~ 20"
							answeredBy 	: []
						,
							option 		: "21 ~ 30"
							answeredBy 	: []
						,
							option 		: "31 ~ 40"
							answeredBy 	: []
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
				
					id   : 2
					title: "Ethnicity"
					question: "What is your ethnicity?"
					created_at 	: 1398108312271
					lists:[
							option 		: "Asian"
							answeredBy 	: []
						,
							option 		: "Hispanic"
							answeredBy 	: []
						,
							option 		: "Caucasian"
							answeredBy 	: []
						,
							option 		: "African-American"
							answeredBy 	: []
					]
				
			]

		.factory 'Question', ()->
			question = [
					id 					: 1
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 8
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 4
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 2
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 3
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 4
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 5
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 6
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 7
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
				,
					id 					: 8
					newOption 			: ""
					question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
					category 			: "Lifestyle"
					respondents 		: [8,3,2,4,5,6,7,9,1]
					alreadyAnswered 	: false
					numOfFavorites 		: 1
					numOfFilters 		: 2
					totalResponses 		: 9
					created_at			: 1398108212271
					creator 			: 1
					creatorName 		: "Masanori"
					photo				: "/img/users/profile-pic.jpg"

					
					options 			: [
							title : 'positive'
							count : 5
							answeredBy :[3,2,5,8,1]
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
									answeredBy 	: [3,6,7,1]
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
			]
		.factory 'User', ()->
			user = 
				
				id  					: 1
				name  					: 'Masanori'
				email 					: 'masanorinyo@gmail.com'
				password 				: 'test'
				profilePic 				: "/img/users/profile-pic.jpg"
				isLoggedIn 				: true
				favorites 				: [1]
				questionMade 			: [1]
				questionsAnswered 		: [
						id 		: 2
						answer 	: "positive"
				]
				filterQuestionsAnswered : [
						# id 		: 1
						# answer 	: "21 ~ 30"
				]

		.factory 'Error', ()->
			error = 
				auth : ""

		.factory 'Setting', ()->
			page = 
				isSetting 	: false
				questionId	: null

		# .factory 'Grid', ()->
		# 	grid = 
		# 		height 		: []
		# 		width		: 0
		# 		numOfLoop 	: 0
		# 		numOfItems	: 0
		# 		numFromLeft : 0
		# 		num 		: 0

				



					
					
				
			