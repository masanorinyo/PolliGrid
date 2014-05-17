(function() {
  var User, createVerification, mail, verificationTokenModel;

  mail = require("./mail");

  verificationTokenModel = require("../models/verificationToken");

  User = require("../models/user");

  createVerification = function(req, user, email) {
    var verificationToken;
    verificationToken = new verificationTokenModel({
      _userId: user._id
    });
    this.send = function(info, type) {
      verificationToken.createVerificationToken(function(err, token) {
        if (err) {
          console.log("Couldn't create verification token", err);
        } else {
          info.textContent += req.protocol + "://" + req.get("host") + "/" + type + "/" + token;
          info.htmlContent += req.protocol + "://" + req.get("host") + "/" + type + "/" + token;
          mail(info, function(error, success) {
            if (error) {
              console.error("Unable to send via nodeMail: " + error.message);
              return;
            } else {
              console.info("Sent an Email");
            }
          });
        }
      });
    };
  };

  exports.getToken = function(req, user, callback) {
    var verificationToken;
    verificationToken = new verificationTokenModel({
      _userId: req.user._id
    });
    verificationToken.createVerificationToken(function(err, token) {
      var username;
      if (err) {
        return callback(user);
      } else {
        username = user.roomName;
        user.url = req.protocol + "://" + req.get("host") + "/visitor/" + username + "/" + token;
        return callback(user);
      }
    });
  };

  exports.sendVerification = function(req, user, email) {
    var info, instance;
    instance = new createVerification(req, user, email);
    info = {
      receiver: email,
      subject: "Confirmation Email - whichone",
      textContent: "Please click the following link to verify your account",
      htmlContent: "<p style='font-size:15px;'>Please click the following link to verify your account</p></br>"
    };
    instance.send(info, "verify");
  };

  exports.sendResetVerification = function(req, user, email) {
    var info, instance;
    instance = new createVerification(req, user, email);
    info = {
      receiver: email,
      subject: "Forgot password - whichone",
      textContent: "Please click the following link to reset your password",
      htmlContent: "<p style='font-size:15px;'>Please click the following link to reset your password</p></br>"
    };
    instance.send(info, "reset");
  };

  exports.verifyUser = function(token, type, done) {
    verificationTokenModel.findOne({
      token: token
    }, function(err, doc) {
      if (err) {
        done(err);
      } else if (!doc) {
        done(err);
      } else {
        User.findOne({
          _id: doc._userId
        }, function(err, user) {
          if (err) {
            done(err);
          } else if (!user) {
            done(err);
          } else {
            if (type === "verify") {
              user.confirmed = true;
              user.save(function(err) {
                if (err) {
                  return done(err);
                } else {
                  console.log("The user has been verified");
                  return done(null, user);
                }
              });
            } else {
              done(null, user);
            }
          }
        });
      }
    });
  };

}).call(this);
