(function() {
  var FacebookStrategy, GoogleStrategy, LocalStrategy, TwitterStrategy, User, uniqify_name, verification;

  LocalStrategy = require("passport-local").Strategy;

  FacebookStrategy = require("passport-facebook").Strategy;

  TwitterStrategy = require("passport-twitter").Strategy;

  GoogleStrategy = require("passport-google-oauth").OAuth2Strategy;

  User = require("../models/user");

  verification = require("./verification");

  uniqify_name = function(name, num, callback) {
    return User.findOne({
      "name": name
    }, function(err, user) {
      var stringNum;
      if (err) {
        throw err;
      } else if (user) {
        stringNum = num.toString();
        name = name.concat(stringNum);
        num++;
        return uniqify_name(name, num, callback);
      } else {
        return callback(name);
      }
    });
  };

  module.exports = function(passport) {
    passport.serializeUser(function(user, done) {
      return done(null, user.id);
    });
    passport.deserializeUser(function(id, done) {
      return User.findById(id, function(err, user) {
        return done(err, user);
      });
    });
    passport.use("local-login", new LocalStrategy({
      usernameField: "email",
      passwordField: "password",
      passReqToCallback: true
    }, function(req, email, password, done) {
      req.session.message = "";
      return process.nextTick(function() {
        return User.findOne({
          "local.email": email
        }, function(err, user) {
          if (err) {
            return done(err);
          } else if (!user) {
            req.session.message = "No user found";
            return done(null, false, req.session.message);
          } else if (!user.validPassword(password)) {
            req.session.message = "Wrong password";
            return done(null, false, req.session.message);
          } else {
            user.visitorId.unshift(req.body.visitorId);
            return user.save(function(err, readyUser) {
              if (err) {
                throw err;
              } else {
                return done(null, user);
              }
            });
          }
        });
      });
    }));
    return passport.use("local-signup", new LocalStrategy({
      usernameField: "email",
      passwordField: "password",
      passReqToCallback: true
    }, function(req, email, password, done) {
      req.session.message = "";
      return process.nextTick(function() {
        return User.findOne({
          "local.email": email
        }, function(err, user) {
          var callback, name, nameMatch;
          if (err) {
            return done(err);
          } else if (user) {
            req.session.message = "That Email is already taken";
            return done(null, false, req.session.message);
          } else {
            nameMatch = email.match(/^([^@]*)@/);
            name = (nameMatch ? nameMatch[1] : null);
            if (name) {
              callback = function(name) {
                var newUser;
                newUser = new User();
                newUser.username = name;
                newUser.email = email;
                newUser.visitorId.push(req.body.visitorId);
                newUser.profilePic = "/img/users/default_img.png";
                newUser.local.email = email;
                newUser.local.password = newUser.generateHash(password);
                newUser.confirmed = false;
                newUser.hasEmail = true;
                return newUser.save(function(err, user) {
                  if (err) {
                    return done(err);
                  } else {
                    verification.sendVerification(req, newUser, email);
                    return done(null, newUser);
                  }
                });
              };
              return uniqify_name(name, 1, callback);
            } else {
              return done(null);
            }
          }
        });
      });
    }));
  };

}).call(this);
