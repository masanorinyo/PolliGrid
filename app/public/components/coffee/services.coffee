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