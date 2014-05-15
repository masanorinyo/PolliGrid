(function() {
  var Filter, Question, User, escapeChar, _;

  Question = require('../models/question');

  User = require('../models/user');

  Filter = require('../models/targetQuestion');

  _ = require('underscore');

  escapeChar = function(regex) {
    return regex.replace(/([()[{*+.$^\\|?])/g, '\\$1');
  };

  exports.makeQuestion = function(req, res) {
    var callback, conditions, id, newQuestion, options, updates;
    newQuestion = new Question(req.body);
    id = req.body.creator;
    conditions = {
      "_id": id
    };
    updates = {
      $push: {
        "questionMade": newQuestion._id
      }
    };
    options = {
      upsert: true
    };
    callback = function(err, user) {
      if (err) {
        return res.send(err);
      } else {
        return res.send(user);
      }
    };
    return newQuestion.save(function(error, newQuestion) {
      if (error) {
        console.log(error);
        return res.send(error);
      } else {
        User.update(conditions, updates, options, callback);
        return res.send(newQuestion);
      }
    });
  };

  exports.findById = function(req, res) {
    var callback, id;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    id = escapeChar(unescape(req.params.questionId));
    return Question.findById(id).exec(callback);
  };

  exports.favoriteQuestion = function(req, res) {
    var action, callback, conditions, options, questionId, updates;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    questionId = escapeChar(unescape(req.params.questionId));
    action = escapeChar(unescape(req.params.action));
    conditions = {
      "_id": questionId
    };
    if (action === "increment") {
      updates = {
        $inc: {
          "numOfFavorites": 1
        }
      };
    } else {
      updates = {
        $inc: {
          "numOfFavorites": -1
        }
      };
    }
    options = {
      upsert: true
    };
    return Question.update(conditions, updates, options, callback);
  };

  exports.findQuestions = function(req, res) {
    var callback, category, offset, order, sorting, term;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    term = escapeChar(unescape(req.params.searchTerm));
    category = escapeChar(unescape(req.params.category));
    order = escapeChar(unescape(req.params.order));
    offset = req.params.offset;
    if (term === "All") {
      term = "";
    }
    if (category === "All") {
      category = "";
    }
    switch (order) {
      case "Recent":
        sorting = {
          "created_at": -1
        };
        break;
      case "Old":
        sorting = {
          "created_at": 1
        };
        break;
      case "Most voted":
        sorting = {
          "totalResponses": -1
        };
        break;
      case "Most popular":
        sorting = {
          "numOfFavorites": -1
        };
    }
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
    }).where("category").equals(new RegExp(category, 'i')).sort(sorting).limit(6).skip(offset).exec(callback);
  };

  exports.findQuestionsAndFiltersByIds = function(req, res) {
    var callback, conditions, ids, offset, type;
    console.log(ids = req.query.ids);
    console.log(offset = req.query.offset);
    console.log(type = req.query.type);
    callback = function(err, questions) {
      if (err) {
        return res.send(err);
      } else {
        return res.send(questions);
      }
    };
    if (_.isArray(ids)) {
      console.log('many');
      conditions = {
        "_id": {
          $in: ids
        }
      };
    } else {
      console.log('one');
      conditions = {
        "_id": ids
      };
    }
    if (type !== "filters") {
      return Question.find(conditions).limit(6).exec(callback);
    } else {
      return Filter.find(conditions).limit(6).exec(callback);
    }
  };

  exports.updateQuestion = function(req, res) {
    var callback, conditions, filterId, index, options, questionId, task, title, updates, userId, visitorId;
    callback = function(err, updated) {
      if (err) {
        return res.send(err);
      } else {
        console.log(updated);
        return res.send(updated);
      }
    };
    questionId = escapeChar(unescape(req.params.questionId));
    userId = escapeChar(unescape(req.params.userId));
    visitorId = escapeChar(unescape(req.params.visitorId));
    title = escapeChar(unescape(req.params.title));
    filterId = escapeChar(unescape(req.params.filterId));
    task = escapeChar(unescape(req.params.task));
    index = req.params.index;
    options = {
      upsert: true
    };
    if (task === "remove") {
      console.log('remove answers');
      conditions = {
        "_id": questionId,
        "option.title": title
      };
      updates = {
        $inc: {
          "option.$.count": -1,
          "totalResponses": -1
        },
        $pull: {
          "option.$.answeredBy": {
            $in: [userId, visitorId]
          },
          "respondents": {
            $in: [userId, visitorId]
          }
        }
      };
    } else if (task === "removeFilter") {
      conditions = {
        "_id": questionId,
        "targets._id": filterId
      };
      updates = {
        $pull: {}
      };
      updates.$pull["targets.$.lists." + index + ".answeredBy"] = {
        $in: [userId, visitorId]
      };
    } else {
      if (filterId !== "0") {
        console.log('update question filter');
        conditions = {
          "_id": questionId,
          "targets._id": filterId
        };
        updates = {
          $push: {}
        };
        updates.$push["targets.$.lists." + index + ".answeredBy"] = userId;
      } else {
        console.log('update question');
        conditions = {
          "_id": questionId,
          "option.title": title
        };
        updates = {
          $inc: {
            "option.$.count": 1,
            "totalResponses": 1
          },
          $push: {
            "option.$.answeredBy": userId,
            "respondents": userId
          }
        };
      }
    }
    return Question.update(conditions, updates, options, callback);
  };

  exports.getQuestionTitle = function(req, res) {
    var callback, category, term;
    callback = function(err, questions) {
      var questionMap;
      questionMap = [];
      questions.forEach(function(question) {
        return questionMap.unshift(question);
      });
      return res.send(questionMap);
    };
    term = escapeChar(unescape(req.params.term));
    category = escapeChar(unescape(req.params.category));
    if (category === "All") {
      category = "";
    }
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
    }).where("category").equals(new RegExp(category, 'i')).limit(6).exec(callback);
  };

  exports.loadFilters = function(req, res) {
    var callback, filters, offset, term;
    callback = function(err, filters) {
      var filterMap;
      filterMap = [];
      filters.forEach(function(filter) {
        return filterMap.unshift(filter);
      });
      return res.send(filterMap);
    };
    term = escapeChar(unescape(req.params.searchTerm));
    offset = req.params.offset;
    if (term === "all") {
      term = "";
    }
    return filters = Filter.find({
      $or: [
        {
          "title": new RegExp(term, 'i')
        }, {
          "question": new RegExp(term, 'i')
        }
      ]
    }).limit(6).skip(offset).exec(callback);
  };

  exports.getFilterTitle = function(req, res) {
    var callback, term;
    callback = function(err, filters) {
      var filterMap;
      filterMap = [];
      filters.forEach(function(filter) {
        return filterMap.unshift(filter);
      });
      return res.send(filterMap);
    };
    term = escapeChar(unescape(req.params.term));
    return Filter.find({
      "title": new RegExp(term, 'i')
    }).limit(6).exec(callback);
  };

  exports.makeFilter = function(req, res) {
    var newFilter;
    newFilter = new Filter(req.body);
    _.each(newFilter.lists, function(list) {
      list.option = list.option;
      return console.log(list.option);
    });
    return newFilter.save(function(error, filter) {
      if (error) {
        console.log(error);
        return res.send(error);
      } else {
        console.log(filter);
        return res.send(filter);
      }
    });
  };

  exports.updateUser = function(req, res) {
    var answer, callback, conditions, fAnswer, fId, options, qAnswer, qId, task, updates, userId;
    userId = escapeChar(unescape(req.params.userId));
    qId = escapeChar(unescape(req.params.qId));
    qAnswer = escapeChar(unescape(req.params.qAnswer));
    fId = escapeChar(unescape(req.params.fId));
    fAnswer = req.params.fAnswer;
    task = escapeChar(unescape(req.params.task));
    callback = function(err, user) {
      if (err) {
        console.log('err');
        console.log(err);
        return res.send(err);
      } else {
        console.log("user");
        console.log(user);
        return res.send(user);
      }
    };
    if (task === "favoritePush") {
      conditions = {
        "_id": userId
      };
      updates = {
        $push: {
          "favorites": qId
        }
      };
    } else if (task === "favoritePull") {
      conditions = {
        "_id": userId
      };
      updates = {
        $pull: {
          "favorites": qId
        }
      };
    } else if (task === "updateQuestion") {
      conditions = {
        "_id": userId
      };
      answer = {
        _id: qId,
        answer: qAnswer
      };
      updates = {
        $push: {
          "questionsAnswered": answer
        }
      };
    } else if (task === "updateFilter") {
      conditions = {
        "_id": userId
      };
      answer = {
        _id: fId,
        answer: fAnswer
      };
      updates = {
        $push: {
          "filterQuestionsAnswered": answer
        }
      };
    } else if (task === "changeFilter") {
      conditions = {
        "_id": userId
      };
      updates = {
        $pull: {
          "filterQuestionsAnswered": {
            "_id": fId
          }
        }
      };
      callback = function() {
        answer = {
          _id: fId,
          answer: fAnswer
        };
        updates = {
          $push: {
            "filterQuestionsAnswered": answer
          }
        };
        return User.update(conditions, updates, options, function(err, data) {
          if (err) {
            return res.send(err);
          } else {
            console.log("success");
            console.log(data);
            return res.send(data);
          }
        });
      };
    } else if (task === "reset") {
      conditions = {
        "_id": userId,
        "questionsAnswered._id": qId
      };
      updates = {
        $pull: {
          "questionsAnswered": {
            "_id": qId
          }
        }
      };
    }
    options = {
      upsert: true
    };
    return User.update(conditions, updates, options, callback);
  };

  exports.getUserInfo = function(req, res) {
    var callback, id;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        return res.json(data);
      }
    };
    id = req.query.userId;
    return User.findById(id).exec(callback);
  };

  exports.visitorToGuest = function(req, res) {
    var callback, filters, options, questions, userId;
    callback = function(err, data) {
      if (err) {
        return res.send(err);
      } else {
        console.log(data);
        return res.json(data);
      }
    };
    options = {
      upsert: true
    };
    userId = req.body.userId;
    questions = req.body.questions;
    filters = req.body.filters;
    if (questions.length) {
      questions.forEach(function(q, key) {
        var conditions;
        conditions = {
          "_id": userId,
          "questionsAnswered._id": q._id
        };
        return User.find(conditions).exec(function(err, found) {
          var updates;
          console.log(found.length);
          if (found.length) {
            updates = {
              $set: {
                "questionsAnswered.$.answer": q.answer
              }
            };
            console.log("question found");
          } else {
            conditions = {
              "_id": userId
            };
            updates = {
              $push: {
                "questionsAnswered": {
                  "_id": q._id,
                  "answer": q.answer
                }
              }
            };
            console.log('ready to push');
          }
          return User.update(conditions, updates, options, callback);
        });
      });
    }
    if (filters.length) {
      return filters.forEach(function(f, key) {
        var conditions;
        conditions = {
          "_id": userId,
          "filterQuestionsAnswered._id": f._id
        };
        return User.find(conditions).exec(function(err, found) {
          var updates;
          if (found.length) {
            updates = {
              $set: {
                "filterQuestionsAnswered.$.answer": f.answer
              }
            };
          } else {
            conditions = {
              "_id": userId
            };
            updates = {
              $push: {
                "filterQuestionsAnswered": {
                  "_id": f._id,
                  "answer": f.answer
                }
              }
            };
          }
          return User.update(conditions, updates, options, callback);
        });
      });
    }
  };

}).call(this);
