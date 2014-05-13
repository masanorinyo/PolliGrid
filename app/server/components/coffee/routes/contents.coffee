# ----------------- Models ----------------- #
Question 	= 	require('../models/question')
User 		= 	require('../models/user')
Filter 		= 	require('../models/targetQuestion');


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
	title 		= escapeChar(unescape(req.params.title))
	filterId 	= escapeChar(unescape(req.params.filterId))
	task 		= escapeChar(unescape(req.params.task))
	index 		= req.params.index	


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
				"option.$.answeredBy":userId
				"respondents":userId
	
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
			
	
	options = {upsert:true}

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
		else
			res.send filter
	

#################################################
# --------------   User handlers   ------------ #
#################################################
exports.updateUser = (req,res)->
	
	console.log userId 	= escapeChar(unescape(req.params.userId))
	console.log qId 	= escapeChar(unescape(req.params.qId))
	console.log qAnswer = escapeChar(unescape(req.params.qAnswer))
	console.log fId 	= escapeChar(unescape(req.params.fId))
	console.log fAnswer = escapeChar(unescape(req.params.fAnswer))
	console.log task 	= escapeChar(unescape(req.params.task))

	callback = (err,user)->
		if err 
			console.log 'err'
			console.log err
			res.send err 
		else
			console.log "user"
			console.log user
			res.send user

	conditions = 
			
		"_id":userId
	

	if task == "favoritePush"
		updates = 	
			$push:
				"favorites":qId

	else if task == "favoritePull"
		updates = 	
			$pull:
				"favorites":qId

	else if task == "updateQuestion"
	
		answer = 
			_id 	: qId
			answer  : qAnswer
	
		updates =
			$push:
				"questionsAnswered":
					answer
	else if task == "updateFilter"

		answer = 
			_id 	: fId 
			answer 	: fAnswer

		updates = 
			$push:
				"filterQuestionsAnswered":
					answer
		
			
	options = {upsert:true}

	User.update(conditions, updates, options, callback);

exports.getUserInfo = (req,res)->
	
	callback = (err,data)->
		if err 
			res.send err 
		else 
			console.log data
			res.json data
	
	id = req.query.userId
	
	User.findById(id).exec(callback)





