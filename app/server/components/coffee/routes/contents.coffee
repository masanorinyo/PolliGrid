# ----------------- Models ----------------- #
Question 	= 	require('../models/question')
User 		= 	require('../models/user')
Filter 		= 	require('../models/targetQuestion');
_ 			= 	require('underscore')

# ----------------- utility functions ----------------- #
escapeChar = (regex)->
	regex.replace(/([()[{*+.$^\\|?])/g, '\\$1')


# ----------------- exports routing functions ----------------- #

#################################################
# -------------- Question handlers -------------- #
#################################################

# make a question
exports.makeQuestion = (req,res)->
	
	newQuestion = new Question(req.body)
	id = req.body.creator
	
	conditions = 		
		"_id":id
	
	updates = 	
		$push:
			"questionMade":newQuestion._id
	
	options = {upsert:true}
	
	callback = (err,user)->
		if err 
			res.send err 
		else 
			res.send user

	newQuestion.save (error,newQuestion)->
		if error 
			console.log error 
			res.send error
		else
			# update user information
			# add the question id to user's creation list
			User.update(conditions,updates,options,callback)
			
			res.send newQuestion


# find a question by id
exports.findById = (req,res)->
	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data
	
	id = escapeChar(unescape(req.params.questionId))
	
	Question.findById(id).exec(callback)

# find a question by id
exports.favoriteQuestion = (req,res)->
	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data
	
	questionId = escapeChar(unescape(req.params.questionId))
	action = escapeChar(unescape(req.params.action))
	conditions = 
			
		"_id":questionId
	

	if action == "increment"
		updates = 	
			$inc:
				"numOfFavorites":1
	else 
		updates = 	
			$inc:
				"numOfFavorites":-1
	
	options = {upsert:true}

	Question.update(conditions, updates, options, callback);


# find questions by search term
exports.findQuestions = (req,res)->

	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data
		
	term = escapeChar(unescape(req.params.searchTerm))
	category = escapeChar(unescape(req.params.category))
	order = escapeChar(unescape(req.params.order))
	offset = req.params.offset


	if term is "All" then term = ""
	if category is "All" then category = ""


	switch order
		when "Recent"
		then sorting = {"created_at":-1}
			
		when "Old"
		then sorting = {"created_at":1}
		
		when "Most voted"
		then sorting = {"totalResponses":-1}

		when "Most popular"
		then sorting = {"numOfFavorites":-1}
			
	Question.find(
			$or:[
	 				"question":new RegExp(term, 'i')
 				,
 					"option":
 						$elemMatch:
 							"title":new RegExp(term,'i')
 			]
		)
		.where("category").equals(new RegExp(category, 'i'))
		.sort(sorting)
		.limit(6)
		.skip(offset)
		.exec(callback)


# find multiple questions by ids
exports.findQuestionsAndFiltersByIds = (req,res)->
	console.log ids = req.query.ids
	console.log offset = req.query.offset
	console.log type = req.query.type



	callback = (err,questions)->
		if err 
			res.send err 
		else 
			console.log questions
			res.send questions

		
	if _.isArray ids
		console.log 'many'
		conditions = 
			"_id":
				$in:ids
	else 

		console.log 'one'
		conditions = 
			"_id":ids
			
	if type != "filters"

		Question.find(conditions).limit(6).exec(callback)

	else 

		Filter.find(conditions).limit(6).exec(callback)


# update question
exports.updateQuestion = (req,res)->
	callback = (err,updated)->
		if err
			res.send err 
		else 
			console.log updated
			res.send updated

	questionId 	= escapeChar(unescape(req.params.questionId))
	userId 		= escapeChar(unescape(req.params.userId))
	visitorId 	= escapeChar(unescape(req.params.visitorId))
	title 		= escapeChar(unescape(req.params.title))
	filterId 	= escapeChar(unescape(req.params.filterId))
	task 		= escapeChar(unescape(req.params.task))
	index 		= req.params.index	

	options = {upsert:true}

	if task == "remove"

		console.log 'remove answers'
		
		conditions = 
			
			"_id":questionId
			"option.title":title
		

		updates = 
			
			$inc:
				"option.$.count":-1
				"totalResponses":-1
			 
			
			$pull:
				"option.$.answeredBy":
					$in:[userId,visitorId]

				"respondents":
					$in:[userId,visitorId]
				
			
	
	else
		if filterId != "0"
			
			console.log 'update question filter'

			conditions = 

				"_id":questionId
				"targets._id":filterId
				
			updates = {$push:{}}
			updates.$push["targets.$.lists."+index+".answeredBy"] = userId

			


		else 
		
			console.log 'update question'

			conditions = 
				"_id":questionId
				"option.title":title
			


			updates = 
				
				$inc:
					"option.$.count":1
					"totalResponses":1
				
				$push:
					"option.$.answeredBy":userId
					"respondents":userId
			
	
	

	Question.update(conditions, updates, options, callback);

# get questions for type head
exports.getQuestionTitle = (req,res)->
	
	callback = (err,questions)->
		
		questionMap = []
		
		questions.forEach (question)->
			questionMap.unshift(question)
		res.send(questionMap)


	term = escapeChar(unescape(req.params.term))
	category = escapeChar(unescape(req.params.category))

	if category is "All" then category = ""

	Question.find(
		$or:[
 				"question":new RegExp(term, 'i')
				,
				"option":
					$elemMatch:
						"title":new RegExp(term,'i')
			]
	)
	.where("category").equals(new RegExp(category, 'i'))
	.limit(6)
	.exec(callback)
	
#################################################
# -------------- filter handlers -------------- #
#################################################

# load filters 
exports.loadFilters = (req,res)->

	callback = (err,filters)->
		filterMap = []
		
		filters.forEach (filter)->
			filterMap.unshift(filter)
		res.send(filterMap)

	term = escapeChar(unescape(req.params.searchTerm))
	offset = req.params.offset

	if term is "all" then term = ""	

	filters = Filter
		.find(
			{
				$or:[
			 		"title":new RegExp(term, 'i')
		 		,
		 			"question":new RegExp(term,'i')
		 					
		 		]
			}
		)
		.limit(6)
		.skip(offset)
		.exec(callback)



# load titles for headtypes
exports.getFilterTitle = (req,res)->


	callback = (err,filters)->
		filterMap = []
		
		filters.forEach (filter)->
			filterMap.unshift(filter)
		res.send(filterMap)



	term = escapeChar(unescape(req.params.term))

	Filter.find(
		{
			"title":new RegExp(term, 'i')
		 }
	)
	.limit(6)
	.exec(callback)


# make filters
exports.makeFilter = (req,res)->
	
	newFilter = new Filter(req.body)

	newFilter.save (error,filter)->
		if error 
			console.log error 
			res.send error
		else
			res.send filter
	

#################################################
# --------------   User handlers   ------------ #
#################################################
exports.updateUser = (req,res)->
	
	userId 	= escapeChar(unescape(req.params.userId))
	qId 	= escapeChar(unescape(req.params.qId))
	qAnswer = escapeChar(unescape(req.params.qAnswer))
	fId 	= escapeChar(unescape(req.params.fId))
	fAnswer = escapeChar(unescape(req.params.fAnswer))
	task 	= escapeChar(unescape(req.params.task))

	callback = (err,user)->
		if err 
			console.log 'err'
			console.log err
			res.send err 
		else
			console.log "user"
			console.log user
			res.send user

	
	if task == "favoritePush"
		conditions = 

			"_id":userId

		updates = 	
			$push:
				"favorites":qId

	else if task == "favoritePull"
		conditions = 

			"_id":userId


		updates = 	
			$pull:
				"favorites":qId

	else if task == "updateQuestion"
		conditions = 

			"_id":userId
	
		answer = 
			_id 	: qId
			answer  : qAnswer
	
		updates =
			$push:
				"questionsAnswered":
					answer
	else if task == "updateFilter"
		conditions = 

			"_id":userId

		answer = 
			_id 	: fId 
			answer 	: fAnswer

		updates = 
			$push:
				"filterQuestionsAnswered":
					answer

	else if task == "changeFilter"
		conditions = 

			"_id":userId

		updates = 
			$pull:
				"filterQuestionsAnswered":
					"_id" 	: fId

		# overwrite the original callback
		# after pulling the original answer 
		# add the new answer to the filter question
		callback = ->
			answer = 
				_id 	: fId 
				answer 	: fAnswer

			updates = 
				$push:
					"filterQuestionsAnswered":
						answer

			User.update(conditions, updates, options, (err,data)->
				if err 
					res.send err 
				else 
					console.log "success"
					console.log data
					res.send data
			)
									

	else if task == "reset"
		conditions = 
			"_id" 					: userId 
			"questionsAnswered._id"	: qId
	
		updates =
			$pull : 
				"questionsAnswered" :
					"_id" 			: qId
				
		

	options = {upsert:true}

	User.update(conditions, updates, options, callback)

exports.getUserInfo = (req,res)->
	
	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data
	
	id = req.query.userId
	
	User.findById(id).exec(callback)

exports.visitorToGuest = (req,res)->
	
	callback = (err,data)->
		if err 
			res.send err 
		else 
			console.log data
			res.json data
	options = {upsert:true}
	
	userId = req.body.userId
	questions = req.body.questions
	filters = req.body.filters
	

	# if there are questions already answered
	# when the user was in the visitor's state
	if questions.length

		# loop through each answered questions
		# and add the information to the logged in user's data
		questions.forEach (q,key)->	

			conditions = 
					
				"_id":userId
				"questionsAnswered._id":q._id

						
			User.find(conditions).exec (err,found)-> 
				console.log found.length
				if found.length

					updates = 
						$set:
							"questionsAnswered.$.answer":q.answer


					console.log "question found"
					
				else 

					conditions = 
						"_id" : userId

					updates = 
						$push:
							"questionsAnswered":
								"_id" 	: q._id
								"answer": q.answer

					console.log 'ready to push'
					
				User.update(conditions, updates, options, callback)

	
	# if there are filter questions already answered
	# when the user was in the visitor's state		

	if filters.length

		# loop through each answered filter questions
		# and add the information to the logged in user's data
		filters.forEach (f,key)->	
			
			conditions = 
					
				"_id":userId
				"filterQuestionsAnswered._id":f._id

			User.find(conditions).exec (err,found)->
				if found.length 

					updates = 
						$set:
							"filterQuestionsAnswered.$.answer":f.answer

					
				
				else

					conditions = 
						"_id":userId

					updates = 
						$push : 
							"filterQuestionsAnswered":
								"_id"	 : f._id
								"answer" : f.answer

				User.update(conditions, updates, options, callback)
			

			

