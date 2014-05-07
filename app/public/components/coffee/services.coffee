define ['angular'], (angular) ->
	angular.module('myapp.services', ['ngResource'])
		.factory 'Filters', ($resource)->
			$resource(
				"/api/filter/:offset"
				{offset : "@offset"}
				{
					"save":
						method:"POST"
						params:
							offset:"0"
						
					
					"get":
						method:"GET"
						isArray:true
					
				}
			)

		.factory 'Question', ($resource)->
			$resource(
				"/api/question"
				{}
				{
					"save":
						method:"POST"
					
					"get":
						method:"GET"
						isArray:true
					
				}
			)

	
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

		.factory 'Page', ()->
			page = 
				questionPage 	: 0
				filterPage 		: 0

		# .factory 'Grid', ()->
		# 	grid = 
		# 		height 		: []
		# 		width		: 0
		# 		numOfLoop 	: 0
		# 		numOfItems	: 0
		# 		numFromLeft : 0
		# 		num 		: 0

				



					
					
				
			