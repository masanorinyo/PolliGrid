(function() {
  var mongoose, questionSchema;

  mongoose = require("mongoose");

  questionSchema = mongoose.Schema({
    newOption: String,
    question: String,
    category: String,
    respondents: [],
    alreadyAnswered: false,
    numOfFavorites: Number,
    numOfFilters: Number,
    totalResponses: Number,
    created_at: Number,
    creator: String,
    creatorName: String,
    photo: String,
    option: [],
    targets: []
  });

  module.exports = mongoose.model("Question", questionSchema);

}).call(this);
