# ----------------- Models ----------------- #
Question 	= 	require('../models/question')
Filter 		= 	require('../models/targetQuestion');


# ----------------- utility functions ----------------- #



# ----------------- exports routing functions ----------------- #

# get all the questions
exports.loadQuestions = (req,res)->
	
	callback = (err,questions)->
		questionsMap = []
		questions.forEach (q)->
			questionsMap.unshift(q)
		res.json(questionsMap)

	questions = Question.find({}).limit(6).exec(callback)
		

	
		
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
	
	id = req.params.id
	
	foundQuestion = Question.findById(id).exec(callback)

# find questions by search term
exports.findByTerm = (req,res)->

	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data

	
	term = req.params.searchTerm
	orderBy = req.params.orderBy
	reversed = req.params.reversed
	offset = req.params.offset



	Question
		.find(
			 $or:[
			 		"question":new RegExp(term, 'i')
		 		,
		 			"option":
		 				$elemMatch:
		 					"title":new RegExp(term,'i')
		 	]
		)
		.sort({orderBy: reversed})
		.limit(2)
		.skip(offset)
		.exec(callback)

exports.findByCategory = (req,res)->

	callback = (err,data)->
		if err 
			res.send err 
		else 
			res.json data

	category = req.params.category
	
	foundQuestion = Question
		.where('category')
		.equals(category)
		.exec(callback)
	

exports.loadFilters = (req,res)->
	
	callback = (err,filters)->
		filterMap = []
		
		filters.forEach (filter)->
			filterMap.unshift(filter)
		
		console.log filterMap
		res.send(filterMap)


	offset = req.params.offset

	filters = Filter.find({}).limit(6).skip(offset).exec(callback)

exports.loadSpecificFilters = (req,res)->
	term = req.params.searchTerm

	console.log term
	
	

exports.makeFilter = (req,res)->
	
	newFilter = new Filter(req.body)

	newFilter.save (error,filter)->
		if error 
			console.log error 
		else
			res.send filter
	
