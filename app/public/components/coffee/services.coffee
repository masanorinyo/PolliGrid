define ['angular'], (angular) ->
	angular.module('myapp.services', ['ngResource'])
		.factory 'Filters', ($resource)->
			$resource(
				"/api/filter/:searchTerm/:offset"
				{
					offset 		: "@offset"
					searchTerm 	: "@searchTerm"
				}
				{
					"save":
						method:"POST"
						params:
							offset:"0"
							searchTerm:"new"
						
					
					"get":
						method:"GET"
						isArray:true
					
				}
			)

		.factory 'FilterTypeHead', ($resource)->
			$resource(
				"/api/getFilterTitle/:term"
				{
					term:"@term"
				}
				{
					"get":
						method:"GET"
						isArray:true
				}
			)
				
		.factory 'Question', ($resource)->
			$resource(
				"/api/question/:questionId"
				{
					questionId:"@questionId"
				}
				{
					"get" :
						method: "GET"

					"save" :
						method : "POST"
						params :
							id : 0
				}
			)

		.factory 'QuestionTypeHead', ($resource)->
			$resource(
				"/api/getQuestionTitle/:term/:category"
				{
					term:"@term"
					category:"@category"
				}
				{
					"get":
						method:"GET"
						isArray:true
				}
			)

		.factory 'FindQuestions', ($resource)->
			$resource(
				"/api/findQuestions/:searchTerm/:category/:order/:offset"
				{
					searchTerm 	: "@searchTerm"
					category 	: "@category"
					order 		: "@order"
					offset 		: "@offset"
				}
				{

					"get":
						method:"GET"
						isArray:true

					"default":
						method:"GET"
						params:
							searchTerm 	: "All"
							category 	: "All"
							order 		: "Recent"
							offset 		: 0
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
						_id 		: "536d57ccd22f0c4e4b0bf6ea"
						answer 		: "Kindergarden"
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

		.factory 'Search', ()->
			search = 
				category 	: "All"

		.factory 'NewQuestion', ()->
			question = 
				question 	: ""

				


		# Create an AngularJS service called debounce
		.factory "Debounce", ($timeout, $q) ->
    
			# The service is actually this function, which we call with the func
			# that should be debounced and how long to wait in between calls
			return debounce = (func, wait, immediate) ->
				timeout = undefined

				# Create a deferred object that will be resolved when we need to
				# actually call the func
				deferred = $q.defer()
				->
					context = this
					args = arguments
					later = ->
						timeout = null
						unless immediate
							deferred.resolve func.apply(context, args)
							deferred = $q.defer()
							return

					callNow = immediate and not timeout
					$timeout.cancel timeout  if timeout
					timeout = $timeout(later, wait)
					if callNow
						deferred.resolve func.apply(context, args)
						deferred = $q.defer()
					deferred.promise