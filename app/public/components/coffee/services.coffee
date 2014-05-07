define ['angular'], (angular) ->
	angular.module('myapp.services', ['ngResource'])
		.factory 'Filters', ($resource)->
			$resource(
				"/api/filter"
				{id : "@id"}
				{
					"save":{
						method:"POST"
					}
					"get":{
						method:"GET"
					}
					"query":{
						method:"GET"
						isArray:true
					}
				}
			)

		.factory 'Question', ($resource)->
			$resource(
				"/api/question"
				{id : "@id"}
				{
					"save":{
						method:"POST"
					}
					"get":{
						method:"GET"
						isArray:true
					}
					"query":{
						'method':"GET"
						isArray:true
					}
				}
			)

		# .factory 'Filters', ()->
		# 	target = [
		# 			id 				: 1
		# 			title 			: "Age"
		# 			question 		: "How old are you?"
		# 			created_at 	: 1398108212271
		# 			lists:[
		# 					option 		: "~ 10"
		# 					answeredBy 	: []
		# 				,
		# 					option 		: "11 ~ 20"
		# 					answeredBy 	: []
		# 				,
		# 					option 		: "21 ~ 30"
		# 					answeredBy 	: []
		# 				,
		# 					option 		: "31 ~ 40"
		# 					answeredBy 	: []
		# 				,
		# 					option 		: "41 ~ 50"
		# 					answeredBy	: []
		# 				,
		# 					option 		: "51 ~ 60"
		# 					answeredBy 	: []
		# 				,
		# 					option 		: "61 ~ "
		# 					answeredBy	: []
		# 			]
		# 	]

		# .factory 'Question', ()->

		# 	question = [
		# 			id 					: 1
		# 			newOption 			: ""
		# 			question 			: "Which one of the following best describes you best best describes you best describes you best describes you describes you"
		# 			category 			: "Lifestyle"
		# 			respondents 		: [8,3,2,4,5,6,7,9]
		# 			alreadyAnswered 	: false
		# 			numOfFavorites 		: 4
		# 			numOfFilters 		: 2
		# 			totalResponses 		: 8
		# 			created_at			: 1398108220
		# 			creator 			: 1
		# 			creatorName 		: "Masanori"
		# 			photo				: "/img/users/profile-pic.jpg"

					
		# 			options 			: [
		# 					title : 'positive'
		# 					count : 5
		# 					answeredBy :[3,2,5,8]
		# 				,
		# 					title : 'negative'
		# 					count : 4
		# 					answeredBy :[4,6,7,9]
		# 			]
		# 			targets 			: [

		# 					id 				: 1
		# 					title 			: "Age"
		# 					question 		: "How old are you?"
		# 					lists:[
		# 							option 		: "~ 10"
		# 							answeredBy 	: [9]
		# 						,
		# 							option 		: "11 ~ 20"
		# 							answeredBy 	: [2,5]
		# 						,
		# 							option 		: "21 ~ 30"
		# 							answeredBy 	: [3,6,7]
		# 						,
		# 							option 		: "31 ~ 40"
		# 							answeredBy 	: [4,8]
		# 						,
		# 							option 		: "41 ~ 50"
		# 							answeredBy	: []
		# 						,
		# 							option 		: "51 ~ 60"
		# 							answeredBy 	: []
		# 						,
		# 							option 		: "61 ~ "
		# 							answeredBy	: []
		# 					]
		# 				,
		# 					id 				: 2
		# 					title 			: "Ethnicity"
		# 					question 		: "What is your ethnicity?"
		# 					lists:[
		# 							option 		: "Asian"
		# 							answeredBy 	: [7,9]
		# 						,
		# 							option 		: "Hispanic"
		# 							answeredBy 	: [2]
		# 						,
		# 							option 		: "Caucasian"
		# 							answeredBy 	: [3,6,8]
		# 						,
		# 							option 		: "African-American"
		# 							answeredBy 	: [4,5]
		# 					]
						
						
		# 			]
				
		# 	]
		.factory 'User', ()->
			user = 
				
				_id  					: 1
				name  					: 'Masanori'
				email 					: 'masanorinyo@gmail.com'
				password 				: 'test'
				profilePic 				: "/img/users/profile-pic.jpg"
				isLoggedIn 				: true
				favorites 				: []
				questionMade 			: [1]
				questionsAnswered 		: [
						# id 		: 2
						# answer 	: "positive"
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
				section 	: null

		# .factory 'Grid', ()->
		# 	grid = 
		# 		height 		: []
		# 		width		: 0
		# 		numOfLoop 	: 0
		# 		numOfItems	: 0
		# 		numFromLeft : 0
		# 		num 		: 0

				



					
					
				
			