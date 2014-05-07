(function() {
  var mongoose, targetQuestionSchema;

  mongoose = require("mongoose");

  targetQuestionSchema = mongoose.Schema({
    title: String,
    question: String,
    created_at: Number,
    lists: [
      {
        option: String,
        answeredBy: []
      }
    ]
  });

  module.exports = mongoose.model("TargetQuestion", targetQuestionSchema);

}).call(this);
