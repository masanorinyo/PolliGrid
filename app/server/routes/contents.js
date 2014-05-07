(function() {
  var Filter, Question;

  Question = require('../models/question');

  Filter = require('../models/targetQuestion');

  exports.loadQuestions = function(req, res) {
    var callback, questions;
    callback = function(err, questions) {
      var questionsMap;
      questionsMap = [];
      questions.forEach(function(q) {
        return questionsMap.unshift(q);
      });
      return res.json(questionsMap);
    };
    return questions = Question.find({}).limit(6).exec(callback);
  };

  exports.makeQuestion = function(req, res) {
    var newQuestion;
    newQuestion = new Question(req.body);
    return newQuestion.save(function(error, newQuestion) {
      if (error) {
        return console.log(error);
      } else {
        return res.send(newQuestion);
      }
    });
  };

  exports.findById = function(req, res) {
    var foundQuestion, id;
    id = req.params.id;
    return foundQuestion = Question.findById(id).exec(callback);
  };

  exports.findByTerm = function(req, res) {
    var callback, offset, orderBy, reversed, term;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    term = req.params.searchTerm;
    orderBy = req.params.orderBy;
    reversed = req.params.reversed;
    offset = req.params.offset;
    return Question.find({
      $or: [
        {
          "question": new RegExp(term, 'i')
        }, {
          "option": {
            $elemMatch: {
              "title": new RegExp(term, 'i')
            }
          }
        }
      ]
    }).sort({
      orderBy: reversed
    }).limit(2).skip(offset).exec(callback);
  };

  exports.findByCategory = function(req, res) {
    var callback, category, foundQuestion;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    category = req.params.category;
    return foundQuestion = Question.where('category').equals(category).exec(callback);
  };

  exports.loadFilters = function(req, res) {
    var callback, filters, offset;
    callback = function(err, filters) {
      var filterMap;
      filterMap = [];
      filters.forEach(function(filter) {
        return filterMap.unshift(filter);
      });
      console.log(filterMap);
      return res.send(filterMap);
    };
    offset = req.params.offset;
    return filters = Filter.find({}).limit(6).skip(offset).exec(callback);
  };

  exports.makeFilter = function(req, res) {
    var newFilter;
    newFilter = new Filter(req.body);
    return newFilter.save(function(error, filter) {
      if (error) {
        return console.log(error);
      } else {
        return res.send(filter);
      }
    });
  };

}).call(this);
