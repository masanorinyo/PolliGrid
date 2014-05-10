# ----------------- Models ----------------- #
Question 	= 	require('../models/question')
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

	newQuestion.save (error,newQuestion)->
		if error 
			console.log error 
		else
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
		
exports.updateQuestion = (req,res)->
	callback = (err,updated)->
		if err
			res.send err 
		else 
			res.send updated

	conditions = { _id:questionId}
	update = {$set:{}}
	options = {upsert:true}

	Question.update(conditions, update, options, callback);

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
	
