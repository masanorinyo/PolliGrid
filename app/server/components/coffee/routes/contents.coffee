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



# get all the questions
exports.loadQuestions = (req,res)->
	
	callback = (err,questions)->
		questionsMap = []
		questions.forEach (q)->
			questionsMap.unshift(q)
		res.json(questionsMap)

	questions = Question.find({}).limit(6).exec(callback)
		

# find a question by id
exports.findById = (req,res)->
	
	id = req.params.id
	
	foundQuestion = Question.findById(id).exec(callback)


# find questions by search term
exports.findQuestions = (req,res)->

	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data
		
	console.log term = decodeURI(req.params.searchTerm)
	console.log category = decodeURI(req.params.category)
	console.log order = decodeURI(req.params.order)
	console.log offset = req.params.offset


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
	


# exports.findByCategory = (req,res)->

# 	callback = (err,data)->
# 		if err 
# 			res.send err 
# 		else 
# 			res.json data

# 	category = req.params.category
	
# 	foundQuestion = Question
# 		.where('category')
# 		.equals(category)
# 		.exec(callback)
	
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
	
