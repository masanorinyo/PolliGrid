(function() {
  var User, mongoose, uuid, verificationTokenSchema;

  mongoose = require("mongoose");

  uuid = require("node-uuid");

  User = require("./user");

  verificationTokenSchema = mongoose.Schema({
    _userId: {
      type: String,
      required: true,
      ref: "User"
    },
    token: {
      type: String,
      required: true
    },
    createdAt: {
      type: Date,
      required: true,
      "default": Date.now,
      expires: "4h"
    }
  });

  verificationTokenSchema.methods.createVerificationToken = function(done) {
    var token, verificationToken;
    verificationToken = this;
    token = uuid.v4();
    verificationToken.set("token", token);
    return verificationToken.save(function(err) {
      if (err) {
        done(err);
      } else {
        return done(null, token);
        console.log("Verification token", verificationToken);
      }
      return;
    });
  };

  module.exports = mongoose.model("VerificationToken", verificationTokenSchema);

}).call(this);
