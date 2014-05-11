(function() {
  var bcrypt, mongoose, userSchema;

  mongoose = require("mongoose");

  bcrypt = require("bcrypt-nodejs");

  userSchema = mongoose.Schema({
    username: String,
    confirmed: Boolean,
    email: String,
    hasEmail: Boolean,
    profilePic: String,
    favorites: [],
    questionMade: [],
    questionsAnswered: [],
    filterQuestionsAnswered: [],
    local: {
      email: String,
      password: String
    },
    facebook: {
      id: String,
      token: String
    },
    twitter: {
      id: String,
      token: String,
      tokenSecret: String
    },
    google: {
      id: String
    }
  }, {
    token: String
  });

  userSchema.methods.generateHash = function(password) {
    return bcrypt.hashSync(password, bcrypt.genSaltSync(8), null);
  };

  userSchema.methods.validPassword = function(password) {
    return bcrypt.compareSync(password, this.local.password);
  };

  module.exports = mongoose.model("User", userSchema);

}).call(this);
