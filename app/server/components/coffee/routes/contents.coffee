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
			.sort("created_at":-1)
			.limit(6)
			.skip(offset)
			.exec(callback)

		when "Old"
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
			.sort("created_at":1)
			.limit(6)
			.skip(offset)
			.exec(callback)

		when "Most voted"
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
			.sort("totalResponses":-1)
			.limit(6)
			.skip(offset)
			.exec(callback)

		when "Most popular"
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
			.sort("numOfFavorites":-1)
			.limit(6)
			.skip(offset)
			.exec(callback)
	


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
	
